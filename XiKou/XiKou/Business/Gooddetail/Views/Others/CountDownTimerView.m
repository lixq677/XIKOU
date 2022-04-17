//
//  CountDownTimerView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CountDownTimerView.h"
#import "XKWeakProxy.h"

@interface CountDownTimerView ()

@property (nonatomic,strong)UILabel *hintLabel;

@property (nonatomic,strong)UILabel *secLabel1;

@property (nonatomic,strong)UILabel *secLabel2;

@property (nonatomic,strong)UILabel *msLabel1;

@property (nonatomic,strong)UILabel *msLabel2;

@property (nonatomic,strong)UILabel *mhLabel;

@property (nonatomic,strong)CAShapeLayer *shapeLayer;

@property (nonatomic,strong)CAGradientLayer *gl;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)BOOL isFire;

@end

@implementation CountDownTimerView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.hintLabel];
        [self addSubview:self.secLabel1];
        [self addSubview:self.secLabel2];
        [self addSubview:self.mhLabel];
        [self addSubview:self.msLabel1];
        [self addSubview:self.msLabel2];
        [self layout];
        [self.layer insertSublayer:self.gl atIndex:0];
        self.clipsToBounds = YES;
        self.timeInterval = 0;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(7.0f, 7.0f)];
    [self.shapeLayer setPath:path.CGPath];
    self.layer.mask = self.shapeLayer;
    self.gl.frame = self.bounds;
    self.gl.startPoint = CGPointMake(0.69, 0.05);
    self.gl.endPoint = CGPointMake(0.18, 0.94);
    self.gl.colors = @[(__bridge id)[UIColor colorWithRed:241/255.0 green:89/255.0 blue:55/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:248/255.0 green:51/255.0 blue:66/255.0 alpha:1.0].CGColor];
    self.gl.locations = @[@(0), @(1.0f)];
}



- (void)layout{
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11.0f);
        make.width.mas_equalTo(58.0f);
        make.height.mas_equalTo(15.0f);
        make.centerY.equalTo(self);
    }];
    
    [self.secLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hintLabel.mas_right).offset(6.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14.0f, 18.0f));
    }];
    
    [self.secLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secLabel1.mas_right).offset(2.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14.0f, 18.0f));
    }];
    
    [self.mhLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.secLabel2.mas_right).offset(2.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(3.0f, 18.0f));
    }];
    
    [self.msLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mhLabel.mas_right).offset(2.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14.0f, 18.0f));
    }];
    
    [self.msLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msLabel1.mas_right).offset(2.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14.0f, 18.0f));
    }];
}


- (void)startTimer{
    if (self.isFire) return;
    self.isFire = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.hidden = NO;
//    self.timer = [NSTimer timerWithTimeInterval:0.01f target:[XKWeakProxy proxyWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    [self.timer setFireDate:[NSDate distantPast]];
}


- (void)timerAction{
    if (self.timeInterval <= 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.secLabel1.text = @"0";
        self.secLabel2.text = @"0";
        self.msLabel1.text = @"0";
        self.msLabel2.text = @"0";
    }
    self.timeInterval-=0.01;
    NSUInteger ms  = self.timeInterval *1000;
    self.secLabel1.text = [NSString stringWithFormat:@"%@",@(ms/10000)];
    self.secLabel2.text = [NSString stringWithFormat:@"%@",@((ms%10000)/1000)];
    
    self.msLabel1.text = [NSString stringWithFormat:@"%@",@((ms%1000)/100)];
    self.msLabel2.text = [NSString stringWithFormat:@"%@",@((ms%100)/10)];
}


- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:11.0f];
        _hintLabel.textColor = HexRGB(0xffffff, 1.0f);
        _hintLabel.text = @"抢拍倒计时";
    }
    return _hintLabel;
}

- (UILabel *)secLabel1{
    if (!_secLabel1) {
        _secLabel1 = [[UILabel alloc] init];
        _secLabel1.font = [UIFont boldSystemFontOfSize:11.0f];
        _secLabel1.textColor = HexRGB(0xF83342, 1.0f);
        _secLabel1.backgroundColor = HexRGB(0xffffff, 1.0f);
        _secLabel1.layer.cornerRadius = 2.0f;
        _secLabel1.textAlignment = NSTextAlignmentCenter;
        _secLabel1.text = @"0";
        _secLabel1.clipsToBounds = YES;
    }
    return _secLabel1;
}

- (UILabel *)secLabel2{
    if (!_secLabel2) {
        _secLabel2 = [[UILabel alloc] init];
        _secLabel2.font = [UIFont boldSystemFontOfSize:11.0f];
        _secLabel2.textColor = HexRGB(0xF83342, 1.0f);
        _secLabel2.backgroundColor = HexRGB(0xffffff, 1.0f);
        _secLabel2.layer.cornerRadius = 2.0f;
        _secLabel2.textAlignment = NSTextAlignmentCenter;
        _secLabel2.text = @"0";
        _secLabel2.clipsToBounds = YES;
    }
    return _secLabel2;
}

- (UILabel *)msLabel1{
    if (!_msLabel1) {
        _msLabel1 = [[UILabel alloc] init];
        _msLabel1.font = [UIFont boldSystemFontOfSize:11.0f];
        _msLabel1.textColor = HexRGB(0xF83342, 1.0f);
        _msLabel1.backgroundColor = HexRGB(0xffffff, 1.0f);
        _msLabel1.layer.cornerRadius = 2.0f;
        _msLabel1.textAlignment = NSTextAlignmentCenter;
        _msLabel1.text = @"0";
        _msLabel1.clipsToBounds = YES;
    }
    return _msLabel1;
}

- (UILabel *)msLabel2{
    if (!_msLabel2) {
        _msLabel2 = [[UILabel alloc] init];
        _msLabel2.font = [UIFont boldSystemFontOfSize:11.0f];
        _msLabel2.textColor = HexRGB(0xF83342, 1.0f);
        _msLabel2.backgroundColor = HexRGB(0xffffff, 1.0f);
        _msLabel2.layer.cornerRadius = 2.0f;
        _msLabel2.textAlignment = NSTextAlignmentCenter;
        _msLabel2.text = @"0";
        _msLabel2.clipsToBounds = YES;
    }
    return _msLabel2;
}

- (UILabel *)mhLabel{
    if (!_mhLabel) {
        _mhLabel = [[UILabel alloc] init];
        _mhLabel.font = [UIFont systemFontOfSize:15.0f];
        _mhLabel.textColor = HexRGB(0xffffff, 1.0f);
        _mhLabel.text = @":";
        _mhLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _mhLabel;
}

- (CAGradientLayer *)gl{
    if (!_gl) {
        _gl = [CAGradientLayer layer];
    }
    return _gl;
}

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    }
    return _shapeLayer;
}

@end
