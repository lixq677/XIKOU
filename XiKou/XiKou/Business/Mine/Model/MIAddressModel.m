//
//  MIAddressModel.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/14.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIAddressModel.h"

@implementation MIAddress

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"children":[MIAddress class]};
}

@end
