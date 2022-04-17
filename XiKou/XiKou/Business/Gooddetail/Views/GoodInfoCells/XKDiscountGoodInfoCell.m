//
//  XKDiscountGoodInfoCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDiscountGoodInfoCell.h"
#import "CGGoodsView.h"

@interface XKDiscountGoodInfoCell ()

@property (nonatomic, strong) CMGradientView *gradientView; 

@end

@implementation XKDiscountGoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.gradientView];
        [self.contentView addSubview:self.discountLabel];
        
        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.originalPriceLabel.mas_right).offset(10);
            make.height.mas_equalTo(14.0f);
            make.centerY.equalTo(self.originalPriceLabel);
        }];
        [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.discountLabel);
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
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.commodityPriceOne doubleValue]/100];
    self.discountLabel.text = [NSString stringWithFormat:@" 分享赚%.2f ",[gModel.shareAmount doubleValue]/100];
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

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [UILabel new];
        _discountLabel.font = Font(9.f);
       // _saleNumLabel.backgroundColor = COLOR_HEX(0xFFF0ED);
        _discountLabel.textColor = [UIColor whiteColor];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.layer.masksToBounds = YES;
        _discountLabel.layer.cornerRadius = 2;
    }
    return _discountLabel;
}


@end
