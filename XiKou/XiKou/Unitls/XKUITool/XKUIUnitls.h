//
//  XKUIUnitls.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <extobjc.h>
#import "UITextField+XKUnitls.h"
#import "UITextView+XKUnitls.h"
#import "UIImage+XKCommon.h"
#import "UIView+XKFrame.h"
#import <Masonry.h>
#import "XKUnitls.h"
#import "UIColor+XKCommon.h"
#import "NSError+XKNetwork.h"
#import "UIView+XKAdapt.h"
#import "UIView+XKUnitls.h"
#import "XKLoading.h"
#import "MJDIYHeader.h"
#import "XKBaseResponse+XKToast.h"

NS_ASSUME_NONNULL_BEGIN

#define kScreenHeight           CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenWidth            CGRectGetWidth([UIScreen mainScreen].bounds)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_MIN (IS_IPHONE && kScreenWidth == 320.0)
#define IS_IPHONE_NOMAL (IS_IPHONE && kScreenWidth == 375.0)
#define IS_IPHONE_PLUS (IS_IPHONE && kScreenWidth == 414.0)

/*缩放一边，基准是iphone 6*/
static inline float scalef(float x){return (kScreenWidth/375.0f*x);}
/*缩放高度，基准是iphone 6*/
static inline float scalefHeight(float y){return (kScreenHeight/667.f*y);}
/*缩放size，基准是iphone 6*/
static inline CGSize scale_size(float width,float height){return CGSizeMake(width*kScreenWidth/375.0f,height*kScreenWidth/375.0f);}
/*缩放rect，基准是iphone 6*/
static inline CGRect scale_rect(float x,float y, float width,float height){return CGRectMake(x*kScreenWidth/375.0f, y*kScreenWidth/375.0f,width*kScreenWidth/375.0f,height*kScreenWidth/375.0f);}

/*缩放边框*/
static inline UIEdgeInsets scale_edgeInsets(float top,float left, float bottom,float right){return
    UIEdgeInsetsMake(top*kScreenWidth/375.0f, left*kScreenWidth/375.0f, bottom*kScreenWidth/375.0f, right*kScreenWidth/375.0f);}

/*是否iphone*/
static inline BOOL IS_IPHONEX_SERIES() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }else{
        if ([[UIApplication sharedApplication] statusBarFrame].size.height == 44) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight+kNavBarHeight)

@interface XKUIUnitls : NSObject
/*安全底部*/
+ (CGFloat)safeBottom;

/*安全顶部*/
+ (CGFloat)safeTop;


@end

NS_ASSUME_NONNULL_END
