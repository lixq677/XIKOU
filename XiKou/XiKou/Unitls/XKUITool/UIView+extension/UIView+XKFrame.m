//
//  UIView+EKFrame.m
//  CallWatch
//
//  Created by kingo on 9/21/15.
//  Copyright © 2015 shenqi329. All rights reserved.
//

#import "UIView+XKFrame.h"

@implementation UIView (XKFrame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size
{
    return self.frame.size;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)middleX
{
    return (CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame))/2.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setMiddleX:(CGFloat)middleX
{
    self.width = middleX*2;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)middleY
{
    return (CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame))/2.0f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setMiddleY:(CGFloat)middleY
{
    self.height = middleY*2;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)middle
{
    return CGPointMake(self.middleX, self.middleY);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setMiddle:(CGPoint)middle
{
    self.size = CGSizeMake(self.middleX * 2, self.middleY * 2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGRect)safeBounds{
    if(@available(iOS 11.0,*)){
        CGRect rc = self.bounds;
        
        return CGRectMake(rc.origin.x+self.safeAreaInsets.left, rc.origin.y+self.safeAreaInsets.top, rc.size.width-self.safeAreaInsets.left-self.safeAreaInsets.right, rc.size.height-self.safeAreaInsets.top-self.safeAreaInsets.bottom);
    }else{
        return self.bounds;
    }
}

- (void)xk_addSubviews:(NSArray *)subViews{
    for (UIView *subView in subViews) {
        [self addSubview:subView];
    }
}

+ (void)Calculate_cicularPoint1:(CGPoint)px1 poin2:(CGPoint)px2 poin3:(CGPoint)px3 complete:(void(^)(CGPoint center,CGFloat r))completHandle
{
    int x1, y1, x2, y2, x3, y3;
    int a, b, c, g, e, f;
    
    x1 = px1.x;
    y1 = px1.y;
    x2 = px2.x;
    y2 = px2.y;
    x3 = px3.x;
    y3 = px3.y;
    
    e = 2 * (x2 - x1);
    f = 2 * (y2 - y1);
    g = x2*x2 - x1*x1 + y2*y2 - y1*y1;
    a = 2 * (x3 - x2);
    b = 2 * (y3 - y2);
    c = x3*x3 - x2*x2 + y3*y3 - y2*y2;
    
    CGFloat X= (g*b - c*f) / (e*b - a*f);
    CGFloat Y = (a*g - c*e) / (a*f - b*e);
    CGFloat R = sqrt((X-x1)*(X-x1)+(Y-y1)*(Y-y1));
    
    completHandle(CGPointMake(X, Y),R);
}
@end
