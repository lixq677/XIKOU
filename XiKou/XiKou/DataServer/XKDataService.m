//
//  XKDataServer.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDataService.h"
#import "XKUserService.h"
#import "XKPropertyService.h"
#import "XKActivityService.h"
#import "XKActivityCartService.h"
#import "XKOrderService.h"
#import "XKHomeService.h"
#import "XKDesignerService.h"
#import "XKAddressService.h"
#import "XKShopService.h"
#import "XKOtherService.h"
#import "XKMessageService.h"
#import "XKShareService.h"

@implementation XKDataService
@synthesize userService     = _userService;
@synthesize propertyService = _propertyService;
@synthesize actService      = _actService;
@synthesize cartService     = _cartService;
@synthesize homeService     = _homeService;
@synthesize designerService = _designerService;
@synthesize addressService = _addressService;
@synthesize orderService = _orderService;
@synthesize shopService = _shopService;
@synthesize otherService = _otherService;
@synthesize shareService    = _shareService;
@synthesize messageService = _messageService;

+(id)shareDataService{
    static id shareDataService= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataService = [[self alloc] init];
    });
    return shareDataService;
}


- (XKUserService *)userService{
    if (!_userService) {
        _userService = [[XKUserService alloc] init];
    }
    return _userService;
}

- (XKPropertyService *)propertyService{
    if (!_propertyService) {
        _propertyService = [[XKPropertyService alloc] init];
    }
    return _propertyService;
}

- (XKActivityService *)actService{
    if (!_actService) {
        _actService = [[XKActivityService alloc]init];
    }
    return _actService;
}

- (XKActivityCartService *)cartService{
    if (!_cartService) {
        _cartService = [[XKActivityCartService alloc]init];
    }
    return _cartService;
}

- (XKOrderService *)orderService{
    if (!_orderService) {
        _orderService = [[XKOrderService alloc]init];
    }
    return _orderService;
}
- (XKHomeService *)homeService{
    if (!_homeService) {
        _homeService = [[XKHomeService alloc] init];
    }
    return _homeService;
}

- (XKDesignerService*)designerService{
    if (!_designerService) {
        _designerService = [[XKDesignerService alloc] init];
    }
    return _designerService;
}

- (XKAddressService *)addressService{
    if (!_addressService) {
        _addressService = [[XKAddressService alloc] init];
    }
    return _addressService;
}

- (XKShopService *)shopService{
    if (!_shopService) {
        _shopService = [[XKShopService alloc] init];
    }
    return _shopService;
}


- (XKOtherService *)otherService{
    if (!_otherService) {
        _otherService = [[XKOtherService alloc] init];
    }
    return _otherService;
}

- (XKShareService *)shareService{
    if (!_shareService) {
        _shareService = [[XKShareService alloc]init];
    }
    return _shareService;
}

- (XKMessageService *)messageService{
    if (!_messageService) {
        _messageService = [[XKMessageService alloc]init];
    }
    return _messageService;
}

@end

FOUNDATION_EXPORT XKDataService *XKFDataService(){
    return [XKDataService shareDataService];
}
