//
//  XKMD5Encryptor.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKMD5Encryptor : NSObject

//MD5:小写
+ (NSString *)md5WithString:(NSString *)string;

+ (NSString *)md5WithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
