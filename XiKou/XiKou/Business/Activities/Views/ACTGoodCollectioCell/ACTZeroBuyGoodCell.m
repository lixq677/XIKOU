//
//  ACTZeroBuyGoodCell.m
//  XiKou
//  带倒计时的0元购cell
//  Created by L.O.U on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTZeroBuyGoodCell.h"
#import "XKGoodModel.h"

@interface ACTZeroBuyGoodCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *buyingBtn;//抢购

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ACTZeroBuyGoodCell
{
    NSInteger _time;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView xk_addSubviews:@[self.buyingBtn,self.timeLabel]];
        [self.buyingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.timeLabel);
            make.height.mas_equalTo(29);
            make.width.mas_equalTo(70);
            make.bottom.equalTo(self.priceLabel);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.nameLabel);
            make.bottom.equalTo(self.buyingBtn.mas_top);
            make.height.mas_equalTo(24);
        }];
    }
    return self;
}

+ (CGFloat)desheight{
    return 106;
}

- (void)setModel:(XKGoodModel *)model{
    [super setModel:model];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.nameLabel.text  = model.commodityName;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.adctionModel.currentPrice doubleValue]/100];
    [self.priceLabel handleRedPrice:FontSemibold(15.f)];
    
    [self.buyingBtn setTitle:model.adctionModel.statusTitle forState:UIControlStateNormal];
    if (model.adctionModel.status == Auction_Begin) {
        [self.buyingBtn setBackgroundColor:COLOR_TEXT_BLACK];
        _time = [model.adctionModel.remainingTime integerValue];
        [self startTimer];
    }else{
        [self.buyingBtn setBackgroundColor:COLOR_HEX(0xCCCCCC)];
        self.timeLabel.text = model.adctionModel.statusTitle;
    }
}

- (void)startTimer {
    if (self.timer) return;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(reloadTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)reloadTime{
    _time--;
    if (_time <= 0) {
        //关闭定时器
        self.timeLabel.text = @"00:00:00";
        [self.timer invalidate];
        self.timer = nil;
    }else {
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour = _time / 3600;
        self.timeLabel.text = [NSString stringWithFormat:@"距离结束: %ld:%02ld:%02ld",hour,minute,second];
    }
}
- (void)buyingClick{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = Font(10.f);
        _timeLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _timeLabel;
}

- (UIButton *)buyingBtn{
    if (!_buyingBtn) {
        _buyingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyingBtn.layer.masksToBounds = YES;
        _buyingBtn.layer.cornerRadius  = 2.f;
        _buyingBtn.enabled = NO;
        [_buyingBtn setBackgroundColor:COLOR_TEXT_BLACK];
        [_buyingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyingBtn.titleLabel setFont:Font(12.f)];
        [_buyingBtn addTarget:self action:@selector(buyingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyingBtn;
}
@end
