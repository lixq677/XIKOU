//
//  XKGoodInfoCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodInfoCell.h"
#import "XKCustomAlertView.h"

@interface XKGoodInfoCell ()<XKTagsViewDelegate>

@end

@implementation XKGoodInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self defaultInstanceUI];
        self.joinVipView.hidden = YES;
    }
    return self;
}


- (void)setDetailModel:(ACTGoodDetailModel *)detailModel{
    _detailModel = detailModel;
}

#pragma mark action
- (void)joinVipClick{
    [MGJRouter openURL:kRouterLogin];
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.colors = @[(__bridge id)ColorRGBA(223, 198, 123, 0.2).CGColor, (__bridge id)ColorRGBA(187, 148, 69, 0.2).CGColor];
        _gradientLayer.locations = @[@(0), @(1.0f)];
        _gradientLayer.cornerRadius = 2.f;
    }
    return _gradientLayer;
}

#pragma mark -------- 布局
#pragma mark 默认
- (void)defaultInstanceUI{
    
    [self.contentView xk_addSubviews:@[self.nameLabel,self.priceLabel,self.originalPriceLabel,self.tagView,self.joinVipView]];
    [self.nameLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
    }];
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(5);
        make.height.mas_equalTo(12);
        make.bottom.equalTo(self.priceLabel).offset(-1);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(15);
    }];
    [self.joinVipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void)clickTagView:(XKTagsView *)tagsView atIndex:(NSUInteger)index{
    NSString *text = [tagsView.titles objectAtIndex:index];
    if ([text isEqualToString:@"全国包邮"]) {
        XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"包邮范围" andContent:@"除以下地区，全国范围内包邮。新疆、西藏、海南、宁夏、青海、内蒙古以及港澳台、海外暂不支持发货，如果有需要，请联系客服。" andBtnTitle:@"知道了"];
        alertView.btnStyle = AlertBtnStyle1;
        [alertView show];
    }
}

#pragma mark -------------
#pragma mark lazy
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = FontMedium(16.f);
        _nameLabel.textColor = COLOR_TEXT_BLACK;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = FontSemibold(20);
        _priceLabel.textColor = COLOR_TEXT_RED;
    }
    return _priceLabel;
}

- (UILabel *)originalPriceLabel{
    if (!_originalPriceLabel) {
        _originalPriceLabel = [UILabel new];
        _originalPriceLabel.font = Font(12.f);
        _originalPriceLabel.textColor = COLOR_PRICE_GRAY;
    }
    return _originalPriceLabel;
}


- (XKTagsView *)tagView{
    if (!_tagView) {
        _tagView = [[XKTagsView alloc] init];
        _tagView.delegate = self;
    }
    return _tagView;
}

- (UIView *)joinVipView{
    if (!_joinVipView) {
        _joinVipView = [UIView new];
        _joinVipView.userInteractionEnabled = YES;
        [_joinVipView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(joinVipClick)]];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"crown"]];
        UIImageView *indicateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowYellow"]];
        UILabel *leftLabel = [UILabel new];
        leftLabel.textColor = COLOR_TEXT_BROWN;
        leftLabel.font  = FontMedium(14.f);
        leftLabel.text  = @"加入喜扣会员";
        UILabel *rightLabel = [UILabel new];
        rightLabel.textColor = COLOR_TEXT_BROWN;
        rightLabel.font  = Font(12.f);
        rightLabel.text  = @"立即开通";
        rightLabel.textAlignment = NSTextAlignmentRight;
        [_joinVipView xk_addSubviews:@[imgView,indicateView,leftLabel,rightLabel]];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(17, 18));
            make.left.mas_equalTo(20);
            make.centerY.equalTo(self.joinVipView);
        }];
        [indicateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6, 10));
            make.centerY.equalTo(self.joinVipView);
            make.right.mas_equalTo(-15);
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.joinVipView);
            make.right.equalTo(indicateView.mas_left).offset(-5);
        }];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(7);
            make.right.equalTo(rightLabel.mas_left).offset(-10);
            make.centerY.equalTo(self.joinVipView);
        }];
    }
    return _joinVipView;
}

@end


