//
//  NSString+XKNetowrk.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NSString+XKNetwork.h"

@implementation NSString (XKNetwork)

- (NSString *)validUrl{
    NSString *result = self;
    if ([self length]>1) {
        if ([self hasSuffix:@"/"]) {
            result = [self substringToIndex:[self length]-2];
        }
    }
    return result;
}

- (BOOL)isValidUrl{
    BOOL result = NO;
    do{
        if (self.length<=0) {
            break;
        }
        //含有非法字符",:,
        if ([self containsString:@"\""]) {
            break;
        }
        NSURL *nsUrl = [NSURL URLWithString:self];
        if (!nsUrl) {
            break;
        }
        result = YES;
    }while(0);
    return result;
}


@end
