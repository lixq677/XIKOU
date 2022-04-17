//
//  ACTWugGoodCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTWugGoodCell.h"

@interface ACTWugGoodCell ()

@property (nonatomic, strong) UILabel *couponLabel;//折扣

@end

@implementation ACTWugGoodCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.couponLabel];
        
        [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(14);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(7);
        }];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.couponLabel.mas_bottom).offset(5);
        }];
    }
    return self;
}

- (void)setModel:(XKGoodListModel *)model{
    [super setModel:model];
    
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:[model.goodsImageUrl appendOSSImageWidth:200 height:200]] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    self.nameLabel.text  = model.commodityName;
    
    self.couponLabel.text = @" 赠券256 ";
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.salePrice doubleValue]/100];
    
    [self.priceLabel handleRedPrice:FontSemibold(15.f)];
    
}

+ (CGFloat)desHeight{
    return 74;
}

- (UILabel *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [UILabel new];
        _couponLabel.font = Font(9.f);
        _couponLabel.backgroundColor = COLOR_HEX(0xFFF0ED);
        _couponLabel.textColor = COLOR_TEXT_RED;
        _couponLabel.textAlignment = NSTextAlignmentCenter;
        _couponLabel.layer.masksToBounds = YES;
        _couponLabel.layer.cornerRadius = 2;
    }
    return _couponLabel;
}

@end
