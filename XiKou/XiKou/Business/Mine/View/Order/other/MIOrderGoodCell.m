//
//  MIOrderGoodCell.m
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOrderGoodCell.h"
#import "XKUIUnitls.h"

@implementation MIOrderGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = COLOR_LINE_GRAY;
        
        [self.bgView xk_addSubviews:@[self.coverView,self.nameLabel,self.numLabel,self.desLabel,self.priceLabel,line]];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView);
            make.height.mas_equalTo(0.5/[UIScreen mainScreen].scale);
            make.left.equalTo(self.bgView).offset(15);
            make.right.equalTo(self.bgView).offset(-15);
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

@implementation MIOrderDetailGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
        }];
    }
    return self;
}
@end


@implementation MIOrderPayAnotherGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.priceLabel.textColor = COLOR_TEXT_RED;
        self.numLabel.textColor = COLOR_TEXT_BLACK;
        [self.bgView xk_addSubviews:@[self.postageLabel,self.amountLabel]];
        [self.postageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.numLabel);
            make.bottom.equalTo(self.coverView);
        }];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self.postageLabel);
            make.right.equalTo(self.postageLabel.mas_left).offset(-10);
        }];
    }
    return self;
}

- (UILabel *)postageLabel{
    if (!_postageLabel) {
        _postageLabel = [UILabel new];
        _postageLabel.textColor = COLOR_TEXT_BLACK;
        _postageLabel.font = Font(12.f);
    }
    return _postageLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.font = Font(12.f);
        _amountLabel.textColor = COLOR_TEXT_BLACK;
    }
    return _amountLabel;
}
@end
