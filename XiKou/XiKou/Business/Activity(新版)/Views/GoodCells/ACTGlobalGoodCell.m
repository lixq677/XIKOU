//
//  ACTGlobalGoodCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGlobalGoodCell.h"
#import "ACTDashedView.h"

@interface ACTGlobalGoodCell ()

@property (nonatomic, strong) ACTDashedView *couponLabel;//优惠券价格

@property (nonatomic, strong) UILabel *originalLabel;//原价

@end

@implementation ACTGlobalGoodCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView xk_addSubviews:@[self.originalLabel,self.couponLabel]];

        [self.originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
            make.bottom.equalTo(self.priceLabel);
        }];
        [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(15);
            make.right.equalTo(self.couponLabel.valueLabel); make.bottom.equalTo(self.priceLabel.mas_top).offset(-9);
        }];
        
    }
    return self;
}

- (void)setModel:(XKGoodModel *)model{
    [super setModel:model];
    self.nameLabel.text = model.commodityName;
    [self.nameLabel setLineSpace:7.f];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.commodityPrice doubleValue]/100];
    [self.priceLabel handleRedPrice:FontSemibold(15.f)];
    self.originalLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    [self.originalLabel addMiddleLineWithSubString:self.originalLabel.text];
    self.couponLabel.value = [model.couponValue doubleValue]/100;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:200 height:200]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
}

- (UILabel *)originalLabel{
    if (!_originalLabel) {
        _originalLabel = [UILabel new];
        _originalLabel.font = Font(10.f);
        _originalLabel.textColor = COLOR_PRICE_GRAY;
    }
    return _originalLabel;
}

- (ACTDashedView *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [ACTDashedView new];
    }
    return _couponLabel;
}

@end
