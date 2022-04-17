//
//  XKOtherService.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKOtherService.h"
#import "XKNetworkManager.h"
#import <LKDBHelper.h>
#import "XKWeakDelegate.h"

@implementation XKOtherService

- (void)queryTasksWithUserId:(NSString *)userId completion:(void (^)(XKTaskResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/tasks";
    request.param = @{@"userId":userId};
    request.responseClass = [XKTaskResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKTaskResponse *resp = (XKTaskResponse *)response;
        if (response.isSuccess) {
           
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};


- (void)queryPaySwitchCompletion:(void (^)(XKPaySwitchResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/paySwitch";
    request.responseClass = [XKPaySwitchResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKPaySwitchResponse *resp = (XKPaySwitchResponse *)response;
        if (response.isSuccess) {
            
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)queryCirclesWithUserId:(NSString *)userId completion:(void (^)(XKSocialResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/circles/queryInfo/%@",userId];
    request.param = @{@"userId":userId};
    request.responseClass = [XKSocialResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKSocialResponse *resp = (XKSocialResponse *)response;
        if (response.isSuccess) {
            
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};


/**
 请求阿里云服务器获取图片尺寸

 @param urlString <#urlString description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)queryImageSizeWithUrl:(NSString *)urlString completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType   = XKHttpRequestTypeGet;
    request.url           = [NSString stringWithFormat:@"%@?x-oss-process=image/info",urlString];
    request.includeDomain = YES;
    request.responseClass = [XKBaseResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

- (void)queryLogisticsWithOrderNo:(NSString *)orderNo orderType:(XKOrderType)orderType completion:(void (^)(XKLogisticsResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/order/order/queryLogistics";
    request.param = @{@"orderNo":orderNo,@"orderType":@(orderType)};
    request.responseClass = [XKLogisticsResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKLogisticsResponse *resp = (XKLogisticsResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

- (void)queryBargainRecordByScheduleId:(NSString *)scheduleId completion:(void (^)(XKBargainScheduleResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/promotion/bargain/queryBargainRecordByScheduleId/%@",scheduleId];
    request.responseClass = [XKBargainScheduleResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKBargainScheduleResponse *resp = (XKBargainScheduleResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};


- (void)queryTheLastestAppVersionWithCompletion:(void (^)(XKVersionResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/appVersionManage/getNewAppVersionInfo/1";
    //request.param = [XKVersionParams new];
    request.responseClass = [XKVersionResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKVersionResponse *resp = (XKVersionResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

@end
