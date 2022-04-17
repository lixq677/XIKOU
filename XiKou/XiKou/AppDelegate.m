//
//  AppDelegate.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "AppDelegate.h"
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UMAnalytics/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MeiQiaSDK/MeiQiaSDK.h>
#import <TABAnimated/TABAnimated.h>
#import "XKNetworkConfig.h"
#import "XKAccountManager.h"
#import "WXApiManager.h"
#import "XKNetworkManager.h"
#import "XKThirdMarco.h"
#import "XKShareTool.h"
#import "XKPayManger.h"
#import <NilSafetyManager.h>
#import "StartupVC.h"
#import "RootViewController.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self networkConfig];
    [self normalConfig];
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       [self openSouceConfig:launchOptions];
    //});
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    @weakify(self);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"custom_launcher" ofType:@"mp4"];
    StartupVC *controller = [[StartupVC alloc] initWithPath:filePath enterBlock:^{
        @strongify(self);
        RootViewController *rc = [[RootViewController alloc] init];
        self.window.rootViewController = rc;
    } configuration:nil];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate = self;
//    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (!error) {
//            NSLog(@"succeeded!");
//        }
//    }];
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
  
    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"] && [url.absoluteString containsString:@"wx_oauth_authorization_state"]) {
        [[WXApiManager defaultManager] handleOpenURL:url options:options];
        
    }else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",kWXAppKey]].location != NSNotFound) {
        [[WXApiManager defaultManager] handleOpenURL:url options:options];
    }else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",[XKAccountManager defaultManager].weixinPayKey]].location != NSNotFound){
        [[WXApiManager defaultManager] handleOpenURL:url options:options];
    }else{
        BOOL result =  [[UMSocialManager defaultManager] handleOpenURL:url options:options];
        if (result) {
            [[UMSocialManager defaultManager] handleOpenURL:url options:options];
        }else{
            // 其他如支付等SDK的回调
            if ([url.host isEqualToString:@"safepay"]) {
                [[XKPayManger sharedMange]applicationAlipayOpenURL:url];
            }
        }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#pragma mark  集成第三步: 进入后台 关闭美洽服务
    [MQManager closeMeiqiaService];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
#pragma mark  集成第二步: 进入前台 打开meiqia服务
    [MQManager openMeiqiaService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
#pragma mark  集成第四步: 上传设备deviceToken
    [MQManager registerDeviceToken:deviceToken];
    [UMessage registerDeviceToken:deviceToken];
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                        stringByReplacingOccurrencesOfString: @">" withString: @""]
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken:%@",token);
    [MobClick event:@"deviceToken" attributes:@{@"token":token}];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [[WXApiManager defaultManager] handleOpenUniversalLink:userActivity];
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [UMessage setBadgeClear:YES];
        NSString *url = [userInfo objectForKey:@"url"];
        if ([XKGlobalModuleRouter isValidScheme:url]) {
            [MGJRouter openURL:url];
        }else if ([url isUrl]){
            [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":url} completion:nil];
        }else{
            // XKShowToast(@"未能识别的字符串");
        }
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)openSouceConfig:(NSDictionary *)launchOptions{
    /*设置微信开放平台*/
    //向微信注册
    [[WXApiManager defaultManager] registerApp:kWXAppKey];
    [[XKShareTool defaultTool]setUp];
    
    
    /*友盟 日志*/
    /*支持普通场景*/
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [MobClick setScenarioType:E_UM_NORMAL];
    [UMConfigure initWithAppkey:kUMAppKey channel:nil];
    
#ifdef DEBUG
    [MobClick setCrashReportEnabled:NO];    //关闭错误统计
#else
    [MobClick setCrashReportEnabled:YES];   //打开错误统计
#endif
    
  //  NSString * deviceID =[UMConfigure deviceIDForIntegration];
   // NSLog(@"集成测试的deviceID:%@", deviceID);
    
    /*友盟推送*/
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"获取推送权限");
        }else{
            NSLog(@"获取推送权限失败");
        }
    }];
    
#pragma mark  集成第一步: 初始化,  参数:appkey  ,尽可能早的初始化appkey.
    [MQManager initWithAppkey:keyMeiqia completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            NSLog(@"美洽 SDK：初始化成功");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
    /*配置高德地图key*/
    [AMapServices sharedServices].apiKey = kMapApiKeyGaode;
    
}

- (void)networkConfig{
    /*设置token*/
    NSString *token = [[XKAccountManager defaultManager] account].token;
    if (token) {
        [[XKNetworkConfig shareInstance] setToken:token];
    }
    [XKNetworkManager getNetworkStatusWithBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiNetworkChange object:@(status)];
    }];
}

- (void)normalConfig{
    /*appstore 越界处理*/
#if APPSTORE
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
#else
    [[NilSafetyManager sharedInstance] setupWithOdds:1.0f];
#endif
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];//设置HUD的Style
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//设置HUD和文本的颜色
    [SVProgressHUD setBackgroundColor:COLOR_TEXT_BLACK];//设置HUD的背景颜色
    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];//字体
    [SVProgressHUD setCornerRadius:5.f];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = NO;
    manager.enableAutoToolbar = YES;
    
    [[TABAnimated sharedAnimated] initWithDropAnimated];
    [TABAnimated sharedAnimated].openLog = NO;
    [TABAnimated sharedAnimated].shimmerBackColor = COLOR_VIEW_GRAY;
    [TABAnimated sharedAnimated].useGlobalCornerRadius = NO;
    // 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在下标，方便快速定位某个动画元素。
    [TABAnimated sharedAnimated].openAnimationTag = NO;
    
}

@end
