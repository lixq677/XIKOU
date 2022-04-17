//
//  SVProgressHUD+Info.h
//  XiKou
//
//  Created by L.O.U on 2019/7/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVProgressHUD (Info)

/**< 成功显示*/
+ (void)xk_showSuccessWithStatus:(NSString *)SuccessString
               dismissWithDelay:(NSTimeInterval )dismissTime;

/**< 成功显示*/
+ (void)xk_showSuccessWithStatus:(NSString *)SuccessString;

/**< 失败*/
+ (void)xk_showErrorWithStatus:(NSString *)ErrorString
             dismissWithDelay:(NSTimeInterval )dismissTime;

/**< 失败*/
+ (void)xk_showErrorWithStatus:(NSString *)ErrorString;


/**< 信息展示*/
+ (void)xk_showInfoWithStatus:(NSString *)InfoString
            dismissWithDelay:(NSTimeInterval )dismissTime;

/**< 信息展示*/
+ (void)xk_showInfoWithStatus:(NSString *)InfoString;
@end

void XKShowToast(NSString *format, ...);

void XKShowToastCompletionBlock(NSString *string,void(^completionBlock)(void));

NS_ASSUME_NONNULL_END
