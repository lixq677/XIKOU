//
//  XKUnitls.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+XKUnitls.h"
#import "NSURL+XKUnitls.h"
#import <YYModel.h>
#import <extobjc.h>

NS_ASSUME_NONNULL_BEGIN

/** 程序版本号 */

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** 获取APP build版本 */
#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

typedef NS_ENUM(int,XKDeviceType) {
    XKDeviceTypeUnknown =   0,//未知
    XKDeviceTypePhone   =   1,//手机
    XKDeviceTypePad     =   2//平板
};


@interface XKUnitls : NSObject

+(NSString*)createUUID;

/** 读取缓存 */
+(float)readCacheSize;

/** 清除缓存 */
+ (void)clearFile;

/*获取版本号*/
+(NSString*)getAppVersion;

/*获取bundleId*/
+(NSString*)getBundleID;

/*获取app名字*/
+(NSString*)getAppName;

/*获取设备类型*/
+ (XKDeviceType)getCurDevice;

/*系统版本*/
+ (NSString *)getSystemVersion;

/*获取设备型号*/
+ (NSString *)getPlatformString;

@end

NS_ASSUME_NONNULL_END
