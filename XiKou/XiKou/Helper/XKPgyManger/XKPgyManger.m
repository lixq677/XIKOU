//
//  XKPgyManger.m
//  XiKou
//
//  Created by L.O.U on 2019/7/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPgyManger.h"
#import "XKNetworkManager.h"
#import "XKPgyUpdateView.h"
#import "XKDataService.h"
#import "XKOtherService.h"

@implementation XKPgyManger

+ (void)checkUpdate{
    [[XKFDataService() otherService] queryTheLastestAppVersionWithCompletion:^(XKVersionResponse * _Nonnull response) {
        if (response.isSuccess) {
            NSString *version = [response.data foreignVersionNumber];
            NSUInteger build = [[response.data internallyVersionNumber] intValue];
            BOOL hasUpdate = [self isUpdateWithAppVersion:version buildNumber:build];
            if (hasUpdate) {
                NSString *updateContent = [response.data versionNotes];
                NSString *updateUrl = @"itms-services://?action=download-manifest&url=https://xikou-app.luluxk.com/iOS-app/manifest.plist";//[response.data downloadLink];
                XKPgyUpdateView *view = [[XKPgyUpdateView alloc]initWithContent:updateContent forceUpdate:response.data.ifForceUpdate];
                view.sureBlock = ^{
                    NSURL *URL = [NSURL URLWithString:updateUrl];
                    UIApplication *application = [UIApplication sharedApplication];
                    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                        
                    }];
                };
                [view show];
            }
        }
    }];
    
    
    

}


+ (BOOL)isUpdateWithAppVersion:(NSString *)version buildNumber:(NSInteger)buildNum{
    NSString *localVerson= APP_VERSION;//获取本地版本号
    //将版本号按照.切割后存入数组中
    NSArray *localArray = [localVerson componentsSeparatedByString:@"."];
    NSArray *appArray = [version componentsSeparatedByString:@"."];
    NSInteger minArrayLength = MIN(localArray.count, appArray.count);
    BOOL needUpdate = NO;
    BOOL same = YES;
    for(int i=0;i<minArrayLength;i++){//以最短的数组长度为遍历次数,防止数组越界
        NSString *localElement = localArray[i];
        NSString *appElement = appArray[i];
        NSInteger localValue = localElement.integerValue;
        NSInteger appValue = appElement.integerValue;
        if(localValue<appValue) {
            needUpdate = YES;
            same = NO;
            break;
        }else if (localValue > appValue){
            needUpdate = NO;
            same = NO;
            break;
        }else{
            needUpdate = NO;
        }
    }
    if (same){
        NSString *bap = APP_BUILD;
        int bapNm = [bap intValue];;
        if (buildNum > bapNm) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return needUpdate;
    }
}

@end
