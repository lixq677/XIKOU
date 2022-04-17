//
//  XKLoading.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKLoading.h"

static const CGFloat kCirleDiameter   =   54.0f;

static const CGFloat kLineWidth       =   3.0f;

static  XKLoading *gLoading = nil;

@interface XKLoading ()

@property (nonatomic,strong)CAShapeLayer *shapeLayer;

@property (nonatomic,strong)CALayer *xilayer;

@property (nonatomic,strong)CAGradientLayer *gradientLayer;

@property (nonatomic,strong)CALayer *maskLayer;

@property (nonatomic,strong)UIView *backgroundView;

@end

@implementation XKLoading

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.shapeLayer.strokeEnd = 0.0f;
        self.shapeLayer.strokeStart = 0.0f;
        self.shapeLayer.strokeColor = [HexRGB(0x333333, 1.0f) CGColor];
        self.shapeLayer.fillColor = [HexRGB(0xffffff, 0.3) CGColor];
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineWidth =  kLineWidth;
        [self.shapeLayer addSublayer:self.xilayer];
        self.xilayer.mask = self.maskLayer;
        [self.xilayer addSublayer:self.gradientLayer];
    }
    return self;
}

+(Class)layerClass{
    return [CAShapeLayer class];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.width-4*kLineWidth;
    self.xilayer.frame = CGRectMake(2*kLineWidth, (self.height - width *11/18.f)/2,width, width *11/18.f);
    self.maskLayer.frame = self.xilayer.bounds;
    self.gradientLayer.frame = CGRectMake(-CGRectGetWidth(self.xilayer.bounds), 0, CGRectGetWidth(self.xilayer.bounds), CGRectGetHeight(self.xilayer.bounds));
    CGFloat radius = self.width*0.5f;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:3*M_PI_2 clockwise:YES];
    self.shapeLayer.path=  bezierPath.CGPath;
}


- (void)setProgress:(CGFloat)progress{
    progress  = progress >= 0 ? progress : 0.0f;
    progress  = progress <= 1.0f ? progress : 1.0f;
    _progress = progress;
    self.shapeLayer.strokeEnd = progress;
}

- (void)startAnimating{
    if (self.hidesWhenStopped) {
        self.hidden = NO;
        self.backgroundView.hidden = NO;
    }
    if (self.progressAnimating) {
        CABasicAnimation *strokeAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.duration = 2.0f;
        strokeAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        strokeAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
        strokeAnimation.toValue=[NSNumber numberWithFloat:1.0f];
        strokeAnimation.autoreverses=NO;
        strokeAnimation.repeatCount = INFINITY;
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.removedOnCompletion = NO;
        [self.shapeLayer addAnimation:strokeAnimation forKey:@"strokeEndAnimation"];
    }
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.duration = 2.0f;
    positionAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    positionAnimation.fromValue= @(-0.5*self.gradientLayer.bounds.size.width);
    positionAnimation.toValue= @(0.5*self.gradientLayer.bounds.size.width);
    positionAnimation.autoreverses=YES;
    positionAnimation.repeatCount = INFINITY;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.removedOnCompletion = NO;
    [self.gradientLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)stopAnimating{
    [self.shapeLayer removeAnimationForKey:@"strokeEndAnimation"];
    [self.gradientLayer removeAnimationForKey:@"positionAnimation"];
    if (self.hidesWhenStopped) {
        self.hidden = YES;
        self.backgroundView.hidden = YES;
    }
}


- (void)showIt{
    [self showItNeedMask:NO];
}

- (void)showItNeedMask:(BOOL)mask{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake(topVC.view.centerX-0.5*kCirleDiameter, topVC.view.centerY,kCirleDiameter, kCirleDiameter);
    if (mask) {
        self.backgroundView.frame = topVC.view.bounds;
//        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self.backgroundView addSubview:self];
        [topVC.view addSubview:self.backgroundView];
    }else{
        [topVC.view addSubview:self];
    }
    
    self.shapeLayer.cornerRadius = CGRectGetWidth(self.shapeLayer.bounds)/2.0f;
    [UIView animateWithDuration:0.2 animations:^{
        self.top-=60.0f;
    }completion:^(BOOL finished) {
        [self startAnimating];
    }];
}

- (void)dismissIt{
    [UIView animateWithDuration:0.2 animations:^{
        self.top+=60.0f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        self.mask = NO;
    }];
}


- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


-(CAShapeLayer *)shapeLayer{
    return (CAShapeLayer *)self.layer;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0.0f, 0.5f);
        _gradientLayer.endPoint = CGPointMake(1.0f, 0.5f);
        _gradientLayer.locations = @[@0.6f,@0.8f,@1.0f];
        _gradientLayer.colors = @[(id)HexRGB(0xcccccc, 1.0f).CGColor,(id)HexRGB(0x666666, 1.0f).CGColor,(id)HexRGB(0x333333, 1.0f).CGColor];
    }
    return _gradientLayer;
}

- (CALayer *)xilayer{
    if (!_xilayer) {
        _xilayer = [CALayer layer];
        _xilayer.backgroundColor = [HexRGB(0x333333, 1.0f) CGColor];
    }
    return _xilayer;
}

- (CALayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"loading_logo"].CGImage);
    }
    return _maskLayer;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}




+ (void)show{
    if (!gLoading) {
        gLoading = [[XKLoading alloc] init];
        gLoading.hidesWhenStopped = YES;
        gLoading.progressAnimating = YES;
    }
    [gLoading showIt];
}

+ (void)showNeedMask:(BOOL)mask{
    if (!gLoading) {
        gLoading = [[XKLoading alloc] init];
        gLoading.hidesWhenStopped = YES;
        gLoading.progressAnimating = YES;
    }
    [gLoading showItNeedMask:mask];
}

+ (void)dismiss{
    [gLoading dismissIt];
    gLoading = nil;
}

+ (BOOL)isShow{
    return gLoading != nil;
}

@end
