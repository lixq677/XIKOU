//
//  XKBargainInfoModel.h
//  XiKou
//
//  Created by L.O.U on 2019/7/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XKBargainPersonModel;
@interface XKBargainInfoModel : NSObject<YYModel>

@property (nonatomic,copy) NSString *id;//ID

@property (nonatomic,copy) NSString *address;//地址ID

@property (nonatomic,copy) NSString *createTime;//创建时间

@property (nonatomic,copy) NSString *activityId;//绑定活动id

@property (nonatomic,copy) NSString *commodityId;//商品ID(sku)

@property (nonatomic,assign) NSInteger bargainCount;//被砍价成功次数

@property (nonatomic,copy) NSString *goodsImageUrl;//商品主图(列表页)

@property (nonatomic,strong) NSNumber *currentPrice;//当前已砍至价格

@property (nonatomic,strong) NSNumber *finalPrice;//最终成交价格

@property (nonatomic,assign) NSInteger state;//1: 未成单 2: 已成单

@property (nonatomic,strong) NSNumber *merchantId;//商家Id

@property (nonatomic,strong) NSArray<XKBargainPersonModel *> *userBargainRecordVoList;

@end

@interface XKBargainPersonModel : NSObject

@property (nonatomic,copy) NSString *assistUserHeadImageUrl;//帮砍用户头像url

@property (nonatomic,copy) NSString *assistUserId;//帮砍用户Id

@property (nonatomic,copy) NSString *assistUserName;//帮砍用户昵称

@property (nonatomic,copy) NSString *bargainScheduleId;//砍价进度Id

@property (nonatomic,copy) NSString *createTime;//创建时间

@property (nonatomic,strong) NSNumber *bargainPrice;//帮砍价格

@end

NS_ASSUME_NONNULL_END
