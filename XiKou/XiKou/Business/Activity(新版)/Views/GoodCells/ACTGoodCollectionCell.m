//
//  ACTGoodCollectionCell.m
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGoodCollectionCell.h"

@implementation ACTGoodCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 7.f;
        
        [self.contentView xk_addSubviews:@[self.coverView,self.nameLabel,self.priceLabel]];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(self.coverView.mas_width);
        }];
        
        self.fontStyle = FontSmall;
    }
    return self;
}

-  (void)setFontStyle:(FontStyle)fontStyle{
    if (_fontStyle == fontStyle) {
        return;
    }
    
    if (fontStyle == FontSmall) {
        self.nameLabel.font = Font(12.f);
        self.priceLabel.font = FontSemibold(14.f);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.coverView.mas_bottom).offset(5);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        }];
    }else{
        self.nameLabel.font = Font(14.f);
        self.priceLabel.font = FontSemibold(17.f);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    _fontStyle = fontStyle;
}

- (void)setModel:(XKGoodListModel *)model{
    _model = model;
}

+ (CGFloat)desHeight{
    return 52;
}

- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [UIImageView new];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = COLOR_TEXT_BLACK;
        _nameLabel.font = Font(12.f);
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = FontSemibold(17.f);
        _priceLabel.textColor = COLOR_TEXT_RED;
    }
    return _priceLabel;
}

@end
