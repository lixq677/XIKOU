//
//  NSString+XKUnitls.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XKUnitls)

+ (BOOL)isNull:(NSString *)string;


/**
 判断是否是url

 @return <#return value description#>
 */
- (BOOL)isUrl;

/*获取汉字拼音*/
- (NSString *)chineseCapitalizedString;

// 判断是否为正确的邮箱
- (BOOL)isValidEmail;

//判断字符串是否全部是字母
- (BOOL)isLettersOfAll;

//判断字符串是否全部是数字
- (BOOL)isNumberOfAll;

//判断是否是手机号码
- (BOOL)isMobileNumber;

// 判断是否全是数字或者字母
- (BOOL)isLetterOrNumberOfAll;

/*比上面函数多了个+号，判断是否正确的电话号码用*/
- (BOOL)isLetterOrCallNumberOfAll;

- (NSString *)mobileNumberFormat;

- (NSString *)deleteSpace;

/*获取字符串的参数*/
-(NSDictionary *)paramsWithUrlString:(NSString *)urlStr;

/*给url添加参数*/
+(NSString *)connectUrl:(NSString *)urlLink params:(NSDictionary *)params;

/// 给阿里云图片设置大小
/// @param size 大小 
- (NSString *)appendOSSImageWidth:(NSInteger)width height:(NSInteger)height;

@end

NS_ASSUME_NONNULL_END
