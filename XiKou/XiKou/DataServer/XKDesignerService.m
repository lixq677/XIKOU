//
//  XKDesignerService.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDesignerService.h"
#import <LKDBHelper.h>
#import "XKNetworkManager.h"
#import "XKUnitls.h"
#import "XKWeakDelegate.h"

@interface XKDesignerService ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKDesignerService
@synthesize weakDelegates = _weakDelegates;

- (void)queryDesignersWithPage:(NSUInteger)page limit:(NSUInteger)limit completion:(void (^)(XKDesignerBriefResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/designer/queryDesignerCircleByList";
    request.param = @{@"page":@(page),@"limit":@(limit)};
    request.responseClass = [XKDesignerBriefResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKDesignerBriefResponse *resp = (XKDesignerBriefResponse *)response;
        if (resp.isSuccess) {
            [XKDesignerBriefData insertArrayByAsyncToDB:resp.data];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (NSArray<XKDesignerBriefData *> *)queryLastestDesignerFromCache{
    return  [XKDesignerBriefData searchWithWhere:nil orderBy:@"rowid desc" offset:0 count:10];
}

- (void)queryDesignerHomePageInfoWithDesignerId:(NSString *)designerId userId:(NSString *)userId completion:(void (^)(XKDesignerHomeResponse * _Nonnull response))completionBlock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (designerId) {
        [params setObject:designerId forKey:@"designerId"];
    }
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/queryDesignerHomePage/index";
    request.param = params;
    request.responseClass = [XKDesignerHomeResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKDesignerHomeResponse *resp = (XKDesignerHomeResponse *)response;
        if (resp.isSuccess) {
            [resp.data saveToDB];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (XKDesignerHomeData *)queryDesignerHomePageInfoFromCacheWithDesignerId:(NSString *)designerId{
    XKDesignerHomeData *data = nil;
    if ([NSString isNull:designerId] == NO) {
        data = [XKDesignerHomeData searchSingleWithWhere:@{@"designerId":designerId} orderBy:nil];
    }
    return data;
}



- (void)queryDesignerWorksWithParams:(XKDesignerWorksParams *)params completion:(void (^)(XKDesignerWorkResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/designerWork/queryDesignerWorks";
    request.param = params;
    request.responseClass = [XKDesignerWorkResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKDesignerWorkResponse *resp = (XKDesignerWorkResponse *)response;
        if (resp.isSuccess) {
            if (params.page.intValue == 1 && resp.data.count < params.limit.intValue) {
                if (NO == [NSString isNull:params.designerId]) {
                    [XKDesignerWorkData deleteWithWhere:@{@"id":params.designerId}];
                }
            }
            if (resp.data.count > 0) {
                [XKDesignerWorkData insertArrayByAsyncToDB:resp.data];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (NSArray<XKDesignerWorkData *> *)queryWorksFromCacheWithParams:(XKDesignerWorksParams *)params{
    NSMutableArray<XKDesignerWorkData *> *array = nil;
    if ([NSString isNull:params.designerId] == NO) {
        array = [XKDesignerWorkData searchWithWhere:@{@"designerId":params.designerId} orderBy:@"updateTime desc" offset:((params.page.integerValue-1)*params.limit.integerValue) count:params.limit.integerValue];
    }else{
         array = [XKDesignerWorkData searchWithWhere:nil orderBy:@"updateTime desc" offset:((params.page.integerValue-1)*params.limit.integerValue) count:params.limit.integerValue];
    }
    return array;
}

- (void)setConcernDesignerWithParams:(XKDesignerFollowVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/merchant/designer/createDesignerFollow";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            XKDesignerHomeData *data = [XKDesignerHomeData searchSingleWithWhere:@{@"designerId":params.designerId} orderBy:nil];
            if (data) {
                data.isFollow = @(params.follow);
                NSInteger fanCnt = 0;
                if (params.follow) {
                    fanCnt = data.fanCnt.integerValue +  1;
                }else{
                    fanCnt = data.fanCnt.integerValue - 1;
                }
                data.fanCnt = @(fanCnt > 0 ? fanCnt : 0);
                [data updateToDB];
            }
            NSString *set = [NSString stringWithFormat:@"isFollow=\'%@\',fanCnt=\'%@\'",@(params.follow),data.fanCnt];
            [XKDesignerWorkData updateToDBWithSet:set where:@{@"designerId":params.designerId}];
            [self.weakDelegates enumerateWithBlock:^(id<XKDesignerServiceDelegate>  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(concernDesignerWithService:param:)]){
                    [delegate concernDesignerWithService:self param:params];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)setThumbupDesignerWithParams:(XKDesignerFollowVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/merchant/designerWork/workPraise";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            XKDesignerWorkData *workData = [XKDesignerWorkData searchSingleWithWhere:@{@"id":params.workId} orderBy:nil];
            XKDesignerHomeData *homeData = [XKDesignerHomeData searchSingleWithWhere:@{@"designerId":params.designerId} orderBy:nil];
            if (params.praise) {
                workData.fabulousCnt =  @(workData.fabulousCnt.integerValue + 1);
                workData.isPraise = @(YES);
                homeData.fabulousCnt = @(homeData.fabulousCnt.integerValue + 1);
            }else{
                workData.fabulousCnt =  @(workData.fabulousCnt.integerValue - 1);
                workData.isPraise = @(NO);
                homeData.fabulousCnt = @(homeData.fabulousCnt.integerValue -1);
            }
            [homeData updateToDB];
            [workData updateToDB];
            [self.weakDelegates enumerateWithBlock:^(id<XKDesignerServiceDelegate>  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(thumbupDesignerWithService:param:)]){
                    [delegate thumbupDesignerWithService:self param:params];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryDesignerCommentsWithParams:(XKDesignerCommentsRequestParams *)params completion:(void(^)(XKDesignerCommentResponse *response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"merchant/merchant/designer/queryWorkCommentByDesigner";
    request.param = params;
    request.responseClass = [XKDesignerCommentResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKDesignerCommentResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)commentWithVoModel:(XKDesignerCommentVoModel *)commentVoModel  completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.timeout = 10.0f;
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/merchant/merchant/designer/createWorkComment";
    request.param = commentVoModel;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(commentWithService:comments:)]){
                    [delegate commentWithService:self comments:commentVoModel];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

- (void)queryDesignersOfMyConcernParams:(XKDesignerMyConcernParams *)params completion:(void (^)(XKDesignerMyConcernResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/merchant/designer/designerFollows/%@",params.userId];
    request.param = params;
    request.responseClass = [XKDesignerMyConcernResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKDesignerMyConcernResponse *resp = (XKDesignerMyConcernResponse*)response;
        if (response.isSuccess) {
            if (params.page.intValue == 1 && resp.data.count < params.limit.intValue) {
                [XKDesignerMyConcernData deleteWithWhere:@{@"userId":params.userId?:@""}];
            }
            if (resp.data.count > 0) {
                [XKDesignerMyConcernData insertToDB:resp.data];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};


- (NSArray<XKDesignerMyConcernData *> *)queryDesignerOfMyConcernFromCache:(XKDesignerMyConcernParams *)params{
    NSArray<XKDesignerMyConcernData *> *array = [XKDesignerMyConcernData searchWithWhere:@{@"userId":params.userId?:@""} orderBy:@"createTime desc" offset:((params.page.integerValue-1)*params.limit.integerValue) count:params.limit.integerValue];
    return array;
}


#pragma mark set delegate
- (void)addWeakDelegate:(id<XKDesignerServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKDesignerServiceDelegate>)delegate{
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
