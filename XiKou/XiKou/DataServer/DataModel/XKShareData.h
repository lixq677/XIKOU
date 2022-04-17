//
//  XKShareData.h
//  XiKou
//
//  Created by L.O.U on 2019/7/31.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKBaseResponse.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class XKPopularizeInfoData;
@interface XKPopularizeInfoResponse : XKBaseResponse

@property (nonatomic,strong) XKPopularizeInfoData *data;

@end

@interface XKPopularizeInfoData : NSObject <YYModel>
//分享图片地址url
@property (nonatomic, copy) NSString *imageUrl;
//分享跳转链接
@property (nonatomic, copy) NSString *jumpUrl;

@end

typedef enum : NSUInteger {
    SPActivityWug  = 1,   //吾G活动中心
    SPActivityGloabl = 2,     //全球买手活动中心
    SPActivityMutil  = 3,      //多买多折活动中心
    SPActivityBargain = 4,    //砍立得活动中心
    SPActivityAuction = 5,    //0元竞拍活动中心
    SPActivityCustom  = 6,     //定制拼团活动中心
    SPShop            = 7,               //店铺主页
    SPMiniApp         = 8,            //小程序分享
    SPGoodDetailWug   = 9,      //吾G商品详情
    SPGoodDetailBargain = 10,  //砍立得商品详情
    SPGoodDetailGlobal  = 11,   //全球买手商品详情
    SPGoodDetailMutil  = 12,    //多买多折商品详情
    SPGoodDetailCustom = 13,   //定制拼团商品详情
    SPGoodDetailAuction = 14,  //0元抢商品详情
    SPDesigner = 15,           //设计师主页
    SPGoodDetailNewUser = 17,//新人专区详情
} SharePosition; //推广位置

//分享的请求模型
@class XKShareGoodModel;
@interface XKShareRequestModel : NSObject<YYModel>

//分享人ID
@property (nonatomic,copy) NSString *shareUserId;

@property (nonatomic,assign) SharePosition popularizePosition;

//活动商品信息;分享活动商品时设置此对象
@property (nonatomic,strong) XKShareGoodModel *activityGoodsCondition;

//活动ID；分享活动时设置此字段
@property (nonatomic,copy) NSString *activityId;

//店铺ID；分享店铺时设置此字段
@property (nonatomic,copy) NSString *shopId;

//设计师ID；分享设计师主页时设置此字段
@property (nonatomic,copy) NSString *designerId;

@end
//分享商品时的商品模型
@interface XKShareGoodModel : NSObject

@property (nonatomic,copy) NSString *activityId;//活动ID

@property (nonatomic,copy) NSString *commodityId;//商品SKU ID

@property (nonatomic,copy) NSString *goodsId;//商品SPU ID

@property (nonatomic,copy) NSString *activityGoodsId;//活动商品ID

@property (nonatomic,assign) XKActivityType activityType;

@end

@class XKShareData;
@interface XKShareResponse : XKBaseResponse

@property (nonatomic,strong) XKShareData *data;

@end

@interface XKShareData : NSObject
//内容
@property (nonatomic,copy) NSString *content;
//图片
@property (nonatomic,copy) NSString *imageUrl;
//跳转链接
@property (nonatomic,copy) NSString *url;
//标题
@property (nonatomic,copy) NSString *title;
//跳转类型;H5页面跳转:url
@property (nonatomic,copy) NSString *type;

@end

@interface XKShareCallbackRequestModel : NSObject<YYModel>

//分享人ID
@property (nonatomic,copy) NSString *popularizeUserId;
//固定推广分享内容ID
@property (nonatomic,assign) SharePosition popularizeId;

//活动商品信息;分享活动商品时设置此对象
@property (nonatomic,strong) XKShareGoodModel *activityGoodsCondition;

//是否分享成功:0-否;1-是;
@property (nonatomic,assign) NSInteger state;

@end

NS_ASSUME_NONNULL_END
