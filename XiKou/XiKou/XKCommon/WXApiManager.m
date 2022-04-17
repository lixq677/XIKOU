//
//  WXApiManager.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "WXApiManager.h"
#import "XKWeakDelegate.h"

static NSString *const kCompletionGetCodeKey = @"CompletionGetCodeKey";

@interface WXApiManager ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@property (nonatomic,strong,readonly) NSMutableDictionary *completions;

@end

@implementation WXApiManager
@synthesize weakDelegates = _weakDelegates;
@synthesize appKey = _appKey;
@synthesize completions = _completions;

+(WXApiManager *)defaultManager{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options{
     return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}


- (BOOL)registerApp:(NSString *)appid{
    _appKey = [appid copy];
    return [WXApi registerApp:appid universalLink:@"https://oss-shop.luluxk.com"];
}

- (void)getCodeCompletion:(void(^)(NSString *code,NSError *error))completion{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
    req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
    if (completion) {
        [self.completions setObject:completion forKey:kCompletionGetCodeKey];
    }
    [WXApi sendReq:req completion:^(BOOL success) {//发起微信授权请求
        NSLog(@"abc");
    }];
}


/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req{
    
}



/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp *)resp;
        if ([response.state isEqualToString:@"wx_oauth_authorization_state"]) {
            void (^completion)(NSString *code,NSError *error) = [self.completions objectForKey:kCompletionGetCodeKey];
            if (completion) {
                NSError *error = nil;
                if (response.errCode != 0) {
                    error = [NSError errorWithDomain:response.errStr code:response.errCode userInfo:nil];
                }
                completion(response.code,error);
            }
        }
        [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
            if([delegate respondsToSelector:@selector(authRespCode:state:)]){
                [delegate authRespCode:response.code state:response.state];
            }
        }];
    }else if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response=(PayResp*)resp;
        [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
            if([delegate respondsToSelector:@selector(payRespCode:resp:)]){
                [delegate payRespCode:resp.errCode resp:response];
            }
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotiWxPayResult object:nil userInfo:@{@"result":response}];
    }
}

#pragma mark set delegate
- (void)addWeakDelegate:(id<WXApiManagerDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<WXApiManagerDelegate>)delegate{
    [self.weakDelegates removeDelegate:delegate];
}

#pragma mark getter
- (XKWeakDelegate *)weakDelegates{
    if (_weakDelegates == nil) {
        _weakDelegates = [[XKWeakDelegate alloc] init];
    }
    return _weakDelegates;
}

- (NSMutableDictionary *)completions{
    if (!_completions) {
        _completions = [NSMutableDictionary dictionary];
    }
    return _completions;
}


@end
