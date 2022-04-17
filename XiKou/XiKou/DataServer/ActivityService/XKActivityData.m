//
//  XKActivityData.m
//  XiKou
//
//  Created by L.O.U on 2019/8/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKActivityData.h"

@implementation ACTHomeRespnse

@synthesize data = _data;

@end

@implementation ACTHomeBaseModel

@end

@implementation ACTHomeModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"globalBuyerCommodityList":[XKGoodListModel class],
             @"bargainCommodityList":[XKGoodListModel class],
             };
}

@end

@implementation ACTMoudleResponse

@synthesize data = _data;

@end

@implementation ACTMoudleData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"bannerList":[XKBannerData class],
             @"sectionList":[ACTMoudleModel class]
             };
}

+ (NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"activityType"];
}

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+(NSString *)getPrimaryKey{
    return @"activityType";
}

@end

@implementation ACTMoudleModel

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"childSectionList":[ACTMoudleModel class]
             };
}

- (NSMutableArray *)commodityList{
    if (!_commodityList) {
        _commodityList = [NSMutableArray array];
    }
    return _commodityList;
}
@end

@implementation  ACTGlobalHomeRespnse

@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[ACTGlobalHomeModel class]};
}

@end

@implementation  ACTGlobalHomeModel

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"bannerList":[XKBannerData class],
             @"sectionCommodityList":[ACTGlobalPlateModel class]
             };
}
@end

@implementation ACTGlobalPlateModel


@end

@implementation ACTGoodsListParams

@end

@implementation ACTGoodListRespnse

@synthesize data = _data;

@end

@implementation ACTGoodListData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"result":[XKGoodListModel class]
             };
}

@end

@implementation ACTGoodDetailRespnse

@synthesize data = _data;


@end

@implementation ACTGoodDetailModel

@end

@implementation ACTRoundRespnse

@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[ACTRoundModel class]};
}

@end

@implementation ACTRoundGoodListRespnse

@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKGoodModel class]};
}

@end

@implementation ACTGoodAuctionRespnse

@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[ACTGoodAuctionModel class]};
}
@end

@implementation ACTGoodDetailAuctionRespnse

@synthesize data = _data;

@end

@implementation ACTGoodAuctionRecondRespnse

@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[ACTAuctionRecordModel class]};
}

@end

@implementation ACTRoundModel

@end

@implementation ACTMutilBuyDiscountRespnse

@synthesize data = _data;

@end

@implementation ACTBargainRespnse

@synthesize data = _data;

@end

@implementation XKBargainInfoRespnse

@synthesize data = _data;

@end

@implementation ACTBargainResponseModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"userBargainRecordVoList":[ACTBargainRecordModel class]};
}

@end

@implementation ACTBargainRecordModel


@end


