//
//  XKGoodRowTagCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodRowTagCell.h"
#import "XKGCDTimer.h"
#import "NSDate+Extension.h"

@implementation XKGoodRowTagCell
{
    NSString *_timerName;
    NSInteger _time;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [UILabel new];
        _titleLabel.font = Font(12.f);
        _titleLabel.textColor = COLOR_TEXT_BLACK;
        
        _imgView = [UIImageView new];
        
        
        [self.contentView xk_addSubviews:@[self.titleLabel,self.imgView]];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.left.height.width.mas_equalTo(15);
        }];
        [self.titleLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.imgView);
            make.bottom.equalTo(self.contentView).offset(-8);
            make.height.mas_greaterThanOrEqualTo(15);
        }];
    };
    return self;
}

- (void)reloadTimeByCreatTime:(NSString *)creatTime
                  andDuration:(NSNumber *)duration
                      andType:(XKActivityType)type{
    
    if (type == Activity_Bargain) {
        NSDate *date = [NSDate date:creatTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval dateTime =[date timeIntervalSince1970];
        
        NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
        
        double secondMax = dateTime + [duration integerValue] *3600;
        
        _time = secondMax - nowTime;
    }else{
        NSDate *date = [NSDate date:creatTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval dateTime =[date timeIntervalSince1970];
        
        NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
        
        _time = dateTime - nowTime;
    }
     [self startTimer:type];
}

#pragma mark 倒计时
- (void)startTimer:(XKActivityType)type {
    if (!_timerName){
        @weakify(self);
        _timerName = @"砍价倒计时";
        [self reloadTime:type];
        [[XKGCDTimer sharedInstance]scheduleGCDTimerWithName:_timerName interval:1 queue:nil repeats:YES option:MergePreviousTimerAction action:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTime:type];
            });
        }];
    }
}

- (void)reloadTime:(XKActivityType)type{
    _time--;
    NSString *time;
    if (type == Activity_Bargain) {
        if (_time <= 0) {
            //关闭定时器
            time = @"离砍价结束时间: 0小时0分0秒";
            [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
        }else {
            //处倒计时
            //处倒计时
            NSInteger second = _time % 60;
            NSInteger minute = (_time % 3600)/60;
            NSInteger hour = _time / 3600;
            time = [NSString stringWithFormat:@"离砍价结束时间: %ld小时%02ld分%02ld秒",hour,minute,second];
        }
    }else{
        if (_time <= 0) {
            //关闭定时器
            time = @"离拼团结束时间: 0小时0分0秒";
            [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
        }else {
            //处倒计时
            //处倒计时
            NSInteger second = _time % 60;
            NSInteger minute = (_time % 3600)/60;
            NSInteger hour = _time / 3600;
            time = [NSString stringWithFormat:@"离拼团结束时间: %ld小时%02ld分%02ld秒",hour,minute,second];
        }
    }
    
    self.titleLabel.text = time;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timerName) {
        [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
    }
}
@end
