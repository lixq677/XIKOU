//
//  XKCartButtonsView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKCartButtonsView.h"

@implementation XKCartButtonsView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initialize];
    }
    return self;
}

- (void)initialize{

    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius  = 2.f;
    
    [_payBtn setBackgroundColor:COLOR_TEXT_BLACK];
    [_payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payBtn.titleLabel setFont:FontMedium(15.f)];
    [_payBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = FontSemibold(20.f);
    _priceLabel.textColor = COLOR_TEXT_RED;
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    [self xk_addSubviews:@[_payBtn,_priceLabel]];
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(scalef(110), 42));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.equalTo(self.payBtn);
        make.right.equalTo(self.payBtn.mas_left).offset(-15);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = COLOR_VIEW_SHADOW;
    self.layer.shadowOffset = CGSizeMake(-0.5,-2);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 2.5;
}

- (void)buyClick{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
