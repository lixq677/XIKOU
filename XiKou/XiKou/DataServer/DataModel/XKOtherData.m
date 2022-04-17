//
//  XKOtherData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKOtherData.h"

@implementation XKTaskModel

@end

@implementation XKTaskData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list":[XKTaskModel class]};
}

@end

@implementation XKTaskResponse
@synthesize data = _data;
@end

@implementation XKPaySwitchData

@end

@implementation XKPaySwitchResponse
@synthesize data = _data;
@end

@implementation XKGroupUp

@end

@implementation XKSocialData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"growUps":[XKGroupUp class]};
}

@end

@implementation XKSocialResponse
@synthesize data = _data;

@end

@implementation XKLogisticsContextData



@end

@implementation XKLogisticsData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKLogisticsContextData class]};
}

@end

@implementation XKLogisticsResponse
@synthesize data = _data;

@end

@implementation XKBargainScheduleData


@end

@implementation XKBargainScheduleResponse
@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKBargainScheduleData class]};
}

@end


@implementation XKVersionParams

- (instancetype)init{
    if (self = [super init]) {
        _versionPlatform = 1;
    }
    return self;
}

@end

@implementation XKVersionData

@end

@implementation XKVersionResponse
@synthesize data = _data;

@end

