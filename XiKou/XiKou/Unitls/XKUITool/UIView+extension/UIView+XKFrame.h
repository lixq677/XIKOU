//
//  UIView+EKFrame.h
//  CallWatch
//
//  Copyright © 2015 shenqi329. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XKFrame)

@property (nonatomic, assign) CGFloat left;     // x轴最小值（原点）

@property (nonatomic, assign) CGFloat x;        // x轴最小值（原点）

@property (nonatomic, assign) CGFloat top;      // y轴最小值（原点）

@property (nonatomic, assign) CGFloat y;        // y轴最小值（原点）

@property (nonatomic, assign) CGFloat right;    // x轴最大值

@property (nonatomic, assign) CGFloat bottom;   // y轴最大值

@property (nonatomic, assign) CGFloat width;    // 宽

@property (nonatomic, assign) CGFloat height;   // 高

@property (nonatomic, assign) CGSize size;      // 宽高size

@property (nonatomic, assign) CGPoint origin;   

@property (nonatomic, assign) CGFloat centerX;  // x中心点(相对父视图的坐标)

@property (nonatomic, assign) CGFloat centerY;  // y中心点(相对父视图的坐标)

@property (nonatomic, assign) CGFloat middleX;  // x中心点(相对于自己的坐标)

@property (nonatomic, assign) CGFloat middleY;  // y中心点(相对于自己的坐标)

@property (nonatomic, assign) CGPoint middle;   // 中心点(相对于自己的坐标)

- (CGRect)safeBounds;

- (void)xk_addSubviews:(NSArray *)subViews;

/**
 *  三个点球圆心和半径
 */
+ (void)Calculate_cicularPoint1:(CGPoint)px1
                          poin2:(CGPoint)px2
                          poin3:(CGPoint)px3
                       complete:(void(^)(CGPoint center,CGFloat r))completHandle;
@end
