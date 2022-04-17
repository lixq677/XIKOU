//
//  XKShareManger.h
//  XiKou
//
//  Created by L.O.U on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
NS_ASSUME_NONNULL_BEGIN

typedef void (^ResultBlock)(BOOL isSuccess);
@interface XKShareManger : NSObject

#pragma mark - 无分享界面（需自定义分享界面）
//分享文本
+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
                       withText:(NSString *)text
                          block:(ResultBlock)result;
//分享图片
+ (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
                       withThumb:(id)thumb
                           image:(id)image
                           block:(ResultBlock)result;
//分享网络图片
+ (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType
                          withThumb:(id)thumb
                              image:(id)image
                              block:(ResultBlock)result;
//网页分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                         withTitle:(NSString *)title
                             descr:(NSString *)descr
                               url:(NSString *)url
                             thumb:(id)thumb
                             block:(ResultBlock)result;

//分享小程序
+ (void)shareProgramToPlatformType:(UMSocialPlatformType)platformType
                          withPath:(NSString *)path
                             title:(NSString *)title
                             image:(NSData *)imageData
                          userName:(NSString *)userName
                             block:(ResultBlock)result;

@end

NS_ASSUME_NONNULL_END
