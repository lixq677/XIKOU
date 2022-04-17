//
//  ACTBargainGoodTableCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBargainGoodTableCell.h"
#import "XKGoodModel.h"
#import "UILabel+NSMutableAttributedString.h"
#import "NSDate+Extension.h"
#import "XKWeakProxy.h"

@interface ACTBargainGoodTableCell ()

@property (nonatomic,strong) UILabel *borderLabel;

@property (nonatomic,strong) UILabel *buyLabel;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UIImageView *statusImgView;

@end

@implementation ACTBargainGoodTableCell
{
    NSTimer *_timer;
    NSInteger _time;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView xk_addSubviews:@[self.borderLabel,self.buyLabel,self.statusImgView,self.statusLabel]];
        [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 29));
            make.right.bottom.mas_equalTo(-15);
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
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.priceLabel.mas_top).offset(-8);
            make.height.mas_equalTo(15);
        }];
    }
    
    return self;
}

- (void)setModel:(XKGoodListModel *)model{
    [super setModel:model];
    
    self.titleLabel.text = model.commodityName;
    [self.titleLabel setLineSpace:5.f];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.model.salePrice doubleValue]/100];
    self.originLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.model.marketPrice doubleValue]/100];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    
    self.borderLabel.text    = [NSString stringWithFormat:@" %ld人助力 ",self.model.bargainNumber];
    
    if (self.model.bargainStatus == BargainIng && self.model.bargainState == BargainContinue) {
        self.buyLabel.text = @"继续砍价";
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
                self.subTextLabel.text = @"剩余: 00: 00: 00";
            }
        }
    }else if (model.bargainStatus == BargainIng && model.bargainState == BargainCanOrder) {
        
        self.buyLabel.text = @"砍价成功";
        self.statusImgView.hidden = NO;
        self.subTextLabel.text    = [NSString stringWithFormat:@"%ld人砍价成功",model.bargainedNum];
        self.statusImgView.image  = [UIImage imageNamed:@"Bargain_Success"];
        
    }else{
        self.buyLabel.text = @"我要砍价";
        self.statusImgView.hidden = YES;
        self.subTextLabel.text    = [NSString stringWithFormat:@"%ld人砍价成功",model.bargainedNum];
    }
    self.statusLabel.text    = @"售罄";
    self.statusLabel.hidden  = YES;
    
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
        self.subTextLabel.text = @"剩余: 00: 00: 00";
        [_timer invalidate];
        _timer = nil;
    }else {
        //处倒计时
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour = _time / 3600;
        self.subTextLabel.text = [NSString stringWithFormat:@"剩余: %02ld: %02ld: %02ld",hour,minute,second];
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

@end
