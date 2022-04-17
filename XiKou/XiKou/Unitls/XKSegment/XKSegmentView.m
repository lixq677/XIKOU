//
//  XKSegmentView.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSegmentView.h"
#import "UIView+XKFrame.h"
#import "XKUIUnitls.h"

@interface XKSegmentView   ()

@property (nonatomic,strong,readonly)NSMutableArray<UIButton *> *buttons;

@property (nonatomic, assign) CGPoint lastContentViewContentOffset;

@property (nonatomic,strong,readonly)UIView *bottomLine;

@end

@implementation XKSegmentView
@synthesize scrollView = _scrollView;
@synthesize buttons = _buttons;
@synthesize bottomLine = _bottomLine;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _lastContentViewContentOffset = CGPointZero;
        [self.scrollView addSubview:self.bottomLine];
        self.selectTitleFont = FontSemibold(15.f);
        self.titleFont = FontMedium(15.f);
        [self addSubview:self.scrollView];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles{
    if (self = [super init]) {
        [self setTitles:titles];
    }
    return self;
}

- (void)setTitles:(NSArray<NSString *> * _Nonnull)titles{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.buttons removeAllObjects];
    _titles = titles;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:HexRGB(0xcccccc, 1.0f) forState:UIControlStateNormal];
        [button setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(actionForClick:) forControlEvents:UIControlEventTouchUpInside];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:15.0f]];
        [self.scrollView addSubview:button];
        [self.buttons addObject:button];
    }];
    [[self.buttons firstObject] setSelected:YES];
    self.currentIndex = 0;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.buttons.count <= 0) return;
    self.scrollView.frame = self.bounds;
    __block UIButton *selectedBtn = nil;
    CGFloat divide = 0;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    if (self.style == XKSegmentViewStyleDivide) {
        divide = width/(self.buttons.count + 1);
    }else if (self.style == XKSegmentViewStyleJustified){
        if (self.buttons.count == 1) {
            divide = 0;
        }else{
            divide = (width-90.0f)/(self.buttons.count-1);
        }
    }else{
         divide = 0;
    }
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.selectColor) {
            [obj setTitleColor:self.selectColor forState:UIControlStateSelected];
        }
        if (self.tintColor) {
            [obj setTitleColor:self.tintColor forState:UIControlStateNormal];
        }
        if(obj.selected){
            [obj.titleLabel setFont:self.selectTitleFont];
            selectedBtn = obj;
        }else{
            [obj.titleLabel setFont:self.titleFont];
        }
        [obj sizeToFit];
        obj.width+=10.0f;
        if (self.style == XKSegmentViewStyleDivide) {
            CGFloat centerX = (idx+1)*divide;
            obj.centerX = centerX;
        }else if (self.style == XKSegmentViewStyleJustified){
            if (idx == 0) {
                obj.centerX = 45.0f;
            }else{
                obj.centerX = 45.0f+idx*divide;
            }
        }else{
            if (idx == 0) {
                obj.left = 20.0f;
            }else{
                UIButton *btn = [self.buttons objectAtIndex:idx-1];
                obj.left = btn.right + 28.0f;
            }
        }
        obj.centerY = CGRectGetHeight(self.bounds)/2.0f;
    }];
    self.bottomLine.frame = CGRectMake(CGRectGetMinX(selectedBtn.frame), CGRectGetMaxY(self.scrollView.bounds)-2.0f, CGRectGetWidth(selectedBtn.frame), 2.0f);
    UIButton *lastBtn = [self.buttons lastObject];
    self.scrollView.contentSize = CGSizeMake(lastBtn.right+20.0f, 0);
}

- (void)setIndex:(NSUInteger)index{
    if (index >= self.buttons.count)return;
    UIButton *btn = [self.buttons objectAtIndex:index];
    [self actionForClick:btn];
}

- (void)actionForClick:(UIButton *)button{
    _index = [self.buttons indexOfObject:button];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.width = CGRectGetWidth(button.frame);
        self.bottomLine.centerX = CGRectGetMidX(button.frame);
    }];
    if (button.tag == _currentIndex) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(segmentView:selectIndex:)]) {
        [self.delegate segmentView:self selectIndex:button.tag];
    }
    self.currentIndex = [self.buttons indexOfObject:button];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex == currentIndex) return;
    _currentIndex = currentIndex;
    __block UIButton *btn;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (currentIndex == idx) {
            obj.selected = YES;
            btn = obj;
            [obj.titleLabel setFont:self.selectTitleFont];
        }else{
            obj.selected = NO;
            [obj.titleLabel setFont:self.titleFont];
        }
    }];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomLine.width = CGRectGetWidth(btn.frame)-10.0f;
        self.bottomLine.centerX = CGRectGetMidX(btn.frame);
    }];
    if (CGRectGetMinX(btn.frame) < self.scrollView.contentOffset.x ) {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetMinX(btn.frame)-10.0f, 0) animated:YES];
    }else if (CGRectGetMaxX(btn.frame) > self.scrollView.contentOffset.x + CGRectGetWidth(self.frame)){
        [self.scrollView setContentOffset:CGPointMake(CGRectGetMaxX(btn.frame)+10.0f-CGRectGetWidth(self.frame), 0) animated:YES];
    }else{
        NSLog(@"不自动处理");
    }
}

- (void)setContentScrollView:(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = contentScrollView;
        [_contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if ((self.contentScrollView.isTracking || self.contentScrollView.isDecelerating)) {
            //只处理用户滚动的情况
            [self contentOffsetOfContentScrollViewDidChanged:contentOffset];
        }
        self.lastContentViewContentOffset = contentOffset;
    }
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    float ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.titles.count || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    if (contentOffset.x == 0 && self.currentIndex == 0 && self.lastContentViewContentOffset.x == 0) {
        //滚动到了最左边，且已经选中了第一个，且之前的contentOffset.x为0
        return;
    }
    CGFloat maxContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.bounds.size.width;
    if (contentOffset.x == maxContentOffsetX && self.currentIndex == self.titles.count - 1 && self.lastContentViewContentOffset.x == maxContentOffsetX) {
        //滚动到了最右边，且已经选中了最后一个，且之前的contentOffset.x为maxContentOffsetX
        return;
    }
    ratio = MAX(0, MIN(self.titles.count, ratio));
    NSInteger baseIndex = floorf(ratio);
    CGFloat remainderRatio = ratio - baseIndex;
    
    if (remainderRatio == 0) {
        //快速滑动翻页，用户一直在拖拽contentScrollView，需要更新选中状态
        //滑动一小段距离，然后放开回到原位，contentOffset同样的值会回调多次。例如在index为1的情况，滑动放开回到原位，contentOffset会多次回调CGPoint(width, 0)
        if (!(self.lastContentViewContentOffset.x == contentOffset.x && self.currentIndex == baseIndex)) {
            self.currentIndex = baseIndex;
        }
    }else {
        //快速滑动翻页，当remainderRatio没有变成0，但是已经翻页了，需要通过下面的判断，触发选中
        if (fabs(ratio - self.currentIndex) > 1) {
            NSInteger targetIndex = baseIndex;
            if (ratio < self.currentIndex) {
                targetIndex = baseIndex + 1;
            }
            self.currentIndex = baseIndex;
        }
    }
}
- (void)dealloc{
    [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (NSMutableArray<UIButton *> *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = HexRGB(0x444444, 1.0f);
    }
    return _bottomLine;
}

@end
