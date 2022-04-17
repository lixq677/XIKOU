//
//  MIOrderFootView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderFootView.h"
#import "XKUIUnitls.h"
#import "XKCustomAlertView.h"
#import "XKOrderModel.h"
#import "MIOrderBtnsView.h"
#import "NSDate+Extension.h"
#import "XKGcdTimer.h"

@interface MIOrderFootView ()

@property (nonatomic, strong) UILabel *infoLabel; //订单信息视图

@property (nonatomic, strong) UILabel *leftLabel; //按钮左边label

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) MIOrderBtnsView *btnsView; //订单按钮

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MIOrderFootView
{
    NSString *_timerName;
    NSInteger _time;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        if ([reuseIdentifier isEqualToString:footID1]) {
            [self.bgView xk_addSubviews:@[self.btnsView,self.infoLabel]];
        }
        if ([reuseIdentifier isEqualToString:footID2]) {
            [self.bgView xk_addSubviews:@[self.btnsView,self.leftLabel]];
        }
        if ([reuseIdentifier isEqualToString:footID3]) {
            [self.bgView addSubview:self.leftLabel];
        }
        [self initTimer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_bgView.height != self.height) {
        _bgView.frame = CGRectMake(15, 0, kScreenWidth - 30, self.height - 10);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }
    if ([self.reuseIdentifier isEqualToString:footID1]) {
        self.infoLabel.frame = CGRectMake(15, 0, self.bgView.width - 30, 10);
        self.btnsView.top    = self.infoLabel.bottom + 15;
        self.btnsView.left   = self.bgView.width - self.btnsView.width;
    }
    if ([self.reuseIdentifier isEqualToString:footID2]) {
        self.btnsView.top    = 0;
        self.btnsView.left   = self.bgView.width - self.btnsView.width;
        self.leftLabel.frame = CGRectMake(15, 0, self.btnsView.right - 75, self.btnsView.height);
    }
    if ([self.reuseIdentifier isEqualToString:footID3]) {
        self.leftLabel.frame = CGRectMake(15, 10, self.width - 30, 10);
    }
}

- (void)setModel:(XKOrderListModel *)model{
    _model = model;
    if ([self.reuseIdentifier isEqualToString:footID1] && model.type != OTConsigned) {
        NSString *postage = @"";
        if ([model.postage floatValue] > 0) {
           postage = [NSString stringWithFormat:@"运费:¥%.2f",[model.postage floatValue]/100];
        }else{
           postage = @"免运费";
        }
        self.infoLabel.text = [NSString stringWithFormat:@"订单总额: ¥%.2f   %@",[model.payAmount doubleValue]/100,postage];
    }
    if ([self.reuseIdentifier isEqualToString:footID2] && model.type == OTCanConsign) {
        
        NSDate *date = [NSDate date:model.payTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval dateTime =[date timeIntervalSince1970];
        
        NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
        
        double secondMax = dateTime + model.timeToBeConfirmed *24*60*60;
        if (nowTime < secondMax) {
            _time = secondMax - nowTime;
            [self startTimer];
        }else{
            self.leftLabel.text = @"申请寄卖过期";
            [self pauseTimer];
        }
    }
    self.btnsView.model = _model;
}

- (void)initTimer{
    @weakify(self);
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:10.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self);
        [self reloadTime];
    }];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)startTimer {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)pauseTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)reloadTime{
    _time = (_time - 10);
    if (_time <= 0) {
        //关闭定时器
        self.leftLabel.text = @"申请寄卖过期";
        self.btnsView.hidden = YES;
        [self.timer invalidate];
    }else {
        //处倒计时
        NSInteger day = _time /(24*60*60);
        NSInteger hour = (_time /(60*60))%24;
        NSInteger minute = (_time/60)%60;
        self.btnsView.hidden = NO;
        self.leftLabel.text = [NSString stringWithFormat:@"剩余时间:%ld天%ld小时%ld分",day,hour,minute];
    }
}


- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel  = [UILabel new];
        _leftLabel.font = Font(10.f);
        _leftLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _leftLabel;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.textColor = COLOR_TEXT_BLACK;
        _infoLabel.font = Font(10.f);
        _infoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _infoLabel;
}

- (MIOrderBtnsView *)btnsView{
    if (!_btnsView) {
        _btnsView = [[MIOrderBtnsView alloc]init];
    }
    return _btnsView;
}
@end
