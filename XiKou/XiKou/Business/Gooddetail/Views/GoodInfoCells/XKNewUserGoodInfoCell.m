//
//  XKNewUserGoodInfoCell.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKNewUserGoodInfoCell.h"
#import "BCTools.h"

@implementation XKNewUserGoodInfoCell

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
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:PriceDef(gModel.commodityPrice.doubleValue/100.00f)];
    [attr appendAttributedString:[[NSAttributedString alloc]initWithString:@"  "]];
    [attr appendAttributedString:PriceDef_line(gModel.salePrice.doubleValue/100.00f)];
    self.priceLabel.attributedText = attr;
    //self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.salePrice doubleValue]/100];
    
    NSMutableArray *tags = @[@"超低折扣",@"新人专享"].mutableCopy;
    if (!detailModel.baseRuleModel.postage || [detailModel.baseRuleModel.postage doubleValue] == 0) {
        [tags insertObject:@"全国包邮" atIndex:0];
    }else{
        [tags insertObject:[NSString stringWithFormat:@"邮费 %.2f元",[detailModel.baseRuleModel.postage doubleValue]/100] atIndex:0];
    }
    self.tagView.titles = tags;
    
    //[self.priceLabel handleRedPrice:FontSemibold(17.f)];
    
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

@end

