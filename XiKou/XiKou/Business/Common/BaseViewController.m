//
//  BaseViewController.m
//  XiKou
//
//  Created by Tony on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKAccountManager.h"
#import "MILoginVC.h"
#import <Aspects.h>
#import "XKNetworkManager.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationBarStyle == XKNavigationBarStyleDefault) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
} 

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.navigationBarStyle == XKNavigationBarStyleDefault) {
           return  UIStatusBarStyleDefault;
       }else{
           return  UIStatusBarStyleLightContent;
       }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
        [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeMemory completion:^{
            NSLog(@"清除缓存");
        }];
    }else{
        [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeMemory completion:^{
            NSLog(@"清除缓存");
        }];
        [[SDWebImageManager sharedManager] cancelAll];
    }
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Return"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    return item;
}

#pragma mark action
- (void)backAction:(id)sender{
    if (self.willPopBlock) {
        if(self.willPopBlock()){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)enterLoginVC {
    MILoginVC *controller = [[MILoginVC alloc] init];
    UINavigationController *nav = [[RTRootNavigationController alloc] initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)showNoNetworkRelaodSel:(SEL)sel{
    if (!self.view.ly_emptyView) {
        LYEmptyView *emptyView = [XKEmptyView networkErrorViewWithTarget:self andSel:sel];
        emptyView.emptyViewIsCompleteCoverSuperView = YES;
        emptyView.backgroundColor = [UIColor whiteColor];
        self.view.ly_emptyView = emptyView;
    }
    [self.view ly_showEmptyView];
}

- (void)hideNoNetwork{
     [self.view ly_hideEmptyView];
}


#pragma mark unit
- (BOOL)popToViewController:(Class)class{
    if (self.navigationController.viewControllers.count <= 0) {
        return NO;
    }
    __block UIViewController *vc = nil;
    [self.rt_navigationController.rt_viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:class]) {
            vc = obj;
            *stop = YES;
        }
    }];
    if (!vc) return NO;
    [self.navigationController popToViewController:vc animated:YES];
    return YES;
}

- (BOOL)contailController:(Class)class{
    if (self.navigationController.viewControllers.count <= 0) {
        return NO;
    }
    __block BOOL isContail = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:class]) {
            isContail = YES;
            *stop = YES;
        }
    }];
    return isContail;
}
#pragma mark ————— 导航栏 添加图片按钮 —————
- (void)addNavigationItemWithImageName:(NSString *)imageName isLeft:(BOOL)isLeft target:(id)target action:(SEL)action{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (isLeft) {
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    }else{
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    }
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

#pragma mark ————— 导航栏 添加文字按钮 —————
- (void)addNavigationItemWithTitle:(NSString *)title isLeft:(BOOL)isLeft target:(id)target action:(SEL)action{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = FontMedium(16.f);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn sizeToFit];
    
    //设置偏移
    if (isLeft) {
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    }else{
        btn.titleLabel.font = Font(14.f);
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)setNavigationBarStyle:(XKNavigationBarStyle)navigationBarStyle{
    if (navigationBarStyle == XKNavigationBarStyleTranslucent) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            self.navigationController.navigationBar.translucent = YES;
        });
    }else{
         [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
                   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
                   [self.navigationController.navigationBar setTintColor:HexRGB(0x444444, 1.0f)];
                   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HexRGB(0x444444, 1.0f)}];
                  
                   self.navigationController.navigationBar.translucent = NO;
        });
    }
    _navigationBarStyle = navigationBarStyle;
}

- (BOOL)isCurrentViewControllerVisible{
    return (self.isViewLoaded && self.view.window);
}

@end
