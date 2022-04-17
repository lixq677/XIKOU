//
//  UIView+XKUnitls.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "UIView+XKUnitls.h"

@implementation UIView (XKUnitls)

/// 添加单边阴影效果
- (void)addShadowWithColor:(UIColor *)theColor margin:(XKShadowMargin)shadowMargin{
    self.layer.shadowColor = theColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5;
    // 单边阴影 顶边
    float shadowPathWidth = self.layer.shadowRadius;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (shadowMargin &  XKShadowMarginLeft) {
        CGRect shadowRect = CGRectMake(0-shadowPathWidth/2.0, 0,shadowPathWidth, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        [bezierPath appendPath:path];
    }
    if (shadowMargin & XKShadowMarginTop){
        CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, self.bounds.size.width, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        [bezierPath appendPath:path];
    }
    if (shadowMargin & XKShadowMarginRight){
        CGRect shadowRect = CGRectMake(self.bounds.size.width-shadowPathWidth/2.0, 0,shadowPathWidth, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        [bezierPath appendPath:path];
    }
    if (shadowMargin & XKShadowMarginBottom){
        CGRect shadowRect = CGRectMake(0, self.bounds.size.height-shadowPathWidth/2.0, self.bounds.size.width, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        [bezierPath appendPath:path];
    }
    self.layer.shadowPath = bezierPath.CGPath;
    
}

/// 添加四边阴影效果
- (void)addShadowWithColor:(UIColor *)theColor {
    // 阴影颜色
    self.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    self.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    self.layer.shadowRadius = 5;
    
}

@end
