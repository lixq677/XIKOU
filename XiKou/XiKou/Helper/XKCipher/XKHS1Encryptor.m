//
//  CXHS1Encryptor.m
//  Basic
//
//  Created by Vincent on 16/7/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

#import "XKHS1Encryptor.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation EKHS1Encryptor

#define CO_HMACSHA1_DIGEST_LENGTH 20

+ (NSData *)hmacsha1:(NSString *)text pravateKey:(NSString *)pravateKey{
    NSData *secretData = [pravateKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CO_HMACSHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    NSData *resultData = [NSData dataWithBytes:result length:CO_HMACSHA1_DIGEST_LENGTH];
    return resultData;
}


@end
