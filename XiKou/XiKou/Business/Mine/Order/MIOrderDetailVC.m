//
//  MIOrderDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderDetailVC.h"
#import "MIOrderGoodCell.h"
#import "MIOrderDetailTableHeader.h"
#import "MIOrderDetailSectionHeader.h"
#import "MIOrderDetailSectionFooter.h"
#import "MIOrderBtnsView.h"
#import "XKCustomAlertView.h"
#import "UILabel+NSMutableAttributedString.h"

#import <MeiQiaSDK/MQManager.h>
#import "MQChatViewManager.h"

#import "XKOrderManger.h"
#import "XKAddressData.h"
#import "CMOrderCommentsVC.h"
#import "XKChooseAddressPopView.h"
#import "MIEditAddressVC.h"
#import "XKAccountManager.h"

@interface MIOrderDetailVC ()
<UITableViewDelegate,
UITableViewDataSource,
XKOrderMangerDelegate,
XKOrderServiceDelegate,
MIOrderDetailSectionHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MIOrderDetailTableHeader *tableHeadView;
@property (nonatomic, strong) MIOrderBtnsView *btnsView;

@property (nonatomic, copy)   NSString *orderNo;
@property (nonatomic, assign) XKOrderType orderType;
@property (nonatomic, strong) NSArray *childOrderArray;
@property (nonatomic,strong) UIView *btnBgView;
@property (nonatomic, strong,readonly) XKAddressVoData *voData;
@end

static NSString * const headID = @"headID";
static NSString * const footID = @"footID";
static NSString * const cellID = @"cellID";
@implementation MIOrderDetailVC
@synthesize voData = _voData;

- (instancetype)initWithOrderID:(NSString *)orderNo andType:(XKOrderType)type{
    self = [super init];
    if (self) {
        _orderNo   = orderNo;
        _orderType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
    [[XKFDataService() orderService] addWeakDelegate:self];
    if (_orderType == OTDiscount) {
        [self getMutilOrderDetail];
    }else{
        [self getOrderDetail];
    }
}

- (void)dealloc{
    [[XKOrderManger sharedMange] removeWeakDelegate:self];
    [[XKFDataService() orderService] removeWeakDelegate:self];
}

- (void)initUI{
    self.title = @"订单详情";
    
    self.btnBgView = [UIView new];
    self.btnBgView.backgroundColor = [UIColor whiteColor];
    self.btnBgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.03].CGColor;
    self.btnBgView.layer.shadowOffset = CGSizeMake(-0.5,-2);
    self.btnBgView.layer.shadowOpacity = 1;
    self.btnBgView.layer.shadowRadius = 2.5;
    if (self.orderType == OTConsigned) {
        self.btnBgView.hidden = YES;
    }
    [self.btnBgView addSubview:self.btnsView];
    
    [self.view xk_addSubviews:@[self.tableView,self.btnBgView]];
    [self.btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.view);
        make.height.mas_equalTo(50+[XKUIUnitls safeBottom]);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.btnsView.mas_top);
    }];
    self.tableView.tableHeaderView = self.tableHeadView;
    self.tableView.tableFooterView = [UIView new];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DD"]];
    bgView.contentMode  = UIViewContentModeScaleAspectFill;
    [self.tableView insertSubview:bgView atIndex:0];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.tableView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.equalTo(bgView.mas_width).multipliedBy(115/375.0);
    }];
    [self addNavigationItemWithImageName:@"item_service" isLeft:NO target:self action:@selector(customerClick)];
}

#pragma mark action
- (void)customerClick{
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

#pragma mark data request
- (void)getOrderDetail{
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() orderService]getOrderDetailByOrderNo:self.orderNo andType:self.orderType comlete:^(XKOrderDetailResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {
            XKOrderDetailModel *model = response.data;
            model.type = self.orderType;
            model.goodsName = model.goodsVo.commodityName;
            self.childOrderArray = @[model];
            self->_voData = model.address;
            [self dataHandle:model];
        }else{
            [response showError];
        }
    }];
}

- (void)getMutilOrderDetail{
    @weakify(self);
    [[XKFDataService() orderService]getMutilOrderDetailByOrderNo:self.orderNo comlete:^(XKMutilOrderDetailResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            self.childOrderArray = response.data;
            CGFloat amount = 0;
            for (XKOrderDetailModel *model in self.childOrderArray) {
                model.type = OTDiscount;
                amount += [model.payAmount floatValue];
            }
            for (XKOrderDetailModel *model in self.childOrderArray) {
                model.discountPayAmount = @(amount);
            }
            [self dataHandle:self.childOrderArray[0]];
        }else{
            [response showError];
        }
    }];
}

- (void)dataHandle:(XKOrderDetailModel *)model{
    self.tableHeadView.model = model;
    self.btnsView.model = model;
    [self.btnsView loadOrderTimeWithModel:model];
    [self.tableView reloadData];
}

- (NSString *)getOrderStatusWithModel:(XKOrderDetailModel *)model {
    XKOrderStatus status = model.state;

    NSString *orderStatus = @"";
    if (status == OSUnDeliver) {
        orderStatus = [NSString stringWithFormat:@"商品将由%@发货给买家",model.merchantName];
    }
    return orderStatus;
}

#pragma order service delegate
- (void)payAnotherApplySuccess:(NSString *)orderNo{
    if ([self.orderNo isEqualToString:orderNo]) {
        [self getOrderDetail];
    }
}

- (void)changeAddress:(XKAddressVoData *)voData{
    XKAddOrModifyAddressVoParams *params = [[XKAddOrModifyAddressVoParams alloc] init];
    params.orderNo = self.orderNo;
    params.receiptAddressRef = voData.id;
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() orderService] changeOrderAddress:params completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        @strongify(self);
        if (response.isSuccess) {
            self->_voData = voData;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}


#pragma mark 获取地址
- (void)chooseAddress{
    XKChooseAddressPopView *addressView = [[XKChooseAddressPopView alloc]init];
    @weakify(self);
    [addressView showWithTitle:@"选择地址" chooseComplete:^(XKAddressVoData * _Nonnull data) {
        @strongify(self);
        [self changeAddress:data];
    } addBlock:^{
        @strongify(self);
        MIEditAddressVC *vc = [[MIEditAddressVC alloc]initWithAddressVoData:[XKAddressVoData new]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark delegate
- (void)orderHasDelete:(NSString *)orderNo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderStatusHasUpdate:(NSString *)orderNo andOrderStatus:(XKOrderStatus)orderStaus{
    [self getOrderDetail];
}

- (void)orderDetailSectionHeader:(MIOrderDetailSectionHeader *)header clickIt:(id)sender{
    XKOrderDetailModel *detailModel = [self.childOrderArray firstObject];
    if (self.orderType == OTZeroBuy && detailModel.state == OSUnPay) {
        [self chooseAddress];
    }
}

#pragma mark tableView delegate && dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.childOrderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOrderDetailGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    XKOrderDetailModel *detailModel = self.childOrderArray[indexPath.section];
    cell.numLabel.text   = [NSString stringWithFormat:@"x%@",detailModel.goodsVo.commodityQuantity ? detailModel.goodsVo.commodityQuantity : @1];
    cell.nameLabel.text  = detailModel.goodsVo.commodityName;
    cell.desLabel.text = [NSString stringWithFormat:@"%@ %@",detailModel.goodsVo.commodityModel,detailModel.goodsVo.commoditySpec];
    [cell.nameLabel setLineSpace:8.5];
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:detailModel.goodsVo.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[detailModel.commoditySalePrice doubleValue]/100];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MIOrderDetailSectionHeader *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headID];
    head.delegate = self;
    XKOrderDetailModel *detailModel = self.childOrderArray[section];
    XKAddressVoData *voData = [detailModel address];
    if (self.orderType == OTZeroBuy) {
        voData = [self voData];
    }
    if (self.orderType == OTZeroBuy && voData == nil) {
        [head.addressView setHasAddress:NO];
    }else{
        [head.addressView setHasAddress:YES];
        head.addressView.nameLabel.text = voData.consigneeName;
        head.addressView.phoneLabel.text = voData.consigneeMobile;
        NSString *address = @"";
        if (voData.provinceName) {
            address = [address stringByAppendingString:voData.provinceName];
        }
        if (voData.cityName) {
            address = [address stringByAppendingString:@" "];
            address = [address stringByAppendingString:voData.cityName];
        }
        if (voData.areaName) {
            address = [address stringByAppendingString:@" "];
            address = [address stringByAppendingString:voData.areaName];
        }
        if (voData.address) {
            address = [address stringByAppendingString:@" "];
            address = [address stringByAppendingString:voData.address];
        }
        head.addressView.addressLabel.text = address;
        if (self.orderType == OTZeroBuy &&  detailModel.state == OSUnPay) {
            head.addressView.arrow.hidden = NO;
        }else{
            head.addressView.arrow.hidden = YES;
        }

    }
    head.titleLabel.text = detailModel.merchantName;
    head.topBgView.backgroundColor = section > 0 ? COLOR_TEXT_BLACK : [UIColor clearColor];
    if (detailModel.type == OTConsigned) {
        NSString *phone = detailModel.buyerAccount;
        if ([detailModel.buyerAccount isMobileNumber]) {
           phone = [detailModel.buyerAccount stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        NSString *namePhone = [NSString stringWithFormat:@"%@  %@",detailModel.buyerNickName,phone];
        [head showUserViewNamePhone:namePhone isBuyer:YES userIcon:detailModel.buyerHeadImage status:[self getOrderStatusWithModel:detailModel]];
    }
    if (detailModel.state == OSConsign) {
          self.btnBgView.hidden = YES;
      }
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MIOrderDetailSectionFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footID];
    XKOrderDetailModel *detailModel = self.childOrderArray[section];
    footer.model = detailModel;
    @weakify(self);
    footer.remarkBlock = ^(NSString *text){
        @strongify(self);
        CMOrderCommentsVC *controller = [[CMOrderCommentsVC alloc] init];
        [controller setText:text];
        [controller canEdit:NO];
        [self.navigationController pushViewController:controller animated:YES];
    };
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101;
}

#pragma mark lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = HexRGB(0xF4F4F4, 1);
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedSectionFooterHeight = 100;
        _tableView.estimatedSectionHeaderHeight = 100;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[MIOrderDetailGoodCell class] forCellReuseIdentifier:cellID];
        [_tableView registerClass:[MIOrderDetailSectionHeader class] forHeaderFooterViewReuseIdentifier:headID];
        [_tableView registerClass:[MIOrderDetailSectionFooter class] forHeaderFooterViewReuseIdentifier:footID];
    }
    return _tableView;
}

- (MIOrderDetailTableHeader *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[MIOrderDetailTableHeader alloc]init];
    }
    return _tableHeadView;
}

- (MIOrderBtnsView *)btnsView{
    if (!_btnsView) {
        _btnsView = [[MIOrderBtnsView alloc]init];
        _btnsView.left  =  5;
        _btnsView.top   = 11;
    }
    return _btnsView;
}

@end
