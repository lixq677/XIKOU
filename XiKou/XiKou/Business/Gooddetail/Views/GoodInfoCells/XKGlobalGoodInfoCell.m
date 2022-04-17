//
//  XKGlobalGoodInfoCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGlobalGoodInfoCell.h"

@implementation XKGlobalGoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.couponLabel];
        [self.couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.priceLabel);
            make.left.equalTo(self.originalPriceLabel.mas_right).offset(15);
            make.height.mas_equalTo(18);
        }];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.joinVipView layoutIfNeeded];
    self.gradientLayer.frame = self.joinVipView.bounds;
    [self.joinVipView.layer insertSublayer:self.gradientLayer atIndex:0];
    
    [self.tagView setNeedsDisplay];
}

- (void)setDetailModel:(ACTGoodDetailModel *)detailModel{
    [super setDetailModel:detailModel];

    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    self.nameLabel.text = gModel.commodityName;
    [self.nameLabel setLineSpace:4.f];
    
    self.originalPriceLabel.text = gModel.salePrice ? [NSString stringWithFormat:@"¥%.2f",[gModel.salePrice doubleValue]/100] : @"";
    [self.originalPriceLabel addMiddleLineWithSubString:self.originalPriceLabel.text];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.commodityPrice doubleValue]/100];
    self.couponLabel.text = [NSString stringWithFormat:@" 用优惠券%.2f  ",[detailModel.baseRuleModel.deductionCouponAmount doubleValue]/100];
    NSMutableArray *tags = @[@"超低折扣",@"会员专享"].mutableCopy;
    if (!detailModel.baseRuleModel.postage || [detailModel.baseRuleModel.postage doubleValue] == 0) {
        [tags insertObject:@"全国包邮" atIndex:0];
    }else{
        [tags insertObject:[NSString stringWithFormat:@"邮费 %.2f元",[detailModel.baseRuleModel.postage doubleValue]/100] atIndex:0];
    }
    self.tagView.titles = tags;
    
    [self.priceLabel handleRedPrice:FontSemibold(17.f)];
    
    if(![[XKAccountManager defaultManager] isLogin]) {
        [self.joinVipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        self.joinVipView.hidden = NO;
    }else{
        [self.joinVipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(40);
        }];
        self.joinVipView.hidden = YES;
    }
    
}

- (XKDashLabel *)couponLabel{
    if (!_couponLabel) {
        _couponLabel = [XKDashLabel new];
        _couponLabel.textAlignment = NSTextAlignmentCenter;
        _couponLabel.textColor = COLOR_TEXT_RED;
        _couponLabel.font = Font(10.f);
    }
    return _couponLabel;
}

@end
