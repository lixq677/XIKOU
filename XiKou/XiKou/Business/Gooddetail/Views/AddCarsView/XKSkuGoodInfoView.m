//
//  XKAddCarGoodInfoView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSkuGoodInfoView.h"

@implementation XKSkuGoodInfoView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _coverView = [UIImageView new];
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius  = 2.f;
        
        _titleLabel = [UILabel new];
        _titleLabel.font = Font(14.f);
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = COLOR_TEXT_BLACK;
        
        _priceLabel = [UILabel new];
        _priceLabel.font = FontSemibold(17.f);
        _priceLabel.textColor = COLOR_TEXT_RED;
        
        _desLabel = [UILabel new];
        _desLabel.font = Font(12.f);
        _desLabel.textColor = COLOR_TEXT_GRAY;
        
        _stockLabel = [UILabel new];
        _stockLabel.font = Font(12.f);
        _stockLabel.textColor = COLOR_TEXT_GRAY;
        
        [self xk_addSubviews:@[self.coverView,self.titleLabel,self.desLabel,self.stockLabel,self.priceLabel]];
        
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).offset(15);
            make.width.height.mas_equalTo(scalef(110));
            make.bottom.equalTo(self).offset(-30);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.coverView);
            make.left.equalTo(self.coverView.mas_right).offset(10);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        
        [self.stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.desLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(15);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.coverView).offset(-5);
            make.height.mas_equalTo(15);
            make.left.equalTo(self.titleLabel);
        }];
        
    }
    return self;
}

@end
