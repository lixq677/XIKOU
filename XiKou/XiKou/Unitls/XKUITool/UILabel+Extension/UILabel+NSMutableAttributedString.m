//
//  UILabel+NSMutableAttributedString.m
//  GoFun
//
//  Created by xun on 16/4/11.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "UILabel+NSMutableAttributedString.h"
#import "NSObject+CombineObject.h"

#define kLabelCombineAttributeSring    "LABEL_COMBINE_ATTRIBUTE_STRING"

@implementation UILabel (NSMutableAttributedString)

- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font
{
    if (!self.text || !self.text.length)
    {
        return;
    }
    if ([subString isKindOfClass:[NSNull class]] || (!subString) || (!subString.length))
    {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (font)
    {
        [dict setValue:font forKey:NSFontAttributeName];
    }
    if (color)
    {
        [dict setValue:color forKey:NSForegroundColorAttributeName];
    }
    if(! [self.text isEqualToString:self.attributedString.string])
    {
        [self removeCombineObjects];
    }
    [self.attributedString addAttributes:dict range:[self.text rangeOfString:subString]];
    [self setAttributedText:self.attributedString];
}

- (void)setAttributedStringWithSubString:(NSString *)subString font:(UIFont *)font
{
    if ([NSString isNull:subString]) return;
    [self setAttributedStringWithSubString:subString color:nil font:font];
}

- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color
{
    if ([NSString isNull:subString])return;
    [self setAttributedStringWithSubString:subString color:color font:nil];
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    if ([NSString isNull:self.text]) return;
    
    NSTextAlignment aligament = self.textAlignment;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace / 2;
    
    if(![self.text isEqualToString:self.attributedString.string])
    {
        [self removeCombineObjects];
    }
    [self.attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, self.text.length)];
    
    [self setAttributedText:self.attributedString];
    self.textAlignment = aligament;
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font
{
    for(NSString *subString in subStringArr)
    {
        [self setAttributedStringWithSubString:subString font:font];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr color:(UIColor *)color
{
    for(NSString *subString in subStringArr)
    {
        [self setAttributedStringWithSubString:subString color:color];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font color:(UIColor *)color
{
    for(NSString *subString in subStringArr)
    {
        [self setAttributedStringWithSubString:subString color:color font:font];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr
{
    int max = (int)(subStringArr.count > fontArr.count ? subStringArr.count : fontArr.count);
    for (int i = 0; i < max; i++)
    {
        [self setAttributedStringWithSubString:subStringArr[i] font:fontArr[i]];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr colors:(NSArray *)colorArr
{
    int max = (int)(subStringArr.count > colorArr.count ? subStringArr.count : colorArr.count);
    for (int i = 0; i < max; i++)
    {
        [self setAttributedStringWithSubString:subStringArr[i] color:colorArr[i]];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr colors:(NSArray *)colorArr
{
    [self setAttributedStringWithSubStrings:subStringArr fonts:fontArr];
    [self setAttributedStringWithSubStrings:subStringArr colors:colorArr];
}

- (void)addMiddleLineWithSubString:(NSString *)subString
{
    if ([NSString isNull:self.text]) return;
    if(![self.attributedString.string isEqualToString:self.text])
    {
        [self removeCombineObjects];
    }
    [self.attributedString setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[self.text rangeOfString:subString]];
    [self setAttributedText:self.attributedString];
}

- (void)stringHeadIndentAndWidth:(CGFloat)width{
    
//    if(![self.attributedString.string isEqualToString:self.text])
//    {
//        [self removeCombineObjects];
//    }
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = width;//缩进
    style.tailIndent = width;//尾部缩进
    style.firstLineHeadIndent = width;
    style.lineSpacing = 10;//行距
    [self.attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.text.length)];
    [self setAttributedText:self.attributedString];
    
}
- (NSMutableAttributedString *)attributedString{
    if (! [self getCombineObjectByKey:kLabelCombineAttributeSring]){
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [self combineObject:attributedString withKey:kLabelCombineAttributeSring];
    }
    return [self getCombineObjectByKey:kLabelCombineAttributeSring];
}

/**
 显示当前文字需要几行
 
 @param width 给定一个宽度
 @return 返回行数
 */
- (NSInteger)needLinesWithWidth:(CGFloat)width{
    //创建一个labe
    UILabel * label = [[UILabel alloc]init];
    //font和当前label保持一致
    label.font = self.font;
    NSString * text = self.text;
    NSInteger sum = 0;
    //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
    NSArray * splitText = [text componentsSeparatedByString:@"\n"];
    for (NSString * sText in splitText) {
        label.text = sText;
        //获取这段文字一行需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        //size.width/所需要的width 向上取整就是这段文字占的行数
        NSInteger lines = ceilf(textSize.width/width);
        //当是0的时候，说明这是换行，需要按一行算。
        lines = lines == 0?1:lines;
        sum += lines;
    }
    return sum;
}

- (void)handleRedPrice:(UIFont *)font{
    
    NSString *priceStr = self.text;
    
    NSString *lastStr;
    NSString *firstStr;
    
    if ([priceStr containsString:@"."]) {
        NSRange range = [priceStr rangeOfString:@"."];
        lastStr = [priceStr substringFromIndex:range.location];
        firstStr = [priceStr substringToIndex:range.location];
    }
    if ([priceStr containsString:@"¥"]) {
        firstStr = [firstStr stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        [self setAttributedStringWithSubString:@"¥" font:[font fontWithSize:font.pointSize - 5]];
    }
    [self setAttributedStringWithSubString:firstStr font:font];
    [self setAttributedStringWithSubString:lastStr font:[font fontWithSize:font.pointSize - 5]];
}

@end
