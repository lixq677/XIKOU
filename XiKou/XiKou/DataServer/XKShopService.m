//
//  XKShopService.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKShopService.h"
#import "XKNetworkManager.h"
#import "XKUnitls.h"
#import <LKDBHelper.h>
#import "XKWeakDelegate.h"

@interface XKShopService ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKShopService
@synthesize weakDelegates = _weakDelegates;

- (void)queryShopIndustryWithCompletion:(void (^)(XKShopIndustryResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/merchant/queryShopIndustryInfo";
    request.responseClass = [XKShopIndustryResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKShopIndustryResponse *resp = (XKShopIndustryResponse *)response;
        if (response.isSuccess) {
            [XKShopIndustryData deleteWithWhere:nil];
            if (resp.data.count > 0) {
                [XKShopIndustryData insertArrayByAsyncToDB:resp.data];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (NSArray<XKShopIndustryData *> *)queryShopIndustryFromCache{
    return [XKShopIndustryData searchWithWhere:nil];
}


- (void)queryShopBriefWithShopBriefParams:(XKShopBriefParams *) briefParams completion:(void (^)(XKShopBriefResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/merchant/shop/queryPageBusiness";
    request.param = briefParams;
    request.responseClass = [XKShopBriefResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKShopBriefResponse *resp = (XKShopBriefResponse *)response;
        if (response.isSuccess) {
            if (briefParams.page.intValue == 1 && resp.data.count < briefParams.limit.intValue) {
                if (briefParams.industry1) {
                   BOOL flag =  [XKShopBriefData deleteWithWhere:@{@"industry1":@(briefParams.industry1.intValue)}];
                    
                    NSLog(@"flag:%@",@(flag));
                }else{
                    [XKShopBriefData deleteWithWhere:nil];
                }
            }
            if (resp.data.count > 0) {
                [resp.data enumerateObjectsUsingBlock:^(XKShopBriefData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.industryName = briefParams.industryName;
                    obj.industry1 = @([briefParams.industry1 intValue]);
                }];
                [XKShopBriefData insertArrayByAsyncToDB:resp.data];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryShopDetailWithShopId:(NSString *)shopId userId:(NSString *)userId completion:(void (^)(XKShopDetailResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (shopId) {
        [params setObject:shopId forKey:@"id"];
    }
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    request.url = @"/merchant/merchant/shop/queryShopDetail";
    request.param = params;
    request.responseClass = [XKShopDetailResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKShopDetailResponse *resp = (XKShopDetailResponse *)response;
        if (response.isSuccess) {
            [resp.data updateToDB];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


-(NSArray<XKShopBriefData *> *)queryShopBriefFromCacheWithShopBriefParams:(XKShopBriefParams *)briefParams{
    NSMutableString *orderBy = [NSMutableString string];
    if (briefParams.rate) {
        if (briefParams.rate == XKShopRateAscend) {
            [orderBy appendString:@"discountRate asc"];
        }else{
            [orderBy appendString:@"discountRate desc"];
        }
    }
    if (briefParams.pop) {
        if ([NSString isNull:orderBy] == NO) {
            [orderBy appendString:@","];
        }
        if (briefParams.pop == XKShopPopAscend) {
            [orderBy appendString:@"popCnt asc"];
        }else{
            [orderBy appendString:@"popCnt desc"];
        }
    }
    NSArray<XKShopBriefData *> *array = nil;
    if (briefParams.industry1) {
        array = [XKShopBriefData searchWithWhere:@{@"industry1":@(briefParams.industry1.intValue)} orderBy:orderBy offset:((briefParams.page.integerValue-1)*briefParams.limit.integerValue) count:briefParams.limit.integerValue];
    }else{
        array = [XKShopBriefData searchWithWhere:nil orderBy:orderBy offset:((briefParams.page.integerValue-1)*briefParams.limit.integerValue) count:briefParams.limit.integerValue];
    }
    return array;
}

- (void)setConcernShopWithParams:(XKShopFollowVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/merchant/merchant/createShopFollow";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            if (![NSString isNull:params.shopId]) {
                XKShopBriefData *data = [XKShopBriefData searchSingleWithWhere:@{@"id":params.shopId} orderBy:nil];
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
            [self.weakDelegates enumerateWithBlock:^(id<XKShopServiceDelegate>  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(concernShopWithService:param:)]){
                    [delegate concernShopWithService:self param:params];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)createOTOOrderWithParams:(XKShopOrderParams *)params  completion:(void (^)(XKShopOrderResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/order/order/createOtoOrder";
    request.param = params;
    request.responseClass = [XKShopOrderResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKShopOrderResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryShopesOfMyConcernParams:(XKShopMyConcernParams *)params completion:(void (^)(XKShopMyConcernResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/merchant/shop/pageUserFollowShop";
    request.param = params;
    request.responseClass = [XKShopMyConcernResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKShopMyConcernResponse *resp = (XKShopMyConcernResponse*)response;
        if (response.isSuccess) {
            if (params.page.intValue == 1 && resp.data.count < params.limit.intValue) {
                [XKShopMyConcernData deleteWithWhere:@{@"userId":params.userId?:@""}];
            }
            if (resp.data.count > 0) {
                [XKShopMyConcernData insertToDB:resp.data];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

- (NSArray<XKShopMyConcernData *> *)queryShopesOfMyConcernFromCache:(XKShopMyConcernParams *)params{
        NSArray<XKShopMyConcernData *> *array = [XKShopMyConcernData searchWithWhere:@{@"userId":params.userId?:@""} orderBy:@"followTime desc" offset:((params.page.integerValue-1)*params.limit.integerValue) count:params.limit.integerValue];
    return array;
}


- (void)searchShopWithParams:(XKShopSearchParams *)params completion:(void (^)(XKShopBriefResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/merchant/merchant/shop/queryPageShop";
    request.param = params;
    request.responseClass = [XKShopBriefResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKShopBriefResponse *resp = (XKShopBriefResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (NSArray<XKShopSearchText *> *)searchLastKeywordFromCache{
    NSArray<XKShopSearchText *> *array = [XKShopSearchText searchWithWhere:nil orderBy:@"timestamp desc" offset:0 count:10];
    return array;
}

- (void)deleteKeywordFromCache{
    [XKShopSearchText deleteWithWhere:nil];
}

- (void)saveKeyworkdToCache:(NSString *)keyword{
    if ([NSString isNull:keyword]) return;
    XKShopSearchText *searchText = [[XKShopSearchText alloc] init];
    searchText.shopName = keyword;
    searchText.timestamp = @((long)[[NSDate date] timeIntervalSince1970]);
    [searchText saveToDB];
}



#pragma mark set delegate
- (void)addWeakDelegate:(id<XKShopServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKShopServiceDelegate>)delegate{
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
