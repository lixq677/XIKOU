//
//  MJDIYHeader.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MJDIYHeader.h"
#import "XKLoading.h"

@interface MJDIYHeader ()

@property (nonatomic,strong)XKLoading *loading;

@property (nonatomic,strong)UILabel *textLabel;

@end

@implementation MJDIYHeader

- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 64.0f + [XKUIUnitls safeTop];
    
    // 添加label
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = HexRGB(0x444444, 1.0f);
    self.textLabel.font = [UIFont systemFontOfSize:9.0f];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLabel];
    
    // loading
    self.loading = [[XKLoading alloc] init];
    [self addSubview:self.loading];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews{
    [super placeSubviews];
    if (self.mj_w > kScreenWidth) {
        self.mj_w = kScreenWidth;
    }else if (self.mj_w <= 0){
        self.mj_w = kScreenWidth;
    }
    self.loading.frame = CGRectMake(0.5*self.mj_w-15.0f, 10.0f + [XKUIUnitls safeTop], 30.0f, 30.0f);
    self.textLabel.frame = CGRectMake(0, CGRectGetMaxY(self.loading.frame)+5.0f, self.mj_w, 10.0f);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.textLabel.text = @"下拉刷新";
            [self.loading setProgress:0.0f];
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.textLabel.text = @"放开我,我要去刷新";
            break;
        case MJRefreshStateRefreshing:
            self.textLabel.text = @"正在刷新中...";
            [self.loading setProgress:1.0f];
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    if (self.state == MJRefreshStateIdle) {
         [self.loading setProgress:pullingPercent];
    }
   
    NSLog(@"下拉%.2f",pullingPercent);
}

@end
