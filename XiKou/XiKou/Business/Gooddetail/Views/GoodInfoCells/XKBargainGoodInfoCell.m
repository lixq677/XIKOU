//
//  XKGoodInfoBargainCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBargainGoodInfoCell.h"
#import "CGGoodsView.h"
#import "XKCustomAlertView.h"

@implementation XKBargainGoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView xk_addSubviews:@[self.discountLabel,self.tipLabel,self.ruleBtn,self.bargainLabel]];
        [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(18);
        }];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.discountLabel.mas_bottom).offset(11);
            make.left.equalTo(self.nameLabel);
            make.height.mas_equalTo(15);
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.originalPriceLabel);
            make.left.equalTo(self.originalPriceLabel.mas_right).offset(21);
        }];
        
        [self.ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(57.0f);
            make.height.mas_equalTo(18.0f);
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(self.discountLabel);
        }];
        
        [self.bargainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(15);
            make.centerY.equalTo(self.priceLabel);
        }];
        @weakify(self);
        [[self.ruleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            XKGoodSKUModel *skuModel = [[self.detailModel.activityCommodityAndSkuModel skuList] firstObject];
            NSString *string = [NSString stringWithFormat:@"砍立得是公司扶持板块，发起商品砍价活动，邀请好友助力，达到助力人数%d人（含发起人），在%@小时内砍到底价，即可购买获取底价商品。\n1.  发起人成功购买后，助力好友可得一个随机现金红包；\n2. 助力好友需注册喜扣商城会员，非喜扣会员无法领取砍价红包；\n3. 现金红包直接划入用户钱包，可在平台直接抵扣购买商品金额或者提现。",(int)self.detailModel.baseRuleModel.bargainNumber,skuModel.bargainEffectiveTimed];
            XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType: CanleAndTitle andTitle:@"砍立得活动介绍" andContent:string andBtnTitle:@"知道了"];
            alert.contentLabel.textAlignment = NSTextAlignmentLeft;
            [alert show];
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
    
    CGFloat salePrice    = [gModel.salePrice   doubleValue]/100;
    CGFloat commityprice = [gModel.commodityPrice doubleValue]/100;
    
    self.originalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",salePrice];
    [self.originalPriceLabel addMiddleLineWithSubString:self.originalPriceLabel.text];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",commityprice];
    self.discountLabel.text = [NSString stringWithFormat:@" %ld人可砍金额: ¥%.2f ",(long)detailModel.baseRuleModel.bargainNumber,[gModel.cutPrice doubleValue]/100];
//    if (gModel.bargainStatus == BargainIng) {
//
//        self.tipLabel.text = [NSString stringWithFormat:@" 当前砍价%ld人，已砍至¥%.2f ",(long)gModel.bargainCount,[gModel.currentPrice floatValue]/100];
//    }
    
    self.bargainLabel.text = [NSString stringWithFormat:@"%ld人砍价成功",(long)gModel.bargainSuccessCount];
    
    NSMutableArray *tags = @[@"超低折扣"].mutableCopy;
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

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [UILabel new];
        _discountLabel.font = Font(10.f);
        _discountLabel.textColor = COLOR_TEXT_RED;
        _discountLabel.layer.cornerRadius = 1.f;
        _discountLabel.layer.borderColor  = COLOR_TEXT_RED.CGColor;
        _discountLabel.layer.borderWidth  = 0.5;
    }
    return _discountLabel;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = Font(12.f);
        _tipLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _tipLabel;
}

- (UIButton *)ruleBtn{
    if (!_ruleBtn) {
        _ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ruleBtn setTitle:@"砍价规则" forState:UIControlStateNormal];
        [_ruleBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        _ruleBtn.layer.cornerRadius = 1;
        _ruleBtn.layer.borderWidth = 1;
        _ruleBtn.layer.borderColor = [HexRGB(0x999999, 1.0f) CGColor];
        _ruleBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _ruleBtn;
}

- (UILabel *)bargainLabel{
    if (!_bargainLabel) {
        _bargainLabel = [UILabel new];
        _bargainLabel.font = Font(11.f);
        _bargainLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _bargainLabel;
}

@end

@interface XKBargainUserInfoCell ()

@property (nonatomic,strong)CMGradientView *gradientView;

@end

@implementation XKBargainUserInfoCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize button = _button;
@synthesize gradientView = _gradientView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.gradientView];
        [self addSubview:self.imageView];
        [self addSubview:self.textLabel];
        [self addSubview:self.detailTextLabel];
        [self addSubview:self.button];
        [self layout];
        
    }
    return self;
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_offset(20.0f);
        make.size.mas_equalTo(CGSizeMake(36.0f, 36.0f));
        make.top.mas_equalTo(12);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10);
        make.centerY.equalTo(self.imageView);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.0f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.button.mas_left).offset(-15);
        make.centerY.equalTo(self.imageView);
        make.left.mas_equalTo(self.textLabel.mas_right).offset(20);
    }];
    
    [self.detailTextLabel setContentCompressionResistancePriority: UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.button);
    }];

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

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 18.0f;
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _detailTextLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"继续砍价" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _button;
}

@end



