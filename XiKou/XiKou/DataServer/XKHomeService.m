//
//  XKHomeService.m
//  XiKou
//  首页的service
//  Created by 陆陆科技 on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKHomeService.h"
#import <LKDBHelper.h>
#import "XKNetworkManager.h"
#import "XKUnitls.h"

@implementation XKHomeService

- (void)queryHomePageActivityWithCompletion:(void (^)(XKHomeActivityResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/activity/commodity/queryHomePageActivity";
    request.responseClass = [XKHomeActivityResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKHomeActivityResponse *resp = (XKHomeActivityResponse *)response;
        if (resp.isSuccess) {
            [XKHomeActivityModel deleteWithWhere:nil];
            [resp.data saveToDB];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (XKHomeActivityModel *)activityModelFromCache{
    return [XKHomeActivityModel searchSingleWithWhere:nil orderBy:nil];
}

- (void)queryBannerWithParams:(XKBannerParams *)params completion:(void (^)(XKBannerResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/banner/query/banners";
    request.param = params;
    request.responseClass = [XKBannerResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKBannerResponse *resp = (XKBannerResponse *)response;
        if (resp.isSuccess) {
            [XKBannerData deleteWithWhere:@{@"moudle":@(params.moudle),@"position":@(params.position)}];
            [XKBannerData insertArrayByAsyncToDB:resp.data];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryRankDataByType:(RanKType)rank Completion:(void (^)(XKRankResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    if (rank == RankHot)       request.url = @"/promotion/activity/rank/queryExplosive";
    if (rank == RankRecommend) request.url = @"/promotion/activity/rank/queryHotPush";
    if (rank == RankMakeMoney) request.url = @"/promotion/activity/rank/queryHotEarn";
    request.responseClass = [XKRankResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKRankResponse *resp = (XKRankResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (NSArray<XKBannerData *> *)queryHomeBannerFromCacheWithPostion:(XKBannerPosition)position{
    NSArray<XKBannerData *> *banners = [XKBannerData searchWithWhere:@{@"moudle":@(XKBannerMoudleHome),@"position":@(position)}];
    return banners;
}

- (NSArray<XKBannerData *> *)queryActivityBannerFromCacheWithPostion:(XKBannerPosition)position moudle:(XKBannerMoudle)moudle{
    NSArray<XKBannerData *> *banners = [XKBannerData searchWithWhere:@{@"moudle":@(moudle),@"position":@(position)}];
    return banners;
}


- (void)searchGoodsWithParams:(XKGoodsSearchParams *)params completion:(void (^)(XKGoodsSearchResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/activity/commodity/queryPagePromotionCommodityToSearch";
    request.param = params;
    request.responseClass = [XKGoodsSearchResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKGoodsSearchResponse *resp = (XKGoodsSearchResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (NSArray<XKGoodsSearchText *> *)searchLastKeywordFromCache{
    NSArray<XKGoodsSearchText *> *array = [XKGoodsSearchText searchWithWhere:nil orderBy:@"timestamp desc" offset:0 count:10];
    return array;
}

- (void)deleteKeywordFromCache{
    [XKGoodsSearchText deleteWithWhere:nil];
}

- (void)saveKeyworkdToCache:(NSString *)keyword{
    if ([NSString isNull:keyword]) return;
    XKGoodsSearchText *searchText = [[XKGoodsSearchText alloc] init];
    searchText.commodityName = keyword;
    searchText.timestamp = @((long)[[NSDate date] timeIntervalSince1970]);
    [searchText saveToDB];
}


@end
