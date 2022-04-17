//
//  NSURL+XKUnitls.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NSURL+XKUnitls.h"

@implementation NSURL (XKUnitls)

- (NSDictionary *)params{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

@end
