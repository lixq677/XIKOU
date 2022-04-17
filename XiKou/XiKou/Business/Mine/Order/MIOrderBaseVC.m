//
//  MIOrderBaseVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderBaseVC.h"
#import "MIOrderListVC.h"
#import "MIDiscountOrderListVC.h"
#import "MIOrderSearchVC.h"
#import "XKSegmentView.h"
#import "XKAccountManager.h"
#import <MeiQiaSDK/MQManager.h>
#import "MQChatViewManager.h"

@interface MIOrderBaseVC ()<XKSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) XKSegmentView *segmentView;

@property (nonatomic, strong) UIScrollView *contetView;

@property (nonatomic, strong) NSMutableDictionary *vcs;

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UIImageView *tipsIcon;


@property (nonatomic, assign) XKOrderType type;
@end

@implementation MIOrderBaseVC
{
    NSArray *_statusArray;
}
- (instancetype)initWithType:(XKOrderType)type{
    self = [super init];
    if (self) {
        _type = type;
        _vcs  = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];
    [self initUI];
//    [self getWugLimiteBalance];
}

//初始化标题
- (void)initTitle{

    if (_type == OTZeroBuy)      self.title = @"0元抢订单";
    if (_type == OTDiscount)     self.title = @"多买多折订单";
    if (_type == OTBargain)      self.title = @"砍立得订单";
    if (_type == OTWug)          self.title = @"吾G订单";
    if (_type == OTGlobalSeller) self.title = @"全球买手订单";
    if (_type == OTCustom)       self.title = @"拼团订单";
    if (_type == OTConsigned)  self.title = @"寄卖订单";
    if (_type == OTNewUser)  self.title = @"新人专区订单";
//    if (_type == OTConsigning) {
//        [self addNavigationItemWithImageName:@"item_service" isLeft:NO target:self action:@selector(customerClick)];
//    }else{
//        if (_type == OTCanConsign) return;
    [self addNavigationItemWithImageName:@"filter" isLeft:NO target:self action:@selector(filterClick)];
    
}
#pragma mark - netword data
- (void)getWugLimiteBalance {
    NSString *userId = [XKAccountManager defaultManager].account.userId ?:@"";
    @weakify(self);
    [[XKFDataService() orderService] getWugLimitBlanceWithUserId:userId comlete:^(XKWugOderLimitBanalceData * _Nonnull response) {
        @strongify(self);
        XKWugOderLimitBanalce *limitModel = response.data;
        CGFloat banlance = 0.00;
        CGFloat limitMoney = 0.00;
        NSString *limitStr = [NSString stringWithFormat:@"吾G专区每月限购%.2f元",limitMoney];
        if (limitModel.limitAmount >= 10000 ) {
             limitMoney = limitModel.limitAmount/100.0/10000.0;
            limitStr = [NSString stringWithFormat:@"吾G专区每月限购%.2f万元",limitMoney];
        }else if (limitMoney > 0) {
            limitMoney = limitModel.limitAmount/100.0;
            limitStr = [NSString stringWithFormat:@"吾G专区每月限购%.2f元",limitMoney];
        }
        if (limitModel.balance > 0) {
            banlance = limitModel.balance/100.0;
        }
      NSString *tips = [NSString stringWithFormat:@"%@ 当前剩余额度%.2f元",limitStr,banlance];
        self.tipsLabel.text = tips;
    }];
}
#pragma mark action
- (void)customerClick{
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)filterClick{
    MIOrderSearchVC *vc = [MIOrderSearchVC new];
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UI
- (void)initUI{
    
    NSArray *segmentTitles = [NSArray array];
    if (_type == OTZeroBuy ||
        _type == OTBargain ||
        _type == OTDiscount ||
        _type == OTWug ||
        _type == OTCustom ||
        _type == OTConsigned) {
        segmentTitles = @[@"全部",@"待付款",@"待发货",@"待收货"];
        _statusArray = @[@0,@(OSUnPay),@(OSUnDeliver),@(OSUnReceive)];
    }
    if (_type == OTGlobalSeller) {
        segmentTitles = @[@"全部",@"待付款",@"待确认",@"待发货",@"待收货"];
        _statusArray = @[@0,@(OSUnPay),@(OSUnSure),@(OSUnDeliver),@(OSUnReceive)];
    }
    
    if (segmentTitles.count > 0) {
        _segmentView = [[XKSegmentView alloc]initWithTitles:segmentTitles];
        _segmentView.delegate = self;
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.style = XKSegmentViewStyleJustified;
        [self.view addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(45);
        }];
    }
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self showTipsView];
    self.tipsView.hidden = YES;
    _contetView = [[UIScrollView alloc]init];
    _contetView.showsHorizontalScrollIndicator = NO;
    _contetView.pagingEnabled = YES;
    _contetView.delegate = self;
    _contetView.contentSize = CGSizeMake(kScreenWidth * segmentTitles.count, 0);
    [self.view addSubview:_contetView];
    [_contetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (self.type == OTWug && !self.tipsView.hidden) {
            make.top.equalTo(self.tipsView.mas_bottom).offset(3);
        }else if(segmentTitles.count > 0){
            make.top.equalTo(self.segmentView.mas_bottom);
        }else{
            make.top.equalTo(self.view);
        }
    }];
    [self sliderIndex:0];
}
- (void)showTipsView {
    if (self.type != OTWug) {
        return;
    }
    [self.view addSubview:self.tipsView];
    [self.tipsView addSubview:self.tipsIcon];
    [self.tipsView addSubview:self.tipsLabel];
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.segmentView) {
            make.top.equalTo(self.segmentView.mas_bottom);
        }else{
            make.top.equalTo(self.view);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    [self.tipsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsView).offset(15);
        make.centerY.equalTo(self.tipsView);
        make.size.mas_equalTo(CGSizeMake(11, 12));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipsIcon.mas_right).offset(10);
        make.centerY.equalTo(self.tipsView);
    }];
    
}
//滚动
- (void)sliderIndex:(NSInteger)index{
    if (![_vcs objectForKey:@(index)]) {
        if(_type == OTDiscount && (index == 0 || index == 1)){ //多买多折的订单，全部或者未付款时一个订单可能会有多个商品多个店铺,走这里，其他的状态页走普通订单列表
            MIDiscountOrderListVC *vc = [[MIDiscountOrderListVC alloc]init];
            vc.status = index == 0 ? 0 : OSUnPay;
            [_vcs setObject:vc forKey:@(index)];
            [self addChildViewController:vc];
            [self.contetView addSubview:vc.view];
            [self.contetView setNeedsLayout];
            [self.contetView layoutIfNeeded];
            vc.view.frame = CGRectMake(self.contetView.width * index, 0, kScreenWidth, self.contetView.height);
        }
        else{
            MIOrderListVC *vc;
            if (index < _statusArray.count) {
                vc = [[MIOrderListVC alloc]initWithOrderType:self.type andOrderStatus:[_statusArray[index] integerValue]];
            }else{
                vc = [[MIOrderListVC alloc]initWithOrderType:self.type andOrderStatus:0];
            }
            [_vcs setObject:vc forKey:@(index)];
            [self addChildViewController:vc];
            [self.contetView addSubview:vc.view];
            [self.contetView setNeedsLayout];
            [self.contetView layoutIfNeeded];
            vc.view.frame = CGRectMake(self.contetView.width * index, 0, kScreenWidth, self.contetView.height);
        }
        
    }
    if (self.segmentView.currentIndex != index) {
        self.segmentView.currentIndex  = index;
    }
    [self.contetView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:YES];
}

//代理
- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index{
    [self sliderIndex:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    [self sliderIndex:index];
}

#pragma mark - lazy
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"吾G专区每月限购2万元 ";
        _tipsLabel.textColor = COLOR_TEXT_RED;
        _tipsLabel.font = Font(12);
        _tipsLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _tipsLabel;
}
- (UIImageView *)tipsIcon {
    if (!_tipsIcon) {
        _tipsIcon = [[UIImageView alloc] init];
        _tipsIcon.image = [UIImage imageNamed:@"qiandai"];
        
    }
    return _tipsIcon;
}
- (UIView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[UIView alloc] init];
        _tipsView.backgroundColor = COLOR_HEX(0xFFF5E0);
    }
    return _tipsView;
}
@end
