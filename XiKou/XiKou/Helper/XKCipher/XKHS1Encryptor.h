//
//  CXHS1Encryptor.h
//  Basic
//
//  Created by Vincent on 16/7/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKHS1Encryptor : NSObject

/**
 *  @author 李笑清, 16-07-07 16:07:57
 *
 *  @brief HMAC-SHA1加密
 *
 *  @param text       加密内容
 *  @param pravateKey 私钥
 *
 *  @return
 */
+ (NSData *)hmacsha1:(NSString *)text pravateKey:(NSString *)pravateKey;

@end
