//
//  BasePageVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BasePageVC.h"

@interface BasePageVC ()

@end

@implementation BasePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pagerView = [self preferredPagingView];
    _pagerView.listContainerView.collectionView.backgroundColor = [UIColor whiteColor];
    self.pagerView.mainTableView.gestureDelegate = self;
    [self.view addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //导航栏隐藏的情况，处理扣边返回，下面的代码要加上
    [self.pagerView.listContainerView.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self.pagerView.mainTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (JXPagerView *)preferredPagingView {
    return [[JXPagerView alloc] initWithDelegate:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.pagerView.frame = CGRectMake(0, 0, kScreenWidth, kscr);
}

@end
