//
//  XKDataServer.h
//  XiKou
//
//  Created by 李笑清 on 2019/5/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XKUserService;
@class XKPropertyService;
@class XKActivityService;
@class XKActivityCartService;
@class XKHomeService;
@class XKDesignerService;
@class XKAddressService;
@class XKOrderService;
@class XKShareService;
@class XKShopService;
@class XKOtherService;
@class XKMessageService;

@interface XKDataService : NSObject

+(id)shareDataService;
/*用户中心service*/
@property (nonatomic, strong, readonly) XKUserService *userService;

/*用户财产service*/
@property (nonatomic, strong, readonly) XKPropertyService *propertyService;

/*活动模块 service*/
@property (nonatomic, strong, readonly) XKActivityService *actService;

/*购物车 service*/
@property (nonatomic, strong, readonly) XKActivityCartService *cartService;

/*订单 service*/
@property (nonatomic, strong, readonly) XKOrderService *orderService;

/*APP首页 service*/
@property (nonatomic, strong, readonly) XKHomeService *homeService;

/*设计师 service*/
@property (nonatomic, strong, readonly) XKDesignerService *designerService;

/*附近店铺 service*/
@property (nonatomic, strong, readonly) XKShopService *shopService;

/*地址的 service*/
@property (nonatomic, strong, readonly) XKAddressService *addressService;

/*其它服务*/
@property (nonatomic, strong, readonly) XKOtherService *otherService;

/*分享的 service*/
@property (nonatomic, strong, readonly) XKShareService *shareService;

/*消息 service*/
@property (nonatomic, strong, readonly) XKMessageService *messageService;

@end

FOUNDATION_EXPORT XKDataService *XKFDataService(void);

NS_ASSUME_NONNULL_END
