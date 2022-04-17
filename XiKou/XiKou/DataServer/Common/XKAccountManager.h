//
//  XKAccountManager.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKAccountData : NSObject<YYModel>

@property (nonatomic,strong) NSString *refreshToken;

@property (nonatomic,strong,nullable) NSString *token;

@property (nonatomic,strong,nullable) NSString *userId;

@end


@interface XKAccountManager : NSObject

@property (nonatomic,strong,nullable,readonly) XKAccountData *account;

@property (nonatomic,assign,readonly,getter=isLogin)BOOL login;

@property (nonatomic,strong,readonly,nullable) NSString *mobile;//电话号码

@property (nonatomic,strong,readonly,nullable) NSString *headUrl;//头像

@property (nonatomic,strong,readonly,nullable) NSString *name;//名字

@property (nonatomic,strong,readonly) NSString *refreshToken;

@property (nonatomic,strong,readonly) NSString *token;

@property (nonatomic,strong,readonly) NSString *userId;

@property (nonatomic,strong,readonly) NSString *extCode;//邀请码

@property (nonatomic,assign,readonly,getter=isVer)BOOL ver;//是否实名认证

@property (nonatomic,assign,readonly)BOOL isPayPassword;//是否设置过支付密码

//优惠券张数
@property (nonatomic,strong,readonly)NSNumber *couponNum;

//红包余额
@property (nonatomic,strong,readonly)NSNumber *balance;

//关注数
@property (nonatomic,strong,readonly)NSNumber *followCnt;

@property (nonatomic,strong) NSString *weixinPayKey;

+(XKAccountManager *)defaultManager;

@end



NS_ASSUME_NONNULL_END
