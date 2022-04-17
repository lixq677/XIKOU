//
//  XKBase64Encryptor.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKBase64Encryptor : NSObject

//Base64
+ (NSString *)base64EncodeData:(NSData *)data;

+ (NSData *)base64DecodeString:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
