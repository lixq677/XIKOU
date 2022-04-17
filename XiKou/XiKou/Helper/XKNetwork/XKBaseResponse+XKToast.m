//
//  XKBaseResponse+XKToast.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/13.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseResponse+XKToast.h"
#import "SVProgressHUD+Info.h"

@implementation XKBaseResponse (XKToast)

- (void)showError{
    if([NSString isNull:self.msg]){
        NSError *error = [NSError errorWithCode:self.code.intValue];
        XKShowToast(error.domain);
    }else{
        XKShowToast(self.msg);
    }
}
@end
