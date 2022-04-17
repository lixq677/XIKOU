//
//  XkGoodInfoCustomCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCustomGoodInfoCell.h"

@implementation XKCustomGoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView xk_addSubviews:@[self.tipLabel]];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.originalPriceLabel);
            make.left.equalTo(self.originalPriceLabel.mas_right).offset(21);
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
    
    self.originalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.salePrice doubleValue]/100];
    [self.originalPriceLabel addMiddleLineWithSubString:self.originalPriceLabel.text];
    
    self.priceLabel.text = [NSString stringWithFormat:@"拼团价 ¥%.2f",[gModel.commodityPrice doubleValue]/100];
    [self.priceLabel setAttributedStringWithSubString:@"拼团价" font:Font(12.f)];
    if (detailModel.baseRuleModel.fightGroupType == 1) {
        self.tipLabel.text = [NSString stringWithFormat:@"最低拼团人数%@人",detailModel.baseRuleModel.targetNumber];
    }else{
        self.tipLabel.text = [NSString stringWithFormat:@"最低拼团数量%@件",detailModel.baseRuleModel.targetNumber];
    }
    
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


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = Font(12.f);
        _tipLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _tipLabel;
}

@end
