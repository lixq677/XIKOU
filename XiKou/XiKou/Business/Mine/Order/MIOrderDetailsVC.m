//
//  MIOrderDetailsVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderDetailsVC.h"
#import "XKKeyValue.h"
#import "XKOrderManger.h"
#import <MeiQiaSDK/MQManager.h>
#import "MQChatViewManager.h"
#import "NSDate+Extension.h"
#import "XKOrderModel.h"
#import "XKAddressData.h"
#import "MIOrderBtnsView.h"

@interface MIOrderDetailsVC ()
<UITableViewDataSource,
UITableViewDelegate,
XKOrderMangerDelegate,
XKOrderServiceDelegate>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)UIImageView *coverImageView;

@property (nonatomic,strong,readonly)UIView *headerView;

@property (nonatomic,strong,readonly)UIImageView *icon;

@property (nonatomic,strong,readonly)UILabel *statusLabel;

@property (nonatomic,strong,readonly)UILabel *hintLabel;

@property (nonatomic,strong,readonly)UIImageView *addressIcon;

@property (nonatomic,strong,readonly)UILabel *addressLabel;

@property (nonatomic,strong,readonly)UILabel *infoLabel;

@property (nonatomic,strong,readonly)UIView *addressView;

@property (nonatomic,strong,readonly)UILabel *nameLabel;

@property (nonatomic,strong,readonly)UIView *line;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *specsLabel;

@property (nonatomic,strong,readonly)UILabel *priceLabel;

@property (nonatomic,strong,readonly)UILabel *countLabel;

@property (nonatomic,strong,readonly)UIView *toolView;

@property (nonatomic, strong) MIOrderBtnsView *btnsView;

@property (nonatomic,strong,readonly)NSMutableArray<XKKeyValue *> *paymentInfoArray;

@property (nonatomic,strong,readonly)NSMutableArray<XKKeyValue *> *orderInfoArray;

@property (nonatomic, copy)   NSString *orderNo;
@property (nonatomic, assign) XKOrderType orderType;

@end

@implementation MIOrderDetailsVC
@synthesize tableView = _tableView;
@synthesize coverImageView = _coverImageView;
@synthesize headerView = _headerView;
@synthesize icon = _icon;
@synthesize statusLabel = _statusLabel;
@synthesize hintLabel = _hintLabel;
@synthesize addressIcon = _addressIcon;
@synthesize addressLabel = _addressLabel;
@synthesize infoLabel = _infoLabel;
@synthesize addressView = _addressView;
@synthesize nameLabel = _nameLabel;
@synthesize line = _line;
@synthesize imageView = _imageView;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize specsLabel = _specsLabel;
@synthesize priceLabel = _priceLabel;
@synthesize countLabel = _countLabel;
@synthesize toolView = _toolView;
@synthesize paymentInfoArray = _paymentInfoArray;
@synthesize orderInfoArray = _orderInfoArray;

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
    self.title = @"订单详情";
    [self setupUI];
    [self layout];
    [[XKOrderManger sharedMange]addWeakDelegate:self];
    [[XKFDataService() orderService] addWeakDelegate:self];
       if (_orderType == OTDiscount) {
           [self getMutilOrderDetail];
       }else{
           [self getOrderDetail];
       }
    [self.tableView setNeedsLayout];
    [self addNavigationItemWithImageName:@"item_service" isLeft:NO target:self action:@selector(customerClick)];
}

- (void)setupUI{
    [self.headerView addSubview:self.coverImageView];
    [self.headerView addSubview:self.icon];
    [self.headerView addSubview:self.statusLabel];
    [self.headerView addSubview:self.hintLabel];
    
    [self.headerView addSubview:self.addressView];
    [self.addressView addSubview:self.addressIcon];
    [self.addressView addSubview:self.infoLabel];
    [self.addressView addSubview:self.addressLabel];
    
    [self.headerView addSubview:self.nameLabel];
    [self.headerView addSubview:self.line];
    [self.headerView addSubview:self.imageView];
    
    [self.headerView addSubview:self.detailTextLabel];
    [self.headerView addSubview:self.specsLabel];
    
    [self.headerView addSubview:self.priceLabel];
    [self.headerView addSubview:self.countLabel];
    
    [self.toolView addSubview:self.btnsView];
    [self.tableView setTableHeaderView:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolView];
}

- (void)layout{
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, scalef(116)+200);
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(scalef(116.0f));
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.width.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(35.0f);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.icon);
        make.left.mas_equalTo(self.icon.mas_right).offset(7.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLabel);
        make.right.mas_equalTo(-16.0f);
    }];
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.height.mas_equalTo(88.0f);
        make.top.mas_equalTo(scalef(80.0f));
    }];
    
    [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.top.mas_equalTo(20.0f);
        make.width.mas_equalTo(15.0f);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressIcon.mas_right).offset(10.0f);
        make.centerY.equalTo(self.addressIcon);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLabel);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(32.0f);
        make.right.mas_equalTo(-20.0f);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(self.addressView.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(self.addressView.mas_bottom).offset(50.0f);
        make.right.mas_equalTo(-20.0f);
        make.height.mas_equalTo(1.0f/[UIScreen mainScreen].scale);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(self.line.mas_bottom).offset(15.0f);
        make.width.height.mas_equalTo(70.0f);
       // make.bottom.equalTo(self.headerView).offset(-10.0f);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.0f);
        make.top.equalTo(self.line.mas_bottom).offset(20.0f);
        make.height.mas_equalTo(18.0f);
        make.width.mas_greaterThanOrEqualTo(100.0f);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.top.equalTo(self.imageView);
        make.height.mas_equalTo(33.0f);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-40.0f);
    }];
    
    [self.specsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailTextLabel);
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(10.0f);
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50+[XKUIUnitls safeBottom]);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.toolView.mas_top);
    }];
}

- (void)customerClick{
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

#pragma mark data request
- (void)getOrderDetail{
    @weakify(self);
    [[XKFDataService() orderService]getOrderDetailByOrderNo:self.orderNo andType:self.orderType comlete:^(XKOrderDetailResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {
            XKOrderDetailModel *model = response.data;
            model.type = self.orderType;
            model.goodsName = model.goodsVo.commodityName;
            [self dealDataWithModel:response.data];
            [self.btnsView setModel:response.data];
            [self.btnsView loadOrderTimeWithModel:response.data];
        }else{
            [response showError];
        }
    }];
}

- (void)getMutilOrderDetail{
    [[XKFDataService() orderService]getMutilOrderDetailByOrderNo:self.orderNo comlete:^(XKMutilOrderDetailResponse * _Nonnull response) {
        if ([response isSuccess]) {
           
        }else{
            [response showError];
        }
    }];
}



- (void)dealDataWithModel:(XKOrderDetailModel *)model{
   switch (model.state) {
        case OSUnPay:{
            self.icon.image = [UIImage imageNamed:@"orderWait"];
            if (model.payInvalidTime) {
                NSDate *date = [NSDate date:model.orderTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval dateTime =[date timeIntervalSince1970];
                NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
                double secondMax = dateTime + [model.payInvalidTime integerValue]*60;
               
            }
            if (model.type == OTBargain) {
                self.statusLabel.text = @"砍价成功，等待买家付款";
            }else if(model.type == OTZeroBuy){
                self.statusLabel.text = @"已拍中，等待买家付款";
            }else if (model.type == OTCustom){
                self.statusLabel.text = @"拼团成功，等待买家付款";
            }else{
                self.statusLabel.text = @"下单成功，等待买家付款";
            }
        }
            break;
        case OSUnDeliver:{
            self.icon.image = [UIImage imageNamed:@"orderPay"];
            self.statusLabel.text = @"已付款，等待卖家发货";
        }
            break;
        case OSUnReceive:{
            self.icon.image = [UIImage imageNamed:@"orderWait"];
            self.statusLabel.text = @"已发货，等待收货";
        }
            break;
        case OSCancle:{
            self.icon.image = [UIImage imageNamed:@"orderTip"];
            self.statusLabel.text = @"订单已取消";
        }
            break;
        case OSClose:{
            self.icon.image = [UIImage imageNamed:@"orderTip"];
            self.statusLabel.text = @"订单已关闭";
        }
            break;
        case OSComlete:{
            self.icon.image = [UIImage imageNamed:@"orderSuccess"];
            self.statusLabel.text = @"交易完成";
        }
            break;
        case OSUnSure:{
            self.icon.image = [UIImage imageNamed:@"orderWait"];
            self.statusLabel.text = @"订单待确认";
        }
            break;
        case OSUnGroup:{
            self.icon.image = [UIImage imageNamed:@"orderWait"];
            self.statusLabel.text = @"订单待成团";
        }
            break;
        case OSGroupSus:{
            self.icon.image = [UIImage imageNamed:@"orderSuccess"];
            self.statusLabel.text = @"订单成团成功";
        }
            break;
        case OSGroupFail:{
            self.icon.image = [UIImage imageNamed:@"orderTip"];
            self.statusLabel.text = @"订单成团失败";
        }
            break;
        case OSConsign:{
            self.icon.image = [UIImage imageNamed:@"orderSuccess"];
            self.statusLabel.text = @"已寄卖";
        }
            break;
        default:
            break;
    }
    self.infoLabel.text = [NSString stringWithFormat:@"%@  %@",model.address.consigneeName,model.address.consigneeMobile];
    
    NSString *address = @"";
    if (model.address.provinceName) {
        address = [address stringByAppendingString:model.address.provinceName];
    }
    if (model.address.cityName) {
        address = [address stringByAppendingString:@" "];
        address = [address stringByAppendingString:model.address.cityName];
    }
    if (model.address.areaName) {
        address = [address stringByAppendingString:@" "];
        address = [address stringByAppendingString:model.address.areaName];
    }
    if (model.address.address) {
        address = [address stringByAppendingString:@" "];
        address = [address stringByAppendingString:model.address.address];
    }
    self.addressLabel.text = address;
    
    self.countLabel.text   = [NSString stringWithFormat:@"x%@",model.goodsVo.commodityQuantity ? model.goodsVo.commodityQuantity : @1];
    self.nameLabel.text  = model.goodsVo.commodityName;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",model.goodsVo.commodityModel,model.goodsVo.commoditySpec];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.goodsVo.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commoditySalePrice doubleValue]/100];
    
    NSAttributedString *(^block)(NSString *text,UIFont *font,UIColor *color) = ^(NSString *text,UIFont *font,UIColor *color){
        return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    };
    
    UIFont *font = [UIFont systemFontOfSize:13.0f];
    UIColor *color = HexRGB(0x999999, 1.0f);
    
    if (model.cutPrice && model.type == OTBargain) {
        XKKeyValue *keyValue1 = [[XKKeyValue alloc] init];
        keyValue1.key = block(@"砍后价",font,color);
        keyValue1.value = block([NSString stringWithFormat:@"¥%.2f",[model.cutPrice doubleValue]/100],font,color);
        [self.paymentInfoArray addObject:keyValue1];
        
    }
    if (model.commodityAuctionPrice && model.type == OTZeroBuy) {
        XKKeyValue *keyValue1 = [[XKKeyValue alloc] init];
        keyValue1.key = block(@"拍卖价",font,color);
        keyValue1.value = block([NSString stringWithFormat:@"¥%.2f",[model.commodityAuctionPrice doubleValue]/100],font,color);
        [self.paymentInfoArray addObject:keyValue1];
    }
    
    XKKeyValue *keyValue2 = [[XKKeyValue alloc] init];
    keyValue2.key = block(@"邮费",font,color);
    keyValue2.value = block([NSString stringWithFormat:@"¥%.2f",[model.postage doubleValue]/100],font,color);
    [self.paymentInfoArray addObject:keyValue2];
    
    XKKeyValue *keyValue3 = [[XKKeyValue alloc] init];
    keyValue3.key = block(@"实付款",font,HexRGB(0x444444, 1.0f));
    keyValue3.value = block([NSString stringWithFormat:@"¥%.2f",[model.payAmount doubleValue]/100],font,HexRGB(0xF94119, 1.0f));
    [self.paymentInfoArray addObject:keyValue3];
    
    UIFont *font1 = [UIFont systemFontOfSize:12.0f];
    
    if (model.type == OTDiscount && model.tradeNo) {
        XKKeyValue *keyValue = [[XKKeyValue alloc] init];
        keyValue.key = block(@"总订单编号:",font1,color);
        keyValue.value = block(model.tradeNo,font1,color);
        [self.orderInfoArray addObject:keyValue];
    }
    
    XKKeyValue *keyValue4 = [[XKKeyValue alloc] init];
    keyValue4.key = block(@"订单编号:",font1,color);
    keyValue4.value = block(model.orderNo,font1,color);
    [self.orderInfoArray addObject:keyValue4];
    
    if (model.externalPlatformNo) {
        XKKeyValue *keyValue = [[XKKeyValue alloc] init];
        keyValue.key = block(@"交易流水号:",font1,color);
        keyValue.value = block(model.externalPlatformNo,font1,color);
        [self.orderInfoArray addObject:keyValue];
    }
    
    XKKeyValue *keyValue5 = [[XKKeyValue alloc] init];
    keyValue5.key = block(@"创建时间:",font1,color);
    keyValue5.value = block(model.orderTime,font1,color);
    [self.orderInfoArray addObject:keyValue5];
    
    if (model.payTime) {
        XKKeyValue *keyValue = [[XKKeyValue alloc] init];
        keyValue.key = block(@"付款时间:",font1,color);
        keyValue.value = block(model.payTime,font1,color);
        [self.orderInfoArray addObject:keyValue];
    }
    
    if (model.shipTime) {
        XKKeyValue *keyValue = [[XKKeyValue alloc] init];
        keyValue.key = block(@"发货时间:",font1,color);
        keyValue.value = block(model.shipTime,font1,color);
        [self.orderInfoArray addObject:keyValue];
    }
    
    if (model.confirmReceiptTime) {
        XKKeyValue *keyValue = [[XKKeyValue alloc] init];
        keyValue.key = block(@"成交时间:",font1,color);
        keyValue.value = block(model.confirmReceiptTime,font1,color);
        [self.orderInfoArray addObject:keyValue];
    }

}

#pragma mark tabeleVeiw Data Source or delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.paymentInfoArray.count;
    }else{
        return self.orderInfoArray.count;;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"iden"];
    }
    if (indexPath.section == 0) {
        XKKeyValue *keyValue = [self.paymentInfoArray objectAtIndex:indexPath.row];
        cell.textLabel.attributedText = (NSAttributedString *)keyValue.key;
        cell.detailTextLabel.attributedText = (NSAttributedString *)keyValue.value;
    }else{
        XKKeyValue *keyValue = [self.orderInfoArray objectAtIndex:indexPath.row];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:(NSAttributedString *)keyValue.key];
        [attributedText appendAttributedString:(NSAttributedString *)keyValue.value];
        cell.textLabel.attributedText = attributedText;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60.0f)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 10.0f, kScreenWidth-30.0f, 1/[UIScreen mainScreen].scale)];
        line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
        [view addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 18)];
        label.text = @"订单信息";
        label.textColor = HexRGB(0x444444, 1.0f);
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        [view addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(view.frame)-65.0f, 27.0f, 45.0f, 24.0f)];
        [button setTitle:@"复制" forState:UIControlStateNormal];
        button.layer.cornerRadius = 2.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [HexRGB(0xe4e4e4, 1.0f) CGColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        [button setTitleColor:HexRGB(0x999999, 1.0f) forState:UIControlStateNormal];
        [view addSubview:button];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 60;
    }
    return 0;
}



#pragma mark getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 30.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DD"]];
    }
    return _coverImageView;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_clock"]];
    }
    return _icon;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HexRGB(0xffffff, 1.0f);
        _statusLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _statusLabel;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = HexRGB(0xffffff, 1.0f);
        _hintLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _hintLabel;
}

- (UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
        _addressView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _addressView.layer.cornerRadius = 3.0f;
        [_addressView addShadowWithColor:[UIColor lightGrayColor]];
    }
    return _addressView;
}

- (UIImageView *)addressIcon{
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodedizhi"]];
    }
    return _addressIcon;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:12.0f];
        _addressLabel.textColor = HexRGB(0x999999, 1.0f);
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:15.0f];
        _infoLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _infoLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _nameLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _nameLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)specsLabel{
    if (!_specsLabel) {
        _specsLabel = [[UILabel alloc] init];
        _specsLabel.textColor = HexRGB(0x999999, 1.0f);
        _specsLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _specsLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x444444, 1.0f);
        _detailTextLabel.numberOfLines = 0;
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _detailTextLabel;
}


- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HexRGB(0x444444, 1.0f);
        _priceLabel.font = [UIFont systemFontOfSize:12.0f];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}


- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = HexRGB(0x999999, 1.0f);
        _countLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _countLabel;
}

- (MIOrderBtnsView *)btnsView{
    if (!_btnsView) {
        _btnsView = [[MIOrderBtnsView alloc]init];
        _btnsView.left  = kScreenWidth - _btnsView.width - 5;
        _btnsView.top   = 11;
    }
    return _btnsView;
}
- (UIView *)toolView{
    if (!_toolView) {
        _toolView = [UIView new];
        _toolView.backgroundColor = HexRGB(0xffffff, 1.0f);
        [_toolView addShadowWithColor:[UIColor lightGrayColor]];
    }
    return _toolView;
}

- (NSMutableArray<XKKeyValue *> *)paymentInfoArray{
    if (!_paymentInfoArray) {
        _paymentInfoArray = [NSMutableArray array];
    }
    return _paymentInfoArray;
}

- (NSMutableArray<XKKeyValue *> *)orderInfoArray{
    if(!_orderInfoArray){
        _orderInfoArray = [NSMutableArray array];
    }
    return _orderInfoArray;
}

@end
