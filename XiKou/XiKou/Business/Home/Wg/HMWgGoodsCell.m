//
//  HMWgGoodsCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMWgGoodsCell.h"
#import "ACTDashedView.h"
#import "XKGoodModel.h"
#import "UILabel+NSMutableAttributedString.h"
#import "NSDate+Extension.h"
#import "XKWeakProxy.h"
#import "UIView+TABAnimated.h"

@interface HMWgGoodsCell ()

@property (nonatomic,strong) UIImageView *coverView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *borderLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *origPriceLabel;

@property (nonatomic,strong) UIButton *buyBtn;

@property (nonatomic,strong) UILabel *subTextLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *statusLabel;

@property (nonatomic,strong) UIImageView *statusImgView;

@property (nonatomic,strong) ACTDashedView *couponView;

@property (nonatomic,strong) UIView *contentV;

@property (nonatomic,strong) UILabel *sellOutLabel;

@end
@implementation HMWgGoodsCell
{
    CellStyle _style;
    NSTimer *_timer;
    NSInteger _time;
}
- (instancetype)initWithCellStyle:(CellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _style = style;
        [self autoLayout];
        if (style == CellBargain) {
            [self layoutBargainCell];
        }
        if (style == CellGlobal){
            [self layoutGlobal];
        }
        self.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    }
    return self;
}

- (void)autoLayout{
    [self.contentView addSubview:self.contentV];
    [self.contentV xk_addSubviews:@[self.coverView,self.titleLabel,self.borderLabel,self.priceLabel,self.origPriceLabel,self.buyBtn]];
    [self.coverView addSubview:self.sellOutLabel];
    [self.sellOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60.0f);
        make.center.equalTo(self.coverView);
    }];
    
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentV).offset(10);
        make.width.height.mas_equalTo(110);
        make.bottom.equalTo(self.contentV).offset(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView.mas_right).offset(10);
        make.right.equalTo(self.contentV).offset(-10);
        make.top.equalTo(self.coverView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.coverView).offset(-2);
        make.height.mas_equalTo(15);
    }];
    [self.origPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(4);
    }];
    [self.borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
        make.height.mas_equalTo(15);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentV).offset(-10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(29);
    }];
}

- (void)layoutBargainCell{
    [self.contentV xk_addSubviews:@[self.subTextLabel,self.timeLabel,self.statusLabel,self.statusImgView]];
    [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.left.equalTo(self.coverView).offset(5);
        make.top.equalTo(self.coverView);
    }];
    self.statusLabel.layer.masksToBounds = YES;
    self.statusLabel.layer.cornerRadius = 45/2.f;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverView);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.buyBtn).offset(-3);
        make.right.equalTo(self.buyBtn.mas_left).offset(-10);
    }];
}

- (void)layoutGlobal{
    self.borderLabel.hidden = YES;
    [self.contentV addSubview:self.couponView];
    [self.couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
        make.height.mas_equalTo(16);
    }];
    [self.buyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentV).offset(-20);
    }];
}

- (void)setModel:(XKGoodListModel *)model{
    _model = model;

    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:220 height:220]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.titleLabel.text  = model.commodityName;
    [self.titleLabel setLineSpace:5.f];
    
    if (_style == CellWG) {
        self.borderLabel.text = [NSString stringWithFormat:@" 赠券%.2f ",[model.couponValue doubleValue]/100];
        [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    }
    if (_style == CellGlobal) {
        self.couponView.value = [model.couponValue doubleValue]/100;
        [self.buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPrice doubleValue]/100];
        self.origPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    }
    if (_style == CellBargain) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
        self.origPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.marketPrice doubleValue]/100];
        
        self.borderLabel.text    = [NSString stringWithFormat:@" %ld人助力 ",model.bargainNumber];
        self.subTextLabel.text   = [NSString stringWithFormat:@"%ld人砍价成功",model.bargainedNum];

        if (model.bargainStatus == BargainIng && model.bargainState == BargainContinue) {
            [self.buyBtn setTitle:@"继续砍价" forState:UIControlStateNormal];
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
                    self.timeLabel.text = @"剩余: 00: 00: 00";
                }
            }
            self.timeLabel.hidden = NO;
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-40);
            }];
            
        }else if (model.bargainStatus == BargainIng && model.bargainState == BargainCanOrder) {
            
            [self.buyBtn setTitle:@"砍价成功" forState:UIControlStateNormal];
            self.statusImgView.hidden = NO;
            self.statusImgView.image = [UIImage imageNamed:@"Bargain_Success"];
            self.timeLabel.hidden = YES;
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-16);
            }];
            
        }else{
            [self.buyBtn setTitle:@"我要砍价" forState:UIControlStateNormal];
            self.statusImgView.hidden = YES;
            self.timeLabel.hidden = YES;
            self.timeLabel.text = @"";
            [self.coverView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-16);
            }];
        }
        self.statusLabel.text    = @"售罄";
        self.statusLabel.hidden  = YES;
    }
    if (self.priceLabel.text.length > 0) {
        [self.priceLabel handleRedPrice:FontSemibold(15.f)];
    }
    if (self.origPriceLabel.text.length > 0) {
        [self.origPriceLabel addMiddleLineWithSubString:self.origPriceLabel.text];
    }
    if (_model.stock == 0) {
        self.buyBtn.enabled = NO;
        self.sellOutLabel.hidden = NO;
    }else{
        self.buyBtn.enabled = YES;
        self.sellOutLabel.hidden = YES;
    }
    
}

- (void)startTimer {
    if (_timer) return;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XKWeakProxy proxyWithTarget:self] selector:@selector(reloadTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)reloadTime{
    _time--;
    if (_timer <= 0) {
        //关闭定时器
        self.timeLabel.text = @"剩余: 00: 00: 00";
        [_timer invalidate];
        _timer = nil;
    }else {
        //处倒计时
        //处倒计时
        NSInteger second = _time % 60;
        NSInteger minute = (_time % 3600)/60;
        NSInteger hour = _time / 3600;
        self.timeLabel.text = [NSString stringWithFormat:@"剩余: %02ld: %02ld: %02ld",hour,minute,second];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && _timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark getter or setter

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [[UIView alloc] init];
        _contentV.backgroundColor = HexRGB(0xffffff, 1.0f);
        _contentV.layer.cornerRadius = 7.0f;
    }
    return _contentV;
}


- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.0f;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
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
        _origPriceLabel.textColor = COLOR_PRICE_GRAY;
        _origPriceLabel.font = Font(10.f);
    }
    return _origPriceLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // _buyBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _buyBtn.layer.cornerRadius = 2.0f;
        _buyBtn.enabled = NO;
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_buyBtn setTitle:@"已售罄" forState:UIControlStateDisabled];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x999999, 1.0f)] forState:UIControlStateDisabled];
        [_buyBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _buyBtn.userInteractionEnabled = NO;
    }
    return _buyBtn;
}

- (UILabel *)subTextLabel{
    if (!_subTextLabel) {
        _subTextLabel = [UILabel new];
        _subTextLabel.font = Font(12.f);
        _subTextLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _subTextLabel;
}

- (UILabel *)sellOutLabel{
    if (!_sellOutLabel) {
        _sellOutLabel = [UILabel new];
        _sellOutLabel.font = Font(20.f);
        _sellOutLabel.textColor = HexRGB(0xffffff, 1.0f);
        _sellOutLabel.backgroundColor = HexRGB(0x0, 0.3);
        _sellOutLabel.text = @"售罄";
        _sellOutLabel.layer.cornerRadius = 30.0f;
        _sellOutLabel.textAlignment = NSTextAlignmentCenter;
        _sellOutLabel.clipsToBounds = YES;
    }
    return _sellOutLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = Font(12.f);
        _timeLabel.textColor = COLOR_TEXT_BLACK;
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

- (ACTDashedView *)couponView{
    if (!_couponView) {
        _couponView = [ACTDashedView new];
    }
    return _couponView;
}

@end

@interface CMGoodsListCell ()

@property (nonatomic,strong) UIImageView *coverView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *borderLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *origPriceLabel;

@property (nonatomic,strong) UIButton *buyBtn;

@property (nonatomic,strong) UIView *contentV;

@property (nonatomic,strong) UILabel *sellOutLabel;

@end
@implementation CMGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self autoLayout];
        self.contentView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    }
    return self;
}


- (void)autoLayout{
    [self.contentView addSubview:self.contentV];
    [self.contentV xk_addSubviews:@[self.coverView,self.titleLabel,self.borderLabel,self.priceLabel,self.origPriceLabel,self.buyBtn]];
    [self.coverView addSubview:self.sellOutLabel];
    [self.sellOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60.0f);
        make.center.equalTo(self.coverView);
    }];
    
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentV).offset(10);
        make.width.height.mas_equalTo(110);
        make.bottom.equalTo(self.contentV).offset(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView.mas_right).offset(10);
        make.right.equalTo(self.contentV).offset(-10);
        make.top.equalTo(self.coverView);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.coverView).offset(-2);
        make.height.mas_equalTo(15);
    }];
    [self.origPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(4);
        make.right.mas_equalTo(self.buyBtn.mas_left).offset(-10.0f);
    }];
    [self.borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
        make.height.mas_equalTo(15);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentV).offset(-10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(29);
    }];
}


- (void)setModel:(XKGoodListModel *)model{
    _model = model;
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:220 height:220]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.titleLabel.text  = model.commodityName;
    [self.titleLabel setLineSpace:5.f];
    self.borderLabel.text = [NSString stringWithFormat:@" 赠券%.2f ",[model.couponValue doubleValue]/100];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    if (self.priceLabel.text.length > 0) {
        [self.priceLabel handleRedPrice:FontSemibold(15.f)];
    }
    if (self.origPriceLabel.text.length > 0) {
        [self.origPriceLabel addMiddleLineWithSubString:self.origPriceLabel.text];
    }
    if (_model.stock == 0) {
        self.buyBtn.enabled = NO;
        self.sellOutLabel.hidden = NO;
    }else{
        self.buyBtn.enabled = YES;
        self.sellOutLabel.hidden = YES;
    }
    
}

#pragma mark getter or setter

- (UIView *)contentV{
    if (!_contentV) {
        _contentV = [[UIView alloc] init];
        _contentV.backgroundColor = HexRGB(0xffffff, 1.0f);
        _contentV.layer.cornerRadius = 7.0f;
    }
    return _contentV;
}


- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.0f;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
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
        _origPriceLabel.textColor = COLOR_PRICE_GRAY;
        _origPriceLabel.font = Font(10.f);
    }
    return _origPriceLabel;
}

- (UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // _buyBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _buyBtn.layer.cornerRadius = 2.0f;
        _buyBtn.enabled = NO;
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_buyBtn setTitle:@"已售罄" forState:UIControlStateDisabled];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x999999, 1.0f)] forState:UIControlStateDisabled];
        [_buyBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _buyBtn.userInteractionEnabled = NO;
    }
    return _buyBtn;
}

- (UILabel *)sellOutLabel{
    if (!_sellOutLabel) {
        _sellOutLabel = [UILabel new];
        _sellOutLabel.font = Font(20.f);
        _sellOutLabel.textColor = HexRGB(0xffffff, 1.0f);
        _sellOutLabel.backgroundColor = HexRGB(0x0, 0.3);
        _sellOutLabel.text = @"售罄";
        _sellOutLabel.layer.cornerRadius = 30.0f;
        _sellOutLabel.textAlignment = NSTextAlignmentCenter;
        _sellOutLabel.clipsToBounds = YES;
        _sellOutLabel.hidden = YES;
    }
    return _sellOutLabel;
}
@end



