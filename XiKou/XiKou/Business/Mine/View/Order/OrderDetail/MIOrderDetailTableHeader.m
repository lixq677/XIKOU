//
//  MIOrderDetailTableHeader.m
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderDetailTableHeader.h"
#import "NSDate+Extension.h"
#import "XKOrderModel.h"
#import "XKGcdTimer.h"

@implementation MIOrderDetailTableHeader
{
    NSString *_timerName;
    NSInteger _time;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kScreenWidth, 65);
        [self creatSubViews];
    }
    return self;
}

- (void)setModel:(XKOrderDetailModel *)model{
    switch (model.state) {
        case OSUnPay:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderWait"];
            if (model.payInvalidTime) {
                NSDate *date = [NSDate date:model.orderTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval dateTime =[date timeIntervalSince1970];
                
                NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
                
                double secondMax = dateTime + [model.payInvalidTime integerValue]*60;
                if (nowTime < secondMax) {
                    _time = secondMax - nowTime;
                    [self startTimer];
                }else{
                    self.timeLabel.text  = @"00分00秒自动关闭";
                }
            }
            if (model.type == OTBargain) {
                self.statuslabel.text = @"砍价成功，等待买家付款";
            }else if(model.type == OTZeroBuy){
                self.statuslabel.text = @"已拍中，等待买家付款";
            }else if (model.type == OTCustom){
                self.statuslabel.text = @"拼团成功，等待买家付款";
            }else{
                self.statuslabel.text = @"下单成功，等待买家付款";
            }
        }
            break;
        case OSUnDeliver:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderPay"];
            self.statuslabel.text = @"已付款，等待卖家发货";
        }
            break;
        case OSUnReceive:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderWait"];
            self.statuslabel.text = @"已发货，等待收货";
        }
            break;
        case OSCancle:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderTip"];
            self.statuslabel.text = @"订单已取消";
        }
            break;
        case OSClose:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderTip"];
            self.statuslabel.text = @"订单已关闭";
        }
            break;
        case OSComlete:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderSuccess"];
            self.statuslabel.text = @"交易完成";
        }
            break;
        case OSUnSure:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderWait"];
            self.statuslabel.text = @"订单待确认";
        }
            break;
        case OSUnGroup:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderWait"];
            self.statuslabel.text = @"订单待成团";
        }
            break;
        case OSGroupSus:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderSuccess"];
            self.statuslabel.text = @"订单成团成功";
        }
            break;
        case OSGroupFail:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderTip"];
            self.statuslabel.text = @"订单成团失败";
        }
            break;
        case OSConsign:
        {
            self.statusImgView.image = [UIImage imageNamed:@"orderSuccess"];
            self.statuslabel.text = @"已寄卖";
        }
            break;
        default:
            break;
    }
}

- (void)startTimer {
    if (!_timerName){
        @weakify(self);
        _timerName = @"订单支付倒计时";
        [self reloadTime];
        [[XKGCDTimer sharedInstance]scheduleGCDTimerWithName:_timerName interval:1 queue:nil repeats:YES option:MergePreviousTimerAction action:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTime];
            });
        }];
    };
}

- (void)reloadTime{
    _time--;
    if (_time <= 0) {
        //关闭定时器
        self.timeLabel.text  = @"00分00秒自动关闭";
    }else {
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = _time/60;
        self.timeLabel.text   = [NSString stringWithFormat:@"%02ld分%02ld秒自动关闭",minute,second];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
}

- (void)creatSubViews{
    
    [self xk_addSubviews:@[self.statusImgView,self.statuslabel,self.timeLabel]];
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.left.equalTo(self).offset(25);
        make.bottom.mas_equalTo(-13);
    }];
    [_timeLabel setContentCompressionResistancePriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.statusImgView);
    }];
    [_statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImgView.mas_right).offset(7);
        make.right.equalTo(self.timeLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.statusImgView);
    }];
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = FontMedium(12.f);
        _timeLabel.textColor = COLOR_HEX(0xC9AA6B);
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)statuslabel{
    if (!_statuslabel) {
        _statuslabel = [UILabel new];
        _statuslabel.font = FontMedium(15.f);
        _statuslabel.textColor = [UIColor whiteColor];
    }
    return _statuslabel;
}

- (UIImageView *)statusImgView{
    if (!_statusImgView) {
        _statusImgView = [[UIImageView alloc]init];
    }
    return _statusImgView;
}



@end
