//
//  ACTService.m
//  XiKou
//
//  Created by L.O.U on 2019/7/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKActivityService.h"
#import <LKDBHelper.h>

@implementation XKActivityService

/**
 获取活动木块首页数据
 */
- (void)getActivityHomeDataComplete:(void(^)(ACTHomeRespnse *_Nonnull response))completionBlock{
    
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/activity/commodity/queryActivityPage";
    request.responseClass = [ACTHomeRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTHomeRespnse *resp = (ACTHomeRespnse *)response;
        if (resp.isSuccess) {
            [ACTHomeRespnse deleteWithWhere:nil];
            [response.data saveToDB];
        }
        if (completionBlock)completionBlock(resp);
        
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (ACTHomeBaseModel *)activityHomeDataFromCache{
    return [ACTHomeBaseModel searchSingleWithWhere:nil orderBy:nil];
}

/**
 获取活动下的模块信息(除了全球买手)
 */
- (void)getActivityMoudleByActivityType:(XKActivityType)type
                               Complete:(void(^)(ACTMoudleResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/promotionCategory/queryPromotionCategory";
    request.param = @{@"activityType":@(type)};
    request.responseClass = [ACTMoudleResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTMoudleResponse *resp = (ACTMoudleResponse *)response;
        if(response.isSuccess){
            resp.data.activityType = type;
            [ACTMoudleData deleteWithWhere:@{@"activityType":@(type)}];
            [response.data saveToDB];
            [resp.data saveToDB];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (ACTMoudleData *)queryModuleDataFromCache:(XKActivityType)activityType{
    return [ACTMoudleData searchSingleWithWhere:@{@"activityType":@(activityType)} orderBy:nil];
}

/**
 根据分类ID获取商品列表
 */
- (void)getGoodListByActivityType:(XKActivityType)type
                    andCategoryId:(NSString *)categoryId
                          andPage:(NSInteger)page
                         andLimit:(NSInteger)limit
                        andUserId:(NSString *)userId
                         Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/promotionCategory/queryPagePromotionCategoryCommodity";
    request.param = @{@"activityType":@(type),
                      @"categoryId":categoryId,
                      @"page":@(page),
                      @"limit":@(limit),
                      @"userId":userId
                      };
    request.responseClass = [ACTGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodListRespnse *resp = (ACTGoodListRespnse *)response;
        if (resp.isSuccess) {
            if (page == 1 && resp.data.result.count < limit) {
                if ([NSString isNull:userId]) {
                    [XKGoodListModel deleteWithWhere:@{@"activityType":@(type),@"categoryId":categoryId?:@""}];
                }else{
                    [XKGoodListModel deleteWithWhere:@{@"activityType":@(type),@"categoryId":categoryId?:@"",@"userId":userId}];
                }
            }
            if (resp.data.result.count > 0) {
                [resp.data.result enumerateObjectsUsingBlock:^(XKGoodListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.categoryId = categoryId;
                    obj.userId = userId;
                    obj.activityType = type;
                }];
                [XKGoodListModel insertArrayByAsyncToDB:resp.data.result];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}



- (NSArray<XKGoodListModel *> *)queryGoodListModelFromCacheByActivityType:(XKActivityType)type
                                                            andCategoryId:(NSString *)categoryId
                                                                  andPage:(NSInteger)page
                                                                 andLimit:(NSInteger)limit
                                                                andUserId:(nullable NSString *)userId{
    if ([NSString isNull:userId]) {
        return [XKGoodListModel searchWithWhere:@{@"activityType":@(type),@"categoryId":categoryId?:@""} orderBy:nil offset:(page-1)*limit count:limit];
    }else{
        return [XKGoodListModel searchWithWhere:@{@"activityType":@(type),@"categoryId":categoryId?:@"",@"userId":userId} orderBy:nil offset:(page-1)*limit count:limit];
    }
}

- (void)queryGoodsListForWgWithParams:(ACTGoodsListParams *) params completion:(void (^)(ACTGoodListRespnse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/promotion/buyGiftCommodity/queryListNew";
    request.param = params;
    request.responseClass = [ACTGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodListRespnse *resp = (ACTGoodListRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getGlobalHomePageDataComplete:(void(^)(ACTGlobalHomeRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/promotionCategory/queryGlobalBuyerActivitySection";
    request.responseClass = [ACTGlobalHomeRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGlobalHomeRespnse *resp = (ACTGlobalHomeRespnse *)response;
        if (resp.isSuccess) {
            [ACTGlobalHomeModel deleteWithWhere:nil];
            [resp.data saveToDB];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (ACTGlobalHomeModel *)queryGlobalHomeModelFromCache{
    return [ACTGlobalHomeModel searchSingleWithWhere:nil orderBy:nil];
}
 
- (void)getGlobalGoodListByClass:(NSDictionary *)param Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/promotion/globalBuyer/queryPaging";
    request.param = param;
    request.responseClass = [ACTGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodListRespnse *resp = (ACTGoodListRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getActivityGoodDetailByActivityGoodId:(NSString *)activityGoodId
                              andActivityType:(XKActivityType)activityType
                                    andUserId:(NSString *)userId
                                     Complete:(void(^)(ACTGoodDetailRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    if (activityType == Activity_ZeroBuy) {
        request.url = @"/promotion/activity/commodity/queryCommodityDetail";
    }else{
        request.url = @"/promotion/activity/commodity/queryCommodityDetailForSpu";
    }
    request.responseClass = [ACTGoodDetailRespnse class];
    request.param = @{@"id":activityGoodId,@"activityType":@(activityType),@"userId":userId};
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodDetailRespnse *resp = (ACTGoodDetailRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getBargainGoodListByParam:(NSDictionary *)param
                         Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = @"/promotion/bargain/activityCommodity/query";
    request.param = param;
    request.responseClass = [ACTGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodListRespnse *resp = (ACTGoodListRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}

- (void)getBargainNewnestGoodListByParam:(NSDictionary *)param
                                Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = @"/promotion/bargain/activityNewCommodity/query";
    request.param = param; //只需要取前三个
    request.responseClass = [ACTGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodListRespnse *resp = (ACTGoodListRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}

/**
 砍立得发起砍价
 */
- (void)startBargainByParam:(NSDictionary *)param
                   Complete:(void(^)(ACTBargainRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url   = @"/promotion/bargain/saveUserBargain";
    request.param = param; 
    request.responseClass = [ACTBargainRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTBargainRespnse *resp = (ACTBargainRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 用户参与砍价
 */
- (void)userJoinBargainByIcon:(NSString *)icon
                      andName:(NSString *)name
                    andUserId:(NSString *)userId
                        andID:(NSString *)ID
                     Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url   = @"/promotion/bargain/modifyUserBargain";
    request.param = @{@"assistUserHeadImageUrl":icon,
                      @"assistUserId":userId,
                      @"assistUserName":name,
                      @"id":ID
                      };
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 砍立得获取砍价详情
 */
- (void)getBargainDetailByUserId:(NSString *)userId
                   andActivityId:(NSString *)activityId
                  andCommodityId:(NSString *)commodityId
                        Complete:(void(^)(XKBargainInfoRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/bargain/queryByUserIdAndCommodityId/%@/%@/%@",userId,activityId,commodityId];
    request.responseClass = [XKBargainInfoRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKBargainInfoRespnse *resp = (XKBargainInfoRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getRoundByType:(XKActivityType)activityType
              Complete:(void(^)(ACTRoundRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/auction/round/query/%ld",activityType];
    request.responseClass = [ACTRoundRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTRoundRespnse *resp = (ACTRoundRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getRoundGoodListByRoundId:(NSString *)roundId
                         Complete:(void(^)(ACTRoundGoodListRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/auction/commodity/query/%@",roundId];
    request.responseClass = [ACTRoundGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTRoundGoodListRespnse *resp = (ACTRoundGoodListRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getGoodAuctionInfoByRoundId:(NSString *)roundId
                            Complete:(void(^)(ACTGoodAuctionRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/auction/infosbyround/query/%@",roundId];
    request.responseClass = [ACTGoodAuctionRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodAuctionRespnse *resp = (ACTGoodAuctionRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 通过活动商品ID和用户ID获取商品竞拍情况
 @param activityGoodId 活动商品 id
 @param userId 用户 id
 */
- (void)getGoodAuctionInfoByActivityGoodId:(NSString *)activityGoodId
                                 andUserId:(NSString *)userId
                                  Complete:(void(^)(ACTGoodDetailAuctionRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/auction/info/query/%@/%@",activityGoodId,userId];
    request.responseClass = [ACTGoodDetailAuctionRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodDetailAuctionRespnse *resp = (ACTGoodDetailAuctionRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 通过商品ID获取商品竞拍出价记录
 @param activityGoodId 活动商品 id
 */
- (void)getGoodAuctionListByActivityGoodId:(NSString *)activityGoodId
                                  Complete:(void(^)(ACTGoodAuctionRecondRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/auction/records/query/%@/%@",activityGoodId,@100];
    request.responseClass = [ACTGoodAuctionRecondRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodAuctionRecondRespnse *rep = (ACTGoodAuctionRecondRespnse *)response;
        if (completionBlock)completionBlock(rep);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}

/**
 商品竞拍出价
 @param param 活动商品 id
 */
- (void)postGoodAuctionListByparam:(NSDictionary *)param
                          Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType    = XKHttpRequestTypePost;
    request.url            = @"/promotion/auction/offer";
    request.param          = param;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 获取多买多折活动商品折扣
 @param commodityId 商品skuId
 @param activityId  活动Id
 */
- (void)getMutilGoodDiscountRateByCommodityId:(NSString *)commodityId
                                andActivityId:(NSString *)activityId
                                     Complete:(void(^)(ACTMutilBuyDiscountRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = @"/promotion/moreDiscount/activityCommodityDiscountRate/query";
    request.param = @{@"commodityId":commodityId,@"activityId":activityId};
    request.responseClass = [ACTMutilBuyDiscountRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTMutilBuyDiscountRespnse *resp = (ACTMutilBuyDiscountRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 获取定制拼团商品列表
 */
- (void)getCustomGoodListByPage:(NSInteger)page
                       andLimit:(NSInteger)limit
                       Complete:(void(^)(ACTGoodListRespnse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = @"/promotion/fightGroup/activityCommodity/query";
    request.param = @{@"page":@(page),@"limit":@(limit)};
    request.responseClass = [ACTGoodListRespnse class];
    request.blockResult = ^(XKBaseResponse *response){
        ACTGoodListRespnse *resp = (ACTGoodListRespnse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}
@end
