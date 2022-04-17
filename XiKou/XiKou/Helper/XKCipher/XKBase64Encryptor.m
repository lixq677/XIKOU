//
//  XKBase64Encryptor.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBase64Encryptor.h"

@implementation XKBase64Encryptor

+ (NSData *)base64DecodeString:(NSString *)str{
    if (str) {
        NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return data;
    }
    
    return nil;
}

+ (NSString *)base64EncodeData:(NSData *)data{
    if (data) {
        data = [data base64EncodedDataWithOptions:0];
        NSString *ret = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        return ret;
    }
    
    return nil;
}

@end
