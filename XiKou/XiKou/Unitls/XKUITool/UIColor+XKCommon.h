//
//  UIColor+EKCommon.h
//  CallWatch
//
//  Created by kingo on 9/21/15.
//  Copyright © 2015 shenqi329. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIColor * HexRGB(int rgbValue,float alv){
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
        return [UIColor colorWithDisplayP3Red:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alv/1.0];
    }else{
        return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alv/1.0];
    }
}

static inline UIColor * ColorRGBA(float r, float g, float b,float a){
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0) {
        return [UIColor colorWithDisplayP3Red:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)];
    }else{
        return [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)];
    }
}


@interface UIColor (XKCommon)

- (UIColor *)colorWithAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithRGBString:(NSString *)rgbString;//示例：rgba(123,120,100,1.0f)

+ (NSString *)stringFromColor:(UIColor *)color;//UIColor转换成NSString
+ (UIColor *)colorWithZYString: (NSString *) stringToConvert;//NSString转换成UIColor

+ (UIColor *)colorWithColorNum:(int)colorNum;//根据序号来获取Color的值
- (NSString *)getColorString;
- (BOOL)isEqualToColor:(UIColor *)color;
+ (int)getColorNumWithColor:(UIColor *)color;//根据颜色来获取Color的序号

//重新设置alpha值
- (UIColor *)setAlpha:(CGFloat)alpha;

+ (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;//求当前颜色和color1之间的过渡色，percent是百分比

- (UIColor *)reverseColor;//获取反颜色。

- (BOOL)isDarkGrayColor;//是否是深色
@end
