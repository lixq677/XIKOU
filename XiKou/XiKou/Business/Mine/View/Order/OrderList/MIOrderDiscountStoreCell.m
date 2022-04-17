//
//  MIOrderMutilStoreCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderDiscountStoreCell.h"
#import "MIOrderGoodCell.h"
#import "MIOrderHeadView.h"
#import "XKUIUnitls.h"

@implementation MIOrderDiscountStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        UIView *line = [UIView new];
        line.backgroundColor = COLOR_LINE_GRAY;
        [self.bgView xk_addSubviews:@[self.titleLabel,self.subLabel,self.coverView,self.nameLabel,self.numLabel,self.desLabel,self.priceLabel,line]];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50.0f);
            make.height.mas_equalTo(0.5/[UIScreen mainScreen].scale);
            make.left.equalTo(self.bgView).offset(15);
            make.right.equalTo(self.bgView).offset(-15);
        }];
        
       
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(line.mas_top);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.bottom.equalTo(self.subLabel);
            make.right.equalTo(self.subLabel.mas_left).offset(-15);
        }];
        
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(70);
            make.left.equalTo(line);
            make.top.equalTo(line.mas_bottom).offset(15);
        }];
        [self.priceLabel setPreferredMaxLayoutWidth:150];
        [self.priceLabel setContentCompressionResistancePriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(line);
            make.top.equalTo(self.coverView);
            make.height.mas_equalTo(15);
        }];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.priceLabel);
            make.top.equalTo(self.priceLabel.mas_bottom).offset(6);
        }];
        [self.nameLabel setContentCompressionResistancePriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel);
            make.left.equalTo(self.coverView.mas_right).offset(10);
            make.right.equalTo(self.priceLabel.mas_left).offset(-15);
            make.height.mas_greaterThanOrEqualTo(15);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.right.equalTo(self.priceLabel);
        }];
    }
    return self;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.needCorner) {
        [self.bgView layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _bgView.bounds;
        maskLayer.path = maskPath.CGPath;
        _bgView.layer.mask = maskLayer;
    }else{
        _bgView.layer.mask = nil;
    }
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = FontMedium(14.f);
    }
    return _titleLabel;
}

- (UILabel *)subLabel{
    if (!_subLabel) {
        _subLabel = [UILabel new];
        _subLabel.backgroundColor = [UIColor whiteColor];
        _subLabel.font = Font(12.f);
        _subLabel.textColor = COLOR_TEXT_RED;
        _subLabel.textAlignment = NSTextAlignmentRight;
    }
    return _subLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = Font(12.f);
        _nameLabel.textColor = COLOR_TEXT_BLACK;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = FontMedium(12.f);
        _priceLabel.textColor = COLOR_TEXT_BLACK;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = Font(10.f);
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _desLabel;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = Font(10.f);
        _numLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _numLabel;
}

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [UIImageView new];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.f;
    }
    return _coverView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}


@end





