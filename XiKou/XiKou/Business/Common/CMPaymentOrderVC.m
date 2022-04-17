//
//  CMPaymentOrderVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMPaymentOrderVC.h"
#import "CMOrderCells.h"
#import "MIPaymentPaswSheet.h"
#import "MIPwdResettingVC.h"
#import "CMPayStateVC.h"
#import "XKCustomAlertView.h"
#import "XKPayManger.h"
#import "MIPwdResettingVC.h"
#import "XKAccountManager.h"
#import "XKOrderService.h"
#import "XKUserService.h"
#import "MIVerifyVC.h"
#import "WXApiManager.h"
@interface PayTypeModel : NSObject

@property (nonatomic, strong) UIImage *img;

@property (nonatomic, copy) NSString *payTypeName;

@property (nonatomic, assign) PayType payType;

@end

@implementation PayTypeModel

@end

@interface CMPaymentOrderVC ()<UITableViewDelegate,UITableViewDataSource,MIPaymentPaswSheetDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIButton *paymentBtn;

@property (nonatomic, strong) XKOrderBaseModel *displayModel;
@end

@implementation CMPaymentOrderVC{
    PayType _type;
    NSMutableArray *_payTypes;
}

- (instancetype)initWithOrder:(XKOrderBaseModel *)displayModel{
    if (!_displayModel) {
        _displayModel = displayModel;
       NSArray *payInfos = @[
                             @[[UIImage imageNamed:@"cash_redbag"],@"钱包支付",@(RedPackgePay)],
                             @[[UIImage imageNamed:@"cash_wexin"],@"微信支付",@(WXPay)],
                             @[[UIImage imageNamed:@"cash_zhifubao"],@"支付宝支付",@(AliPay)],
//                             @[[UIImage imageNamed:@"cash_yinhangka"],@"银行卡支付",@(BankCardPay)],
                            ];
        _payTypes = [NSMutableArray array];
        for (int i = 0; i<payInfos.count; i++) {
            NSArray *subArray = payInfos[i];
            PayTypeModel *model = [PayTypeModel new];
            model.img         = subArray[0];
            model.payTypeName = subArray[1];
            model.payType     = [subArray[2] integerValue];
            [_payTypes addObject:model];
            if (i == 0) _type = model.payType;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rt_disableInteractivePop = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
    [self layout];

}

- (void)backAction:(id)sender{
    XKCustomAlertView *view = [[XKCustomAlertView alloc]initWithType:CanleAndTitle
                                                            andTitle:@"支付确认"
                                                          andContent:@"支付尚未完成，是否退出？"
                                                         andBtnTitle:@"退出"];
    @weakify(self);
    view.sureBlock = ^{
        @strongify(self);
        if ([self contailController:NSClassFromString(@"MineViewController")]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        if ([self popToViewController:NSClassFromString(@"ACTCartVC")]) return;
        if ([self popToViewController:NSClassFromString(@"XKGoodDetailVC")])return;
        if ([self popToViewController:NSClassFromString(@"NBShopDetailVC")]) return;
    };
    [view show];
}

- (void)setupUI{
    [self.view addSubview:self.paymentBtn];
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    self.title = @"支付订单";
    

    [self.tableView registerClass:[CMOrderDetailCell class] forCellReuseIdentifier:@"CMOrderDetailCell"];
    [self.tableView registerClass:[CMOrderPaymentCell class] forCellReuseIdentifier:@"CMOrderPaymentCell"];
    [self.paymentBtn setTitle:[NSString stringWithFormat:@"支付金额 ￥%.2f",[self.displayModel.payAmount intValue]/100.0f] forState:UIControlStateNormal];
    [self.paymentBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)layout{
    [self.paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
        make.bottom.mas_equalTo(-[XKUIUnitls safeBottom]-12.0f);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.paymentBtn.mas_top).offset(-12.0f);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
    }];
}


#pragma mark tableview data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.displayModel.type == OTGlobalSeller ||
            self.displayModel.type == OTMyOTO ||
            self.displayModel.type == OTWug) {
            return 4;
        }
        if (self.displayModel.type == OTDiscount) {
            return 2;
        }
        return 3;
    }else{
        return _payTypes.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30.0f, 20.0f)];
        view.backgroundColor = HexRGB(0xffffff, 1.0f);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        view.layer.mask = layer;
        return view;
    }else{
        UIView *paymentHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30.0f, 40.0f)];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"支付方式";
        label.textColor = HexRGB(0x444444, 1.0f);
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        [label sizeToFit];
        label.x = 20.0f;
        label.y = 20.0f;
        [paymentHeadView addSubview:label];
        paymentHeadView.backgroundColor = HexRGB(0xffffff, 1.0f);
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:paymentHeadView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(6, 6)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        paymentHeadView.layer.mask = layer;
        return paymentHeadView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = COLOR_VIEW_GRAY;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }else{
        return 40.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CMOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderDetailCell" forIndexPath:indexPath];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        NSArray *titles = nil;
        NSArray *details = nil;
        switch (self.displayModel.type) {
            case OTMyOTO:{
                titles = @[@"订单号",@"订单金额",@"优惠券",@"实际支付金额"];
                NSString *orderNo = self.displayModel.orderNo ?:@"";
                NSString *orderAmount = [NSString stringWithFormat:@"¥%.2f",self.displayModel.orderAmount.doubleValue/100.00f];
                NSString *deductionCouponAmount = [NSString stringWithFormat:@"¥%.2f",self.displayModel.deductionCouponAmount.doubleValue/100.00f];
                NSString *payAmount = [NSString stringWithFormat:@"¥%.2f",self.displayModel.payAmount.doubleValue/100.00f];
                details = @[orderNo,orderAmount,deductionCouponAmount,payAmount];
            }
                break;
            case OTWug:{
                titles = @[@"订单号",@"商品",@"订单金额",@"赠送优惠券"];
                NSString *orderNo = self.displayModel.orderNo ?:@"";
                NSString *goodsName = self.displayModel.goodsName?:@"";
                NSString *payAmount = [NSString stringWithFormat:@"¥%.2f",self.displayModel.payAmount.doubleValue/100.00f];
                NSString *deductionCouponAmount = [NSString stringWithFormat:@"¥%.2f",self.displayModel.deductionCouponAmount.doubleValue/100.00f];
                details = @[orderNo,goodsName,payAmount,deductionCouponAmount];
            }
                break;
            case OTGlobalSeller:{
                titles = @[@"订单号",@"商品",@"订单金额",@"消耗优惠券"];
                NSString *orderNo = self.displayModel.orderNo ?:@"";
                NSString *goodsName = self.displayModel.goodsName?:@"";
                NSString *payAmount = [NSString stringWithFormat:@"￥%.2f",self.displayModel.payAmount.doubleValue/100.00f];
                NSString *deductionCouponAmount = [NSString stringWithFormat:@"￥%.2f",self.displayModel.deductionCouponAmount.doubleValue/100.00f];
                details = @[orderNo,goodsName,payAmount,deductionCouponAmount];
            }
                break;
            case OTDiscount:{
                titles = @[@"订单号",@"订单金额"];
                NSString *orderNo = self.displayModel.orderNo ?:@"";
                NSString *payAmount = [NSString stringWithFormat:@"￥%.2f",self.displayModel.payAmount.doubleValue/100.00f];
                details = @[orderNo,payAmount];
            }
                break;
            default:
                titles = @[@"订单号",@"商品",@"订单金额"];
                NSString *orderNo = self.displayModel.orderNo ?:@"";
                NSString *goodsName = self.displayModel.goodsName?:@"";
                NSString *payAmount = [NSString stringWithFormat:@"¥%.2f",self.displayModel.payAmount.doubleValue/100.00f];
                details = @[orderNo,goodsName,payAmount];
                break;
        }
        cell.textLabel.text = titles[indexPath.row];
        cell.detailTextLabel.text = details[indexPath.row];
        return cell;
    }else{
        CMOrderPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderPaymentCell" forIndexPath:indexPath];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        PayTypeModel *model = _payTypes[indexPath.row];
        cell.imageView.image = model.img;
        cell.textLabel.text  = model.payTypeName;
        if (indexPath.row == 3) {
            cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, -kScreenWidth);
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 20.0f, 0, 20.0f);
        }
        cell.paidSelect = (model.payType == _type);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    UIBezierPath *bezierPath;
    CGRect rect = cell.bounds;
    if (indexPath.row == numberOfRows - 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(6, 6)];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    cell.layer.mask = layer;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        PayTypeModel *model = _payTypes[indexPath.row];
        _type = model.payType;
        [self.tableView reloadData];
    }
}

#pragma mark delegate for CMPaymentPaswSheet
- (void)paymentPaswSheet:(MIPaymentPaswSheet *)sheet inputPassword:(NSString *)password{
    [sheet dismiss];
    XKOrderPayRequestParam *param = [[XKOrderPayRequestParam alloc]init];
    param.payWay        = Pay_Redpackge;
    param.payPassword   = password;
    param.paymentAmount = self.displayModel.payAmount;
    [self payWithParam:param];
}

- (void)resetPassword:(MIPaymentPaswSheet *)sheet{
    MIPwdResettingVC *controller = [[MIPwdResettingVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark action

- (void)payAction:(id)sender{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    if ([NSString isNull:userId] || [[XKAccountManager defaultManager] isLogin] == NO) {//未登录
        [MGJRouter openURL:kRouterLogin];
        return;
    }
    if(_type != RedPackgePay){/*不是钱包支付，直接支付*/
        XKOrderPayRequestParam *param = [[XKOrderPayRequestParam alloc]init];
        self.paymentBtn.enabled = NO;
        if (_type == WXPay) {
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a = [dat timeIntervalSince1970];
            NSString *time = [NSString stringWithFormat:@"%.f",a];
            
            param.timestamp = @([time integerValue]);
            param.payWay = Pay_Wx;
        }
        if (_type == AliPay) {
            param.payWay = Pay_Ali;
        }
        [self payWithParam:param];
        return;
    }
    //钱包支付
    
    /*未实名认证 实名认证*/
    if([[XKAccountManager defaultManager] isVer] == NO){
        XKShowToast(@"请先实名认证");
        [MGJRouter openURL:kRouterAuthen];
        return;
    }
    
    /*已设置密码，直接支付*/
    if ([[XKAccountManager defaultManager] isPayPassword]) {
        MIPaymentPaswSheet *sheet = [[MIPaymentPaswSheet alloc] initWithDelegate:self];
        [sheet show];
        return;
    }
    
    [[XKFDataService() userService] queryPaymentPasswordIsSettingWithUserId:userId completion:^(XKBaseResponse * _Nonnull response) {
        if (response.isSuccess) {
            if([response.data isKindOfClass:[NSNumber class]] && [response.data boolValue]){
                MIPaymentPaswSheet *sheet = [[MIPaymentPaswSheet alloc] initWithDelegate:self];
                [sheet show];
            }else{
                XKShowToast(@"请先设置支付密码");
                [self.navigationController pushViewController:[MIPwdResettingVC new] animated:YES];
            }
        }else{
            [response showError];
        }
    }];
}

- (void)payWithParam:(XKOrderPayRequestParam *)param{
    
    param.orderNo = self.displayModel.orderNo;
    param.clientType = @"ios";
    param.osType     = OS_Ios;
    param.payType    = App;
    if (self.displayModel.isPayByOthers) {
        param.orderType = OTMyPayment;
    }else{
        param.orderType  = self.displayModel.type;
    }
    param.userId     = [XKAccountManager defaultManager].userId;
    
    [XKLoading showNeedMask:YES];
    [[XKFDataService() orderService]orderPayWithParam:param comlete:^(XKBaseResponse * _Nonnull response) {
        self.paymentBtn.enabled = YES;
        [XKLoading dismiss];
        if ([response isSuccess]) {
            if (param.payWay == WXPay) {
                if (!response.data) {
                    XKShowToast(@"订单数据错误");
                    return ;
                }
                [XKAccountManager defaultManager].weixinPayKey = response.data[@"appid"];
                [[WXApiManager defaultManager] registerApp:response.data[@"appid"]];
                [[XKPayManger sharedMange]wxPay:response.data complete:^(PayType type, BOOL isSuccess, NSError * _Nonnull error) {
                    [self payResult:isSuccess andError:error];
                }];
            }else if (param.payWay == AliPay){
                if (!response.data) {
                    XKShowToast(@"订单数据错误");
                    return ;
                }
                [[XKPayManger sharedMange]aliPay:response.data[@"aliPay"] complete:^(PayType type, BOOL isSuccess, NSError * _Nonnull error) {
                    [self payResult:isSuccess andError:error];
                    
                }];
            }else{
                [self payResult:YES andError:nil];
            }
        }else{
            [response showError];
        }
    }];
}

- (void)payResult:(BOOL)isSuccess andError:(NSError *)error{
    if (error.code == -1) {
        XKShowToast(error.domain);
        return;
    }
    if (isSuccess) {
        CMPayStateVC *controller = [[CMPayStateVC alloc] initWithPayState:CMStatePaySuccess];
        controller.orderNo   = self.displayModel.orderNo;
        controller.payAmount = self.displayModel.payAmount;
        controller.orderType = self.displayModel.type;
        controller.isPayByOthers = self.displayModel.isPayByOthers;
        controller.orderType = self.displayModel.type;
        controller.scheduleId = self.displayModel.scheduleId;
        controller.bargain = self.displayModel.bargain;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        CMPayStateVC *controller = [[CMPayStateVC alloc] initWithPayState:CMStatePayFaild];
        controller.isPayByOthers = self.displayModel.isPayByOthers;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor  = COLOR_LINE_GRAY;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 9.0f;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.estimatedRowHeight = 130.0f;
    }
    return _tableView;
}


- (UIButton *)paymentBtn{
    if (!_paymentBtn) {
        _paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _paymentBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _paymentBtn.layer.cornerRadius = 2.0f;
        [_paymentBtn setTitle:@"支付金额 ¥0.00" forState:UIControlStateNormal];
        [[_paymentBtn titleLabel] setFont:[UIFont systemFontOfSize:15.0f]];
        [_paymentBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
    }
    return _paymentBtn;
}


@end

