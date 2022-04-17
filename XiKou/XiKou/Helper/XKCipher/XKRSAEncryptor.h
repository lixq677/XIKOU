//
//  CXRSAEncryptor.h
//  Basic
//
//  Created by Vincent on 16/7/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKRSAEncryptor : NSObject

/**
 *  加密方法
 *
 *  @param data    需要加密的二进制数据
 *  @param pubKey 公钥字符串
 */
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;

/**
 *  解密方法
 *
 *  @param data   需要解密的二进制数据
 *  @param privKey 私钥字符串
 */
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

/**
 *  加密方法
 *
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;



/**
 *  解密方法
 *
 *  @param string     需要解密的字符串
 *  @param privKey 私钥字符串
 */
+ (NSString *)decryptString:(NSString *)string privateKey:(NSString *)privKey;

/**
 *  加密方法
 *
 *  @param data   需要加密的二进制数据
 *  @param path  '.der'格式的公钥文件路径
 */

+ (NSData *)encryptData:(NSData *)data publicKeyWithContentsOfFile:(NSString *)path;

/**
 *  解密方法
 *
 *  @param data       需要解密的二进制数据
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSData *)decryptData:(NSData *)data privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 *  加密方法
 *
 *  @param str   需要加密的字符串
 *  @param path  '.der'格式的公钥文件路径
 */
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

/**
 *  解密方法
 *
 *  @param str       需要解密的字符串
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 *  加密方法
 *
 *  @param data   需要加密的二进制数据
 *  @param privKey 私钥字符串 */

+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

/**
 *  解密方法
 *
 *  @param data   需要解密的二进制数据
 *  @param pubKey 公钥字符串
 */

+ (NSData *)decryptData:(NSData *)data publickKey:(NSString *)pubKey;

/**
 *  加密方法
 *
 *  @param string    需要加密的字符串
 *  @param privKey  私钥字符串
 */

+ (NSString *)encryptString:(NSString *)string privateKey:(NSString *)privKey;

/**
 *  解密方法
 *
 *  @param string     需要解密的字符串
 *  @param pubKey 公钥字符串
 */

+ (NSString *)decryptString:(NSString *)string publicKey:(NSString *)pubKey;


@end
