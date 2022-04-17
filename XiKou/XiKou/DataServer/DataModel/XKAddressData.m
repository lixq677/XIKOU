//
//  XKAddressData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

static NSString * const kAddressVoDataKey = @"kAddressVoDataKey";

#import "XKAddressData.h"

@implementation XKAddressVoModel

- (instancetype)initWithVoData:(XKAddressVoData *)voData{
    if (self = [super init]) {
        self.provinceId = voData.provinceId;
        self.cityId = voData.cityId;
        self.districtId = voData.areaId;
        self.address = voData.address;
    }
    return self;
}


+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return  @[@"location"];
}


+ (void)saveVoModelToCache:(XKAddressVoModel *)voModel{
    NSMutableDictionary *dict = [[voModel yy_modelToJSONObject] mutableCopy];
    [dict setObject:@(voModel.location.coordinate.latitude) forKey:@"latitude"];
    [dict setObject:@(voModel.location.coordinate.longitude) forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kAddressVoDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (XKAddressVoModel *)voModelFromCache{
    NSDictionary *voParams = [[NSUserDefaults standardUserDefaults] objectForKey:kAddressVoDataKey];
    XKAddressVoModel *voModel = nil;
    if (voParams) {
        voModel = [XKAddressVoModel yy_modelWithJSON:voParams];
        CLLocationDegrees latitude = [[voParams objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude = [[voParams objectForKey:@"longitude"] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        voModel.location = location;
    }
    return voModel;
}

@end

@implementation XKAddressVoData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (NSArray *)getPrimaryKeyUnionArray{
    return @[@"id",@"userId"];
}

- (id)copyWithZone:(NSZone *)zone{
    XKAddressVoData *voData = [XKAddressVoData yy_modelWithJSON:[self yy_modelToJSONObject]];
    return voData;
}

@end


@implementation XKAddressVoResponse
@synthesize data = _data;

@end

@implementation XKAddressUserListResponse
@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKAddressVoData class]};
}

@end

@implementation XKAddressDeleteResponse
@synthesize data = _data;
@end

@implementation XKAddressInfoData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"areaId";
}


@end

@implementation XKAddressInfoListResponse
@synthesize data = _data;

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKAddressInfoData class]};
}

@end
