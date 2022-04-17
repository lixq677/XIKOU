//
//  NBShopDetailHeaderView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBShopDetailSectionHeaderView.h"
#import "UIButton+Position.h"

@implementation NBShopDetailSectionHeaderView
@synthesize concern = _concern;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel = [UILabel new];
        _titleLabel.font = FontMedium(16.f);
        _titleLabel.textColor = COLOR_TEXT_BLACK;
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.borderColor = COLOR_TEXT_BROWN.CGColor;
        _button.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
        _button.layer.cornerRadius = 29/2.f;
        _button.titleLabel.font    = FontMedium(12.f);
        
        [_button setImage:[UIImage imageNamed:@"atention"] forState:UIControlStateNormal];
        [_button setTitle:@"关注" forState:UIControlStateNormal];
        [_button setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
        [_button XK_imagePositionStyle:XKImagePositionStyleLeft spacing:5];
        [_button addTarget:self action:@selector(attentionClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self xk_addSubviews:@[self.titleLabel,self.button]];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 29));
            make.bottom.equalTo(self.contentView).offset(-11);
            make.right.mas_equalTo(-20);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.bottom.mas_equalTo(-15);
            make.right.equalTo(self.button.mas_left);
        }];
    }
    return self;
}

- (void)setConcern:(BOOL)concern{
    _concern = concern;
    if (self.concern) {
        [self setupUnconcern];
    }else{
        [self setupConcern];
    }
}

- (void)attentionClick{
    if (self.block) {
        self.block();
    }
}

- (void)setupConcern{
    [self.button setTitle:@"关注" forState:UIControlStateNormal];
    [self.button setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"atention"] forState:UIControlStateNormal];
    [self.button XK_imagePositionStyle:XKImagePositionStyleLeft spacing:5];
}

- (void)setupUnconcern{
    [self.button setTitle:@"取消关注" forState:UIControlStateNormal];
    [self.button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.button setImage:nil forState:UIControlStateNormal];
    [self.button XK_imagePositionStyle:XKImagePositionStyleLeft spacing:0];
}


@end
