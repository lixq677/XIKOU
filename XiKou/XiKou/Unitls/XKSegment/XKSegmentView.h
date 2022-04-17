//
//  XKSegmentView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,XKSegmentViewStyle) {
    XKSegmentViewStyleDefault   =     0,
    XKSegmentViewStyleDivide    =     1,
    XKSegmentViewStyleJustified =     2,
};

@class XKSegmentView;
@protocol XKSegmentViewDelegate <NSObject>

- (void)segmentView:(XKSegmentView *)segmentView selectIndex:(NSUInteger)index;

@end

@interface XKSegmentView : UIView

@property (nonatomic,strong)UIColor *selectColor;

@property (nonatomic,strong)UIColor *tintColor;

@property (nonatomic,strong)UIFont *titleFont;

@property (nonatomic,strong)UIFont *selectTitleFont;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,weak)id<XKSegmentViewDelegate> delegate;

@property (nonatomic,assign)NSUInteger index;

@property (nonatomic,assign)XKSegmentViewStyle style;

@property (nonatomic,strong,readonly)UIScrollView *scrollView;

@property (nonatomic,strong,readonly)NSArray<NSString *> *titles;

@property (nonatomic, strong) UIScrollView *contentScrollView;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;

- (void)setTitles:(NSArray<NSString *> * _Nonnull)titles;

@end

NS_ASSUME_NONNULL_END
