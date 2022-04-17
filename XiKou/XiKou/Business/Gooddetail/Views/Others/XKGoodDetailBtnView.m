//
//  XKGoodDetailBtnView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodDetailBtnView.h"
#import "UIButton+Position.h"

@interface XKGoodDetailBtnView ()

@property (nonatomic, strong) UIButton *blackBtn;//黑色按钮

@property (nonatomic, strong) UIButton *brownBtn;//棕色按钮

@property (nonatomic, strong) UIButton *homeBtn;//首页按钮

@property (nonatomic, strong) UIButton *serviceBtn;//客服按钮

@property (nonatomic, strong) UIView *middleLine;//中间线
@end

@implementation XKGoodDetailBtnView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight - 65 - [XKUIUnitls safeBottom], kScreenWidth, 65);
        
        self.backgroundColor     = [UIColor whiteColor];
        self.layer.shadowColor   = COLOR_VIEW_SHADOW;
        self.layer.shadowOffset  = CGSizeMake(-0.5,-2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius  = 2.5;
        
        self.needBrownBtn = NO;
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    self.homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeBtn.tag = ActionHomeBtn;
    [self.homeBtn setTitle:@"首页" forState:UIControlStateNormal];
    [self.homeBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [self.homeBtn setImage:[UIImage imageNamed:@"item_home"] forState:UIControlStateNormal];
    [self.homeBtn.titleLabel setFont:Font(10.f)];
    [self.homeBtn XK_imagePositionStyle:XKImagePositionStyleTop spacing:6];
    
    self.serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.serviceBtn.tag = ActionServiceBtn;
    [self.serviceBtn setTitle:@"客服" forState:UIControlStateNormal];
    [self.serviceBtn setTitleColor:COLOR_TEXT_BLACK forState:UIControlStateNormal];
    [self.serviceBtn setImage:[UIImage imageNamed:@"item_service"] forState:UIControlStateNormal];
    [self.serviceBtn.titleLabel setFont:Font(10.f)];
    [self.serviceBtn XK_imagePositionStyle:XKImagePositionStyleTop spacing:6];
    
    self.middleLine = [[UIView alloc]init];
    self.middleLine.backgroundColor = COLOR_LINE_GRAY;
    
    self.blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.blackBtn.tag = ActionBlackBtn;
    [self.blackBtn setBackgroundColor:COLOR_TEXT_BLACK];
    [self.blackBtn setTitle:@"" forState:UIControlStateNormal];
    [self.blackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.blackBtn.titleLabel setFont:FontMedium(14.f)];
    [self.blackBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x444444, 1.0f)] forState:UIControlStateNormal];
    [self.blackBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0x999999, 1.0f)] forState:UIControlStateDisabled];
    
    self.brownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.brownBtn.tag = ActionBrownBtn;
    self.brownBtn.titleLabel.numberOfLines = 2;
   // [self.brownBtn setBackgroundColor:COLOR_HEX(0xF6EFE0)];
    
    [self.brownBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xF6EFE0, 1.0f)] forState:UIControlStateNormal];
    [self.brownBtn setBackgroundImage:[UIImage imageWithColor:HexRGB(0xcccccc, 0.6f)] forState:UIControlStateDisabled];
    [self.brownBtn setTitle:@"" forState:UIControlStateNormal];
    [self.brownBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateNormal];
    [self.brownBtn.titleLabel setFont:FontMedium(13.f)];
    
    [self.homeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.brownBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.blackBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self xk_addSubviews:@[self.homeBtn,self.serviceBtn,self.blackBtn,self.middleLine,self.brownBtn]];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.homeBtn.frame    = CGRectMake(7, 0, 52, 65);
    self.serviceBtn.frame = CGRectMake(59.5, 0 , 52, 65);
    self.middleLine.frame = CGRectMake(self.homeBtn.right, 18, 0.5, 30);
    
    CGFloat width = self.width - self.serviceBtn.right - 28 - 15;
    if (self.needBrownBtn) {
        self.brownBtn.layer.cornerRadius = 0.f;
        self.blackBtn.layer.cornerRadius = 0.f;
        self.brownBtn.hidden = NO;
        self.brownBtn.frame  = CGRectMake(self.serviceBtn.right + 28, 12, width/2, 42);
        self.blackBtn.frame  = CGRectMake(self.brownBtn.right, 12, width/2, 42);
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.brownBtn.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomLeft) cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = bezierPath.CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        self.brownBtn.layer.mask = layer;
        
        UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:self.blackBtn.bounds byRoundingCorners:(UIRectCornerTopRight|UIRectCornerBottomRight) cornerRadii:CGSizeMake(2, 2)];
        CAShapeLayer *layer2 = [CAShapeLayer layer];
        layer2.path = bezierPath2.CGPath;
        layer2.fillColor = [UIColor whiteColor].CGColor;
        self.blackBtn.layer.mask = layer2;
    }else{
        self.brownBtn.hidden = YES;
        self.blackBtn.frame = CGRectMake(self.serviceBtn.right + 28, 12, width, 42);
        self.blackBtn.layer.masksToBounds = YES;
        self.blackBtn.layer.cornerRadius  = 2.f;
    }
}

- (void)buttonClick:(UIButton *)sender{
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
}

- (void)setNeedBrownBtn:(BOOL)needBrownBtn{
    _needBrownBtn = needBrownBtn;
    [self layoutSubviews];
}

- (void)reloadBlackBtnStatus:(void (^)(UIButton * _Nonnull))block{
    block(self.blackBtn);
}

- (void)reloadBrownBtnTitle:(void (^)(UIButton * _Nonnull))block{
    block(self.brownBtn);
}
@end
