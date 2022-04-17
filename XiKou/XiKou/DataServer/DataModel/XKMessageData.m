//
//  XKMessageData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKMessageData.h"

@implementation XKMsgTypeModel

@end

@implementation XKMsgUnReadData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"typesList":[XKMsgTypeModel class]};
}

@end



@implementation XKMsgUnReadResponse
@synthesize data = _data;

@end

@implementation XKMsgParams

@end

@implementation XKMsgData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}


@end

@implementation XKMsgResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKMsgData class]};
}

@end



