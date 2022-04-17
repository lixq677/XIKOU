//
//  RootViewController.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "RootViewController.h"
#import "XKNetworkManager.h"
#import "HomeViewController.h"
#import "NearByViewController.h"
#import "MineViewController.h"

#import "XKUIUnitls.h"
#import "XKTabBar.h"
#import "CustomSheet.h"
#import "CTCustomGroupBaseVC.h"
#import "CTHallVC.h"
#import "CTDesignerVC.h"
#import "HMRankVC.h"
#import <RTRootNavigationController.h>
#import "XKPgyManger.h"


@interface RootViewController ()<XKTabBarDelegate,UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initiation];
    [self addChildViewControllers];
    
    /*检查网络状态*/
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)initiation{
//    XKTabBar *tabBar = [[XKTabBar alloc] init];
//    tabBar.tintColor = HexRGB(0x444444, 1.0f);
//    tabBar.tabBarDelegate = self;
//    [self setValue:tabBar forKey:@"tabBar"];
    
    self.delegate = self;
    self.tabBar.tintColor = HexRGB(0x444444, 1.0f);
    self.tabBar.backgroundImage     = [UIImage new];
    self.tabBar.shadowImage         = [UIImage new];
    self.tabBar.layer.shadowColor   = [UIColor colorWithWhite:0 alpha:0.03].CGColor;
    self.tabBar.layer.shadowOffset  = CGSizeMake(-0.5, -2);
    self.tabBar.layer.shadowOpacity = 1;
    self.tabBar.layer.shadowRadius  = 2.5;
    self.tabBar.translucent = NO;
    //设置导航栏颜色
    [[UINavigationBar appearance] setTintColor:HexRGB(0x444444, 1.0f)];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
  
    //设置textField
    [[UITextField appearance] setFont:[UIFont systemFontOfSize:15.0f]];
    [[UITextField appearance] setTintColor:HexRGB(0xcccccc, 1.0f)];
    //    UIImage *backImage = [[UIImage imageNamed:@"Return"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 0) resizingMode:UIImageResizingModeTile];
    //    [[UIBarButtonItem appearance] setBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, -500) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}forState:UIControlStateNormal];
    
    [XKPgyManger checkUpdate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTintColor:HexRGB(0x444444, 1.0f)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexRGB(0x444444, 1.0f)}];
}

- (void)addChildViewControllers {
    // 首页
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addOneChildViewController:homeVC title:@"首页" normalImage:[UIImage imageNamed:@"ic_home_default"] pressedImage:[UIImage imageNamed:@"ic_home_select"] navigationBarTitle:@"首页"];
    
    // 热排行
    HMRankVC *rankVC = [[HMRankVC alloc] init];
    [self addOneChildViewController:rankVC title:@"热排行" normalImage:[UIImage imageNamed:@"ic_hotrank_default"] pressedImage:[UIImage imageNamed:@"ic_hotrank_select"] navigationBarTitle:@"热排行"];
    
    // 附近
    NearByViewController *nearByVC  = [[NearByViewController alloc] init];
    [self addOneChildViewController:nearByVC title:@"附近" normalImage:[UIImage imageNamed:@"ic_nearby_default"] pressedImage:[UIImage imageNamed:@"ic_nearby_select"] navigationBarTitle:@"附近"];
    // 我的
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addOneChildViewController:mineVC title:@"我的" normalImage:[UIImage imageNamed:@"ic_mine_default"] pressedImage:[UIImage imageNamed:@"ic_mine_select"] navigationBarTitle:@"我的"];
}

#pragma mark - 添加1个子控制器
- (void)addOneChildViewController:(UIViewController *)viewController
                            title:(NSString *)menutitle
                      normalImage:(UIImage *)normalImage
                     pressedImage:(UIImage *)pressedImage
               navigationBarTitle:(NSString *)title{
    
    viewController.tabBarItem.title = menutitle;
    [viewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5.0f)];
    // 设置标签图片
    viewController.tabBarItem.image = normalImage;
    viewController.tabBarItem.selectedImage = pressedImage;
    
    //设置默认文字样式颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] =  HexRGB(0x999999, 1.0);
    //设置默认文字大小
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [viewController.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = HexRGB(0x999999, 1.0);
    //设置选中文字大小
    selectedTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [viewController.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    RTRootNavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

- (void)tabBarPlusBtnClick:(XKTabBar *)tabBar{
    CustomSheet *sheet = [[CustomSheet alloc] init];
    sheet.actionAssembleBlock = ^{
        CTCustomGroupBaseVC *controller = [[CTCustomGroupBaseVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    };
    sheet.actionHallBlock = ^{
        CTHallVC *controller = [[CTHallVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    };
    sheet.actionDesignerBlock =^{
        CTDesignerVC *controller = [[CTDesignerVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    };

    [sheet show];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //self.navigationItem.title = viewController.tabBarItem.title;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    return YES;
}

//- (void)hideTabBar:(BOOL)hide animated:(BOOL)animated{
//    
//    CGFloat barHeight = 49.f + [XKUIUnitls safeBottom];
//    if (hide == YES)
//    {
//        if (self.tabBar.frame.origin.y == self.view.frame.size.height) return;
//    }
//    else
//    {
//        if (self.tabBar.frame.origin.y == self.view.frame.size.height - barHeight) return;
//    }
//    if (animated){
//        [UIView animateWithDuration:0.3 animations:^{
//            if (hide){
//                self.tabBar.y = self.tabBar.frame.origin.y + barHeight;
//            }else{
//                self.tabBar.y = self.tabBar.frame.origin.y - barHeight;
//            }
//        }];
//    }else{
//        if (hide){
//            self.tabBar.y = self.tabBar.frame.origin.y + barHeight;
//        }else{
//            self.tabBar.y = self.tabBar.frame.origin.y - barHeight;
//        }
//    }
//}

@end
