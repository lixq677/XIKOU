//
//  UIView+XKUnitls.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(int, XKShadowMargin) {
    XKShadowMarginNone                 = 0,
    XKShadowMarginLeft                 = 1 << 0,
    XKShadowMarginRight                = 1 << 1,
    XKShadowMarginTop                  = 1 << 2,
    XKShadowMarginBottom               = 1 << 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XKUnitls)

/**
 添加单边阴影

 @param theColor <#theColor description#>
 @param shadowMargin <#shadowMargin description#>
 */
- (void)addShadowWithColor:(UIColor *)theColor margin:(XKShadowMargin)shadowMargin;


/**
 添加四边阴影

 @param theColor <#theColor description#>
 */
- (void)addShadowWithColor:(UIColor *)theColor;

@end

NS_ASSUME_NONNULL_END
