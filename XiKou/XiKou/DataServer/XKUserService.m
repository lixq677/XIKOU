//
//  XKUserService.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKUserService.h"
#import "XKWeakDelegate.h"
#import "XKAccountManager.h"
#import <LKDBHelper.h>

@interface XKUserService ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKUserService
@synthesize weakDelegates = _weakDelegates;

- (void)getValidCodeWithNumber:(NSString *)number completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"auth/login/getValidCode";
    request.param = @{@"mobile":number};
    request.responseClass = [XKCodeResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKCodeResponse *resp = (XKCodeResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)loginWithNumber:(NSString *)number code:(NSString *)code completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/auth/login/userLogin";
    request.param = @{@"mobile":number,@"validCode":code};
    request.responseClass = [XKCodeResponse class];
    @weakify(self);
    request.blockResult = ^(XKBaseResponse *response){
        @strongify(self);
        XKCodeResponse *resp = (XKCodeResponse *)response;
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(loginWithService:userInfo:)]){
                    [delegate loginWithService:self userInfo:resp.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)loginWithWXAppid:(NSString *)appId code:(NSString *)wxcode completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"auth/wx/login";
    request.param = @{@"appid":appId,@"code":wxcode};
    request.responseClass = [XKCodeResponse class];
    @weakify(self);
    request.blockResult = ^(XKBaseResponse *response){
        @strongify(self);
        XKCodeResponse *resp = (XKCodeResponse *)response;
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(loginWithService:userInfo:)]){
                    [delegate loginWithService:self userInfo:resp.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)logoutWithUserId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock{
    XKBaseResponse *response = [[XKBaseResponse alloc] init];
    response.code = @(0);
    if (response.isSuccess) {
        [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
            if([delegate respondsToSelector:@selector(logoutWithService:userId:)]){
                [delegate logoutWithService:self userId:userId];
            }
        }];
    }
    if (completionBlock)completionBlock(response);
    
}

- (void)isRegisterWithMobile:(NSString *)mobile completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/auth/login/isRegist";
    request.param = @{@"mobile":mobile};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)registerWithNumber:(NSString *)number verifyCode:(NSString *)vCode inviteCode:(NSString *)iCode completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"auth/login/userRegister";
    request.param = @{@"mobile":number,@"validCode":vCode,@"invitationCode":iCode};
    request.responseClass = [XKCodeResponse class];
    @weakify(self);
    request.blockResult = ^(XKBaseResponse *response){
        @strongify(self);
        XKCodeResponse *resp = (XKCodeResponse *)response;
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(loginWithService:userInfo:)]){
                    [delegate loginWithService:self userInfo:resp.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)registerWithParams:(XKRegisterParams *)params completion:(void (^)(XKCodeResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"auth/login/userRegister";
    request.param = params;
    request.responseClass = [XKCodeResponse class];
    @weakify(self);
    request.blockResult = ^(XKBaseResponse *response){
        @strongify(self);
        XKCodeResponse *resp = (XKCodeResponse *)response;
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(loginWithService:userInfo:)]){
                    [delegate loginWithService:self userInfo:resp.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)verifyWithParams:(XKVerifyParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"user/users/saveRealName";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
            if ([delegate respondsToSelector:@selector(verifySuccessWithSevice:userId:)]) {
                [delegate verifySuccessWithSevice:self userId:params.userId];
            }
        }];
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)getVerifyInfoWithUserId:(NSString *)userId completion:(void (^)(XKVerifyInfoResponse* _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/selectRealNameCertification";
    request.param = @{@"userId":userId};
    request.responseClass = [XKVerifyInfoResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKVerifyInfoResponse *res = (XKVerifyInfoResponse *)response;
        if (completionBlock)completionBlock(res);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getReferrerInfoWithUserId:(NSString *)userId completion:(void (^)(XKReferrerResponse* _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/findInvitationInfoById/%@",userId];
    request.responseClass = [XKReferrerResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKReferrerResponse *res = (XKReferrerResponse *)response;
        if (completionBlock)completionBlock(res);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)refreshToken:(NSString *)token completion:(void (^)(XKCodeResponse * _Nonnull ))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"auth/login/refreshToken";
    request.param = @{@"refreshToken":token};
    request.responseClass = [XKCodeResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKCodeResponse *resp = (XKCodeResponse *)response;
        if (response.isSuccess) {
            
            [self.weakDelegates enumerateWithBlock:^(id<XKUserServiceDelegate>  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(refreshTokenWithService:userInfo:)]){
                    [delegate refreshTokenWithService:self userInfo:resp.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)getUserBasicInfomationWithId:(NSString *)userId completion:(void (^)(XKUserInfoResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"user/users/user_data/%@",userId];
    request.responseClass = [XKUserInfoResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKUserInfoResponse *resp = (XKUserInfoResponse *)response;
        if([resp isSuccess]){
            if (([resp.data isExistsFromDB])) {
                [XKUserInfoData updateToDB:resp.data where:nil];
            }else{
                [resp.data saveToDB];
            }
            [self.weakDelegates enumerateWithBlock:^(id<XKUserServiceDelegate>  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(queryUserBasicInfoWithService:userInfoData:)]){
                    [delegate queryUserBasicInfoWithService:self userInfoData:resp.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getUserMineInfomationWithId:(NSString *)userId completion:(void (^)(XKUserInfoResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"user/users/my_user/%@",userId];
    request.responseClass = [XKUserInfoResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKUserInfoResponse *resp = (XKUserInfoResponse *)response;
        if([resp isSuccess]){
            if (([resp.data isExistsFromDB])) {
                [XKUserInfoData updateToDB:resp.data where:nil];
            }else{
                [resp.data saveToDB];
            }
            [self.weakDelegates enumerateWithBlock:^(id<XKUserServiceDelegate>  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(queryUserMineInfoWithService:userInfoData:)]){
                    [delegate queryUserMineInfoWithService:self userInfoData:response.data];
                }
            }];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (XKUserInfoData *)queryUserInfoFromCacheWithId:(NSString *)id{
    if([NSString isNull:id])return nil;
    return  [XKUserInfoData searchSingleWithWhere:@{@"id":id} orderBy:nil];
}

- (void)modifyUserInfomation:(XKModifyUserVoParams *)params withUserId:(NSString *)userId   completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = [NSString stringWithFormat:@"user/users/update/%@",userId];
    request.param = params;
    request.responseClass = [XKUserInfoResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if ([delegate respondsToSelector:@selector(modifyWithSevice:userInfomation:userId:)]) {
                    [delegate modifyWithSevice:self userInfomation:params userId:userId];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)uploadWithConstructingBodyBlock:(XKBlockConstructingBody)constructingBodyBlock completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePostForUpload;
    request.requestSerializerType = XKRequestSerializerTypeHttp;
    request.responseSerializerType = XKResponseSerializerTypeHttp;
    request.url = @"user/oss/putObject";
    request.param = @{@"folderName":@"user"};
    request.blockConstructingBody = constructingBodyBlock;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)changePayPasswordWithParams:(XKPayPasswordParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/users/savePayPassword";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(changePaymentPasswordWithService:userId:)]){
                    [delegate changePaymentPasswordWithService:self userId:params.userId];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)isValidCodeWithMobile:(NSString *)mobile code:(NSString *)code completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/verifyVerificationCode";
    request.param = @{@"mobile":mobile,@"verificationCode":code};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)changePayPasswordForGetVerifyCodeWithMobile:(NSString *)mobile completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/sendVerificationCode";
    request.param = @{@"mobile":mobile};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryPaymentPasswordIsSettingWithUserId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/selectPayPassworsByUserId/%@",userId];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)unBindThirdRelationWithUserId:(NSString *)userId type:(XKThirdPlatformType)type completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/users/unBindThirdRelation";
    request.param = @{@"userId":userId,@"loginType":@(type)};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryUserInfoWithMobile:(NSString *)mobile completion:(nullable void (^)(XKUserInfoResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/queryUserByMobile/%@",mobile];
    request.responseClass = [XKUserInfoResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKUserInfoResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


#pragma mark set delegate
- (void)addWeakDelegate:(id<XKUserServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKUserServiceDelegate>)delegate{
    [self.weakDelegates removeDelegate:delegate];
}

#pragma mark getter
- (XKWeakDelegate *)weakDelegates{
    if (_weakDelegates == nil) {
        _weakDelegates = [[XKWeakDelegate alloc] init];
    }
    return _weakDelegates;
}

@end
