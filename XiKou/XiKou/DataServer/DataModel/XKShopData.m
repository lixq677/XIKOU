//
//  XKShopData.m
//  XiKou
//  店铺数据
//  Created by 陆陆科技 on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShopData.h"

@implementation XKShopIndustryData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"bannerImageList":[NSString class]};
}

@end

@implementation XKShopIndustryResponse
@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKShopIndustryData class]};
}


@end

@implementation XKShopBriefParams

+ (NSArray *)modelPropertyBlacklist {
    return @[@"industryName"];
}


@end

@implementation XKShopImageModel


@end

@implementation XKShopServiceModel

@end

@implementation XKShopBriefData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSArray *)getPrimaryKeyUnionArray{
    return @[@"id",@"industry1"];
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"imageList":[XKShopImageModel class],@"serviceList":[XKShopServiceModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}


@end

@implementation XKShopBriefResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKShopBriefData class]};
}
@end

@implementation XKShopDetailResponse
@synthesize data = _data;

@end

@interface XKShopFollowVoParams ()

//操作类型(是关注(follow)还是取消关注(cancel))   操作类型(是点赞(praise)还是取消点赞(cancel)
@property (nonatomic,strong)NSString *operationType;

@end

@implementation XKShopFollowVoParams
@dynamic follow;

+ (NSArray *)modelPropertyBlacklist {
    return @[@"follow"];
}


- (void)setFollow:(BOOL)follow{
    if (follow) {
        self.operationType = @"follow";
    }else{
        self.operationType = @"cancel";
    }
}

- (BOOL)follow{
    if ([self.operationType isEqualToString:@"follow"]) {
        return YES;
    }else{
        return NO;
    }
}

@end

@implementation XKShopOrderParams

@end

@implementation XKShopOrderData

@end

@implementation XKShopOrderResponse
@synthesize data = _data;

@end

@implementation XKShopMyConcernParams


@end

@implementation XKShopMyConcernData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

@end

@implementation XKShopMyConcernResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKShopMyConcernData class]};
}

@end

@implementation XKShopSearchParams


@end

@implementation XKShopSearchText
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"shopName";
}

@end

