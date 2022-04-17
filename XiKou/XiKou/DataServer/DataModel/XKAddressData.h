//
//  XKAddressData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,XKAddressType) {
    XKAddressTypeNone       =   0,//普通地址
    XKAddressTypeDefault    =   1,//默认地址
};

@class XKAddressVoData;

@interface XKAddressVoModel : NSObject <YYModel>

@property (nonatomic,strong,nullable)NSString *district;

@property (nonatomic,strong,nullable)NSString *city;

@property (nonatomic,strong,nullable)NSString *province;

@property (nonatomic,strong,nullable)NSNumber *districtId;

@property (nonatomic,strong,nullable)NSNumber *cityId;

@property (nonatomic,strong,nullable)NSNumber *provinceId;

@property (nonatomic,strong,nullable)NSString *address;

@property (nonatomic,strong,nullable)CLLocation *location;

- (instancetype)initWithVoData:(XKAddressVoData *)voData;

+ (void)saveVoModelToCache:(XKAddressVoModel *)voModel;

+ (XKAddressVoModel *)voModelFromCache;

@end


/**
 地址model 供用户选用地址信息使用
 */
@interface XKAddressVoData : NSObject <YYModel,NSCopying>

@property (nonatomic,strong)NSString *address;//详细地址

@property (nonatomic,strong,nullable)NSNumber *areaId;//区域id

@property (nonatomic,strong,nullable)NSNumber *cityId;//市id

@property (nonatomic,strong)NSString *consigneeMobile;//收货人手机号

@property (nonatomic,strong)NSString *consigneeName;//收货人名称

@property (nonatomic,strong)NSNumber *defaultId;//默认标识（1：默认地址 0：正常地址）

@property (nonatomic,strong)NSString *id;//主键ID

@property (nonatomic,strong,nullable)NSNumber *provinceId;//省份id

@property (nonatomic,strong)NSString *userId;//用户id

@property (nonatomic,strong)NSString *provinceName;//省名字

@property (nonatomic,strong)NSString *cityName;//市名字

@property (nonatomic,strong)NSString *areaName;//区名字

@property (nonatomic,assign)BOOL outRange;//超出配送范围

@end


@interface XKAddressVoResponse : XKBaseResponse <YYModel>

@property (nonatomic,strong)XKAddressVoData *data;

@end



/**
 用户添加过的地址列表
 */
@interface XKAddressUserListResponse : XKBaseResponse <YYModel>

@property (nonatomic,strong)NSArray<XKAddressVoData *> *data;

@end

@interface XKAddressDeleteResponse : XKBaseResponse <YYModel>

@property (nonatomic,strong)XKAddressVoData  *data;

@end

typedef NS_ENUM(int,XKAddressLevel) {
    XKAddressLevelProvince   =   1,//省
    XKAddressLevelCity       =   2,//市
    XKAddressLevelDistrict   =   3,//区
    XKAddressLevelStreet     =   4,//街道
};


@interface XKAddressInfoData : NSObject  <YYModel>

@property (nonatomic,strong) NSNumber *areaId;//区域id

@property (nonatomic,strong) NSNumber *level;//区域等级 XKAddressLevel

@property (nonatomic,strong) NSString *name;//区域名称

@property (nonatomic,strong) NSNumber *parentId;//父区域id

@end


@interface XKAddressInfoListResponse : XKBaseResponse <YYModel>

@property (nonatomic,strong)NSArray<XKAddressInfoData *> *data;

@end













NS_ASSUME_NONNULL_END
