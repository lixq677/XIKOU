//
//  XKShareData.m
//  XiKou
//
//  Created by L.O.U on 2019/7/31.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShareData.h"

@implementation XKPopularizeInfoResponse
@synthesize data = _data;

@end

@implementation XKPopularizeInfoData

@end

@implementation XKShareRequestModel


@end

@implementation XKShareGoodModel


@end

@implementation XKShareResponse
@synthesize data = _data;

@end

@implementation XKShareData

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"url" : @"params.url"};
}

@end

@implementation XKShareCallbackRequestModel


@end
