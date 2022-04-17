//
//  XKAlertAction.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKAlertAction.h"
#import "XKUIUnitls.h"

@implementation XKAlertAction
@dynamic titleColor;

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;{
    XKAlertAction *action = [super actionWithTitle:title style:style handler:handler];
    if (style == UIAlertActionStyleCancel) {
        [action setTitleColor:COLOR_TEXT_BROWN];
    }else if (style == UIAlertActionStyleDefault){
        [action setTitleColor:HexRGB(0x444444, 1.0f)];
    }else{
        //默认
    }
    return action;
}


- (void)setTitleColor:(UIColor *)titleColor{
    [super setValue:titleColor forKey:@"titleTextColor"];
}

- (UIColor *)titleColor{
    return [super valueForKey:@"titleTextColor"];
}

@end
