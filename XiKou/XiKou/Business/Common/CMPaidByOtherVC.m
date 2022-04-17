//
//  CMPaidByOtherVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMPaidByOtherVC.h"
#import "XKCustomAlertView.h"
#import "CMOrderCells.h"
#import "XKOrderService.h"
#import "XKAccountManager.h"
#import "CMOrderCells.h"
@interface CMPaidByOtherVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImageView *backgroundImageView;

@property (nonatomic,strong)UILabel *hintLabel;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UILabel *balanceLabel;

@property (nonatomic, strong) XKOrderBaseModel *displayModel;

@property (nonatomic, assign) NSInteger selectedOtherPay;

@property (nonatomic, strong) NSString *friendPhone;

@property (nonatomic, strong) NSString *friendUserId;

@end

@implementation CMPaidByOtherVC

- (instancetype)initWithOrder:(XKOrderBaseModel *)displayModel{
    self = [super init];
    if (self) {
        _displayModel = displayModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发起代付";
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
    //默认请合伙人代付
    self.selectedOtherPay = 2;
    self.friendPhone = @"";
    self.friendUserId = @"";
    [self setupUI];
    [self layout];
    @weakify(self);
    self.willPopBlock = ^BOOL{
        @strongify(self);
        XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"提示" andContent:@"确认退出该笔订单代付？" andBtnTitle:@"确定"];
        alertView.sureBlock = ^{
            if ([self popToViewController:NSClassFromString(@"XKGoodDetailVC")])return;
            [self.navigationController popViewControllerAnimated:YES];
        };
        [alertView show];
        return NO;
    };
    
    self.balanceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_displayModel.payAmount floatValue]/100];
    
}

- (void)setupUI{
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.hintLabel];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[CMOrderDetailCell class] forCellReuseIdentifier:@"CMOrderDetailCell"];
}


- (void)layout{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(245+[XKUIUnitls safeTop]);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30 + kTopHeight);
        make.centerX.equalTo(self.view);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hintLabel.mas_bottom).offset(7);
        make.centerX.equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.mas_equalTo(self.balanceLabel.mas_bottom).offset(34);
        make.bottom.mas_equalTo(-([XKUIUnitls safeBottom] + 30));
    }];
}

#pragma mark tableview data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        CMOrderPaidByOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderPaidByOtherCell"];
        if (cell == nil) {
            cell = [[CMOrderPaidByOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CMOrderPaidByOtherCell"];
        }
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
    CMOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMOrderDetailCell" forIndexPath:indexPath];
    NSArray *titles = @[@"订单号",@"商品",@"合伙人ID"];
    cell.textLabel.text = titles[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = _displayModel.orderNo;
    }
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = _displayModel.goodsName;
    }
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = _displayModel.partnerId;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    
    UIBezierPath *bezierPath;
    if (indexPath.row == 0) {
        if (numberOfRows == 1) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(4, 4)];
        }else{
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
        }
        cell.separatorInset  = UIEdgeInsetsMake(0, 10, 0, 10);
    }else if (indexPath.row == numberOfRows - 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
        cell.separatorInset  = UIEdgeInsetsMake(0, kScreenWidth, 0, 10);
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:cell.bounds];
        cell.separatorInset  = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    cell.layer.mask = layer;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   if (indexPath.section == 1) {
        CMOrderPaidByOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 1) { //请好友代付
            self.selectedOtherPay = 1;
            [MGJRouter openURL:kRouterSearchFriend withUserInfo:@{@"phoneBlock":^(NSString *phone,NSString *userId){
                self.friendPhone = phone;
                self.friendUserId = userId;
                [cell setPayStyle:YES friendPhone:phone];
            }} completion:nil];
        }else{
            self.selectedOtherPay = 2;
            [cell setPayStyle:NO friendPhone:@""];
        }
       [self.tableView reloadData];
    }
}
- (void)payForAnother{
    
    NSString *contentStr = self.selectedOtherPay == 1 ? [NSString stringWithFormat:@"你想让%@帮你代付吗？",self.friendPhone] : @"你想让合伙人帮你代付吗？";
    XKCustomAlertView *view = [[XKCustomAlertView alloc]initWithType:CanleAndTitle
                                                            andTitle:@"提示"
                                                          andContent:contentStr
                                                         andBtnTitle:@"确定"];
    @weakify(self);
    view.sureBlock = ^{
        @strongify(self);
        NSString *userId = @"";
        if (self.selectedOtherPay == 1) {
            userId = self.friendUserId ?: @"";
        }else{
            userId = [[XKAccountManager defaultManager] userId] ?: @"";
            self.friendPhone = @"";
        }
        NSString *mobile = [self.friendPhone deleteSpace];
        [[XKFDataService() orderService] payByAnotherWithOrderNo:self.displayModel.orderNo andOrdertype:self.displayModel.type andUserId:userId andPhone:mobile comlete:^(XKBaseResponse * _Nonnull response) {
            if (response.isSuccess) {
                XKShowToastCompletionBlock(@"发起代付成功", ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [response showError];
            }
        }];
    };
    [view show];
}


#pragma mark getter or setter
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    }
    return _backgroundImageView;
}


- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = HexRGB(0xc0c0c0, 1.0f);
        _hintLabel.text = @"代付金额";
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.font = Font(12.f);
    }
    return _hintLabel;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = HexRGB(0xffffff, 1.0f);
        _balanceLabel.font = FontMedium(25.f);
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _balanceLabel;
}

#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces  = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        UIView *footView = [[UIView alloc]init];
        footView.frame = CGRectMake(0, 0, kScreenWidth - 30, 55);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 15, kScreenWidth - 30, 40);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius  = 4.f;
        [button setBackgroundColor:COLOR_TEXT_BLACK];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button.titleLabel setFont:Font(15.f)];
        [button addTarget:self action:@selector(payForAnother) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:button];
        
        _tableView.tableFooterView = footView;
        
    }
    return _tableView;
}


@end
