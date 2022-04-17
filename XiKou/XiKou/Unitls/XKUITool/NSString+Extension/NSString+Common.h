//
//  NSString+Common.h
//  XiKou
//
//  Created by L.O.U on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Common)

#pragma mark - string of size

/**
 *  @brief  文本尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font andMaxW:(CGFloat)maxW;

/**
 *  @brief  带行间距的文本高度
 */
-(CGFloat)getSpaceLabelHeightwithSpace:(CGFloat)Space
                              withFont:(UIFont*)font
                               andMaxW:(CGFloat)maxW;

//姓名校验
- (BOOL)isVaildRealName;

//校验身份证格式
- (BOOL)checkUserID;
@end

NS_ASSUME_NONNULL_END
