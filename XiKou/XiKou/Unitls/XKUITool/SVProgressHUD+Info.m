//
//  SVProgressHUD+Info.m
//  XiKou
//
//  Created by L.O.U on 2019/7/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#define HUD_TIME 1.3f
@implementation SVProgressHUD (Info)

+ (void)xk_showSuccessWithStatus:(NSString *)SuccessString
               dismissWithDelay:(NSTimeInterval )dismissTime{
    if (SuccessString && SuccessString.length > 0) {
        [SVProgressHUD showSuccessWithStatus:SuccessString];
        [SVProgressHUD dismissWithDelay:dismissTime];
    }
}

+ (void)xk_showSuccessWithStatus:(NSString *)SuccessString{
    
    [SVProgressHUD xk_showSuccessWithStatus:SuccessString
                          dismissWithDelay:HUD_TIME];
}


+ (void)xk_showErrorWithStatus:(NSString *)ErrorString
             dismissWithDelay:(NSTimeInterval )dismissTime{
    if ([ErrorString isKindOfClass:[NSNull class]]) {
        return;
    }
    if (ErrorString && ErrorString.length > 0) {
        [SVProgressHUD showErrorWithStatus:ErrorString];
        [SVProgressHUD dismissWithDelay:dismissTime];
    }
}

+ (void)xk_showErrorWithStatus:(NSString *)ErrorString{
    
    [SVProgressHUD xk_showErrorWithStatus:ErrorString
                        dismissWithDelay:HUD_TIME];
}


+ (void)xk_showInfoWithStatus:(NSString *)InfoString
            dismissWithDelay:(NSTimeInterval )dismissTime{
    if (InfoString && InfoString.length > 0) {
        [SVProgressHUD showInfoWithStatus:InfoString];
        [SVProgressHUD dismissWithDelay:dismissTime];
    }
}

+ (void)xk_showInfoWithStatus:(NSString *)InfoString{
    
    [SVProgressHUD xk_showInfoWithStatus:InfoString
                       dismissWithDelay:HUD_TIME];
}

/**< 信息展示回调*/
+ (void)xk_showInfoWithStatus:(NSString *)InfoString
          withDismissComplete:(SVProgressHUDDismissCompletion)complete{
    if (InfoString && InfoString.length > 0) {
        [SVProgressHUD showInfoWithStatus:InfoString];
        [SVProgressHUD dismissWithDelay:HUD_TIME completion:complete];
    }
}

@end


//void XKShowToast(NSString *string){
//    [SVProgressHUD xk_showInfoWithStatus:string];
//}

void XKShowToast(NSString *format, ...){
    va_list list;
    va_start(list, format);
    format = [[NSString alloc]initWithFormat:format arguments:list];
    va_end(list);
    [SVProgressHUD xk_showInfoWithStatus:format];
}

void XKShowToastCompletionBlock(NSString *string,void(^completionBlock)(void)){
    [SVProgressHUD xk_showInfoWithStatus:string withDismissComplete:completionBlock];
}
