//
//  MJDIYFooter.m
//  XiKou
//
//  Created by L.O.U on 2019/8/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MJDIYFooter.h"

@interface MJDIYFooter ()

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIView *leftLine;

@property (nonatomic, strong) UIView *rightLine;

@property (nonatomic, strong) NSMutableDictionary *stateTitles;

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;

@end

@implementation MJDIYFooter

#pragma mark - 懒加载
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (NSMutableDictionary *)stateTitles{
    if (!_stateTitles) {
        _stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = FontMedium(12.f);
        _statusLabel.textColor = COLOR_RGB(204, 204, 204, 1);
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_statusLabel];
    }
    return _statusLabel;
}

- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [UIView new];
        _leftLine.backgroundColor = COLOR_HEX(0xCCCCCC);
        [self addSubview:_leftLine];
    }
    return _leftLine;
}

- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [UIView new];
        _rightLine.backgroundColor = COLOR_HEX(0xCCCCCC);
        [self addSubview:_rightLine];
    }
    return _rightLine;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.statusLabel.text = self.stateTitles[@(self.state)];
}

- (NSString *)titleForState:(MJRefreshState)state {
    return self.stateTitles[@(state)];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterIdleText] forState:MJRefreshStateIdle];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterPullingText] forState:MJRefreshStatePulling];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterRefreshingText] forState:MJRefreshStateRefreshing];
    [self setTitle:[NSBundle mj_localizedStringForKey:@"我也是有底线的"] forState:MJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.statusLabel.constraints.count) return;
    
    self.statusLabel.mj_w  = self.statusLabel.mj_textWith;
    self.statusLabel.mj_y  = self.mj_h/2 - self.statusLabel.mj_h/2;
    self.statusLabel.mj_h  = 20;
    self.statusLabel.mj_x  = self.mj_w/2 - self.statusLabel.mj_w/2;
    
    CGFloat lineWidth = 23;
    CGFloat space = 13;
    CGFloat lineH = 1/[UIScreen mainScreen].scale;
    
    self.leftLine.frame = CGRectMake(self.statusLabel.mj_x - space - lineWidth, self.statusLabel.centerY - lineH/2, lineWidth, lineH);
    self.rightLine.frame = CGRectMake(self.statusLabel.mj_x + space + self.statusLabel.mj_w, self.leftLine.mj_y, lineWidth, lineH);
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
  
    loadingCenterX -= self.statusLabel.mj_textWith * 0.5 + 20;
    
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 设置状态文字
    self.statusLabel.text = self.stateTitles[@(state)];
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
        self.leftLine.hidden  = NO;
        self.rightLine.hidden = NO;
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
        self.leftLine.hidden  = YES;
        self.rightLine.hidden = YES;
    }
}

@end
