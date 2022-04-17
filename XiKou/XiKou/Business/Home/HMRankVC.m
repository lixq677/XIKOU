//
//  HMRankVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMRankVC.h"
#import "HMRankChildVC.h"
#import "XKSegmentView.h"

@interface HMRankVC ()<XKSegmentViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) XKSegmentView *segmentView;

@property (nonatomic, strong) UIScrollView *contetView;

@property (nonatomic, strong) NSMutableDictionary *vcs;

@end

@implementation HMRankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initUI];
}

#pragma mark UI
- (void)initUI{
    _vcs = [NSMutableDictionary dictionary];
    self.navigationItem.titleView = self.segmentView;
    _contetView = [[UIScrollView alloc]init];
    _contetView.showsHorizontalScrollIndicator = NO;
    _contetView.pagingEnabled = YES;
    _contetView.delegate = self;
    _contetView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    [self.view addSubview:_contetView];
    [_contetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self sliderIndex:0];
}

//滚动
- (void)sliderIndex:(NSInteger)index{
    if (![_vcs objectForKey:@(index)]) {
        HMRankChildVC *vc = [[HMRankChildVC alloc]init];
        vc.type = index;
        [_vcs setObject:vc forKey:@(index)];
        [self addChildViewController:vc];
        [self.contetView addSubview:vc.view];
        [self.contetView setNeedsLayout];
        [self.contetView layoutIfNeeded];
        vc.view.frame = CGRectMake(self.contetView.width * index, 0, kScreenWidth, self.contetView.height);
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

- (XKSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[XKSegmentView alloc] initWithTitles:@[@"爆品榜",@"热推榜",@"喜赚榜"]];
        _segmentView.frame = CGRectMake(0, 0, kScreenWidth-80, kNavBarHeight);
        _segmentView.delegate = self;
        _segmentView.style = XKSegmentViewStyleDivide;
    }
    return _segmentView;
}

@end
