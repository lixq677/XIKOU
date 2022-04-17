//
//  BaseViewController.h
//  XiKou
//
//  Created by Tony on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKEmptyView.h"
#import "XKUnitls.h"
#import "XKUIUnitls.h"
#import "XKDataService.h"
#import <RTRootNavigationController.h>

typedef NS_ENUM(int,XKNavigationBarStyle) {
    XKNavigationBarStyleDefault     =   0,
    XKNavigationBarStyleTranslucent =   1,
};


@interface BaseViewController : UIViewController

@property (nonatomic,copy)BOOL(^willPopBlock)(void);

@property (nonatomic,assign)XKNavigationBarStyle navigationBarStyle;

- (void)addNavigationItemWithImageName:(NSString *)imageName isLeft:(BOOL)isLeft target:(id)target action:(SEL)action;

- (void)addNavigationItemWithTitle:(NSString *)title isLeft:(BOOL)isLeft target:(id)target action:(SEL)action;
/**
 *  跳转登陆页面
 *
 */
- (void)enterLoginVC;

/*退出到某个类c的对象*/
- (BOOL)popToViewController:(Class)class;

- (BOOL)contailController:(Class)class;

- (BOOL)isCurrentViewControllerVisible;

/**
 *  返回，便于子类拦截
 *
 */
- (void)backAction:(id)sender;

- (void)showNoNetworkRelaodSel:(SEL)sel;

- (void)hideNoNetwork;

@end
