//
//  XKShareManger.m
//  XiKou
//
//  Created by L.O.U on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShareManger.h"

#import <UserNotifications/UserNotifications.h>
//#import <UShareUI/UShareUI.h>

@implementation XKShareManger

#pragma mark - share type

//分享文本
+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType
                       withText:(NSString *)text
                          block:(ResultBlock)result{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        [self handResult:data andError:error andResult:^(BOOL isSuccess) {
            result(isSuccess);
        }];
    }];
}

//分享图片
+ (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
                       withThumb:(id)thumb
                           image:(id)image
                           block:(ResultBlock)result{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage = thumb;
    [shareObject setShareImage:image];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        [self handResult:data andError:error andResult:^(BOOL isSuccess) {
            result(isSuccess);
        }];
    }];
}

//分享网络图片
+ (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType
                          withThumb:(id)thumb
                              image:(id)image
                              block:(ResultBlock)result{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumb;
    [shareObject setShareImage:image];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        [self handResult:data andError:error andResult:^(BOOL isSuccess) {
            result(isSuccess);
        }];
    }];
}

//网页分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                         withTitle:(NSString *)title
                             descr:(NSString *)descr
                               url:(NSString *)url
                             thumb:(id)thumb
                             block:(ResultBlock)result{
    if (!thumb) {
        thumb = [UIImage imageNamed:@"qidong_logo"];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumb];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    __block BOOL callBack = NO;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (callBack == NO) {
            callBack = YES;
            [self handResult:data andError:error andResult:^(BOOL isSuccess) {
                result(isSuccess);
            }];
        }
    }];
}

//分享小程序
+ (void)shareProgramToPlatformType:(UMSocialPlatformType)platformType
                          withPath:(NSString *)path
                             title:(NSString *)title
                             image:(NSData *)imageData
                          userName:(NSString *)userName
                             block:(ResultBlock)result{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject new];
    shareObject.title       = title;
    //设置网页地址
    shareObject.path        = path;
    shareObject.webpageUrl  = path;
    shareObject.userName    = userName;
    shareObject.hdImageData = imageData;
    shareObject.miniProgramType = UShareWXMiniProgramTypePreview;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        [self handResult:data andError:error andResult:^(BOOL isSuccess) {
            result(isSuccess);
        }];
    }];
    
}

+ (void)handResult:(id)data andError:(NSError *)error andResult:(ResultBlock)result{
    if (error) {
        [self alertWithError:error];
        result(NO);
        UMSocialLogInfo(@"************Share fail with error %@*********",error);
    }else{
        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
            UMSocialShareResponse *resp = data;
            //分享结果消息
            UMSocialLogInfo(@"response message is %@",resp.message);
            //第三方原始返回的数据
            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            
        }else{
            UMSocialLogInfo(@"response data is %@",data);
        }
        result(YES);
    }
}

+ (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
    }else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@\n", error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"分享失败:%@",str];
        }else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    NSLog(@"shareresult ======================== %@",result);
}

@end
