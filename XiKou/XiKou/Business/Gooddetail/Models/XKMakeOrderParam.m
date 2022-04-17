//
//  XKMakeOrderModel.m
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKMakeOrderParam.h"
#import "XKGoodModel.h"

@implementation XKMakeOrderParam

+ (NSArray *)modelPropertyBlacklist{
    return @[@"condition"];
}

@end

@implementation XKMakeOrderResultModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list":[XKMakeOrderResultModel class]};
}

@end
