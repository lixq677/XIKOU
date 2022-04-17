//
//  XKBannerData.h
//  XiKou
//
//  Created by L.O.U on 2019/7/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(int,XKBannerMoudle) {
    XKBannerMoudleHome       =   1,//首页
    XKBannerMoudleActivity   =   2,//活动,
    XKBannerMoudleWg         =   3,//吾G
};

typedef NS_ENUM(int,XKBannerPosition) {
    XKBannerPositionTop       =   1,//头部 banner
    XKBannerPositionMiddle    =   2,//中部banner
    XKBannerPositionMain      =   3,//活动主图
};

typedef NS_ENUM(int,XKBannerStatus) {
    XKBannerStatusWillShelf =  1,//1：待上架
    XKBannerStatusOnShelf =    2,//2：已上架
    XKBannerStatusOffShelf =   3,//3：已下架
};

typedef NSString * XKBannerSkipType;//banner跳转类型

FOUNDATION_IMPORT XKBannerSkipType XKBannerSkipTypeGoods;//商品
FOUNDATION_IMPORT XKBannerSkipType XKBannerSkipTypeActivity;//活动
FOUNDATION_IMPORT XKBannerSkipType XKBannerSkipTypeUrl;//链接

@interface XKBannerData : NSObject <YYModel>

@property (nonatomic,strong)NSString *id;//主键Id

@property (nonatomic,strong)NSString *imageUrl;//banner图片Url

@property (nonatomic,assign)int isTop;//是否置顶 1：是 2: 否

@property (nonatomic,assign)XKBannerMoudle moudle;//模块(1: 首页 2: 活动首页 3: 吾G频道)

@property (nonatomic,assign)XKBannerPosition position;//位置(1： 头部BANNER 2： 中部BANNER 3: 活动主图)

@property (nonatomic,assign)XKBannerSkipType skipType;//跳转类型: goods(商品),activity(活动),url(链接)等

@property (nonatomic,strong)NSString *sort;//排序字段

@property (nonatomic,assign)XKBannerStatus status;//状态(显示为2 不显示为1) 1：待上架 2：已上架 3：已下

@property (nonatomic,strong)NSString *targetParams;//跳转json参数

@property (nonatomic,strong)NSString *targetUrl1;//跳转地址url1

@property (nonatomic,strong)NSString *targetUrl2;//跳转地址url2

@property (nonatomic,strong)NSString *title;//banner标题

@end


NS_ASSUME_NONNULL_END
