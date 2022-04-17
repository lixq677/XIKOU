//
//  XKMD5Encryptor.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKMD5Encryptor.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@implementation XKMD5Encryptor

#pragma mark - MD5
+ (NSString *)md5WithString:(NSString *)string{
    if (string.length<=0) {
        return @"";
    }else{
        const char *cStr = [string UTF8String];
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        
        CC_MD5(cStr, (unsigned int)strlen(cStr), result);
        
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    }
}

+ (NSString*)md5WithData:(NSData *)data{
    
    if (data.length<=0) {
        return @"";
    }else{
        unsigned char digist[ CC_MD5_DIGEST_LENGTH ];  //CC_MD5_DIGEST_LENGTH = 16
        
        CC_MD5 ([data bytes], (unsigned int)[data length], digist);
        
        NSMutableString * outPutStr = [ NSMutableString stringWithCapacity : 10 ];
        
        for ( int   i = 0 ; i< CC_MD5_DIGEST_LENGTH ;i++){
            [outPutStr appendFormat : @"%02x" ,digist[i]]; // 小写 x 表示 输出的是小写 MD5 ，大写 X 表示输出的是大写 MD
        }
        
        return [outPutStr lowercaseString];
    }
}

@end
