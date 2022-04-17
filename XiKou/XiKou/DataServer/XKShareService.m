//
//  XKShareService.m
//  XiKou
//
//  Created by L.O.U on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShareService.h"

@implementation XKShareService

- (void)getPopularizeShareInfomationCompletion:(void (^)(XKPopularizeInfoResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"user/share/queryShareImage";
    request.responseClass = [XKPopularizeInfoResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKPopularizeInfoResponse *resp = (XKPopularizeInfoResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryShareDataByModel:(XKShareRequestModel *)model Completion:(void (^)(XKShareResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/share/queryShareLinkInfo";
    request.param = model;
    request.responseClass = [XKShareResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKShareResponse *resp = (XKShareResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)shareCallbackByModel:(XKShareCallbackRequestModel *)model Completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/share/queryShareCallBack";
    request.param = model;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}
@end


