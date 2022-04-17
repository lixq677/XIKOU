//
//  XKCountDownView.m
//  XiKou
//
//  Created by L.O.U on 2019/8/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCountDownView.h"

@interface XKCountDownView ()

@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation XKCountDownView
{
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _hourLabel   = [self instanceTimeLabel];
        _minuteLabel = [self instanceTimeLabel];
        _secondLabel = [self instanceTimeLabel];
        _secondLabel.text = @"00";
        _minuteLabel.text = @"00";
        _hourLabel.text = @"00";
        
        self.titleLabel = [self instanceTipLabel:@"距离结束:" andColor:COLOR_TEXT_BLACK andFont:Font(10.f)];
        UILabel *tipLabel2 = [self instanceTipLabel:@":" andColor:COLOR_TEXT_BLACK andFont:FontMedium(15.)];
        UILabel *tipLabel3 = [self instanceTipLabel:@":" andColor:COLOR_TEXT_BLACK andFont:FontMedium(15.)];
        [self xk_addSubviews:@[self.hourLabel,self.minuteLabel,self.secondLabel,self.titleLabel,tipLabel2,tipLabel3]];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.height.mas_equalTo(21);
            make.centerY.equalTo(self);
        }];
        [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.titleLabel);
            make.width.mas_equalTo(21);
            make.left.equalTo(self.titleLabel.mas_right).offset(7);
        }];
        [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.titleLabel);
            make.width.mas_equalTo(13);
            make.left.equalTo(self.hourLabel.mas_right).offset(7);
        }];
        [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.hourLabel);
            make.left.equalTo(tipLabel2.mas_right).offset(7);
        }];
        [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(tipLabel2);
            make.left.equalTo(self.minuteLabel.mas_right).offset(7);
        }];
        [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(self.hourLabel);
            make.left.equalTo(tipLabel3.mas_right).offset(7);
            make.right.equalTo(self);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setTime:(NSInteger)time{
    _time = time;
    [self startTimer];
}

- (void)startTimer {
    if (_timer) return;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(reloadTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)reloadTime{
    _time--;
    if (_time <= 0) {
        //关闭定时器
        _secondLabel.text = @"00";
        _minuteLabel.text = @"00";
        _hourLabel.text = @"00";
        if (!_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }else {
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour = _time / 3600;
        _secondLabel.text = [NSString stringWithFormat:@"%02ld",second];
        _minuteLabel.text = [NSString stringWithFormat:@"%02ld",minute];
        _hourLabel.text = [NSString stringWithFormat:@"%02ld",hour];
    }
}

- (UILabel *)instanceTimeLabel{
    UILabel *label = [UILabel new];
    label.font = FontBoldMT(13.f);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = COLOR_TEXT_BLACK;
    label.size = CGSizeMake(21, 21);
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius  = 21/2.;
    return label;
}

- (UILabel *)instanceTipLabel:(NSString *)string
                     andColor:(UIColor *)color
                      andFont:(UIFont *)font{
    
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    label.text = string;
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
