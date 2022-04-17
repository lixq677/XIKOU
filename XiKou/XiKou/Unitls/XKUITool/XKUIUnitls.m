//
//  XKUIUnitls.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKUIUnitls.h"

@implementation XKUIUnitls

+ (CGFloat)safeBottom{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if(@available(iOS 11.0,*)){
        insets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    }
    return insets.bottom;
}

+ (CGFloat)safeTop{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if(@available(iOS 11.0,*)){
        insets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    }
    if (insets.top == 0) {
        insets.top = 20.0f;
    }
    return insets.top;
}

@end
