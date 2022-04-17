//
//  XKUnitls.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKUnitls.h"
#import <UserNotifications/UserNotifications.h>
#import <sys/utsname.h>


@implementation XKUnitls

+(NSString*)createUUID{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString* uuidString = [NSString stringWithString:(__bridge NSString*)strRef];
    CFRelease(strRef);
    CFRelease(uuidObj);
    return uuidString;
}

+(float)readCacheSize
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath :cachePath];
}

+ (float)folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
}

+ (long long) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

+ (void)clearFile
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
}


//获取 bundle version版本号

+(NSString*) getAppVersion{
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
}

//获取BundleID
+(NSString*)getBundleID{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

//获取app的名字
+(NSString*) getAppName{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+ (XKDeviceType)getCurDevice{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return XKDeviceTypePhone;
    }else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return XKDeviceTypePad;
    }else{
        return XKDeviceTypeUnknown;
    }
}

+ (NSString *)getSystemVersion{
    NSString *model = [[UIDevice currentDevice] systemName];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    return [model stringByAppendingString:version];
}

//获取ios设备号
+ (NSString *)getPlatformString {
    NSString *padType = @"";
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"]){
        padType = @"ipad";
        return @"iPad";
    }
    if ([deviceString isEqualToString:@"iPad1,2"]){
        padType = @"ipad";
        return @"iPad 3G";
    }
    if ([deviceString isEqualToString:@"iPad2,1"]){
        padType = @"ipad";
        return @"iPad 2 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad2,2"]){
        padType = @"ipad";
        return @"iPad 2";
    }
    if ([deviceString isEqualToString:@"iPad2,3"]){
        padType = @"ipad";
        return @"iPad 2 (CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad2,4"]){
        padType = @"ipad";
        return @"iPad 2";
    }
    if ([deviceString isEqualToString:@"iPad2,5"]){
        padType = @"ipad";
        return @"iPad Mini (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad2,6"]){
        padType = @"ipad";
        return @"iPad Mini";
    }
    if ([deviceString isEqualToString:@"iPad2,7"]){
        padType = @"ipad";
        return @"iPad Mini (GSM+CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad3,1"]){
        padType = @"ipad";
        return @"iPad 3 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad3,2"]){
        padType = @"ipad";
        return @"iPad 3 (GSM+CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad3,3"]){
        padType = @"ipad";
        return @"iPad 3";
    }
    if ([deviceString isEqualToString:@"iPad3,4"]){
        padType = @"ipad";
        return @"iPad 4 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad3,5"]){
        padType = @"ipad";
        return @"iPad 4";
    }
    if ([deviceString isEqualToString:@"iPad3,6"]){
        padType = @"ipad";
        return @"iPad 4 (GSM+CDMA)";
    }
    if ([deviceString isEqualToString:@"iPad4,1"]){
        padType = @"ipad";
        return @"iPad Air (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad4,2"]){
        padType = @"ipad";
        return @"iPad Air (Cellular)";
    }
    if ([deviceString isEqualToString:@"iPad4,4"]){
        padType = @"ipad";
        return @"iPad Mini 2 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad4,5"]){
        padType = @"ipad";
        return @"iPad Mini 2 (Cellular)";
    }
    if ([deviceString isEqualToString:@"iPad4,6"]){
        padType = @"ipad";
        return @"iPad Mini 2";
    }
    if ([deviceString isEqualToString:@"iPad4,7"]){
        padType = @"ipad";
        return @"iPad Mini 3";
    }
    if ([deviceString isEqualToString:@"iPad4,8"]){
        padType = @"ipad";
        return @"iPad Mini 3";
    }
    if ([deviceString isEqualToString:@"iPad4,9"]){
        padType = @"ipad";
        return @"iPad Mini 3";
    }
    if ([deviceString isEqualToString:@"iPad5,1"]){
        padType = @"ipad";
        return @"iPad Mini 4 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad5,2"]){
        padType = @"ipad";
        return @"iPad Mini 4 (LTE)";
    }
    if ([deviceString isEqualToString:@"iPad5,3"]){
        padType = @"ipad";
        return @"iPad Air 2";
    }
    if ([deviceString isEqualToString:@"iPad5,4"]){
        padType = @"ipad";
        return @"iPad Air 2";
    }
    if ([deviceString isEqualToString:@"iPad6,3"]){
        padType = @"ipad";
        return @"iPad Pro 9.7";
    }
    if ([deviceString isEqualToString:@"iPad6,4"]){
        padType = @"ipad";
        return @"iPad Pro 9.7";
    }
    if ([deviceString isEqualToString:@"iPad6,7"]){
        padType = @"ipad";
        return @"iPad Pro 12.9";
    }
    if ([deviceString isEqualToString:@"iPad6,8"]){
        padType = @"ipad";
        return @"iPad Pro 12.9";
    }
    if ([deviceString isEqualToString:@"iPad6,11"]){
        padType = @"ipad";
        return @"iPad 5 (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad6,12"]){
        padType = @"ipad";
        return @"iPad 5 (Cellular)";
    }
    if ([deviceString isEqualToString:@"iPad7,1"]){
        padType = @"ipad";
        return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad7,2"]){
        padType = @"ipad";
        return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    }
    if ([deviceString isEqualToString:@"iPad7,3"]){
        padType = @"ipad";
        return @"iPad Pro 10.5 inch (WiFi)";
    }
    if ([deviceString isEqualToString:@"iPad7,4"]){
        padType = @"ipad";
        return @"iPad Pro 10.5 inch (Cellular)";
    }
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}



@end
