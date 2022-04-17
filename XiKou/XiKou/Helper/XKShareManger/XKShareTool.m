//
//  XKShareTool.m
//  XiKou
//
//  Created by L.O.U on 2019/7/31.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShareTool.h"
#import "XKDataService.h"
#import "XKShareService.h"
#import "XKThirdMarco.h"
#import "WXApi.h"
#import "NSString+XKUnitls.h"
#import "XKAccountManager.h"


@interface XKShareTool ()

@property (nonatomic, strong) XKShareRequestModel *callbackModel;

@end

@implementation XKShareTool


+ (instancetype)defaultTool{
    static XKShareTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self defaultTool];
}

- (void)setUp{
    [self setupUShareSettings];
    [self setupUSharePlatforms];
}

- (void)setupUShareSettings
{
    [UMConfigure initWithAppkey:kUMAppKey channel:@"App Store"];
}

- (void)setupUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppKey appSecret:kWXAppSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kSinaAppKey/*设置sina平台的appID*/  appSecret:nil redirectURL:nil];

}

- (void)shareWithModel:(XKShareRequestModel *)data
              andTitle:(NSString *)title
            andContent:(NSString *__nullable)content
          andNeedPhoto:(BOOL)needPhoto
             andUIType:(ShareUIType)type{
    
    self.callbackModel = data;
    [XKLoading showNeedMask:YES];
    [[XKFDataService() shareService]queryShareDataByModel:data Completion:^(XKShareResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {
            [SVProgressHUD dismiss];
            XKShareData *data = [response data];
            if ([data.url isUrl]) {
                NSURL *url = [NSURL URLWithString:data.url];
                data.url = [self addExtCodeWithUrl:url];
            }
            [self shareWithData:data
               andCallbackModel:self.callbackModel
                       andTitle:title
                     andContent:content
                   andNeedPhoto:needPhoto];
        }else{
            XKShowToast(@"获取活动分享数据失败");
        }
    }];
}

- (void)shareWithData:(XKShareData *)data
     andCallbackModel:(XKShareRequestModel *)callbackModel
             andTitle:(NSString *)title
           andContent:(NSString *__nullable)content
         andNeedPhoto:(BOOL)needPhoto{
    XKShareView *shareView = [[XKShareView alloc]initWithType:ShareUIBottom];
    
    NSArray *shareItems;
    if (needPhoto) {
        shareItems = [self addPlatform:@[@(ShareWX),@(ShareCircle),@(ShareSina),@(SharePhoto)]];
    }else{
        shareItems = [self addPlatform:@[@(ShareWX),@(ShareCircle),@(ShareSina)]];
    }
    
    [shareView showWithTitle:title andContent:content andPlaforms:shareItems andComplete:^(ShareType type) {
        if (type == SharePhoto) {
            if (self.photoCallBack) self.photoCallBack(data.url);
        }else{
            UMSocialPlatformType plateType;
            if (type == ShareWX){
                plateType = UMSocialPlatformType_WechatSession;
            }else if (type == ShareCircle){
                plateType = UMSocialPlatformType_WechatTimeLine;
            }else{
                plateType = UMSocialPlatformType_Sina;
            }
            if (![self checkPlatform:plateType]) {
                XKShowToast(@"尚未检测到相关客户端，分享失败");
                return ;
            }
            [XKShareManger shareWebPageToPlatformType:plateType withTitle:data.title descr:data.content url:data.url thumb:data.imageUrl block:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self handleShareResult];
                    [shareView dismiss];
                    //                    [SVProgressHUD xk_showInfoWithStatus:@"分享成功"];
                }else{
                    XKShowToast(@"分享失败");
                }
                
            }];
        }
    }];
    
}

- (void)shareWithData:(XKShareData *)data
     andCallbackModel:(XKShareRequestModel *)callbackModel
             andTitle:(NSString *)title
           andContent:(NSString *__nullable)content
          andNeedSina:(BOOL)needSina
         andNeedPhoto:(BOOL)needPhoto{
    XKShareView *shareView = [[XKShareView alloc]initWithType:ShareUIBottom];
    
    NSMutableArray *shareItems = [NSMutableArray array];
    [shareItems addObjectsFromArray:[self addPlatform:@[@(ShareWX),@(ShareCircle)]]];
    if (needSina) {
        [shareItems addObjectsFromArray:[self addPlatform:@[@(ShareSina)]]];
    }
    if (needPhoto) {
        [shareItems addObjectsFromArray:[self addPlatform:@[@(needSina)]]];
    }
    
    [shareView showWithTitle:title andContent:content andPlaforms:shareItems andComplete:^(ShareType type) {
        if (type == SharePhoto) {
            if (self.photoCallBack) self.photoCallBack(data.url);
        }else{
            UMSocialPlatformType plateType;
            if (type == ShareWX){
                plateType = UMSocialPlatformType_WechatSession;
            }else if (type == ShareCircle){
                plateType = UMSocialPlatformType_WechatTimeLine;
            }else{
                plateType = UMSocialPlatformType_Sina;
            }
            if (![self checkPlatform:plateType]) {
                XKShowToast(@"尚未检测到相关客户端，分享失败");
                return ;
            }
            [XKShareManger shareWebPageToPlatformType:plateType withTitle:data.title descr:data.content url:data.url thumb:data.imageUrl block:^(BOOL isSuccess) {
                if (isSuccess) {
                    [self handleShareResult];
                    [shareView dismiss];
                    //                    [SVProgressHUD xk_showInfoWithStatus:@"分享成功"];
                }else{
                    XKShowToast(@"分享失败");
                }
                
            }];
        }
    }];
    
}

- (void)handleShareResult{
    
    XKShareCallbackRequestModel *model = [XKShareCallbackRequestModel new];
    model.popularizeUserId = _callbackModel.shareUserId;
    model.popularizeId     = _callbackModel.popularizePosition;
    model.state            = 1;

    if (!_callbackModel.activityGoodsCondition) { //毫无意义的构建，但是不传系统就要溜号
        XKShareGoodModel *gModel = [XKShareGoodModel new];
        gModel.commodityId = @"";
        gModel.goodsId = @"";
        gModel.activityId = @"";
        gModel.activityType = 0;
        model.activityGoodsCondition = gModel;
    }else{
        model.activityGoodsCondition = _callbackModel.activityGoodsCondition;
    }
    [[XKFDataService() shareService]shareCallbackByModel:model Completion:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            NSLog(@"分享回调成功");
        }
    }];
}

/*
 分享图片，不需要请求h服务器回调
 @param callbackModel  分享成功后回调用到的数据模型
 */
- (void)shareWithTitle:(NSString *)title
                 Image:(UIImage *)image
              andThumb:(UIImage *)thumb
          andNeedPhtot:(BOOL)needPhoto{
    
    XKShareView *shareView = [[XKShareView alloc]initWithType:ShareUIBottom];
    
    NSArray *shareItems;
    if (needPhoto) {
        shareItems = [self addPlatform:@[@(ShareWX),@(ShareCircle),@(ShareSina),@(SharePhoto)]];
    }else{
        shareItems = [self addPlatform:@[@(ShareWX),@(ShareCircle),@(ShareSina)]];
    }
    
    @weakify(self);
    [shareView showWithTitle:title andContent:nil andPlaforms:shareItems andComplete:^(ShareType type) {
        @strongify(self);
        if (type == SharePhoto) {
            if (self.photoCallBack) self.photoCallBack(nil);
        }else{
            UMSocialPlatformType plateType;
            if (type == ShareWX){
                plateType = UMSocialPlatformType_WechatSession;
            }else if (type == ShareCircle){
                plateType = UMSocialPlatformType_WechatTimeLine;
            }else{
                plateType = UMSocialPlatformType_Sina;
            }
            if (![self checkPlatform:plateType]) {
                XKShowToast(@"尚未检测到相关客户端，分享失败");
                return ;
            }
            [XKShareManger shareImageToPlatformType:plateType withThumb:thumb image:image block:^(BOOL isSuccess) {
                if (isSuccess) {
                    [shareView dismiss];
                }else{
                    XKShowToast(@"分享失败");
                }
            }];
        }
    }];
}

- (void)shareProgramWithViewTitle:(NSString *)viewTitle
                       andContent:(NSString *__nullable)content
                           andUrl:(NSString *)url
                         andImage:(NSData *)imageData
                    andShareTitle:(NSString *)shareTitle{
    XKShareView *shareView = [[XKShareView alloc]initWithType:ShareUICenter];
    
    
    NSString *orginId = @"gh_ddff50ba8161";//分享小程序的原始ID
    
    NSArray *shareItems  = [self addPlatform:@[@(ShareWX)]];
    
    [shareView showWithTitle:viewTitle andContent:content andPlaforms:shareItems andComplete:^(ShareType type) {
        
        UMSocialPlatformType plateType;
        if (type == ShareWX){
            plateType = UMSocialPlatformType_WechatSession;
        }else{
            plateType = UMSocialPlatformType_WechatTimeLine;
        }
        if (![self checkPlatform:plateType]) {
            XKShowToast(@"尚未检测到相关客户端，分享失败");
            return ;
        }
        [XKShareManger shareProgramToPlatformType:plateType withPath:url title:shareTitle image:imageData userName:orginId block:^(BOOL isSuccess) {
            if (isSuccess) {
                [shareView dismiss];
            }else{
                XKShowToast(@"分享失败");
            }
        }];
    }];
}

- (void)shareWxOfficialAccountsPlatformWithViewTitle:(NSString *)viewTitle
                       andContent:(NSString *__nullable)content
                           andUrl:(NSString *)url
                         andImage:(NSData *)imageData
                    andShareTitle:(NSString *)shareTitle{
    XKShareView *shareView = [[XKShareView alloc]initWithType:ShareUICenter];
    
    NSArray *shareItems  = [self addPlatform:@[@(ShareWX)]];
    
    [shareView showWithTitle:viewTitle andContent:content andPlaforms:shareItems andComplete:^(ShareType type) {
        
        UMSocialPlatformType plateType;
        if (type == ShareWX){
            plateType = UMSocialPlatformType_WechatSession;
        }else{
            plateType = UMSocialPlatformType_WechatTimeLine;
        }
        if (![self checkPlatform:plateType]) {
            XKShowToast(@"尚未检测到相关客户端，分享失败");
            return ;
        }
        [XKShareManger shareWebPageToPlatformType:plateType withTitle:shareTitle descr:content url:url thumb:imageData block:^(BOOL isSuccess) {
            if (isSuccess) {
                [shareView dismiss];
            }else{
                XKShowToast(@"分享失败");
            }
        }];
    }];
}



- (NSArray *)addPlatform:(NSArray <NSNumber *> *)shareTypes{
    NSMutableArray *array = [NSMutableArray array];
    for (NSNumber *number in shareTypes) {
        if ([number integerValue] == ShareWX) {
            XKShareItemData *item = [XKShareItemData new];
            item.title   = @"微信分享";
            item.imgName = @"weixin";
            [array addObject:item];
        }
        if ([number integerValue] == ShareCircle) {
            XKShareItemData *item2 = [XKShareItemData new];
            item2.title   = @"朋友圈分享";
            item2.imgName = @"wxCircle";
            [array addObject:item2];
        }
        if ([number integerValue] == ShareSina) {
            XKShareItemData *item = [XKShareItemData new];
            item.title   = @"新浪分享";
            item.imgName = @"sina";
            [array addObject:item];
        }
        if ([number integerValue] == SharePhoto) {
            XKShareItemData *item = [XKShareItemData new];
            item.title   = @"生成海报";
            item.imgName = @"photo";
            [array addObject:item];
        }
    }
    return array;
}

- (BOOL)checkPlatform:(UMSocialPlatformType)platformType{
    if (platformType == UMSocialPlatformType_Sina){
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Sinaweibo://"]]) {
            [SVProgressHUD xk_showInfoWithStatus:@"您的手机尚未安装新浪"];
            return NO;
        }
    }
    if (![WXApi isWXAppInstalled]) {
        [SVProgressHUD xk_showInfoWithStatus:@"您的手机尚未安装微信"];
        return NO;
        }
    return YES;
}

- (NSString *)addExtCodeWithUrl:(NSURL *)url{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[url params]];
    NSString *URLString = nil;
    NSString *exCode =  [[XKAccountManager defaultManager] extCode];
    if (exCode) {
        [params setValue:exCode forKey:@"extcode"];
    }
    NSString *domain = [[url.absoluteString componentsSeparatedByString:@"?"] firstObject];
    URLString = [NSString connectUrl:domain params:params];
    return URLString;
}

@end
