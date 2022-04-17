//
//  ACTGlobalCouponGoodCell.m
//  XiKou
//  全球购优惠券c商品cell
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGlobalCouponGoodCell.h"
#import "ACTDashedView.h"
#import "XKGoodModel.h"

@interface ACTGlobalCouponGoodCell ()

@property (nonatomic, strong) ACTDashedView *couponLabel;//优惠券价格

@property (nonatomic, strong) UILabel *originalLabel;//原价


@end

@implementation ACTGlobalCouponGoodCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius  = 7.f;
        
        [self.contentView xk_addSubviews:@[self.originalLabel,self.couponLabel]];
        
        [self.originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
            make.bottom.equalTo(self.priceLabel);
        }];
        [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(15);
            make.bottom.equalTo(self.priceLabel.mas_top).offset(-8);
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
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:self.height height:self.height]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
}

+ (CGFloat)desheight{
    return 105;
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

@implementation ACTGlobalHorizontalGoodCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(self.coverView.mas_width).multipliedBy(0.6);
        }];
        [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.coverView.mas_bottom).offset(10);
        }];
    }
    return self;
}

+ (CGFloat)desheight{
    return 110;
}
@end



