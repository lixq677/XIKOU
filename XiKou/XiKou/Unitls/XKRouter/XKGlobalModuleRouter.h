//
//  XKGlobalModuleRouter.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kRouterLogin    @"XK://Login" //登录

#define kRouterPay    @"XK://pay" //支付

#define kRouterPayByOther  @"XK://payByOther" //代付

#define kRouterWeb     @"XK://web" //跳转网页

#define kRouterActivity @"XK://activity"//跳转到活动

#define kRouterGoods    @"XK://goods" //跳转到商品

#define kRouterWg       @"xk://activity/wug" //跳转到吾G

#define kRouterBargain @"xk://activity/cut" //砍立得首页

#define kRouterMutilBuy @"xk://activity/many" //多买多折

#define kRouterGlobalBuy @"xk://activity/global" //全球购

#define kRouterCustomAssemble @"xk://activity/group" //定制拼团

#define kRouterZeroBuy  @"XK://zeroBuy" //0元抢

#define kRouterCustomer  @"XK://customer" //客服

#define kRouterSearchShop @"XK://searchShop" //搜索店铺

#define kRouterSearchGoods @"XK://searchGoods" //搜索商品

#define kRouterAuthen @"xk://user/authen"   //实名认证

#define kRouterComment @"xk://designer/home"    //点评任务

#define kRouterNearShop @"xk://near/shop" //商铺首页

#define kRouterAdvertising @"xk://user/promotion" //推广

#define kRouterNewUser @"xk://newuser" //新人专区

#define kRouterNewGoods @"xk://newgoods" //新品价到

#define kRouterLogistics @"xk://logisticss" //醒看物流

#define kRouterSearchFriend @"xk://searchfriend" //搜索朋友

#define kRouterOrderDetail @"xk://order/detail" //订单详情


//#define kRouterShare @"XK://share" //分享


@interface XKGlobalModuleRouter : NSObject


+ (BOOL)isValidScheme:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
