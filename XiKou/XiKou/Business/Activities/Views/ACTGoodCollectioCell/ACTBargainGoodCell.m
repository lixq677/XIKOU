//
//  ACTBargainGoodCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBargainGoodCell.h"
#import "NSDate+Extension.h"
#import "XKWeakProxy.h"

@interface ACTBargainGoodCell ()

@property (nonatomic, strong) UILabel *originLabel;

@property (nonatomic, strong) UILabel *subTextLabel;

@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, strong) UILabel *borderLabel;

@property (nonatomic, strong) UILabel *buyLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImageView *statusImgView;


@end

@implementation ACTBargainGoodCell
{
    NSTimer *_timer;
    NSInteger _time;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius  = 7.f;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.contentView xk_addSubviews:@[self.coverView,self.nameLabel,self.subTextLabel,
                                           self.priceLabel,self.originLabel,self.borderLabel,
                                           self.buyLabel,self.statusImgView,self.statusLabel,self.timerLabel]];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            make.width.equalTo(self.coverView.mas_height);
            //make.bottom.mas_equalTo(-15);
        }];

        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverView.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.coverView);
        }];
        [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        }];
        
        [self.timerLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.nameLabel);
            make.bottom.mas_equalTo(-15.0f);
            make.top.mas_equalTo(self.coverView.mas_bottom);
            make.height.mas_equalTo(12.0f);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.bottom.mas_equalTo(self.timerLabel.mas_top).offset(-5);
            make.height.mas_equalTo(15);
        }];
        [self.originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.priceLabel);
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
        }];
        [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 29));
            make.right.mas_equalTo(-15);
            make.bottom.equalTo(self.coverView);
        }];
        [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.coverView);
            make.height.width.mas_equalTo(20);
        }];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(45);
            make.center.equalTo(self.coverView);
        }];
        [self.borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self.priceLabel.mas_top).offset(-8);
            make.height.mas_equalTo(15);
        }];
    }
    
    return self;
}

- (void)setModel:(XKGoodListModel *)model{
    [super setModel:model];
    
    self.nameLabel.text = model.commodityName;
    [self.nameLabel setLineSpace:5.f];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.model.commodityPrice doubleValue]/100];
    self.originLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.model.salePrice doubleValue]/100];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:220 height:220]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    
    self.borderLabel.text    = [NSString stringWithFormat:@" %ld人助力 ",(long)self.model.bargainNumber];
    
    if (self.model.bargainStatus == BargainIng && self.model.bargainState == BargainContinue) {
        self.buyLabel.text = @"继续砍价";
        self.buyLabel.backgroundColor = HexRGB(0x444444, 1.0f);
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Bargain_Ing"];
        if (model.bargainEffectiveTime && model.bargainCreateTime) {
            NSDate *date = [NSDate date:model.bargainCreateTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSTimeInterval dateTime =[date timeIntervalSince1970];
            
            NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
            
            double secondMax = dateTime + [model.bargainEffectiveTime integerValue]*3600;
            if (nowTime < secondMax) {
                _time = secondMax - nowTime;
                [self startTimer];
            }else{
                self.timerLabel.text = @"剩余: 00: 00: 00";
            }
        }
    }else if (model.bargainStatus == BargainIng && model.bargainState == BargainCanOrder) {
        
        self.buyLabel.text = @"砍价成功";
        self.buyLabel.backgroundColor = HexRGB(0x444444, 1.0f);
        self.statusImgView.hidden = NO;
        self.statusImgView.image  = [UIImage imageNamed:@"Bargain_Success"];
        
    }else{
        
        if (self.model.stock == 0) {
            self.buyLabel.text = @"已售罄";
            self.buyLabel.backgroundColor = HexRGB(0x999999, 1.0f);
        }else{
            self.buyLabel.text = @"我要砍价";
            self.buyLabel.backgroundColor = HexRGB(0x444444, 1.0f);
        }
        self.statusImgView.hidden = YES;
        self.subTextLabel.text    = [NSString stringWithFormat:@"%ld人砍价成功",(long)model.bargainedNum];
    }
    self.statusLabel.text    = @"售罄";
    self.statusLabel.hidden  = YES;
    self.subTextLabel.text    = [NSString stringWithFormat:@"%ld人砍价成功",(long)model.bargainedNum];
    
    [self.priceLabel handleRedPrice:FontSemibold(15.f)];
    [self.originLabel addMiddleLineWithSubString:self.originLabel.text];
}

- (void)startTimer {
    if (_timer) return;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:[XKWeakProxy proxyWithTarget:self] selector:@selector(reloadTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)reloadTime{
    _time--;
    if (_timer <= 0) {
        //关闭定时器
        self.timerLabel.text = @"剩余: 00: 00: 00";
        [_timer invalidate];
        _timer = nil;
    }else {
        //处倒计时
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour = _time / 3600;
        self.timerLabel.text = [NSString stringWithFormat:@"剩余: %02ld: %02ld: %02ld",hour,minute,second];
    }
}


- (UILabel *)borderLabel{
    if (!_borderLabel) {
        _borderLabel = [[UILabel alloc] init];
        _borderLabel.textColor = COLOR_HEX(0xF94119);
        _borderLabel.font      = Font(10.f);
        _borderLabel.layer.cornerRadius  = 1.0f;
        _borderLabel.layer.borderColor   = COLOR_HEX(0xF94119).CGColor;
        _borderLabel.layer.borderWidth   = 0.5f;
    }
    return _borderLabel;
}

- (UILabel *)buyLabel{
    if (!_buyLabel) {
        _buyLabel = [UILabel new];
        _buyLabel.backgroundColor = COLOR_TEXT_BLACK;
        _buyLabel.layer.cornerRadius = 2.0f;
        _buyLabel.layer.masksToBounds = YES;
        _buyLabel.font = Font(12.f);
        _buyLabel.textAlignment = NSTextAlignmentCenter;
        _buyLabel.textColor = [UIColor whiteColor];
    }
    return _buyLabel;
}

- (UIImageView *)statusImgView{
    if (!_statusImgView) {
        _statusImgView = [UIImageView new];
        _statusImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _statusImgView;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = Font(12.);
    }
    return _statusLabel;
}

- (UILabel *)originLabel{
    if (!_originLabel) {
        _originLabel = [[UILabel alloc] init];
        _originLabel.textColor = COLOR_PRICE_GRAY;
        _originLabel.font = Font(10.f);
    }
    return _originLabel;
}

- (UILabel *)subTextLabel{
    if (!_subTextLabel) {
        _subTextLabel = [UILabel new];
        _subTextLabel.font = Font(12.f);
        _subTextLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _subTextLabel;
}

- (UILabel *)timerLabel{
    if (!_timerLabel) {
        _timerLabel = [UILabel new];
        _timerLabel.font = Font(12.f);
        _timerLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _timerLabel;
}

@end
