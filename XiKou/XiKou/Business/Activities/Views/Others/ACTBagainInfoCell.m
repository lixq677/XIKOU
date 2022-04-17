//
//  ACTBagainInfoCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTBagainInfoCell.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKGCDTimer.h"
#import "NSDate+Extension.h"
#import "XKActivityData.h"

@interface ACTBagainInfoCell ()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailTextLabel;

@property (nonatomic, strong) UILabel *borderLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *origPriceLabel;

@property (nonatomic, strong) UIButton *blackBtn;

@property (nonatomic, strong) UIButton *whiteBtn;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIImageView *statusImgView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UILabel *bargainDesLabel;

@property (nonatomic, strong) UILabel *textDesLabel;

@end

@implementation ACTBagainInfoCell
{
    NSString *_timerName;
    NSInteger _time;
}
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self autoLayout];
    }
    return self;
}

#pragma mark action
- (void)blackBtnAction{
    if (_cellAction) {
        _cellAction(_blackBtn.tag);
    }
}

- (void)whiteBtnAction{
    if (_cellAction) {
        _cellAction(ActionBuy);
    }
}

- (void)reloadGoodInfo:(XKGoodSKUModel *)skuModel
        andBargainInfo:(XKBargainInfoModel *)infoModel ruleMode:(XKActivityRulerModel *)rulerModel{
    /**********商品信息**********/
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:skuModel.skuImage] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.titleLabel.text  = skuModel.commodityName;
    NSMutableString *string = [NSMutableString string];
    [skuModel.contition enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendString:obj];
        [string appendString:@" "];
    }];
    self.detailTextLabel.text = string;
    self.priceLabel.text  = [NSString stringWithFormat:@"¥%.2f",[skuModel.commodityPrice doubleValue]/100];
    self.origPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[skuModel.salePrice doubleValue]/100];
    [self.priceLabel handleRedPrice:FontSemibold(17.f)];
    [self.origPriceLabel addMiddleLineWithSubString:self.origPriceLabel.text];
    self.statusImgView.image = [UIImage imageNamed:@"ic_bottom_price"];
    
    /**********砍价信息**********/
    if (infoModel.state == 1) {
        self.bargainDesLabel.text = [NSString stringWithFormat:@"已砍至: ¥%.2f",[infoModel.currentPrice doubleValue]/100];
        [self.blackBtn setTitle:@"邀请好友帮忙砍价" forState:UIControlStateNormal];
        self.blackBtn.tag = ActionShare;
        self.whiteBtn.tag = ActionBuy;
        self.whiteBtn.hidden = YES;
        [self.textDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.blackBtn.mas_bottom).offset(10);
        }];
    }else{
        if (infoModel.bargainCount == rulerModel.bargainNumber) {
            self.bargainDesLabel.text = [NSString stringWithFormat:@"砍价成功: ¥%.2f",[infoModel.currentPrice doubleValue]/100];
            self.whiteBtn.hidden = YES;
            [self.blackBtn setTitle:@"砍价成功，前往支付" forState:UIControlStateNormal];
            self.blackBtn.tag = ActionBragainBuy;
             self.whiteBtn.hidden = YES;
            [self.textDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.blackBtn.mas_bottom).offset(10);
            }];
            
        }else{
            self.bargainDesLabel.text = [NSString stringWithFormat:@"已砍至: ¥%.2f",[infoModel.currentPrice doubleValue]/100];
            [self.whiteBtn setTitle:@"直接买下得实惠" forState:UIControlStateNormal];
            [self.blackBtn setTitle:@"分享好友多砍一刀" forState:UIControlStateNormal];
            self.blackBtn.tag = ActionShare;
            self.whiteBtn.tag = ActionBuy;
            self.whiteBtn.hidden = NO;
            [self.textDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.whiteBtn.mas_bottom).offset(10);
            }];
        }
    }
    
    [self.bargainDesLabel setLineSpace:8.f];
    
    CGFloat rate = infoModel.bargainCount / rulerModel.bargainNumber;
    [self.progressView setProgress:0.00001 animated:NO];
    [self.progressView setProgress:rate animated:YES];
    
    
    if (infoModel.createTime) {
        NSDate *date = [NSDate date:skuModel.bargainCreateTime WithFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval dateTime =[date timeIntervalSince1970];
        
        NSDate* nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval nowTime =[nowDate timeIntervalSince1970];
        
        double secondMax = dateTime + [skuModel.bargainEffectiveTimed integerValue] *3600;
        _time = secondMax - nowTime;
        [self startTimer];
    }
}

#pragma mark 倒计时
- (void)startTimer{
    if (!_timerName){
        @weakify(self);
        _timerName = @"砍价倒计时";
        [self reloadTime];
        [[XKGCDTimer sharedInstance]scheduleGCDTimerWithName:_timerName interval:1 queue:nil repeats:YES option:MergePreviousTimerAction action:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadTime];
            });
        }];
    }
}

- (void)reloadTime{
    _time --;
    NSString *text = nil;
  
    if (_time <= 0) {
        //关闭定时器
        text = @"剩余: 00: 00: 00 砍价过期";
        [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
    }else {
        //处倒计时
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour   = _time / 3600;
        text = [NSString stringWithFormat:@"剩余: %02ld: %02ld: %02ld 砍价过期",(long)hour,(long)minute,(long)second];
    }
    self.timeLabel.text = text;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timerName) {
        [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
    }
}

- (void)autoLayout{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius  = 4.f;
  
    [self.contentView xk_addSubviews:@[self.coverView,self.titleLabel,self.borderLabel,
                                    self.priceLabel,self.origPriceLabel,self.timeLabel,
                                    self.progressView,self.bargainDesLabel,self.blackBtn,
                                    self.whiteBtn]];
    
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.statusImgView];
    [self.contentView addSubview:self.textDesLabel];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.width.height.mas_equalTo(110);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.coverView).offset(3);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusImgView.mas_right).offset(10);
        make.bottom.equalTo(self.coverView).offset(-7);
        make.height.mas_equalTo(15);
    }];
    [self.origPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(4);
    }];
    
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailTextLabel);
        make.centerY.equalTo(self.priceLabel);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(15);
    }];
    
    
    [self.borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-5);
        make.height.mas_equalTo(18);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.coverView.mas_bottom).offset(25);
        make.height.mas_equalTo(12);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(17);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(13);
    }];
    [self.bargainDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.progressView);
        make.top.equalTo(self.progressView.mas_bottom).offset(20);
    }];
    [self.blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bargainDesLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.progressView);
        make.height.mas_equalTo(40);
    }];
    [self.whiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackBtn.mas_bottom).offset(10);
        make.left.right.equalTo(self.blackBtn);
        make.height.mas_equalTo(40);
    }];
    [self.textDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBtn.mas_bottom).offset(10);
        make.left.right.equalTo(self.whiteBtn);
        make.height.mas_equalTo(17);
        make.bottom.mas_equalTo(-20);
    }];
}

#pragma mark getter or setter
- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.0f;
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}

- (UILabel *)textDesLabel{
    if (!_textDesLabel) {
        _textDesLabel = [[UILabel alloc] init];
        _textDesLabel.textColor = HexRGB(0x9b9b9b, 1.0f);
        _textDesLabel.font = [UIFont systemFontOfSize:12.0f];
        _textDesLabel.textAlignment = NSTextAlignmentCenter;
        _textDesLabel.text = @"购买成功后帮您砍价的好友可以获得现金红包哦！";
    }
    return _textDesLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x9b9b9b, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _detailTextLabel;
}

- (UILabel *)borderLabel{
    if (!_borderLabel) {
        _borderLabel = [[UILabel alloc] init];
        _borderLabel.textColor = HexRGB(0xf94119, 1.0f);
        _borderLabel.font = [UIFont systemFontOfSize:9.0f];
        _borderLabel.layer.cornerRadius = 1.0f;
        _borderLabel.layer.borderColor = [HexRGB(0xef421c, 1.0f) CGColor];
        _borderLabel.layer.borderWidth = 0.5f;
    }
    return _borderLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = COLOR_TEXT_RED;
        _priceLabel.font = FontSemibold(17.f);
    }
    return _priceLabel;
}

- (UILabel *)origPriceLabel{
    if (!_origPriceLabel) {
        _origPriceLabel = [[UILabel alloc] init];
        _origPriceLabel.textColor = COLOR_TEXT_GRAY;
        _origPriceLabel.font = Font(10.f);
    }
    return _origPriceLabel;
}

- (UIButton *)blackBtn{
    if (!_blackBtn) {
        _blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _blackBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _blackBtn.layer.cornerRadius = 2.0f;
        [_blackBtn setTitle:@"分享好友多砍一刀" forState:UIControlStateNormal];
        [_blackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_blackBtn.titleLabel setFont:FontMedium(14.f)];
        [_blackBtn addTarget:self action:@selector(blackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _blackBtn;
}

- (UIButton *)whiteBtn{
    if (!_whiteBtn) {
        _whiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _whiteBtn.layer.borderWidth = 0.5;
        _whiteBtn.layer.borderColor = COLOR_LINE_GRAY.CGColor;
        _whiteBtn.layer.cornerRadius = 2.0f;
        [_whiteBtn setTitle:@"直接买下得优惠" forState:UIControlStateNormal];
        [_whiteBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
        [_whiteBtn.titleLabel setFont:Font(14.f)];
        [_whiteBtn addTarget:self action:@selector(whiteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whiteBtn;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = Font(12.f);
        _timeLabel.textColor = COLOR_TEXT_BLACK;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
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

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.trackTintColor = COLOR_HEX(0xFFF0ED);
        _progressView.progressTintColor   = COLOR_TEXT_RED;
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius  = 8.5;
        for (UIImageView * imageview in _progressView.subviews) {
            imageview.layer.cornerRadius = 8.5;
            imageview.clipsToBounds = YES;
        }
    }
    return _progressView;
}

- (UILabel *)bargainDesLabel{
    if (!_bargainDesLabel) {
        _bargainDesLabel = [UILabel new];
        _bargainDesLabel.font = Font(19.f);
        _bargainDesLabel.textColor = COLOR_TEXT_RED;
        _bargainDesLabel.textAlignment = NSTextAlignmentCenter;
        _bargainDesLabel.numberOfLines = 2;
    }
    return _bargainDesLabel;
}


@end
