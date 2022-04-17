//
//  XKHomeData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKHomeData.h"
#import <LKDBHelper.h>
#import "XKGoodModel.h"

/**
 基类，抽出共有参数
 */
@implementation XKHomeActivityBaseModel

@end

/*0元抢专区商品Model对象*/
@implementation XKHomeAuctionActivityModel

+ (BOOL)isContainParent{
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"homeAuctionCommodityModels":[XKGoodListModel class]};
}

@end


/*砍立得专区商品Model对象*/

@implementation XKHomeBargainActivityModel

+ (BOOL)isContainParent{
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"homeBargainCommodityModels":[XKGoodListModel class]};
}

@end



/*吾G专区商品Model对象*/

@implementation XKHomeBuyGiftActivityModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"homeBuyGiftCommodityModels":[XKGoodListModel class]};
}

+ (BOOL)isContainParent{
    return YES;
}

@end




/*多买多折专区商品Model对象*/

@implementation XKHomeDiscountActivityModel

+ (BOOL)isContainParent{
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"homeDiscountCommodityModels":[XKGoodListModel class]};
}
@end

/*全球买手区商品Model对象*/
@implementation XKHomePageGlobalBuyerActivityModel

+ (BOOL)isContainParent{
    return YES;
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"homeGlobalBuyerCommodityModels":[XKGoodListModel class]};
}

@end



@implementation XKHomeActivityModel

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

@end

@implementation XKHomeActivityResponse
@synthesize data = _data;

@end

@implementation XKBannerParams

@end


@implementation XKBannerResponse
@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKBannerData class]};
}

@end

@implementation XKRankResponse
@synthesize data = _data;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKGoodModel class]};
}
@end

@implementation XKGoodsSearchParams

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"nwFlag" : @"newFlag"};
}


@end


@implementation XKGoodsSearchData


@end

@implementation XKGoodsSearchResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKGoodsSearchData class]};
}
@end

@implementation XKGoodsSearchText
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"commodityName";
}

@end
