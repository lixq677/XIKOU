//
//  XKShareTool.h
//  XiKou
//
//  Created by L.O.U on 2019/7/31.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKShareView.h"
#import "XKShareManger.h"
#import "XKShareData.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKShareTool : NSObject

+ (instancetype)defaultTool;

- (void)setUp;

@property (nonatomic, copy) void(^photoCallBack)( NSString * _Nullable url);

/**
 分享
 @param data           获取分享数据的请求体
 @param title          分享标题
 @param content        内容
 @param needPhoto      是否需要保存本地的图片按钮
 @param type  UI       类型
 */
- (void)shareWithModel:(XKShareRequestModel *)data
              andTitle:(NSString *)title
            andContent:(NSString *__nullable)content
          andNeedPhoto:(BOOL)needPhoto
             andUIType:(ShareUIType)type;

/**
 分享
 @param title          分享标题
 @param image          图片
 @param thumb          缩略图
 @param needPhoto      是否需要保存本地按钮
 */
- (void)shareWithTitle:(NSString *)title
                 Image:(UIImage *)image
              andThumb:(UIImage *)thumb
          andNeedPhtot:(BOOL)needPhoto;


/// 分享
/// @param data <#data description#>
/// @param callbackModel <#callbackModel description#>
/// @param title <#title description#>
/// @param content <#content description#>
/// @param needSina <#needSina description#>
/// @param needPhoto <#needPhoto description#>
- (void)shareWithData:(XKShareData *)data
andCallbackModel:(XKShareRequestModel *__nullable)callbackModel
        andTitle:(NSString *)title
      andContent:(NSString *__nullable)content
     andNeedSina:(BOOL)needSina
         andNeedPhoto:(BOOL)needPhoto;



/**
 分享小程序 UMShareMiniProgramObject

 @param viewTitle 分享视图标题
 @param content 分享视图展示内容文字
 @param url 分享小程序url
 @param imageData 分享小程序缩略图
 @param shareTitle 分享到小程序的标题
 */
- (void)shareProgramWithViewTitle:(NSString *)viewTitle
                       andContent:(NSString *__nullable)content
                           andUrl:(NSString *)url
                         andImage:(NSData *)imageData
                    andShareTitle:(NSString *)shareTitle;


/**
 分享微信公众号

 @param viewTitle <#viewTitle description#>
 @param content <#content description#>
 @param url <#url description#>
 @param imageData <#imageData description#>
 @param shareTitle <#shareTitle description#>
 */
- (void)shareWxOfficialAccountsPlatformWithViewTitle:(NSString *)viewTitle
                                          andContent:(NSString *__nullable)content
                                              andUrl:(NSString *)url
                                            andImage:(NSData *)imageData
                                       andShareTitle:(NSString *)shareTitle;
@end

NS_ASSUME_NONNULL_END
