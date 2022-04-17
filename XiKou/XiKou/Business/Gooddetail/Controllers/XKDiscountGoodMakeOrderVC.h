//
//  ACTMutilBuyMakeOrderVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKAddressData.h"

NS_ASSUME_NONNULL_BEGIN

@class ACTCartGoodModel;
@interface XKDiscountGoodMakeOrderVC : BaseViewController

- (instancetype)initWithGoods:(NSArray<ACTCartGoodModel *> *)goods;

@property (nonatomic, assign) CGFloat totalAmount;

@property (nonatomic, copy) void(^makeOrderSuccess)(void);

@end

@interface XKMutilBuyMakeOrderModel : NSObject

@property (nonatomic, copy) NSString *merchantName;//店铺名

@property (nonatomic, strong) NSMutableArray <ACTCartGoodModel *>*list;//展示和下单列表，同一个商品不同数量需要拆分

@property (nonatomic, strong) NSMutableArray <ACTCartGoodModel *>*orderGoodList;//原始数据列表，未拆分

@property (nonatomic, copy) NSString *merchantId;//店铺ID

@property (nonatomic, strong) NSNumber *postage;//

@property (nonatomic, strong) XKAddressVoData *addressModel;//

@property (nonatomic, copy) NSString *cartId;//店铺ID

@property (nonatomic, copy) NSString *remarks;//订单备注

@end
NS_ASSUME_NONNULL_END
