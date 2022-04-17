//
//  MIOrderPayAnotherFooter.m
//  XiKou
//
//  Created by L.O.U on 2019/8/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderPayAnotherFooter.h"

#import "NSDate+Extension.h"

@implementation MIOrderPayAnotherFooter
{
    NSString *_timerName;
    NSInteger _time;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = COLOR_VIEW_GRAY;
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        [self.bgView xk_addSubviews:@[self.countDownView,self.button,self.leftLabel]];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(102, 30));
        }];
        [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.button);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(15);
        }];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(self.countDownView);
        }];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = _bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bgView.layer.mask = maskLayer;
    
    
}
+ (NSString *)identify{
    return NSStringFromClass([self class]);
}

- (void)reloadTime:(NSString *)creatTime anDuration:(NSInteger)duration{
    NSDate *date = [NSDate date:creatTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval dateTime =[date timeIntervalSince1970];
    
    NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
    
    NSInteger secondMax = dateTime + duration *60;
   
    NSInteger time = secondMax - nowTime;
    if (time <= 0) {
        self.countDownView.hidden = YES;
        self.leftLabel.hidden = NO;
        self.leftLabel.text = @"支付过期";
        self.button.enabled = NO;
    }else{
        self.countDownView.hidden = NO;
        self.leftLabel.hidden = YES;
        self.button.enabled = YES;
    }
    self.countDownView.time = time;
   
}
- (XKCountDownView *)countDownView{
    if (!_countDownView) {
        _countDownView = [[XKCountDownView alloc]init];
        _countDownView.title = @"支付剩余时间:";
    }
    return _countDownView;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius  = 2.f;
        [_button setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateSelected];
        [_button setBackgroundImage:[UIImage imageWithColor:COLOR_TEXT_BLACK] forState:UIControlStateHighlighted];
        [_button setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 1.0f)] forState:UIControlStateDisabled];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button.titleLabel setFont:FontMedium(13.f)];
        [_button setTitle:@"帮Ta付" forState:UIControlStateNormal];
    }
    return _button;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textColor = COLOR_TEXT_GRAY;
        _leftLabel.font = Font(9.f);
    }
    return _leftLabel;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
@end
