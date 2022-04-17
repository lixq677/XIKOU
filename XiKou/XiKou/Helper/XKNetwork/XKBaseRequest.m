//
//  XKBaseRequest.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseRequest.h"

@interface XKBaseRequest ()

@property (nonatomic,strong)NSString *domain;

@end

@implementation XKBaseRequest

- (instancetype)init{
    if (self = [super init]) {
        [self initDefault];
    }
    return self;
}

- (void)initDefault{
    self.timeout = 10.0f;
    self.includeDomain = NO;
    self.httpHeaders = @{@"Accept":@"application/json",@"Content-Type":@"application/json; charset=UTF-8"};
    self.domain = @"";
    self.requestSerializerType = XKRequestSerializerTypeJson;
    self.responseSerializerType = XKResponseSerializerTypeJson;
}

@end
