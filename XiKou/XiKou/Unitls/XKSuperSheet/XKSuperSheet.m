//
//  XKSuperSheet.m
//  XiKou
// 
//  Created by 陆陆科技 on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSuperSheet.h"
#import "XKUIUnitls.h"

@interface XKSuperSheet ()

@property (nonatomic,strong)UIButton *dissBtn;

@property (nonatomic,strong)UIView *topLine;

@end

@implementation XKSuperSheet
@synthesize titleLabel = _titleLabel;
@synthesize backgroundView = _backgroundView;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleHeight = 50.0f;
        [self addSubview:self.titleLabel];
        [self addSubview:self.dissBtn];
        [self addSubview:self.topLine];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.bounds)/2.0f-100.0f, 0, 200.0f, self.titleHeight);
    self.topLine.frame = CGRectMake(15.0f, CGRectGetHeight(self.titleLabel.frame)-0.5f, CGRectGetWidth(self.bounds)-30.0f, 0.5f);
    self.dissBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-50.0f, CGRectGetMidY(self.titleLabel.frame)-15.0f, 30.0f, 30.0f);
}

- (void)show{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(0, CGRectGetHeight(topVC.view.bounds), [self sheetWidth], [self sheetHeight]);
    [topVC.view addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}


- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview{
    [self.backgroundView removeFromSuperview];
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake(0,CGRectGetHeight(topVC.view.bounds), [self sheetWidth], [self sheetHeight]);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    self.backgroundView.frame = topVC.view.bounds;
    [topVC.view addSubview:self.backgroundView];
    CGRect afterFrame = CGRectMake(0, (CGRectGetHeight(topVC.view.bounds)-[self sheetHeight]),[self sheetWidth], [self sheetHeight]);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
    } completion:nil];
    [super willMoveToSuperview:newSuperview];
}

#pragma mark getter or setter
- (UIButton *)dissBtn{
    if (!_dissBtn) {
        _dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dissBtn setImage:[UIImage imageNamed:@"custom_dissmiss"] forState:UIControlStateNormal];
        [_dissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dissBtn;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _topLine;
}


- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HexRGB(0x0, 0.3);
    }
    return _backgroundView;
}


- (CGFloat)sheetWidth{
    NSAssert(NO, @"子类实现");
    return 0;
}

- (CGFloat)sheetHeight{
    NSAssert(NO, @"子类实现");
    return 0;
}
@end
