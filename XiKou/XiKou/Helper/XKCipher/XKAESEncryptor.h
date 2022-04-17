//
//  CXAESEncryptor.h
//  Basic
//
//  Created by Vincent on 16/7/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKAESEncryptor : NSObject

/**
 *  @author 李笑清, 16-07-07 16:07:11
 *
 *  @brief AES128加密
 *
 */
+ (NSData *)aes128EncryptData:(NSData *)data key:(NSString *)key;

/**
 *  @author 李笑清, 16-07-07 16:07:01
 *
 *  @brief AES128解密
 *
 */
+ (NSData *)aes128DecryptData:(NSData *)data key:(NSString *)key;

+ (NSData *)aes128EncryptDataNoPadding:(NSData *)data key:(NSString *)key;

/**
 *  @author 李笑清, 16-07-07 16:07:50
 *
 *  @brief AES256加密
 *
 */
+ (NSData*)aes256EncryptData:(NSData*)data key:(NSString*)key;

/**
 *  @author 李笑清, 16-07-07 16:07:28
 *
 *  @brief AES256解密
 *
 */
+ (NSData*)aes256DecryptData:(NSData*)data key:(NSString*)key;


/**
 *  @author 李笑清, 16-07-07 16:07:11
 *
 *  @brief AES128加密
 *
 */
+ (NSData *)aes128EncryptString:(NSString *)string key:(NSString *)key;

/**
 *  @author 李笑清, 16-07-07 16:07:01
 *
 *  @brief AES128解密
 *
 */
+ (NSData *)aes128DecryptString:(NSString *)string key:(NSString *)key;

/**
 *  @author 李笑清, 16-07-07 16:07:50
 *
 *  @brief AES256加密
 *
 */
+ (NSData*)aes256EncryptString:(NSString *)string key:(NSString*)key;

/**
 *  @author 李笑清, 16-07-07 16:07:28
 *
 *  @brief AES256解密
 *
 */
+ (NSData*)aes256DecryptString:(NSString *)string key:(NSString*)key;

@end
