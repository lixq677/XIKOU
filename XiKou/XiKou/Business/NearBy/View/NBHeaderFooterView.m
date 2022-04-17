//
//  NBHeaderFooterView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBHeaderFooterView.h"
#import "XKUIUnitls.h"
#import "UIButton+Position.h"

@implementation NBHeaderFooterView
@synthesize distanceSortBtn = _distanceSortBtn;
@synthesize discountSortBtn = _discountSortBtn;
@synthesize popularitySortBtn = _popularitySortBtn;


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
//    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
//        [self setupUI];
//    }
//    return self;
//}

- (void)setupUI{
    [self.distanceSortBtn setTitle:@"由近到远" forState:UIControlStateNormal];
    [self.distanceSortBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    
    [self.discountSortBtn setTitle:@"折扣最优" forState:UIControlStateNormal];
    [self.discountSortBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.discountSortBtn setImage:[UIImage imageNamed:@"arrow_dw"] forState:UIControlStateNormal];
    [self.discountSortBtn setImage:[UIImage imageNamed:@"arrow_pu"] forState:UIControlStateSelected];
    
    [self.popularitySortBtn setTitle:@"人气最旺" forState:UIControlStateNormal];
    [self.popularitySortBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.popularitySortBtn setImage:[UIImage imageNamed:@"arrow_dw"] forState:UIControlStateNormal];
    [self.popularitySortBtn setImage:[UIImage imageNamed:@"arrow_pu"] forState:UIControlStateSelected];
    
    [self addSubview:self.distanceSortBtn];
    [self addSubview:self.discountSortBtn];
    [self addSubview:self.popularitySortBtn];
    
    [self.discountSortBtn addTarget:self action:@selector(discountAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.popularitySortBtn addTarget:self action:@selector(popularityAction:) forControlEvents:UIControlEventTouchUpInside];
    //[self.distanceSortBtn addTarget:self action:@selector(distanceAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = kScreenWidth - 30.0f;
    self.distanceSortBtn.frame = CGRectMake(width/4.0-50.0f, CGRectGetMidY(self.bounds)-6.0f, 60.0f, 12.0f);
    self.discountSortBtn.frame = CGRectMake(width/2.0-30.0f, CGRectGetMidY(self.bounds)-6.0f, 60.0f, 12.0f);
    self.popularitySortBtn.frame = CGRectMake(width*3.0f/4.0-10.0f, CGRectGetMidY(self.bounds)-6.0f, 60.0f, 12.0f);
    [self.discountSortBtn XK_imagePositionStyle:XKImagePositionStyleRight spacing:7];
    [self.popularitySortBtn XK_imagePositionStyle:XKImagePositionStyleRight spacing:7];
}

- (void)discountAction:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        if ([self.delegate respondsToSelector:@selector(headerFooterView:shopRate:)]) {
            [self.delegate headerFooterView:self shopRate:XKShopRateDescend];
        }
    }else{
        btn.selected = YES;
        if ([self.delegate respondsToSelector:@selector(headerFooterView:shopRate:)]) {
            [self.delegate headerFooterView:self shopRate:XKShopRateAscend];
        }
    }
}

- (void)popularityAction:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        if ([self.delegate respondsToSelector:@selector(headerFooterView:shopPop:)]) {
            [self.delegate headerFooterView:self shopPop:XKShopPopDescend];
        }
    }else{
        btn.selected = YES;
        if ([self.delegate respondsToSelector:@selector(headerFooterView:shopPop:)]) {
            [self.delegate headerFooterView:self shopPop:XKShopPopAscend];
        }
    }
}


//- (void)distanceAction:(UIButton *)btn{
//
//}






#pragma mark getter or setter
- (UIButton *)discountSortBtn{
    if (!_discountSortBtn) {
        _discountSortBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _discountSortBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _discountSortBtn;
}

- (UIButton *)distanceSortBtn{
    if (!_distanceSortBtn) {
        _distanceSortBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _distanceSortBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _distanceSortBtn;
}

- (UIButton *)popularitySortBtn{
    if (!_popularitySortBtn) {
        _popularitySortBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _popularitySortBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _popularitySortBtn;
}

@end
