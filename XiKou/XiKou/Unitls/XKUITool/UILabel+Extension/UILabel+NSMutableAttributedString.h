//
//  UILabel+NSMutableAttributedString.h
//  GoFun
//
//  Created by xun on 16/4/11.
//  Copyright © 2016年 xun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NSMutableAttributedString)

/**
 *  设置label内字符串某些字符串的字体以及颜色
 *
 *  @param subString 子字符串
 *  @param color     期望颜色
 *  @param font      期望字体
 */
- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font;

/**
 *  设置label内字符串某些字符串的颜色
 *
 *  @param subString 子字符串
 *  @param color     期望颜色
 */
- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color;

/**
 *  设置label内字符串某些字符串的字体
 *
 *  @param subString 子字符串
 *  @param font      期望字体
 */
- (void)setAttributedStringWithSubString:(NSString *)subString font:(UIFont *)font;

/**
 *  设置label行间距
 *
 *  @param lineSpace 行间距
 */
- (void)setLineSpace:(CGFloat)lineSpace;

/**
 *  设置label内字符串多串子字符串的颜色
 *
 *  @param subStringArr 子字符串数组
 *  @param font         期望字体
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font;

/**
 *  设置label内字符串多串子字符串的颜色
 *
 *  @param subStringArr 子字符串数组
 *  @param color        期望颜色
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr color:(UIColor *)color;

/**
 *  设置label内字符串多串子字符串的颜色和字体
 *
 *  @param subStringArr 子字符串数组
 *  @param font         期望字体
 *  @param color        期望颜色
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font color:(UIColor *)color;

/**
 *  设置label内字符串多串子字符串各自的颜色以及字体
 *
 *  @param subStringArr 子字符串数组
 *  @param fontArr      期望字体数组
 *  @param colorArr     期望颜色数组
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr colors:(NSArray *)colorArr;

/**
 *  设置label内字符串多串子字符串各自的字体
 *
 *  @param subStringArr 子字符串数组
 *  @param fontArr      期望字体数组
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr;

/**
 *  设置label内字符串多串子字符串各自的颜色
 *
 *  @param subStringArr 子字符串数组
 *  @param colorArr     期望颜色数组
 */
- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr colors:(NSArray *)colorArr;

/**
 *  为Label内字字符串添加中间划线
 *
 *  @param subString    子字符串
 */
- (void)addMiddleLineWithSubString:(NSString *)subString;
/**
 *  为Label头尾缩进 ,可当做padding使用
 *
 *  @param width 缩进长度
 */
- (void)stringHeadIndentAndWidth:(CGFloat)width;

/**
 显示当前文字需要几行
 
 @param width 给定一个宽度
 @return 返回行数
 */
- (NSInteger)needLinesWithWidth:(CGFloat)width;

/**
 价格显示处理
 */
- (void)handleRedPrice:(UIFont *)font;

@end
