//
//  XKPageControl.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPageControl.h"

@interface XKPageControl ()

@property (nonatomic,strong,readonly)NSMutableArray<UIView *> *pages;

@end

@implementation XKPageControl
@synthesize pages = _pages;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = 5.0f;
    CGFloat width = 10.0f;
    CGFloat height = 2.0f;
    CGFloat x = 0.0f;
    CGFloat totalW = self.numberOfPages*(width+space);
    if (totalW < self.width) {
        x = 0.5f*(self.width - totalW);
    }
    [self.pages enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(x + idx*(width+space),0.5f*(CGRectGetHeight(self.bounds)-height), width, height);
        if (idx == self.currentPage) {
            obj.backgroundColor = self.currentPageIndicatorTintColor;
        }else{
            obj.backgroundColor = self.pageIndicatorTintColor;
        }
        obj.hidden = NO;
    }];
    if (self.hidesForSinglePage && self.numberOfPages <= 1) {
        [self.pages enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
    }
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount{
    CGFloat space = 5.0f;
    CGFloat width = 10.0f;
    CGFloat height = 2.0f;
    CGSize size = CGSizeMake(pageCount*(space+width), height);
    return size;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages{
    _numberOfPages = numberOfPages;
    [self.pages enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.pages removeAllObjects];
    for (int i = 0; i < self.numberOfPages; i++) {
        UIView *view = [UIView new];
        view.tag = i+ 2000;
        view.layer.cornerRadius = 1.0f;
        [self addSubview:view];
        [self.pages addObject:view];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    UIView *view1 = [self viewWithTag:2000+self.currentPage];
    view1.backgroundColor = self.pageIndicatorTintColor;
    UIView *view2 = [self viewWithTag:2000+currentPage];
    view2.backgroundColor = self.currentPageIndicatorTintColor;
    _currentPage = currentPage;
}


- (NSMutableArray<UIView *> *)pages{
    if (!_pages) {
        _pages = [NSMutableArray array];
    }
    return _pages;
}
@end
