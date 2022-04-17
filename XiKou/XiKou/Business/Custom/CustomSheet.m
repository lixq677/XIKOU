//
//  CustomSheet.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CustomSheet.h"
#import "XKUIUnitls.h"

@interface CustomSheet ()

@property (nonatomic,strong)UIButton *assembleBtn;

@property (nonatomic,strong)UIButton *hallBtn;

@property (nonatomic,strong)UIButton *designerBtn;

@property (nonatomic,strong)UIButton *dismissBtn;

@property (nonatomic,strong)UILabel *assembleLabel;

@property (nonatomic,strong)UILabel *hallLabel;

@property (nonatomic,strong)UILabel *designerLabel;


@property (nonatomic,strong)UIView *backgroundView;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;

@property (nonatomic,assign)BOOL dismissAnimate;

@end

@implementation CustomSheet
@synthesize assembleBtn = _assembleBtn;
@synthesize hallBtn = _hallBtn;
@synthesize designerBtn = _designerBtn;
@synthesize dismissBtn = _dismissBtn;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.assembleBtn];
        [self addSubview:self.hallBtn];
        [self addSubview:self.designerBtn];
        [self addSubview:self.dismissBtn];
        [self addSubview:self.assembleLabel];
        [self addSubview:self.hallLabel];
        [self addSubview:self.designerLabel];
        self.backgroundColor = HexRGB(0xffffff, 0.98);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.assembleBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)/4.0f-25.0f, 40.0f, 50.0f, 50.0f);
    self.assembleLabel.frame = CGRectMake(self.assembleBtn.left-10.0f, self.assembleBtn.bottom + 10.0f,70.0f,14.0f);
    
    self.hallBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)/2.0f-25.0f, 40.0f, 50.0f, 50.0f);
    self.hallLabel.frame = CGRectMake(self.hallBtn.left-10.0f, self.hallBtn.bottom + 10.0f,70.0f,14.0f);
    
    self.designerBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)*3.0f/4.0f-25.0f, 40.0f, 50.0f, 50.0f);
    self.designerLabel.frame = CGRectMake(self.designerBtn.left-10.0f, self.designerBtn.bottom + 10.0f,70.0f,14.0f);
    
    self.dismissBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)/2.0f-15.0f, CGRectGetHeight(self.bounds)-30-[XKUIUnitls safeBottom], 30.0f, 30.0f);
}

- (void)show{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(0, CGRectGetHeight(topVC.view.bounds), [CustomSheet sheetWidth], [CustomSheet sheetHeight]);
    [topVC.view addSubview:self];
}

- (void)dismiss{
    self.dismissAnimate = YES;
    [self removeFromSuperview];
}

- (void)dismissWithAnimate:(BOOL)animate{
    self.dismissAnimate = animate;
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
    CGRect afterFrame = CGRectMake(0,CGRectGetHeight(topVC.view.bounds), [CustomSheet sheetWidth], [CustomSheet sheetHeight]);
    if (self.dismissAnimate) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = afterFrame;
        } completion:^(BOOL finished) {
            [super removeFromSuperview];
        }];
    }else{
        [super removeFromSuperview];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    self.backgroundView.frame = topVC.view.bounds;
    [topVC.view addSubview:self.backgroundView];
    CGRect afterFrame = CGRectMake(0, (CGRectGetHeight(topVC.view.bounds)-[CustomSheet sheetHeight]),[CustomSheet sheetWidth], [CustomSheet sheetHeight]);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = afterFrame;
    } completion:nil];
    [super willMoveToSuperview:newSuperview];
}


- (void)actionForDismiss{
    [self dismiss];
}

- (void)actionForAssemble{
    if (self.actionAssembleBlock) {
        self.actionAssembleBlock();
    }
    [self dismissWithAnimate:NO];
}

- (void)actionForHall{
    if (self.actionHallBlock) {
        self.actionHallBlock();
    }
    [self dismissWithAnimate:NO];
}

- (void)actionForDesigner{
    if (self.actionDesignerBlock) {
        self.actionDesignerBlock();
    }
    [self dismissWithAnimate:NO];
}

#pragma mark getter

- (UIButton *)assembleBtn{
    if (!_assembleBtn) {
        _assembleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_assembleBtn setImage:[UIImage imageNamed:@"assemble"] forState:UIControlStateNormal];
        [_assembleBtn addTarget:self action:@selector(actionForAssemble) forControlEvents:UIControlEventTouchUpInside];
    }
    return _assembleBtn;
}

- (UIButton *)hallBtn{
    if (!_hallBtn) {
        _hallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hallBtn setImage:[UIImage imageNamed:@"hall"] forState:UIControlStateNormal];
        [_hallBtn addTarget:self action:@selector(actionForHall) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hallBtn;
}

- (UIButton *)designerBtn{
    if (!_designerBtn) {
        _designerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_designerBtn setImage:[UIImage imageNamed:@"iconquanzinor"] forState:UIControlStateNormal];
        [_designerBtn addTarget:self action:@selector(actionForDesigner) forControlEvents:UIControlEventTouchUpInside];
    }
    return _designerBtn;
}

- (UILabel *)assembleLabel{
    if (!_assembleLabel) {
        _assembleLabel = [[UILabel alloc] init];
        _assembleLabel.font = [UIFont systemFontOfSize:13.0f];
        _assembleLabel.textColor = COLOR_TEXT_BROWN;
        _assembleLabel.textAlignment = NSTextAlignmentCenter;
        _assembleLabel.text = @"定制拼团";
    }
    return _assembleLabel;
}

- (UILabel *)hallLabel{
    if (!_hallLabel) {
        _hallLabel =  [[UILabel alloc] init];
        _hallLabel.font = [UIFont systemFontOfSize:13.0f];
        _hallLabel.textColor = COLOR_TEXT_BROWN;
        _hallLabel.textAlignment = NSTextAlignmentCenter;
        _hallLabel.text = @"定制馆";
    }
    return _hallLabel;
}

- (UILabel *)designerLabel{
    if (!_designerLabel) {
        _designerLabel = [[UILabel alloc] init];
        _designerLabel.font = [UIFont systemFontOfSize:13.0f];
        _designerLabel.textColor = COLOR_TEXT_BROWN;
        _designerLabel.textAlignment = NSTextAlignmentCenter;
        _designerLabel.text = @"设计师圈";
    }
    return _designerLabel;
}

- (UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setImage:[UIImage imageNamed:@"custom_dissmiss"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    }
    return _dismissBtn;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HexRGB(0x0, 0.3f);
        [_backgroundView addGestureRecognizer:self.tapGesture];
    }
    return _backgroundView;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForDismiss)];
    }
    return _tapGesture;
}

+ (CGFloat)sheetWidth{
    return kScreenWidth;
}

+ (CGFloat)sheetHeight{
    return  260.0f+[XKUIUnitls safeBottom];
}


@end
