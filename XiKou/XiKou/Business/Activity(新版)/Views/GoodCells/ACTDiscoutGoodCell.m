//
//  ACTDiscoutGoodCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTDiscoutGoodCell.h"

@interface ACTDiscoutGoodCell ()

@property (nonatomic, strong) UILabel *originalLabel;//原价

@property (nonatomic, strong) UILabel *discountLabel;//折扣

@property (nonatomic, strong) UILabel *saleNumLabel;//销量

@end

@implementation ACTDiscoutGoodCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView xk_addSubviews:@[self.originalLabel,self.discountLabel,self.saleNumLabel]];
        
        [self.originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
            make.bottom.equalTo(self.priceLabel);
        }];
        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(14);
            make.bottom.equalTo(self.priceLabel.mas_top).offset(-10);
        }];
        [self.saleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.discountLabel.mas_right).offset(5);
            make.height.top.bottom.equalTo(self.discountLabel);
        }];
    }
    return self;
}

- (UILabel *)originalLabel{
    if (!_originalLabel) {
        _originalLabel = [UILabel new];
        _originalLabel.font = Font(10.f);
        _originalLabel.textColor = COLOR_PRICE_GRAY;
    }
    return _originalLabel;
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
        _saleNumLabel.backgroundColor = COLOR_HEX(0xFFF0ED);
        _saleNumLabel.textColor = COLOR_TEXT_RED;
        _saleNumLabel.textAlignment = NSTextAlignmentCenter;
        _saleNumLabel.layer.masksToBounds = YES;
        _saleNumLabel.layer.cornerRadius = 2;
    }
    return _saleNumLabel;
}
@end
