//
//  CMPayStateVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMPayStateVC.h"
#import "HMViews.h"
#import "MIOrderDetailVC.h"
#import "MIRedBagVC.h"
#import "MICashoutDetailVC.h"
#import "MIRedBagDetailVC.h"
#import "ACTBargainVC.h"
#import "CMBargainAlertView.h"
#import "XKOtherService.h"
#import "XKCustomAlertView.h"

@interface CMPayStateVC () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *stateLabel;

@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@property (nonatomic,strong)UIButton *homeBtn;

@property (nonatomic,strong)UIButton *priceBtn;

@property (nonatomic,strong)UIView *spreadLine;

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,assign)CMState state;

@property (nonatomic,strong)HMReusableView *reusableView;

@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;

@end


@implementation CMPayStateVC
@synthesize tapGesture = _tapGesture;

- (instancetype)initWithPayState:(CMState)state{
    if(self = [super init]){
        _state = state;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    self.rt_disableInteractivePop = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.stateLabel];
    [self.scrollView addSubview:self.priceLabel];
    [self.scrollView addSubview:self.homeBtn];
    [self.scrollView addSubview:self.priceBtn];
    [self.scrollView addSubview:self.detailTextLabel];
    
//    [self.scrollView addSubview:self.spreadLine];
//
//    [self.scrollView addSubview:self.reusableView];
//    [self.scrollView addSubview:self.collectionView];
    if (self.state == CMStatePaySuccess) {
        [self setupUIForPaySuccess];
    }else if(self.state == CMStatePayFaild){
        [self setupUIForPayFailed];
    }else if (self.state == CMStateCashSuccess) {
        [self setupUIForCashSuccess];
    }else if(self.state == CMStateCashFaild){
        [self setupUIForCashFailed];
    }else if (self.state == CMStateTransportSuccess){
        [self setupUIForTransportSuccess];
    }else if (self.state == CMStateTransportFailed){
        [self setupUIForTransportFailed];
    }
//    [self.collectionView registerClass:[CGGoodsCell class] forCellWithReuseIdentifier:@"CGGoodsCell"];
    [self layout];
}


- (void)setOrderNo:(NSString *)orderNo{
    _orderNo = orderNo;
}

- (void)setPayAmount:(NSNumber *)payAmount{
    _payAmount = payAmount;
    self.priceLabel.text = [NSString stringWithFormat:@"实际支付:¥%.2f",[self.payAmount doubleValue]/100];
}

- (void)setupUIForPaySuccess{
    self.imageView.image = [UIImage imageNamed:@"pay_success"];
    self.stateLabel.text = @"支付成功";
    self.priceLabel.hidden = NO;
    if(self.isPayByOthers || self.orderType == OTMyOTO || self.orderType == OTMyPayment){
        self.priceBtn.hidden = YES;
    }else{
        self.priceBtn.hidden = NO;
    }
    [self.priceBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    if (self.orderType == OTBargain && self.bargain) {
        [self.homeBtn setTitle:@"更多砍价" forState:UIControlStateNormal];
        self.detailTextLabel.text = @"现金红包已发放至帮您砍价的好友账户 >";
        [self.detailTextLabel addGestureRecognizer:self.tapGesture];
    }else{
        [self.homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
        self.detailTextLabel.text = nil;
        self.detailTextLabel.hidden = YES;
    }
}

- (void)setupUIForPayFailed{
    self.imageView.image = [UIImage imageNamed:@"pay_failed"];
    self.stateLabel.text = @"支付失败";
    self.priceLabel.hidden = YES;
    [self.priceBtn setTitle:@"重新支付" forState:UIControlStateNormal];
    [self.homeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
}

- (void)setupUIForCashSuccess{
    self.imageView.image = [UIImage imageNamed:@"pay_success"];
    self.stateLabel.text = @"申请提现成功";
    self.priceLabel.hidden = YES;
    [self.priceBtn setTitle:@"查看提现明细" forState:UIControlStateNormal];
    [self.homeBtn setTitle:@"返回我的账户" forState:UIControlStateNormal];
}

- (void)setupUIForCashFailed{
    self.imageView.image = [UIImage imageNamed:@"pay_failed"];
    self.stateLabel.text = @"申请提现失败";
    self.priceLabel.hidden = YES;
    [self.priceBtn setTitle:@"查看提现明细" forState:UIControlStateNormal];
    [self.homeBtn setTitle:@"返回我的账户" forState:UIControlStateNormal];
    [self.priceBtn setHidden:YES];
}

- (void)setupUIForTransportSuccess{
    self.imageView.image = [UIImage imageNamed:@"pay_success"];
    self.stateLabel.text = @"转账成功";
    [self.priceBtn setTitle:@"查看转账明细" forState:UIControlStateNormal];
    [self.homeBtn setTitle:@"返回我的账户" forState:UIControlStateNormal];
}

- (void)setupUIForTransportFailed{
    self.imageView.image = [UIImage imageNamed:@"pay_failed"];
    self.stateLabel.text = @"转账失败";
    [self.priceBtn setTitle:@"查看转账明细" forState:UIControlStateNormal];
    [self.homeBtn setTitle:@"返回我的账户" forState:UIControlStateNormal];
}

- (void)layout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(94.0f);
        make.centerX.equalTo(self.scrollView);
        make.width.height.mas_equalTo(60.0f);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(16.0f);
        make.centerX.equalTo(self.imageView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(12.0f);
        make.centerX.equalTo(self.imageView);
    }];
    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(34.0f);
        make.height.mas_equalTo(40.0f);
        make.centerX.equalTo(self.priceLabel);
        make.width.mas_equalTo(285.0f);
    }];
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeBtn.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(40.0f);
        make.centerX.width.equalTo(self.homeBtn);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceBtn.mas_bottom).offset(15.0f);
        make.height.mas_equalTo(20.0f);
        make.centerX.width.equalTo(self.priceBtn);
    }];
    
//    [self.spreadLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.priceBtn.mas_bottom).offset(56.0f);
//        make.height.mas_equalTo(10.0f);
//        make.left.right.equalTo(self.scrollView);
//    }];
//    [self.reusableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.width.equalTo(self.scrollView);
//        make.right.equalTo(self.scrollView);
//        make.top.mas_equalTo(self.spreadLine.mas_bottom);
//        make.height.mas_equalTo(58.0f);
//
//    }];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.scrollView).offset(15.0f);
//        make.right.equalTo(self.scrollView).offset(-15.0f);
//        make.height.mas_equalTo(scalef(170.0f));
//        make.top.mas_equalTo(self.reusableView.mas_bottom);
//    }];
}

- (void)rePayAction{
    if (self.state == CMStatePayFaild) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.state == CMStatePaySuccess){
        MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:self.orderNo andType:self.orderType];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.state == CMStateCashSuccess || self.state == CMStateCashFaild){
        __block UIViewController *controller = nil;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[MIRedBagVC class]]) {
                controller = obj;
                *stop = YES;
            }
        }];
        if (controller) {
            NSMutableArray<UIViewController *> *controllers = [NSMutableArray array];
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [controllers addObject:obj];
                if (obj == controller) {
                    *stop = YES;
                }
            }];
            MICashoutDetailVC *vc = [[MICashoutDetailVC alloc] init];
            [controllers addObject:vc];
            [self.navigationController setViewControllers:controllers animated:YES];
        }else{
            MICashoutDetailVC *vc = [[MICashoutDetailVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (self.state == CMStateTransportSuccess || self.state == CMStateTransportFailed){
        __block UIViewController *controller = nil;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[MIRedBagVC class]]) {
                controller = obj;
                *stop = YES;
            }
        }];
        if (controller) {
            NSMutableArray<UIViewController *> *controllers = [NSMutableArray array];
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [controllers addObject:obj];
                if (obj == controller) {
                    *stop = YES;
                }
            }];
            MIRedBagDetailVC *vc = [[MIRedBagDetailVC alloc] init];
            [controllers addObject:vc];
            [self.navigationController setViewControllers:controllers animated:YES];
        }else{
            MIRedBagDetailVC *vc = [[MIRedBagDetailVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)homeAction{
    if(self.state == CMStateCashSuccess || self.state == CMStateCashFaild || self.state == CMStateTransportSuccess || self.state == CMStateTransportFailed){
        __block UIViewController *controller = nil;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isMemberOfClass:[MIRedBagVC class]]) {
                controller = obj;
                *stop = YES;
            }
        }];
        if (controller) {
            [self.navigationController popToViewController:controller animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        if (self.orderType == OTBargain) {
            __block UIViewController *controller = nil;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               if ([obj isMemberOfClass:[ACTBargainVC class]]) {
                   controller = obj;
                   *stop = YES;
               }
           }];
            NSMutableArray<UIViewController *> *controllers = [NSMutableArray array];
            if (controller) {
               [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   [controllers addObject:obj];
                   if (obj == controller) {
                       *stop = YES;
                   }
               }];
               [self.navigationController setViewControllers:controllers animated:YES];
           }else{
               [controllers addObject:[self.navigationController.viewControllers firstObject]];
               ACTBargainVC *vc = [[ACTBargainVC alloc] init];
               [controllers addObject:vc];
               [self.navigationController setViewControllers:controllers animated:YES];
           }
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }
    
}
#pragma mark getter or setter
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CGGoodsCell" forIndexPath:indexPath];
    CGFloat hspace = 0.5*(CGRectGetWidth(collectionView.frame)-CGRectGetWidth(cell.frame)*3);
    if (hspace < 0) {
        hspace = 0;
    }
    CGFloat x = -0.5*hspace + (hspace+ CGRectGetWidth(cell.frame)) * indexPath.row;
    do{
        if (x <= 0)break;
        UIView *horizontalLine = [collectionView viewWithTag:100+indexPath.row];
        if (horizontalLine)break;
        horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(x,0, 1, scalef(100.0f))];
        horizontalLine.tag  = 100+indexPath.row;
        horizontalLine.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
        [collectionView addSubview:horizontalLine];
    }while (0);
    NSString *price = nil;
    NSString *opr = nil;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"k1"];
        cell.textLabel.text = @"稻草人女包2019新款时尚百搭可爱...";
        price = @"399";
        opr = @"599";
    }else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"k2"];
        cell.textLabel.text = @"金吊坠正品玫瑰金四叶草花朵";
        price = @"776";
        opr = @"924";
    }else{
        cell.imageView.image = [UIImage imageNamed:@"k3"];
        cell.textLabel.text = @"黄金转运珠手链男女款3D硬金貔貅...";
        price = @"1389";
        opr = @"2389";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:9.0f],NSForegroundColorAttributeName:HexRGB(0xef421c, 1.0f)}];
    NSAttributedString *astr1 = [[NSMutableAttributedString alloc] initWithString:[price stringByAppendingString:@"  "] attributes:@{NSForegroundColorAttributeName:HexRGB(0xef421c, 1.0f),NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}];
    NSAttributedString *astr2 = [[NSMutableAttributedString alloc] initWithString:[@"¥" stringByAppendingString:opr] attributes:@{NSForegroundColorAttributeName:HexRGB(0xcccccc, 1.0f),NSFontAttributeName:[UIFont boldSystemFontOfSize:10.0f],NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
    [attributedString appendAttributedString:astr1];
    [attributedString appendAttributedString:astr2];
    cell.priceLabel.attributedText = attributedString;
    return cell;
}

- (void)tapAction{
    [XKLoading show];
    [[XKFDataService() otherService] queryBargainRecordByScheduleId:self.scheduleId completion:^(XKBargainScheduleResponse * _Nonnull response) {
        [XKLoading dismiss];
        if (response.isSuccess) {
            if (response.data.count > 0) {
                CMBargainAlertView *alertView = [[CMBargainAlertView alloc] init];
                alertView.scheduleDatas = response.data;
                [alertView show];
            }else{
                XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"恭喜您完成砍价购买" andContent:@"现金红包正在发放中请稍等" andBtnTitle:@"确定"];
                [alertView show];
            }
        }else{
            [response showError];
        }
    }];
}


#pragma mark getter or setter

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)stateLabel{
    if(!_stateLabel){
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = HexRGB(0x444444, 1.0f);
        _stateLabel.font = [UIFont systemFontOfSize:15.0f];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (UILabel *)detailTextLabel{
    if(!_detailTextLabel){
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x4a4a4a, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.userInteractionEnabled = YES;
    }
    return _detailTextLabel;
}


- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HexRGB(0x999999, 1.0f);
        _priceLabel.font = [UIFont systemFontOfSize:12.0f];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UIButton *)homeBtn{
    if (!_homeBtn) {
        _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _homeBtn.layer.cornerRadius = 2.0f;
        _homeBtn.layer.borderColor = [HexRGB(0x999999, 1.0f) CGColor];
        _homeBtn.layer.borderWidth = 1.f;
        _homeBtn.backgroundColor = HexRGB(0xffffff, 1.0f);
        _homeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_homeBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _homeBtn;
}

- (UIButton *)priceBtn{
    if (!_priceBtn) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceBtn.layer.cornerRadius = 2.0f;
        _priceBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _priceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_priceBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_priceBtn addTarget:self action:@selector(rePayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceBtn;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIView *)spreadLine{
    if (!_spreadLine) {
        _spreadLine = [[UIView alloc] init];
        _spreadLine.backgroundColor = COLOR_VIEW_GRAY;
    }
    return _spreadLine;
}

- (HMReusableView *)reusableView{
    if (!_reusableView) {
        _reusableView = [[HMReusableView alloc] init];
//        _reusableView.textLabel.text = @"砍立得";
//        _reusableView.detailTextLabel.text = @"分享好友 砍价得红包";
    }
    return _reusableView;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    }
    return _tapGesture;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = scale_size(100.0f, 170.0f);
        _flowLayout.minimumLineSpacing = 0.5*(kScreenWidth-30.0f-3*scalef(100.0f));
        _flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end
