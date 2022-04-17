//
//  MIConcernVC.m
//  XiKou
//
//  Created by Tony on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIConcernVC.h"
#import "XKUIUnitls.h"
#import "XKSegmentView.h"
#import <MJRefresh.h>
#import "MIDesignerConcernVC.h"
#import "MIShopConcernVC.h"

@interface MIConcernVC ()<XKSegmentViewDelegate>
@property (nonatomic,strong,readonly)XKSegmentView *segmentView;

@property (nonatomic,strong,readonly) UIScrollView *scrollView;

@property (nonatomic,strong,readonly) MIDesignerConcernVC *designerVC;

@property (nonatomic,strong,readonly) MIShopConcernVC *shopVC;

@end

@implementation MIConcernVC
@synthesize segmentView = _segmentView;
@synthesize scrollView = _scrollView;
@synthesize shopVC = _shopVC;
@synthesize designerVC = _designerVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self setupUI];
    [self autoLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
- (void)setupUI{
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //分段按钮
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.scrollView];
    
    [self addChildViewController:self.designerVC];
    [self.scrollView addSubview:self.designerVC.view];
    [self.designerVC didMoveToParentViewController:self];

    [self addChildViewController:self.shopVC];
    [self.scrollView addSubview:self.shopVC.view];
    [self.shopVC didMoveToParentViewController:self];
}

- (void)autoLayout{
    CGFloat space = 0.0f;
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45.0);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(space);
        make.bottom.equalTo(self.view);
    }];
    [self.designerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.equalTo(self.scrollView);
    }];
   
    [self.shopVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.designerVC.view.mas_right).offset(space);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.equalTo(self.scrollView);
    }];
    self.scrollView.contentSize = CGSizeMake(2*(kScreenWidth+space), 0);
}


- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index{
     [self.scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
}

#pragma mark getter
- (XKSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[XKSegmentView alloc] initWithTitles:@[@"设计师",@"O2O店铺"]];
        _segmentView.style = XKSegmentViewStyleDivide;
        _segmentView.contentScrollView = self.scrollView;
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = HexRGB(0xcccccc, 1.0f);
        _scrollView.pagingEnabled = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (MIShopConcernVC *)shopVC{
    if (!_shopVC) {
        _shopVC = [[MIShopConcernVC alloc] init];
    }
    return _shopVC;
}

- (MIDesignerConcernVC *)designerVC{
    if (!_designerVC) {
        _designerVC = [[MIDesignerConcernVC alloc] init];
    }
    return _designerVC;
}


@end
