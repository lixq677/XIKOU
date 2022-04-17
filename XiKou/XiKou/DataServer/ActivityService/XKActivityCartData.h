//
//  XKActivityCartData.h
//  XiKou
//
//  Created by L.O.U on 2019/8/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@class ACTCartStoreModel;
@interface ACTCartDataResponse : XKBaseResponse

@property (nonatomic, strong) NSArray<ACTCartStoreModel *> *data;

@end

@class ACTCartGoodModel;
@interface ACTCartStoreModel : NSObject<YYModel> //以店铺为一条

@property (nonatomic, copy) NSString *merchantName;//店铺名

@property (nonatomic, strong) NSMutableArray <ACTCartGoodModel *>*list;//商品列表

@property (nonatomic, copy) NSString *merchantId;//店铺ID

@property (nonatomic, strong) NSNumber *postage;//邮费

@end

@interface ACTCartGoodModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *id; //购物车ID

@property (nonatomic, copy) NSString *activityId;//活动ID

@property (nonatomic, copy) NSString *buyerUserId;//购买人ID

@property (nonatomic, copy) NSString *commodityId;//商品ID

@property (nonatomic, copy) NSString *commodityModel;//型号

@property (nonatomic, copy) NSString *commodityName;//名字

@property (nonatomic, copy) NSString *commoditySpec;//规格

@property (nonatomic, copy) NSString *commodityUnit;//单位

@property (nonatomic, copy) NSString *goodsId;//

@property (nonatomic, copy) NSString *activityGoodsId;//

@property (nonatomic, copy) NSString *goodsImageUrl;//图

@property (nonatomic, strong) NSNumber *activityPrice;//活动价

@property (nonatomic, strong) NSNumber *salePrice; // 售价

@property (nonatomic, strong) NSNumber *buyerNumber;//购买数量

@property (nonatomic, strong) NSNumber *discount;//最小折扣
//********自添字段，用于购物车逻辑处理
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) NSInteger selectNum;//选中数量

@property (nonatomic, assign) NSInteger maxNum;//所有商品已选的最大数量

@property (nonatomic, strong) NSMutableArray *indexs;//选中顺序的下标,选中多个就会有多个下标

@property (nonatomic, strong) NSNumber *rateOne;//折扣1

@property (nonatomic, strong) NSNumber *rateThree;//折扣3

@property (nonatomic, strong) NSNumber *rateTwo;//折扣2

//********自添字段，用于后传创建订单,防止购物车数量过多，遍历已选店铺数组挑选出已选商品过于耗时间
@property (nonatomic, copy) NSString *merchantId;//商家ID

@property (nonatomic, copy) NSString *merchantName;//商家名字

@property (nonatomic, strong) NSNumber *postage;//邮费

@property (nonatomic, strong) NSNumber *cartID;//购物车ID

@property (nonatomic, strong) NSNumber *currentDiscount;//折扣

@property (nonatomic, assign) NSInteger selectIndex;//选中的顺序

@end

NS_ASSUME_NONNULL_END
