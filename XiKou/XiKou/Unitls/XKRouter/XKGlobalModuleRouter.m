//
//  XKGlobalModuleRouter.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGlobalModuleRouter.h"
#import <MGJRouter.h>
#import "XKEnum.h"
#import <RTRootNavigationController.h>

#import "MILoginVC.h"
#import "CMPaymentOrderVC.h"
#import "XKWebViewController.h"
#import "ACTBargainVC.h"
#import "ACTDiscountBuyVC.h"
#import "ACTZeroBuyVC.h"
#import "ACTGlobalSellerVC.h"

#import "CTCustomGroupBaseVC.h"
//#import "HMLimitBuyBaseVC.h"
#import "HMWgVC.h"

#import "XKWugGoodDetailVC.h"
#import "XKDiscountGoodDetail.h"
#import "XKGlobalGoodDetailVC.h"
#import "XKZeroBuyGoodDetailVC.h"
#import "XKBargainGoodDetailVC.h"
#import "XKCustomGoodDetailVC.h"
#import "XKNewUserGoodDetailVC.h"

#import "NBSearchShopsVC.h"
#import "HMSearchGoodsVC.h"

#import "CMPaidByOtherVC.h"
#import "MIAdvertisingVC.h"

#import "MIVerifyVC.h"
#import "CTDesignerVC.h"
#import "NearByViewController.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import <MQChatViewManager.h>
#import "ACTNewUserVC.h"
#import "ACTNewGoodsVC.h"
#import "XKLogisticsVC.h"
#import "XKSearchFriendViewController.h"
#import "MIOrderDetailVC.h"
#import "ACTWgVC.h"

@interface XKGlobalModuleRouter ()

+ (UINavigationController *)currentNC;

@end

@implementation XKGlobalModuleRouter

+(void)load{
    [MGJRouter registerURLPattern:kRouterLogin toHandler:^(NSDictionary *routerParameters) {
       
         UINavigationController *currentNC = [self currentNC];
        if ([[XKAccountManager defaultManager] isLogin]) {
            XKShowToast(@"您已登录过账户了");
            return;
        }
        NSDictionary *params = [routerParameters objectForKey:MGJRouterParameterUserInfo];
        MILoginVC *controller = [[MILoginVC alloc] initWithParams:params];
        UINavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:controller];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentNC.visibleViewController presentViewController:nav animated:YES completion:nil];
    }];
    [MGJRouter registerURLPattern:kRouterPay toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        XKOrderBaseModel *displayModel = routerParameters[MGJRouterParameterUserInfo][@"key"];
        CMPaymentOrderVC *controller = [[CMPaymentOrderVC alloc] initWithOrder:displayModel];
        [currentNC pushViewController:controller animated:YES];
    }];
    [MGJRouter registerURLPattern:kRouterPayByOther toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        XKOrderBaseModel *displayModel = routerParameters[MGJRouterParameterUserInfo][@"key"];
        CMPaidByOtherVC *controller = [[CMPaidByOtherVC alloc] initWithOrder:displayModel];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterWeb toHandler:^(NSDictionary *routerParameters) {
        NSString *url = [routerParameters[MGJRouterParameterUserInfo] objectForKey:@"url"];
        NSString *title = [routerParameters[MGJRouterParameterUserInfo] objectForKey:@"title"];
        
        XKWebViewController *controller = [XKWebViewController WebControllerWithURLString:url];
        if (![NSString isNull:title]) {
            controller.title = title;
        }
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterOrderDetail toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        UIViewController *topVC = [currentNC topViewController];
        if ([topVC isMemberOfClass:[MIOrderDetailVC class]]) return;
        
        NSString *orderNo = [routerParameters[MGJRouterParameterUserInfo] objectForKey:@"orderNo"];
        if ([NSString isNull:orderNo]) {
            XKShowToast(@"订单号为空");
            return;
        }
        XKOrderType orderType = [[routerParameters[MGJRouterParameterUserInfo] objectForKey:@"orderType"] intValue];
        MIOrderDetailVC *controller = [[MIOrderDetailVC alloc] initWithOrderID:orderNo andType:orderType];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterActivity toHandler:^(NSDictionary *routerParameters) {
        XKActivityType activity = [[routerParameters[MGJRouterParameterUserInfo] objectForKey:@"activityType"] intValue];
        UINavigationController *currentNC = [self currentNC];
        switch (activity) {
            case Activity_WG:{
                
                //HMLimitBuyBaseVC *controller = [[HMLimitBuyBaseVC alloc] init];
               // HMWgVC *controller = [[HMWgVC alloc] init];
                ACTWgVC *controller = [[ACTWgVC alloc] init];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Discount:{
                ACTDiscountBuyVC *controller = [[ACTDiscountBuyVC alloc] init];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_ZeroBuy:{
                ACTZeroBuyVC *controller = [[ACTZeroBuyVC alloc] init];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Bargain:{
                ACTBargainVC *controller = [[ACTBargainVC alloc] init];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Global:{
                ACTGlobalSellerVC *controller = [[ACTGlobalSellerVC alloc] init];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Custom:{
                CTCustomGroupBaseVC *controller = [[CTCustomGroupBaseVC alloc] init];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    [MGJRouter registerURLPattern:kRouterGoods toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *params = routerParameters[MGJRouterParameterUserInfo];
        XKActivityType activity = [[params objectForKey:@"activityType"] intValue];
        UINavigationController *currentNC = [self currentNC];
        switch (activity) {
            case Activity_WG:{
                XKWugGoodDetailVC *controller = [[XKWugGoodDetailVC alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Discount:{
                XKDiscountGoodDetail *controller = [[XKDiscountGoodDetail alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_ZeroBuy:{
                XKZeroBuyGoodDetailVC *controller = [[XKZeroBuyGoodDetailVC alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Bargain:{
                XKBargainGoodDetailVC *controller = [[XKBargainGoodDetailVC alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Global:{
                XKGlobalGoodDetailVC *controller = [[XKGlobalGoodDetailVC alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_Custom:{
                XKCustomGoodDetailVC *controller = [[XKCustomGoodDetailVC alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            case Activity_NewUser:{
                XKNewUserGoodDetailVC *controller = [[XKNewUserGoodDetailVC alloc] initWithActivityGoodID:params[@"id"] andActivityType:activity];
                [currentNC pushViewController:controller animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    [MGJRouter registerURLPattern:kRouterWg toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        //HMLimitBuyBaseVC *controller = [[HMLimitBuyBaseVC alloc] init];
       // HMWgVC *controller = [[HMWgVC alloc] init];
        ACTWgVC *controller = [[ACTWgVC alloc] init];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterMutilBuy toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        ACTDiscountBuyVC *controller = [[ACTDiscountBuyVC alloc] init];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterZeroBuy toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        ACTZeroBuyVC *controller = [[ACTZeroBuyVC alloc] init];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterGlobalBuy toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        ACTGlobalSellerVC *controller = [[ACTGlobalSellerVC alloc] init];
        [currentNC pushViewController:controller animated:YES];
    }];

    [MGJRouter registerURLPattern:kRouterBargain toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        ACTBargainVC *controller = [[ACTBargainVC alloc] init];
        [currentNC pushViewController:controller animated:YES];
    }];
    [MGJRouter registerURLPattern:kRouterCustomAssemble toHandler:^(NSDictionary *routerParameters) {
        UINavigationController *currentNC = [self currentNC];
        CTCustomGroupBaseVC *controller = [[CTCustomGroupBaseVC alloc] init];
        [currentNC pushViewController:controller animated:YES];
    }];

    [MGJRouter registerURLPattern:kRouterSearchShop toHandler:^(NSDictionary *routerParameters) {
        NSString *searchText = [routerParameters[MGJRouterParameterUserInfo] objectForKey:@"searchText"];
        NBSearchShopsVC *controller = [[NBSearchShopsVC alloc] initWithSearchText:searchText];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterSearchGoods toHandler:^(NSDictionary *routerParameters) {
        NSString *searchText = [routerParameters[MGJRouterParameterUserInfo] objectForKey:@"searchText"];
        HMSearchGoodsVC *controller = [[HMSearchGoodsVC alloc] initWithSearchText:searchText];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    //实名认证
    [MGJRouter registerURLPattern:kRouterAuthen toHandler:^(NSDictionary *routerParameters) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        UIViewController *controller = nil;
        BOOL ver = [[XKAccountManager defaultManager] isVer];
        if (ver) {//实名认证
            controller = [story instantiateViewControllerWithIdentifier:@"MIVerifiedVC"];
        }else{
            controller = [story instantiateViewControllerWithIdentifier:@"MIVerifyVC"];
        }
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    //点评任务
    [MGJRouter registerURLPattern:kRouterComment toHandler:^(NSDictionary *routerParameters) {
        CTDesignerVC *controller = [[CTDesignerVC alloc] init];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    //线下买单
    [MGJRouter registerURLPattern:kRouterNearShop toHandler:^(NSDictionary *routerParameters) {
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([vc isKindOfClass:[UITabBarController class]]) {
            RTRootNavigationController *nav =  (RTRootNavigationController *)[(UITabBarController *)vc selectedViewController];
            if ([nav isKindOfClass:[UINavigationController class]]) {
                [nav popToRootViewControllerAnimated:NO];
            }
            [(UITabBarController *)vc setSelectedIndex:2];
        }
    }];
    
    [MGJRouter registerURLPattern:kRouterAdvertising toHandler:^(NSDictionary *routerParameters) {
        MIAdvertisingVC *controller = [[MIAdvertisingVC alloc] init];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    //新人专区
    [MGJRouter registerURLPattern:kRouterNewUser toHandler:^(NSDictionary *routerParameters) {
        ACTNewUserVC *controller = [[ACTNewUserVC alloc] init];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    //新品价到
    [MGJRouter registerURLPattern:kRouterNewGoods toHandler:^(NSDictionary *routerParameters) {
        ACTNewGoodsVC *controller = [[ACTNewGoodsVC alloc] init];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterLogistics toHandler:^(NSDictionary *routerParameters) {
        XKOrderBaseModel *model = routerParameters[MGJRouterParameterUserInfo][@"OrderBaseModel"];

        XKLogisticsVC *controller = [[XKLogisticsVC alloc] initWithOrderModel:model];
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    
    [MGJRouter registerURLPattern:kRouterSearchFriend toHandler:^(NSDictionary *routerParameters) {
        XKSearchFriendViewController *controller = [[XKSearchFriendViewController alloc] init];
        void(^phoneBlock)(NSString *phone,NSString *userId) = routerParameters[MGJRouterParameterUserInfo][@"phoneBlock"];
        controller.phoneBlock = phoneBlock;
        UINavigationController *currentNC = [self currentNC];
        [currentNC pushViewController:controller animated:YES];
    }];
    [MGJRouter registerURLPattern:kRouterCustomer toHandler:^(NSDictionary *routerParameters) {
#pragma mark 总之, 要自定义UI层  请参考 MQChatViewStyle.h类中的相关的方法 ,要修改逻辑相关的 请参考MQChatViewManager.h中相关的方法
#pragma mark  最简单的集成方法: 全部使用meiqia的,  不做任何自定义UI.
        //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        //    [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"meiqia-icon"]];
        //    [chatViewManager pushMQChatViewControllerInViewController:self];
#pragma mark  觉得返回按钮系统的太丑 想自定义 采用下面的方法
        
        UINavigationController *currentNC = [self currentNC];
        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        MQChatViewStyle *aStyle = [chatViewManager chatViewStyle];
        [aStyle setNavBarTintColor:HexRGB(0x444444, 1.0f)];
        [aStyle setNavBackButtonImage:[UIImage imageNamed:@"Return"]];
        [aStyle setEnableRoundAvatar:YES];
        [aStyle setEnableOutgoingAvatar:YES];
        [aStyle setEnableIncomingAvatar:YES];
        [aStyle setOutgoingBubbleColor:COLOR_TEXT_BROWN];
        [aStyle setIncomingBubbleColor:HexRGB(0xffffff, 1.0f)];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *userName = [[XKAccountManager defaultManager] name];
        NSString *avatar = [[XKAccountManager defaultManager] headUrl];
        //NSString *userId = [[XKAccountManager defaultManager] userId];
        if (![NSString isNull:userName]) {
            [dict setObject:userName forKey:@"name"];
        }
        if (![NSString isNull:avatar]) {
            [dict setObject:avatar forKey:@"avatar"];
        }else{
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"default_a" ofType:@"png"];
            if(imagePath)[dict setObject:imagePath forKey:@"avatar"];
        }
        [chatViewManager enableSyncServerMessage:YES];
        [chatViewManager setClientInfo:dict];
//        [chatViewManager setLoginMQClientId:userId];
        chatViewManager.chatViewStyle.backgroundColor = COLOR_HEX(0xf4f4f4);
        [chatViewManager presentMQChatViewControllerInViewController:currentNC];
#pragma mark 觉得头像 方形不好看 ,设置为圆形.
        //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        //    MQChatViewStyle *aStyle = [chatViewManager chatViewStyle];
        //    [aStyle setEnableRoundAvatar:YES];
        //    [aStyle setEnableOutgoingAvatar:NO]; //不显示用户头像
        //    [aStyle setEnableIncomingAvatar:NO]; //不显示客服头像
        //    [chatViewManager pushMQChatViewControllerInViewController:self];
#pragma mark 导航栏 右按钮 想自定义 ,但是不到万不得已,不推荐使用这个,会造成meiqia功能的缺失,因为这个按钮 1 当你在工作台打开机器人开关后 显示转人工,点击转为人工客服. 2在人工客服时 还可以评价客服
        //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        //    MQChatViewStyle *aStyle = [chatViewManager chatViewStyle];
        //    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [bt setImage:[UIImage imageNamed:@"meiqia-icon"] forState:UIControlStateNormal];
        //    [aStyle setNavBarRightButton:bt];
        //    [chatViewManager pushMQChatViewControllerInViewController:self];
#pragma mark 客户自定义信息
        //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        ////    [chatViewManager setClientInfo:@{@"name":@"123测试",@"gender":@"man11",@"age":@"100"} override:YES];
        //    [chatViewManager setClientInfo:@{@"name":@"123测试",@"gender":@"man11",@"age":@"100"}];
        //    [chatViewManager pushMQChatViewControllerInViewController:self];
        
#pragma mark 预发送消息
        //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        //    [chatViewManager setPreSendMessages: @[@"我想咨询的订单号：【1705045496811】"]];
        //    [chatViewManager pushMQChatViewControllerInViewController:self];
        
#pragma mark 如果你想绑定自己的用户系统 ,当然推荐你使用 客户自定义信息来绑定用户的相关个人信息
#pragma mark 切记切记切记  一定要确保 customId 是唯一的,这样保证  customId和meiqia生成的用户ID是一对一的
        //    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
        //    NSString *customId = @"获取你们自己的用户ID 或 其他唯一标识的";
        //    if (customId){
        //        [chatViewManager setLoginCustomizedId:customId];
        //    }else{
        //   #pragma mark 切记切记切记 下面这一行是错误的写法 , 这样会导致 ID = "notadda" 和 meiqia多个用户绑定,最终导致 对话内容错乱 A客户能看到 B C D的客户的对话内容
        //        //[chatViewManager setLoginCustomizedId:@"notadda"];
        //    }
        //    [chatViewManager pushMQChatViewControllerInViewController:self];
    }];
}

+ (UINavigationController *)currentNC{
    if (![[UIApplication sharedApplication].windows.lastObject isKindOfClass:[UIWindow class]]) {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentNCFrom:rootViewController];
}

//递归
+ (UINavigationController *)getCurrentNCFrom:(UIViewController *)vc{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UINavigationController *nc = ((UITabBarController *)vc).selectedViewController;
        return [self getCurrentNCFrom:nc];
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentNCFrom:((UINavigationController *)vc).presentedViewController];
        }
        if ([vc isKindOfClass:[RTRootNavigationController class]]) {
            return [self getCurrentNCFrom:((RTRootNavigationController *)vc).rt_topViewController];
        }else{
            return [self getCurrentNCFrom:((UINavigationController *)vc).topViewController];
        }
    }else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentedViewController) {
            return [self getCurrentNCFrom:vc.presentedViewController];
        }else {
            return [self getCurrentNCReverseFrom:vc];
        }
    }else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}

+ (UINavigationController *)getCurrentNCReverseFrom:(UIViewController *)vc{
    if (vc.navigationController) return vc.navigationController;
    if (vc.presentingViewController) return [self getCurrentNCReverseFrom:vc.presentingViewController];
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    }else{
        return nil;
    }
}

+ (UITabBarController *)getCurrentTBFrom:(UIViewController *)vc{
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)vc;
    }else if ([vc isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)vc).presentedViewController) {
            return [self getCurrentTBFrom:((UINavigationController *)vc).presentedViewController];
        }
        if ([vc isKindOfClass:[RTRootNavigationController class]]) {
            return [self getCurrentTBFrom:((RTRootNavigationController *)vc).rt_topViewController];
        }else{
            return [self getCurrentTBFrom:((UINavigationController *)vc).topViewController];
        }
    }else if ([vc isKindOfClass:[UIViewController class]]) {
        if (vc.presentingViewController) {
            return [self getCurrentTBFrom:vc.presentingViewController];
        }
        return nil;
    }else {
        NSAssert(0, @"未获取到导航控制器");
        return nil;
    }
}
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}
+ (BOOL)isValidScheme:(NSString *)string{
    NSString *str = [string uppercaseString];
    return [str hasPrefix:@"XK://"];
}

@end
