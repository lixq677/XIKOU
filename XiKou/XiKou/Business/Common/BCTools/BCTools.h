//
//  BCTools.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define Price(x,f) [BCTools price:x font:f]

#define PriceDef(x) [BCTools price:x]

#define Price_line(x,f) [BCTools priceAddLine:x font:f]

#define PriceDef_line(x) [BCTools priceAddLine:x]

@interface BCTools : NSObject

+ (NSAttributedString *)price:(CGFloat)price;

+ (NSAttributedString *)price:(CGFloat)price font:(UIFont *)font;

+ (NSAttributedString *)priceAddLine:(CGFloat)price;

+ (NSAttributedString *)priceAddLine:(CGFloat)price font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
