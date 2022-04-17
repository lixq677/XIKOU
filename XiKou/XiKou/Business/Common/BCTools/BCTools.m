//
//  BCTools.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BCTools.h"

@implementation BCTools

+ (NSAttributedString *)price:(CGFloat)price{
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    return [BCTools price:price font:font];
}

+ (NSAttributedString *)price:(CGFloat)price font:(UIFont *)font{
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
    
    NSString *frontStr = @"";
    NSString *backStr  = @"";
    if ([priceStr containsString:@"."]) {
        NSRange range = [priceStr rangeOfString:@"."];
        frontStr = [priceStr substringToIndex:range.location];
        backStr  = [priceStr substringFromIndex:range.location];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:[font fontWithSize:font.pointSize - 5],NSForegroundColorAttributeName:COLOR_TEXT_RED}];
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:frontStr attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:COLOR_TEXT_RED}];
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:backStr attributes:@{NSFontAttributeName:[font fontWithSize:font.pointSize - 5],NSForegroundColorAttributeName:COLOR_TEXT_RED}];
    
    [attributedString appendAttributedString:attributedString1];
    [attributedString appendAttributedString:attributedString2];
    
    return attributedString;
}


+ (NSAttributedString *)priceAddLine:(CGFloat)price{
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    return [BCTools priceAddLine:price font:font];
}

+ (NSAttributedString *)priceAddLine:(CGFloat)price font:(UIFont *)font{
    if (font == nil) {
        font = [UIFont boldSystemFontOfSize:10.0f];
    }
    NSString *priceS = [NSString stringWithFormat:@"%.2f",price];
    NSAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:[@"¥" stringByAppendingString:priceS] attributes:@{NSForegroundColorAttributeName:HexRGB(0xcccccc, 1.0f),NSFontAttributeName:font,NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
    return astr;
}

@end
