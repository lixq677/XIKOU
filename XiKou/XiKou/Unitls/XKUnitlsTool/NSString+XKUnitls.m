//
//  NSString+XKUnitls.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NSString+XKUnitls.h"

@implementation NSString (XKUnitls)

+ (BOOL) isNull:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSString *str = [string stringByReplacingOccurrencesOfString:@"\a" withString:@""];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isUrl{
    if(self == nil) {
        return NO;
    }
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

- (NSString *)chineseCapitalizedString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    //NSString *pinYin = [str capitalizedString];//首字母大写
    NSString *pinYin = [str uppercaseString];//首字母大写
    return pinYin;
}

- (BOOL)isValidEmail{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailCheck];
    return [emailTest evaluateWithObject:self];
}

//判断是否为全为字母
- (BOOL)isLettersOfAll{
    NSString *lettersCheck = @"[A-Za-z]+";
    NSPredicate *lettersTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",lettersCheck];
    return [lettersTest evaluateWithObject:self];
}

//判断是否为全为字母
- (BOOL)isNumberOfAll{
    NSString *numberCheck = @"[0-9]+";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberCheck];
    return [numberTest evaluateWithObject:self];
}

- (BOOL)isLetterOrNumberOfAll{
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isLetterOrCallNumberOfAll{
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9+]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

- (NSString *)deleteSpace{
    NSString *text = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return text;
}


-(NSDictionary *)paramsWithUrlString:(NSString *)urlStr{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count != 2) return nil;
        NSString *paramsStr = array[1];
        if(paramsStr.length == 0)return nil;
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
        for (NSString *param in paramArray) {
            if (param && param.length) {
                NSArray *parArr = [param componentsSeparatedByString:@"="];
                if (parArr.count == 2) {
                    [paramsDict setObject:parArr[1] forKey:parArr[0]];
                }
            }
        }
        return paramsDict;
    }
    return nil;
}


+(NSString *)connectUrl:(NSString *)urlLink params:(NSDictionary *)params{
    // 初始化参数变量
    if(params == nil || params.allKeys.count == 0)return urlLink;
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    return [urlLink stringByAppendingString:string];
}

- (BOOL)isMobileNumber{
    NSString *phoneRegex1=@"1[3456789]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return  [phoneTest1 evaluateWithObject:self];
}
- (NSString *)mobileNumberFormat {
    return  [self stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{4})(\\d{4})"
                                                               withString:@"$1 $2 $3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [self length])];

    
}
- (NSString *)appendOSSImageWidth:(NSInteger)width height:(NSInteger)height {
    NSInteger imgW = width;
    NSInteger imgH = height;
    //默认给100x100
    if (width <= 100 ) {
        imgW = 100;
    }
    if (height <= 100) {
        imgH = 100;
    }
    if (![self containsString:@"oss"]) {
        return self;
    }
    NSString *ossString = [NSString stringWithFormat:@"?x-oss-process=image/resize,m_fill,h_%ld,w_%ld",imgH,imgW];
    return [self stringByAppendingString:ossString];
}
@end
