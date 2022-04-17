//
//  NBCashVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBCashVC.h"
#import "XKUIUnitls.h"
#import "NBCells.h"
#import <AFViewShaker.h>
#import "UILabel+NSMutableAttributedString.h"
#import "CMPaymentOrderVC.h"
#import "XKPropertyService.h"
#import "XKAccountManager.h"
#import "XKShopService.h"
#import "XKOtherService.h"

@interface NBCashVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) UIButton *payBtn;

@property (nonatomic,strong,readonly) XKShopBriefData *briefData;

@property (nonatomic,assign,readonly) int prefenceSum;

@end

@implementation NBCashVC
@synthesize tableView = _tableView;
@synthesize payBtn = _payBtn;

- (instancetype)initWithBriefData:(XKShopBriefData *)briefData{
    if (self = [super init]) {
        _briefData = briefData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.briefData.shopName;
    [self creatSubView];
    [self getPaySwitch];
    [self queryPrefenceAmount];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)creatSubView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payBtn];
    
    self.navigationController.navigationBar.tintColor = HexRGB(0x444444, 1.0f);
    [self.payBtn setTitle:@"确认买单" forState:UIControlStateNormal];
    [self.payBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
    [self.payBtn.titleLabel setFont:Font(14.f)];
    [self.payBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:UIControlStateDisabled];
    self.payBtn.backgroundColor = HexRGB(0x444444, 1.0f);
    [self.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupTabelView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
    }];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.equalTo(self.view).mas_offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(13.0f);
        make.bottom.equalTo(self.view).offset(-[XKUIUnitls safeBottom]-13.0f);
    }];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    self.tableView.tableFooterView = footView;
    
    UILabel *label = [UILabel new];
    label.text = @"提示说明\n1、当全额订单使用优惠劵时，可以享受商家设定的最大优惠比例\n2通过调节不享受优惠的金额，可以调节优惠劵的最佳使用额度";
    label.textColor = COLOR_HEX(0xCCCCCC);
    label.font = Font(10.f);
    label.numberOfLines = 3;
    [label setAttributedStringWithSubString:@"提示说明" color:COLOR_TEXT_GRAY font:FontSemibold(12.f)];
    [label setLineSpace:7.f];
    [footView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
}
- (void)setupTabelView{
    [self.tableView registerClass:[NBConsumeCell class] forCellReuseIdentifier:@"NBConsumeCell"];
    [self.tableView registerClass:[NBPreferentialCell class] forCellReuseIdentifier:@"NBPreferentialCell"];
    [self.tableView registerClass:[NBBalanceCell class] forCellReuseIdentifier:@"NBBalanceCell1"];
    [self.tableView registerClass:[NBBalanceCell class] forCellReuseIdentifier:@"NBBalanceCell2"];
}

#pragma mark data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NBConsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBConsumeCell" forIndexPath:indexPath];
        cell.textLabel.text = @"消费金额";
        cell.detailTextLabel.text = @"¥";
        cell.layer.cornerRadius = 4.0f;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"请咨询商家买单金额"];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:COLOR_TEXT_GRAY
                            range:NSMakeRange(0, placeholder.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:Font(13.f)
                            range:NSMakeRange(0, placeholder.length)];
        cell.textField.attributedPlaceholder = placeholder;
        return cell;
    }else if (indexPath.section == 1){
        NBPreferentialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBPreferentialCell" forIndexPath:indexPath];
        cell.textLabel.text = @"不参与优惠金额";
        cell.textField.placeholder = @"请输入金额";
        @weakify(self);
        cell.selectBlock = ^{
            @strongify(self);
            [self calculateData];
        };
        cell.layer.cornerRadius = 4.0f;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            NBBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBBalanceCell1" forIndexPath:indexPath];
            cell.textLabel.text = @"优惠券";
            cell.detailTextLabel.text = @"当前可用优惠劵¥0.0";
            cell.bottomLine.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            NBBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBBalanceCell2" forIndexPath:indexPath];
            cell.textLabel.text = @"实际支付金额";
            cell.detailTextLabel.text = @"不参与优惠金额+买单优惠后金额";
            cell.bottomLine.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        return;
    }
    //圆率
    CGFloat cornerRadius = 4.0;
    //大小
    CGRect bounds = cell.bounds;
    //行数
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    
    //绘制曲线
    UIBezierPath *bezierPath = nil;
    
    if (indexPath.row == 0 && numberOfRows == 1) {
        //一个为一组时，四个角都为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (indexPath.row == 0) {
        //为组的第一行时，左上、右上角为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (indexPath.row == numberOfRows - 1) {
        //为组的最后一行，左下、右下角为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else {
        //中间的都为矩形
        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    }
    //cell的背景色透明
    cell.backgroundColor = [UIColor clearColor];
    //新建一个图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    //图层边框路径
    layer.path = bezierPath.CGPath;
    //图层填充色，也就是cell的底色
    layer.fillColor = [UIColor whiteColor].CGColor;
    //图层边框线条颜色
    /*
     如果self.tableView.style = UITableViewStyleGrouped时，每一组的首尾都会有一根分割线，目前我还没找到去掉每组首尾分割线，保留cell分割线的办法。
     所以这里取巧，用带颜色的图层边框替代分割线。
     这里为了美观，最好设为和tableView的底色一致。
     设为透明，好像不起作用。
     */
   // layer.strokeColor = [UIColor grayColor].CGColor;
    //将图层添加到cell的图层中，并插到最底层
    [cell.layer insertSublayer:layer atIndex:0];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (void)textFieldChanged:(id)sender{
    if ([sender isKindOfClass:[NSNotification class]] == NO) {
        return;
    }
    UITextField *textField = nil;
    NSNotification *notif = (NSNotification *)sender;
    if ([notif.object isKindOfClass:[UITextField class]]) {
        textField = (UITextField *)notif.object;
    }
    [self calculateData];
}

- (void)calculateData{
    NBConsumeCell *consumeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NBPreferentialCell *preferentialCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NBBalanceCell *balanceCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    NBBalanceCell *balanceCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    /*获取折扣*/
    float disccount = self.briefData.discountRate.intValue*0.01;
    /*消费金额*/
    int consume = [consumeCell.textField.text floatValue]*100;
    int preferential = 0;//不参与优惠金额
    int actualSum = 0;//实际支付
    int discountSum = 0;//优惠金额
    
    if ([NSString isNull:consumeCell.textField.text]) {//消费金额没有值的时候
        balanceCell1.detailTextLabel.text = [NSString stringWithFormat:@"当前可用优惠劵¥%.2f",self.prefenceSum*0.01f];
        balanceCell2.detailTextLabel.text = @"不参与优惠金额+买单优惠后金额";
        return;
    }
    if (preferentialCell.selectBtn.isSelected && ![NSString isNull:preferentialCell.textField.text]) {
        preferential = [preferentialCell.textField.text floatValue]*100;
    }else{
        preferential = 0;
    }
    if (consume-preferential >= 0) {
        discountSum = (consume - preferential)*disccount;
        self.payBtn.enabled = YES;
    }else{
        discountSum = 0;
        self.payBtn.enabled = NO;
        XKShowToast(@"输入金额有误,请重新输入");
    }
    if (discountSum > self.prefenceSum) {
        XKShowToast(@"您的优惠券不足支付");
        balanceCell1.detailTextLabel.text = [NSString stringWithFormat:@"当前可用优惠劵¥%.2f",self.prefenceSum*0.01];
        balanceCell2.detailTextLabel.text = @"不参与优惠金额+买单优惠后金额";
        return;
    }
    actualSum = consume - discountSum;
    balanceCell1.detailTextLabel.text = [NSString stringWithFormat:@"优惠金额 ¥%.2f",discountSum*0.01];
    balanceCell2.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",actualSum*0.01];
}

- (void)queryPrefenceAmount{
    [XKLoading show];
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    @weakify(self);
    [[XKFDataService() propertyService] getPreferenceAmountWithId:userId completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (response.isSuccess) {
            self->_prefenceSum = [(NSNumber *)response.data  intValue];
            NBBalanceCell *balanceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            balanceCell.detailTextLabel.text = [NSString stringWithFormat:@"当前可用优惠劵¥%.2f",self.prefenceSum*0.01f];
        }
    }];
}

#pragma mark ------- 获取下单开关,底部按钮状态处理
- (void)getPaySwitch{
    [[XKFDataService() otherService]queryPaySwitchCompletion:^(XKPaySwitchResponse * _Nonnull response) {
        if ([response isSuccess]) {
            self.payBtn.enabled = response.data.oto;
        }
    }];
}

- (void)creatOrder{
    NBConsumeCell *consumeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NBPreferentialCell *preferentialCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    float disccount = self.briefData.discountRate.floatValue*0.01;
    int consume = [consumeCell.textField.text floatValue]*100;
    int preferential = 0;
    int actualSum = 0;
    int discountSum = 0;
    
    if ([NSString isNull:consumeCell.textField.text]) {
        AFViewShaker *shakerView = [[AFViewShaker alloc] initWithView:consumeCell.textField];
        [shakerView shake];
        return;
    }
    if (preferentialCell.selectBtn.isSelected && ![NSString isNull:preferentialCell.textField.text]) {
        preferential = [preferentialCell.textField.text floatValue]*100;
    }else{
        preferential = 0;
    }
    if (consume-preferential > 0) {
        discountSum = (consume - preferential)*disccount;
    }else{
        discountSum = 0;
    }
    if (discountSum > self.prefenceSum) {
        XKShowToast(@"优惠券余额不足");
        return;
    }
    actualSum = consume - discountSum;
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKShopOrderParams *params = [[XKShopOrderParams alloc] init];
    params.deductionCouponAmount = @(discountSum);
    params.discount = @((int)(disccount*100));
    params.merchantId = self.briefData.merchantId;
    params.nonOfferAmount = @(preferential);
    params.orderAmount = @(consume);
    params.payAmount = @(actualSum);
    params.orderSource = @(1);//表示订单来源是APP
    params.shopId = self.briefData.id;
    params.buyerId = userId;
    [XKLoading show];
    self.payBtn.enabled = NO;
    [[XKFDataService() shopService] createOTOOrderWithParams:params completion:^(XKShopOrderResponse * _Nonnull response) {
        [XKLoading dismiss];
        self.payBtn.enabled = YES;
        if (response.isSuccess) {
            XKOrderBaseModel *dataModel = [XKOrderBaseModel yy_modelWithJSON:[response.data yy_modelToJSONObject]];
            dataModel.type = OTMyOTO;
            [MGJRouter openURL:kRouterPay withUserInfo:@{@"key":dataModel} completion:nil];
        }else{
            [response showError];
        }
    }];
}

- (void)payAction:(id)sender{
    [self creatOrder];
}

#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 120.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
        _tableView.sectionHeaderHeight = 9.f;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _payBtn;
}

@end
