//
//  ACTGoodBaseTableCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGoodBaseTableCell.h"

@implementation ACTGoodBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius  = 7.f;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.bottom.mas_equalTo(-10);
            make.top.equalTo(self);
        }];
        [self.contentView xk_addSubviews:@[self.coverView,self.titleLabel,self.subTextLabel,
                                           self.priceLabel,self.originLabel]];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            make.width.height.mas_equalTo(110);
            make.bottom.mas_equalTo(-15);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverView.mas_right).offset(10);
            make.right.mas_equalTo(-15);
            make.top.equalTo(self.coverView);
        }];
        [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.coverView).offset(-2);
            make.height.mas_equalTo(15);
        }];
        [self.originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.priceLabel);
            make.left.equalTo(self.priceLabel.mas_right).offset(5);
        }];
    }
    return self;
}

- (void)setModel:(XKGoodListModel *)model{
    _model = model;
}

#pragma mark getter or setter
- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.0f;
    }
    return _coverView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_TEXT_BLACK;
        _titleLabel.font = Font(12.f);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = COLOR_TEXT_RED;
        _priceLabel.font = FontSemibold(17.f);
    }
    return _priceLabel;
}

- (UILabel *)originLabel{
    if (!_originLabel) {
        _originLabel = [[UILabel alloc] init];
        _originLabel.textColor = COLOR_PRICE_GRAY;
        _originLabel.font = Font(10.f);
    }
    return _originLabel;
}

- (UILabel *)subTextLabel{
    if (!_subTextLabel) {
        _subTextLabel = [UILabel new];
        _subTextLabel.font = Font(12.f);
        _subTextLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _subTextLabel;
}

@end
