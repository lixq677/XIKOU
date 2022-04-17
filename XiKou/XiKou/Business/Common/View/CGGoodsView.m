//
//  CGGoodsView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CGGoodsView.h"
#import "XKGoodModel.h"
#import "BCTools.h"
#import "XKGradientButton.h"

@implementation CMGradientView
@synthesize gradientLayer = _gradientLayer;


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

@end


@implementation CGMoreGoodsCell
@synthesize imageView = _imageView;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self layout];
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.contentView);
        make.width.mas_equalTo(75.0f);
        //make.height.mas_equalTo(150.0f);
        make.top.bottom.mas_equalTo(0.0f);
        make.left.mas_equalTo(5.0f);
    }];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode =   UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"see_more"];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end

@implementation CGBrandCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self layout];
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.width.mas_equalTo(63.0f);
        make.height.mas_equalTo(34.0f);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(6.0f);
        make.height.mas_equalTo(13.0f);
        make.bottom.mas_equalTo(-5.0f);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = COLOR_TEXT_BLACK;
        _textLabel.font = Font(12.0f);
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode =   UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"see_more"];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end

/**********商品CELL*************/
@implementation CGGoodsCell
@synthesize textLabel = _textLabel;
@synthesize detailLabel = _detailLabel;
@synthesize imageView = _imageView;
@synthesize priceLabel = _priceLabel;
@synthesize sellOutLabel = _sellOutLabel;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.imageView addSubview:self.sellOutLabel];
        [self.sellOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60.0f);
            make.center.equalTo(self.imageView);
        }];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode =   UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = COLOR_TEXT_BLACK;
        _textLabel.font = Font(12.0f);
    }
    return _textLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = COLOR_TEXT_BLACK;
        _priceLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    }
    return _priceLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont boldSystemFontOfSize:9.0f];
        _detailLabel.textColor = COLOR_TEXT_RED;
        _detailLabel.layer.cornerRadius = 2.0f;
    }
    return _detailLabel;
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

@implementation CGWgCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layout];
        self.detailLabel.backgroundColor = HexRGB(0xfff0ed, 1.0f);
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(14.0f);
    }];
}
@end

@implementation CGBrainCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layout];
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.imageView.mas_bottom).offset(10.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.textLabel.mas_bottom).offset(5.0f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(5.0f);
    }];
    
}

@end

@implementation CGZeroBuyCell

@end

@implementation CGGlobleBuyerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.couponLabel];
        [self layout];
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(7.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.top.mas_equalTo(self.couponLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(15.0f);
       // make.bottom.mas_equalTo(-15.0f);
    }];
}

- (ACTDashedView *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [ACTDashedView new];
    }
    return _couponLabel;
}
@end

@interface CGMultiDiscountCell ()

@property (nonatomic, strong) CMGradientView *gradientView;

@end


@implementation CGMultiDiscountCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.gradientView];
        [self.contentView addSubview:self.saleNumLabel];
        [self.contentView addSubview:self.discountLabel];
        [self layout];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(5.0f);
        make.left.equalTo(self.textLabel);
        make.height.mas_equalTo(14);
    }];
    [self.saleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountLabel.mas_right).offset(5);
        make.height.top.bottom.equalTo(self.discountLabel);
    }];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.saleNumLabel);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.top.mas_equalTo(self.discountLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(15.0f);
       // make.bottom.mas_equalTo(-15.0f);
    }];
}

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [UILabel new];
        _discountLabel.font = Font(9.f);
        _discountLabel.backgroundColor = COLOR_HEX(0xFFF0ED);
        _discountLabel.textColor = COLOR_TEXT_RED;
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.layer.masksToBounds = YES;
        _discountLabel.layer.cornerRadius = 2;
    }
    return _discountLabel;
}

- (UILabel *)saleNumLabel{
    if (!_saleNumLabel) {
        _saleNumLabel = [UILabel new];
        _saleNumLabel.font = Font(9.f);
       // _saleNumLabel.backgroundColor = COLOR_HEX(0xFFF0ED);
        _saleNumLabel.textColor = [UIColor whiteColor];
        _saleNumLabel.textAlignment = NSTextAlignmentCenter;
        _saleNumLabel.layer.masksToBounds = YES;
        _saleNumLabel.layer.cornerRadius = 2;
    }
    return _saleNumLabel;
}

- (CMGradientView *)gradientView{
    if (!_gradientView) {
        _gradientView = [[CMGradientView alloc] init];
        _gradientView.gradientLayer.startPoint = CGPointMake(0.34, 1);
        _gradientView.gradientLayer.endPoint = CGPointMake(0.8, 0);
        _gradientView.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:229/255.0 green:32/255.0 blue:36/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:106/255.0 blue:83/255.0 alpha:1.0].CGColor];
        _gradientView.gradientLayer.locations = @[@(0), @(1.0f)];
        _gradientView.layer.cornerRadius = 2;
        _gradientView.clipsToBounds = YES;
    }
    return _gradientView;
}

@end

@implementation CGNewUserCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layout];
        self.detailLabel.backgroundColor = HexRGB(0xfff0ed, 1.0f);
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layout{
    self.textLabel.preferredMaxLayoutWidth = self.width-20;
    [self.textLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    self.textLabel.numberOfLines = 2;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
    }];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(7.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.bottom.mas_equalTo(-15.0f);
    }];
}

@end

@implementation CGWgNCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layout];
        self.detailLabel.backgroundColor = HexRGB(0xfff0ed, 1.0f);
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(12.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(15.0f);
    }];
}
@end

@implementation CGBrainNCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layout];
        self.detailLabel.layer.borderColor = HexRGB(0xef421c, 1.0f).CGColor;
        self.detailLabel.layer.borderWidth = 1.0f;
        self.textLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layout{
    //CGFloat width = (kScreenWidth-30.0f)/2.0f;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(15.0f);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(15.0f);
    }];
}

@end

@implementation CGGlobleBuyerNCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.couponLabel];
        self.textLabel.numberOfLines = 0;
        [self layout];
        self.backgroundColor = HexRGB(0xffffff, 1.0f);
        self.layer.cornerRadius = 7.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_lessThanOrEqualTo(33.0f);
    }];
    [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        //make.top.mas_equalTo(self.textLabel.mas_bottom).offset(7.0f);
        make.height.mas_equalTo(15.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textLabel);
        make.top.mas_equalTo(self.couponLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(15.0f);
         make.bottom.mas_equalTo(-15.0f);
    }];
}

- (ACTDashedView *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [ACTDashedView new];
    }
    return _couponLabel;
}
@end

@implementation CGSearchGoodsCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layout];
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 5.0f;
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10.0f);
        make.height.mas_lessThanOrEqualTo(33.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
       // make.top.mas_equalTo(self.textLabel.mas_bottom).offset(5.0f);
        make.height.mas_equalTo(14.0f);
        make.bottom.mas_equalTo(-10.0f);
    }];
    [self.textLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}
@end


@interface CGGoodsListCell ()

@property (nonatomic,strong) UIImageView *coverView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *borderLabel;

@property (nonatomic,strong) UILabel *priceLabel;

@property (nonatomic,strong) UILabel *origPriceLabel;

@property (nonatomic,strong) XKGradientButton *buyBtn;

@property (nonatomic,strong) UIView *contentV;

@property (nonatomic,strong) UILabel *sellOutLabel;

@end

@implementation CGGoodsListCell

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
        make.left.equalTo(self.contentV).offset(10);
        make.width.height.mas_equalTo(110);
        make.bottom.equalTo(self.contentV).offset(-15);
        make.top.equalTo(self.contentV).offset(15);
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
    [self.priceLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.origPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.buyBtn.mas_left).offset(-10.0f);
    }];
    [self.borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
        make.height.mas_equalTo(15);
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.coverView);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(29);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.model.activityType == Activity_WG){
        self.buyBtn.gradientLayer.startPoint = CGPointMake(0.08, 1);
        self.buyBtn.gradientLayer.endPoint = CGPointMake(0.95, 0);
        self.buyBtn.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:83/255.0 blue:83/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:234/255.0 green:25/255.0 blue:62/255.0 alpha:1.0].CGColor];
        self.buyBtn.gradientLayer.locations = @[@(0), @(1.0f)];
        self.buyBtn.layer.cornerRadius = 14.5;
    }else{
        self.buyBtn.gradientLayer.startPoint = CGPointMake(0.34, 1);
        self.buyBtn.gradientLayer.endPoint = CGPointMake(0.8, 0);
        self.buyBtn.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:229/255.0 green:32/255.0 blue:36/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:106/255.0 blue:83/255.0 alpha:1.0].CGColor];
        self.buyBtn.gradientLayer.locations = @[@(0), @(1.0f)];
        self.buyBtn.layer.cornerRadius = 2;
    }
}


- (void)setModel:(XKGoodListModel *)model{
    _model = model;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:220 height:220]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.titleLabel.text  = model.commodityName;
    if (model.activityType == Activity_Discount) {
        self.borderLabel.text = [NSString stringWithFormat:@" 分享赚%.2f ",[model.shareAmount doubleValue]/100];
        //self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
        self.priceLabel.attributedText = PriceDef([model.commodityPriceOne doubleValue]/100);
        self.origPriceLabel.attributedText = PriceDef_line([model.salePrice doubleValue]/100.00f);
    }else if (model.activityType == Activity_WG){
        self.borderLabel.text = [NSString stringWithFormat:@" 赠券%.2f ",[model.couponValue doubleValue]/100];
        //self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
        self.priceLabel.attributedText = PriceDef([model.salePrice doubleValue]/100);
       // self.origPriceLabel.attributedText = PriceDef_line([model.salePrice doubleValue]/100.00f);
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
        _borderLabel.layer.cornerRadius = 2.0f;
        _borderLabel.clipsToBounds = YES;
        _borderLabel.backgroundColor = HexRGB(0xFFECE8, 1.0f);
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

- (XKGradientButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [XKGradientButton buttonWithType:UIButtonTypeCustom];
        // _buyBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _buyBtn.layer.cornerRadius = 2.0f;
        _buyBtn.enabled = NO;
        [_buyBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_buyBtn setTitle:@"已售罄" forState:UIControlStateDisabled];
       // [_buyBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
        [_buyBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x999999, 1.0f)] forState:UIControlStateDisabled];
        [_buyBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _buyBtn.userInteractionEnabled = NO;
        _buyBtn.gradientLayer.startPoint = CGPointMake(0.34, 1);
        _buyBtn.gradientLayer.endPoint = CGPointMake(0.8, 0);
        _buyBtn.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:229/255.0 green:32/255.0 blue:36/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:106/255.0 blue:83/255.0 alpha:1.0].CGColor];
        _buyBtn.gradientLayer.locations = @[@(0), @(1.0f)];
        _buyBtn.layer.cornerRadius = 2;
        _buyBtn.clipsToBounds = YES;
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

