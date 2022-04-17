//
//  HMCountTimerView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMCountTimerView.h"

@interface HMCountTimerView ()

@property (nonatomic,strong,readonly)UILabel *hintLabel;

@property (nonatomic,strong,readonly)UILabel *hourLabel;

@property (nonatomic,strong,readonly)UILabel *minuteLabel;

@property (nonatomic,strong,readonly)UILabel *secondLabel;

@property (nonatomic,strong,readonly)UILabel *colonLabel1;

@property (nonatomic,strong,readonly)UILabel *colonLabel2;

@property (nonatomic,strong)dispatch_source_t timer;

@property (nonatomic,strong)NSDate *date;

@end

@implementation HMCountTimerView
@synthesize hintLabel = _hintLabel;
@synthesize hourLabel = _hourLabel;
@synthesize minuteLabel = _minuteLabel;
@synthesize secondLabel = _secondLabel;
@synthesize colonLabel1 = _colonLabel1;
@synthesize colonLabel2 = _colonLabel2;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.hintLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuteLabel];
        [self addSubview:self.secondLabel];
        [self addSubview:self.colonLabel1];
        [self addSubview:self.colonLabel2];
        [self layout];
    }
    return self;
}

- (void)dealloc{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}


- (void)layout{
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.0f);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(14.0f);
    }];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hintLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.hintLabel);
        make.width.height.mas_equalTo(20.0f);
    }];
    [self.colonLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hourLabel.mas_right).offset(4.0f);
        make.centerY.equalTo(self.hourLabel);
        make.width.mas_equalTo(5.0f);
        make.height.mas_equalTo(20.0f);
    }];
    [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.colonLabel1.mas_right).offset(4.0f);
        make.centerY.equalTo(self.colonLabel1);
        make.width.height.mas_equalTo(20.0f);
    }];
    [self.colonLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minuteLabel.mas_right).offset(4.0f);
        make.centerY.equalTo(self.minuteLabel);
        make.width.mas_equalTo(5.0f);
        make.height.mas_equalTo(20.0f);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.colonLabel2.mas_right).offset(4.0f);
        make.centerY.equalTo(self.colonLabel2);
        make.width.height.mas_equalTo(20.0f);
    }];
}

- (void)stopCount{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)suspendCount{
    if(self.timer){
        dispatch_suspend(self.timer);
    }
}


- (void)startCountDownTime:(NSDate *)date{
    if(self.date && [self.date isEqualToDate:date])return;
    
    if (NSOrderedDescending != [date compare:[NSDate date]]) return;
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        NSTimeInterval timeInterval = [date timeIntervalSinceDate:[NSDate date]];
        if (timeInterval <=0) {
            dispatch_source_cancel(self.timer);
        }else{
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps = [calendar components:unit fromDate:[NSDate date] toDate:date options:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                self.hourLabel.text = [NSString stringWithFormat:@"%02d",(int)comps.hour];
                self.minuteLabel.text = [NSString stringWithFormat:@"%02d",(int)comps.minute];
                self.secondLabel.text = [NSString stringWithFormat:@"%02d",(int)comps.second];
            });
            
        }
        
    });
    dispatch_resume(self.timer);
}


- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"距离结束";
        _hintLabel.textColor = HexRGB(0x999999, 1.0f);
        _hintLabel.font = [UIFont systemFontOfSize:14.0f];
        
    }
    return _hintLabel;
}

- (UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.backgroundColor = HexRGB(0x444444, 1.0f);
        _hourLabel.textColor = HexRGB(0xffffff, 1.0f);
        _hourLabel.font = [UIFont systemFontOfSize:11.0f];
        _hourLabel.layer.cornerRadius = 10.f;
        _hourLabel.text = @"00";
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.clipsToBounds = YES;
    }
    return _hourLabel;
}

- (UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.backgroundColor = HexRGB(0x444444, 1.0f);
        _minuteLabel.textColor = HexRGB(0xffffff, 1.0f);
        _minuteLabel.font = [UIFont systemFontOfSize:11.0f];
        _minuteLabel.layer.cornerRadius = 10.f;
        _minuteLabel.text = @"00";
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.clipsToBounds = YES;
    }
    return _minuteLabel;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.backgroundColor = HexRGB(0x444444, 1.0f);
        _secondLabel.textColor = HexRGB(0xffffff, 1.0f);
        _secondLabel.font = [UIFont systemFontOfSize:11.0f];
        _secondLabel.layer.cornerRadius = 10.f;
        _secondLabel.text = @"00";
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.clipsToBounds = YES;
    }
    return _secondLabel;
}

- (UILabel *)colonLabel1{
    if (!_colonLabel1) {
        _colonLabel1 = [[UILabel alloc] init];
        _colonLabel1.textColor = HexRGB(0x444444, 1.0f);
        _colonLabel1.text = @":";
        _colonLabel1.textAlignment = NSTextAlignmentCenter;
        _colonLabel1.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _colonLabel1;
}

- (UILabel *)colonLabel2{
    if (!_colonLabel2) {
        _colonLabel2 = [[UILabel alloc] init];
        _colonLabel2.textColor = HexRGB(0x444444, 1.0f);
        _colonLabel2.text = @":";
        _colonLabel2.textAlignment = NSTextAlignmentCenter;
        _colonLabel2.font = [UIFont boldSystemFontOfSize:17.0f];
    }
    return _colonLabel2;
}

@end
