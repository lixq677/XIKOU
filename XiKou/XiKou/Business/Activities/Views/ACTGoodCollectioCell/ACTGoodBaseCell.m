//
//  ACTGoodBaseCell.m
//  XiKou
//  基cell
//  Created by L.O.U on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "ACTGoodBaseCell.h"

@implementation ACTGoodBaseCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius  = 7.f;
        
        [self.contentView xk_addSubviews:@[self.coverView,self.nameLabel,self.priceLabel]];
        [self.coverView addSubview:self.sellOutLabel];
        
        [self.sellOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60.0f);
            make.center.equalTo(self.coverView);
        }];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(self.coverView.mas_width);
        }];
        [self.nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.equalTo(self.coverView.mas_bottom).offset(10);
        }];
        
        [self.priceLabel setContentHuggingPriority:MASLayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.bottom.equalTo(self.contentView).offset(-15);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)setModel:(XKGoodListModel *)model{
    _model = model;
    if(model.stock == 0){
        self.sellOutLabel.hidden = NO;
    }else{
        self.sellOutLabel.hidden = YES;
    }
}

+ (CGFloat)desheight{
    return 0;
}
- (UIImageView *)coverView{
    if (!_coverView) {
        _coverView = [UIImageView new];
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.0f;
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = Font(12.f);
        _nameLabel.textColor = COLOR_TEXT_BLACK;
        _nameLabel.numberOfLines = 2.f;
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

- (UILabel *)sellOutLabel{
    if (!_sellOutLabel) {
        _sellOutLabel = [UILabel new];
        _sellOutLabel.font = Font(20.f);
        _sellOutLabel.textColor = HexRGB(0xffffff, 1.0f);
        _sellOutLabel.backgroundColor = HexRGB(0x0, 0.3);
        _sellOutLabel.text = @"售罄";
        _sellOutLabel.layer.cornerRadius = 30.0f;
        _sellOutLabel.textAlignment = NSTextAlignmentCenter;
        _sellOutLabel.clipsToBounds = YES;
    }
    return _sellOutLabel;
}


@end
