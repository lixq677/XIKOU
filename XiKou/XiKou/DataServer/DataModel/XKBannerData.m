//
//  XKBannerData.m
//  XiKou
//
//  Created by L.O.U on 2019/7/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBannerData.h"

XKBannerSkipType XKBannerSkipTypeGoods = @"goods";//商品
XKBannerSkipType XKBannerSkipTypeActivity = @"activity";//活动
XKBannerSkipType XKBannerSkipTypeUrl = @"url";//链接

@implementation XKBannerData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

@end
