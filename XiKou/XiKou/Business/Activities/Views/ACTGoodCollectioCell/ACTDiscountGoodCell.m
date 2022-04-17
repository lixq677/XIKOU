//
//  ACTMultiGoodCell.m
//  XiKou
//  多买多折cell，带折扣label
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDiscountGoodCell.h"
#import "XKGoodModel.h"
#import "BCTools.h"

@interface ACTDiscountGoodCell ()

@end

@implementation ACTDiscountGoodCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self autoLayout];
        self.contentView.layer.cornerRadius = 7.0f;
        self.contentView.clipsToBounds = YES;
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.salePriceLabel];
    [self.contentView addSubview:self.marketPriceLabel];
    [self.imageView addSubview:self.discountLabel];
}

- (void)autoLayout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scalef(10.0f));
        make.right.mas_equalTo(scalef(-10.0f));
        make.top.mas_equalTo(scalef(8.0f));
        make.width.height.mas_equalTo(scalef(90.0f));
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.bottom.equalTo(self.imageView);
        make.width.mas_equalTo(scalef(40.0f));
        make.height.mas_equalTo(scalef(12.0f));
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.imageView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(scalef(4.0f));
        make.height.mas_equalTo(scalef(28.0f));
    }];
    
    [self.salePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.bottom.mas_equalTo(scalef(-10));
        make.height.mas_equalTo(scalef(14.0f));
    }];
    
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.salePriceLabel.mas_right).offset(scalef(5));
        make.height.bottom.equalTo(self.salePriceLabel);
        make.right.equalTo(self.imageView);
    }];
    [self layoutIfNeeded];
    [self.salePriceLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.discountLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(5.5f, 5.5f)];
    shapeLayer.path = [path CGPath];
    self.discountLabel.layer.mask = shapeLayer;

}

- (void)setModel:(XKGoodListModel *)model{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.textLabel.text  = model.commodityName;
    self.salePriceLabel.attributedText =  PriceDef([model.commodityPriceOne doubleValue]/100);
    self.marketPriceLabel.attributedText =  PriceDef_line([model.salePrice doubleValue]/100);
    if (model.rateThree) {
        self.discountLabel.text = [NSString stringWithFormat:@"封顶%@折",model.rateOne];
    }
}


+ (NSString *)identify{
    return NSStringFromClass([self class]);
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _textLabel;
}

- (UILabel *)salePriceLabel{
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc] init];
    }
    return _salePriceLabel;
}

- (UILabel *)marketPriceLabel{
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[UILabel alloc] init];
    }
    return _marketPriceLabel;
}

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.font = [UIFont systemFontOfSize:8.0f];
        _discountLabel.textColor = [UIColor whiteColor];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.backgroundColor = HexRGB(0xF94119, 1.0f);
    }
    return _discountLabel;
}

@end
