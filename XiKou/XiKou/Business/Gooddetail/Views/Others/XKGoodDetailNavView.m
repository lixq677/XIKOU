//
//  XKGoodDetailNavView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodDetailNavView.h"
#import "NSString+Common.h"

@implementation XKGoodDetailNavView
{
    UILabel *_cartNumLabel;
}
- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarHeight + kStatusBarHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self xk_addSubviews:@[self.backBtn,self.titlelabel,self.carBtn,self.shareBtn]];
        
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(31, 31));
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-7);
        }];
        [_carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.bottom.equalTo(self.shareBtn);
            make.right.equalTo(self.shareBtn.mas_left).offset(-10);
        }];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.bottom.equalTo(self.shareBtn);
            make.left.equalTo(self).offset(10);
        }];
        [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backBtn.mas_right).offset(15);
            make.right.equalTo(self.carBtn.mas_left);
            make.top.bottom.equalTo(self.backBtn);
        }];
        
        _shareBtn.layer.masksToBounds = YES;
        _shareBtn.layer.cornerRadius  = 31/2.f;
        
        _carBtn.layer.masksToBounds = YES;
        _carBtn.layer.cornerRadius  = 31/2.f;
        
        _backBtn.layer.masksToBounds = YES;
        _backBtn.layer.cornerRadius  = 31/2.f;
    }
    return self;
}

- (void)cartAction{
    if (_actionBlock) {
        _actionBlock(ActionCart);
    }
}

- (void)backAction{
    if (_actionBlock) {
        _actionBlock(ActionBack);
    }
}

- (void)shareAction{
    if (_actionBlock) {
        _actionBlock(ActionShare);
    }
}
- (void)setCurrentAlpha:(CGFloat)currentAlpha{
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:currentAlpha];
    if (currentAlpha < 0.5) {
        [self reloadTintColor:[UIColor colorWithWhite:1 alpha:1-currentAlpha]];
        [self reloadBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5-currentAlpha]];
    }else{
        if (currentAlpha > 0.99) {
            currentAlpha = 1;
        }
        [self reloadTintColor:[UIColor colorWithWhite:0 alpha:currentAlpha]];
        [self reloadBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setCartNum:(NSInteger)cartNum{
    if (cartNum == 0 && _cartNumLabel) {
        _cartNumLabel.hidden = YES;
    }
    if (cartNum > 0) {
        _cartNumLabel.hidden = NO;
        if (!_cartNumLabel) {
            _cartNumLabel = [UILabel new];
            _cartNumLabel.font = Font(12.f);
            _cartNumLabel.backgroundColor = COLOR_TEXT_RED;
            _cartNumLabel.textColor = [UIColor whiteColor];
            _cartNumLabel.textAlignment = NSTextAlignmentCenter;
            _cartNumLabel.layer.masksToBounds = YES;
            _cartNumLabel.layer.cornerRadius  = 16.5/2.f;
            [self addSubview:_cartNumLabel];
        }
        NSString *num = [NSString stringWithFormat:@"%ld",cartNum];
        CGFloat width = [num sizeWithFont:_cartNumLabel.font].width + 4;
        if (width < 16.5) {
            width = 16.5;
        }
        _cartNumLabel.text = num;
        _cartNumLabel.frame = CGRectMake(self.carBtn.x + 18, self.carBtn.y, width, 16.5);
    }
}

- (void)reloadTintColor:(UIColor *)color{
    self.titlelabel.textColor = color;
    self.backBtn.tintColor = color;
    self.carBtn.tintColor = color;
    self.shareBtn.tintColor = color;
}

- (void)reloadBackgroundColor:(UIColor *)color{
    [_shareBtn setBackgroundColor:color];
    [_carBtn setBackgroundColor:color];
    [_backBtn setBackgroundColor:color];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titlelabel.text = _title;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel new];
        _titlelabel.font = FontMedium(17.f);
        _titlelabel.textColor = COLOR_TEXT_BLACK;
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_backBtn setImage:[[UIImage imageNamed:@"Return"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -1.5, 0, 1.5)];
        [_backBtn setContentMode:UIViewContentModeCenter];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)carBtn{
    if (!_carBtn) {
        _carBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carBtn setImage:[[UIImage imageNamed:@"carBlack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_carBtn addTarget:self action:@selector(cartAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _carBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[[UIImage imageNamed:@"hm_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
@end
