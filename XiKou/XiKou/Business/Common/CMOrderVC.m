//
//  CMOrderVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMOrderVC.h"
#import "MIEditAddressVC.h"

#import "CMOrderCells.h"
#import "XKChooseAddressPopView.h"
#import "XKCartButtonsView.h"

#import "UILabel+NSMutableAttributedString.h"
#import "XKAddressService.h"
#import "XKUserService.h"
#import "XKOrderService.h"
#import "XKMakeOrderParam.h"
#import "CMOrderCommentsVC.h"
#import "MIBasicCell.h"
#import "XKCustomAlertView.h"
@interface CMOrderVC ()
<UITableViewDelegate,
UITableViewDataSource,
XKAddressServiceDelegate,
XKOrderServiceDelegate,
CMOrderCommentsVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKCartButtonsView *bottomView;
@property (nonatomic, strong) XKMakeOrderParam *model;
@property (nonatomic, strong) XKAddressVoData *addressModel;
@property (nonatomic, strong) NSString *friendPhone;
@property (nonatomic, strong) NSString *friendUserId;
@property (nonatomic, assign) NSInteger selectedOtherPay;

@end

@implementation CMOrderVC

- (instancetype)initWithModel:(XKMakeOrderParam *)model{
    self = [super init];
    if (self) {
        _model = model;
        _model.insteadPay = @0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
    self.friendPhone = @"";
    self.selectedOtherPay = 0; //默认不代付
    [[XKFDataService() addressService] addWeakDelegate:self];
    
    [self initializeData];
    [self setUI];
    @weakify(self);
    self.bottomView.actionBlock = ^{
        @strongify(self);
        [self orderAction];
    };
}

- (void)setUI{
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self.tableView registerClass:[MIBasicAddressCell class] forCellReuseIdentifier:@"MIBasicAddressCell"];
    [self.tableView registerClass:[CMOrderAddrCell class] forCellReuseIdentifier:@"CMOrderAddrCell"];
    [self.tableView registerClass:[CMOrderGoodCell class] forCellReuseIdentifier:@"CMOrderGoodCell"];
    [self.tableView registerClass:[CMOrderDeliveryCell class] forCellReuseIdentifier:@"CMOrderDeliveryCell"];
    [self.tableView registerClass:[CMOrderPaidByOtherCell class] forCellReuseIdentifier:@"CMOrderPaidByOtherCell"];
    
    [self.view xk_addSubviews:@[self.tableView,self.bottomView]];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo([XKUIUnitls safeBottom]+66.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.equalTo(self.view).mas_offset(-15.0f);
        make.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    if (self.model.activityType == Activity_WG || self.model.activityType == Activity_Global) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30.0f, 30.0f)];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textColor = HexRGB(0xcccccc, 1.0f);
        label.text = @"注意：目前支持推荐人代付";
        label.hidden = YES;
        [label sizeToFit];
        label.frame = CGRectMake(18.0f, 13.0f, label.width, label.height);
        [tableFooterView addSubview:label];
        self.tableView.tableFooterView = tableFooterView;
    }
}

- (void)initializeData{
    XKAddressVoData *(^getAddressVoData)(NSArray<XKAddressVoData *> *addresses) = ^(NSArray<XKAddressVoData *> *addresses){
        XKAddressVoData *voData = nil;
        for (XKAddressVoData *data in addresses) {
            if ([data.defaultId isEqualToNumber:@1]) {
                   voData = data;
                   break;
            }
            if (voData == nil && addresses.count > 0) {
                voData = [addresses firstObject];
            }
        }
        return voData;
    };
    @weakify(self);
    NSString *userId = [[XKAccountManager defaultManager] userId];
    [[XKFDataService() addressService] queryAddressListWithUserId:userId completion:^(XKAddressUserListResponse * _Nonnull response) {
        if (response.isSuccess) {
            @strongify(self);
            XKAddressVoData *voData = getAddressVoData(response.data);
            self->_addressModel = voData;
            [self.tableView reloadData];
        }
    }];
#if 0
    NSString *userId = [[XKAccountManager defaultManager] userId];
    NSArray<XKAddressVoData *> *addresss = [[XKFDataService() addressService]queryAddressListFromCacheWithUserId:userId];
    XKAddressVoData *voData = getAddressVoData(addresss);
    if (voData) {
        _addressModel = voData;
    }else{
        @weakify(self);
        [[XKFDataService() addressService] queryAddressListWithUserId:userId completion:^(XKAddressUserListResponse * _Nonnull response) {
            if (response.isSuccess) {
                @strongify(self);
                XKAddressVoData *voData = getAddressVoData(response.data);
                self->_addressModel = voData;
                [self.tableView reloadData];
            }
        }];
    }
#endif
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"合计  ¥%.2f",_model.orderAmount/100+ [self.model.postage doubleValue]/100];
    [self.bottomView.priceLabel setAttributedStringWithSubString:@"合计" color:COLOR_TEXT_BLACK font:Font(12.f)];
    [self.bottomView.priceLabel setAttributedStringWithSubString:@"¥" font:FontSemibold(14.f)];
    
}

#pragma mark tableview delegate && dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.model.activityType == Activity_WG || self.model.activityType == Activity_Global) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        if (_model.activityType == Activity_Global || _model.activityType == Activity_WG) {
            return 5;
        }else{
           return 4;
        }
    }else if (section == 1){
        return 2;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        CMOrderPaidByOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderPaidByOtherCell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 4.0f;
        if (indexPath.row == 1) {
            cell.textLabel.text = @"请喜扣好友代付";
            cell.imageView.image = [UIImage imageNamed:@"xikou_friend"];
            [cell setPayStyle:YES friendPhone:self.friendPhone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.paidSelect = self.selectedOtherPay == 1;
        }else{
            cell.paidSelect = self.selectedOtherPay == 2;
        }
        return cell;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.addressModel == nil) {
            CMOrderAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderAddrCell" forIndexPath:indexPath];
            cell.hasAddress = NO;
            return cell;
        }else{
            MIBasicAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBasicAddressCell" forIndexPath:indexPath];
            cell.nameLabel.text = self.addressModel.consigneeName;
            cell.telLabel.text = self.addressModel.consigneeMobile;
            XKAddressVoModel *voModel = [[XKAddressVoModel alloc] initWithVoData:self.addressModel];
            NSString *areaAddress = GetAreaAddressWithVoModel(voModel);
            cell.addrLabel.text = [NSString stringWithFormat:@"%@ %@",areaAddress,self.addressModel.address];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.defaultLabel.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editBtn.hidden = YES;
            if(self.addressModel.outRange){
                cell.nameLabel.textColor = COLOR_TEXT_BLACK;
                cell.telLabel.textColor = COLOR_TEXT_BLACK;
                cell.addrLabel.textColor = COLOR_TEXT_GRAY;
                cell.detailTextLabel.hidden = YES;
            }else{
                cell.nameLabel.textColor =  HexRGB(0xcccccc, 1.0f);
                cell.telLabel.textColor  =  HexRGB(0xcccccc, 1.0f);
                cell.addrLabel.textColor =  HexRGB(0xcccccc, 1.0f);
                cell.detailTextLabel.hidden = NO;
            }
            return cell;
        }
    }
    if(indexPath.section == 0 && indexPath.row == 1){
        CMOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderGoodCell" forIndexPath:indexPath];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = _model.goodsName;
        
        NSMutableString *string = [NSMutableString string];
        [self.model.condition enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [string appendString:obj];
            [string appendString:@" "];
        }];
        cell.detailTextLabel.text = string;
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.goodsPrice floatValue]/100];
        cell.countLabel.text = [NSString stringWithFormat:@"x%@",_model.commodityQuantity];
        return cell;
    }
    CMOrderDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderDeliveryCell" forIndexPath:indexPath];
    if (indexPath.row == 2 && _model.activityType == Activity_Global) {
        cell.textLabel.text = @"抵扣优惠券";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.deductionCouponAmount doubleValue]/100*[_model.commodityQuantity integerValue]];
        cell.detailTextLabel.textColor = COLOR_TEXT_RED;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.row == 2 && _model.activityType == Activity_WG) {
        cell.textLabel.text = @"赠送优惠券";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.deductionCouponAmount doubleValue]/100*[_model.commodityQuantity integerValue]];
        cell.detailTextLabel.textColor = COLOR_TEXT_RED;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if((indexPath.row == 3 && (_model.activityType == Activity_WG || _model.activityType == Activity_Global)) || (indexPath.row == 2 && !(_model.activityType == Activity_WG || _model.activityType == Activity_Global))){
        cell.textLabel.text = @"配送方式";
        cell.detailTextLabel.text = (_model.postage && [_model.postage doubleValue]>0) ? [NSString stringWithFormat:@"邮费 %.2f元",[_model.postage doubleValue]/100] : @"全国包邮";
        cell.detailTextLabel.textColor = COLOR_TEXT_GRAY;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.textLabel.text = @"订单备注:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if ([NSString isNull:self.model.remarks]) {
            cell.detailTextLabel.text = @"无";
        }else{
            cell.detailTextLabel.text = self.model.remarks;
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        CMOrderPaidByOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 1) { //请好友代付
            @weakify(self);
            [MGJRouter openURL:kRouterSearchFriend withUserInfo:@{@"phoneBlock":^(NSString *phone,NSString *userId){
                @strongify(self);
                self.friendPhone = phone;
                self.friendUserId = userId;
                if (self.friendPhone.length > 0) {
                    self.selectedOtherPay = 1;
                }else{
                    self.selectedOtherPay = 0;
                }
                if (self.selectedOtherPay > 0) {
                    self.model.insteadPay = @1;
                }
                [cell setPayStyle:YES friendPhone:phone];
                [self.tableView reloadData];
            }} completion:nil];
        }else{
            if (self.selectedOtherPay == 2) {
                self.selectedOtherPay = 0 ;
            }else{
                self.selectedOtherPay = 2;
            }
            [cell setPayStyle:NO friendPhone:@""];
        }
        if (self.selectedOtherPay > 0) {
            self.model.insteadPay = @1;
        }else{
            self.model.insteadPay = @0;
        }
        [self.tableView reloadData];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self chooseAddress];
    }else if ((indexPath.row == 4 && (_model.activityType == Activity_WG || _model.activityType == Activity_Global)) || (indexPath.row == 3 && !(_model.activityType == Activity_WG || _model.activityType == Activity_Global))){
        CMOrderCommentsVC *controller = [[CMOrderCommentsVC alloc] initWithDelegate:self];
        [controller setText:self.model.remarks];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)commentsViewController:(CMOrderCommentsVC *)controller commentText:(NSString *)text{
    if ((self.model.activityType == Activity_WG || self.model.activityType == Activity_Global)) {
        CMOrderDeliveryCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        cell.detailTextLabel.text = text;
    }else{
        CMOrderDeliveryCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell.detailTextLabel.text = text;
    }
    self.model.remarks = text;
}

#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 130.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (XKCartButtonsView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[XKCartButtonsView alloc]init];
        [_bottomView.payBtn setTitle:@"确认订单" forState:UIControlStateNormal];
    }
    return _bottomView;
}
#pragma mark ---------------------------------业务
#pragma mark 获取地址
- (void)chooseAddress{
    XKChooseAddressPopView *addressView = [[XKChooseAddressPopView alloc]init];
    @weakify(self);
    [addressView showWithTitle:@"选择地址" chooseComplete:^(XKAddressVoData * _Nonnull data) {
        @strongify(self);
        self.addressModel = data;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } addBlock:^{
        @strongify(self);
        MIEditAddressVC *vc = [[MIEditAddressVC alloc]initWithAddressVoData:[XKAddressVoData new]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark  add Address
- (void)addAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data{
    [self chooseAddress];
}

#pragma mark 生成订单
- (void)orderAction{
    
    if (!self.addressModel) {
        XKShowToast(@"请选择地址");
        return;
    }
    if (self.addressModel.outRange == NO) {
        XKShowToast(@"地址超出配送范围，请重新选择");
        return;
    }
    self.model.receiptAddressRef =  self.addressModel.id;
    self.bottomView.payBtn.enabled = NO;
    if (self.selectedOtherPay == 1) {
        self.model.payPhone = [self.friendPhone deleteSpace];
    }
    [[XKFDataService() orderService]creatNormalOrderWithModel:self.model comlete:^(XKBaseResponse * _Nonnull response) {
        self.bottomView.payBtn.enabled = YES;
        if ([response isSuccess]) {
            if ([self.model.insteadPay isEqualToNumber:@1]) {
                NSString *message = @"";
                if (self.model.payPhone.length > 0) {
                    message = @"代付订单生成成功，请通知喜扣好友付款";
                }else{
                    message = @"代付订单生成成功，请通知合伙人付款";
                }
                XKShowToastCompletionBlock(message, ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                XKShowToast(@"订单生成成功");
                [self orderResult:response.data];
            }
            
        }else{
            [response showError];
        }
    }];
}


/**
 订单生成成功跳转支付

 @param data <#data description#>
 */
- (void)orderResult:(id)data{
    
    XKMakeOrderResultModel *model = [XKMakeOrderResultModel yy_modelWithJSON:data];
    if (self.model.activityType == Activity_ZeroBuy) model.type = OTZeroBuy;
    if (self.model.activityType == Activity_Global)  model.type = OTGlobalSeller;
    if (self.model.activityType == Activity_Bargain) model.type = OTBargain;
    if (self.model.activityType == Activity_WG)      model.type = OTWug;
    if (self.model.activityType == Activity_Custom)  model.type = OTCustom;
    if (self.model.activityType == Activity_NewUser) model.type = OTNewUser;
    XKOrderBaseModel *disModel = [XKOrderBaseModel new];
    disModel.payAmount = model.payAmount;
    disModel.type      = model.type;
    disModel.orderNo   = model.orderNo;
    disModel.scheduleId = self.model.id;
    disModel.goodsName = self.model.goodsName;
    if (self.model.createType.intValue == 2 && self.model.activityType == Activity_Bargain) {
        disModel.bargain = YES;
    }else{
        disModel.bargain = NO;
    }
    if (self.model.activityType == Activity_WG) {
        
    }
    disModel.deductionCouponAmount = @([self.model.deductionCouponAmount doubleValue]*[_model.commodityQuantity integerValue]);
    if (self.selectedOtherPay > 0) {
        [MGJRouter openURL:kRouterPayByOther];
    }else{
        [MGJRouter openURL:kRouterPay withUserInfo:@{@"key":disModel} completion:nil];
    }
}

- (void)dealloc{
    [[XKFDataService() addressService]removeWeakDelegate:self];
}
@end
