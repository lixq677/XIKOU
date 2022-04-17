//
//  ACTCartService.m
//  XiKou
//
//  Created by L.O.U on 2019/7/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKActivityCartService.h"

@implementation XKActivityCartService

- (void)getCartDataByUserId:(NSString *)userId
                   Complete:(void(^)(ACTCartDataResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url   = [NSString stringWithFormat:@"/promotion/moreDiscount/buyerCart/commodity/%@",userId];
    request.responseClass = [ACTCartDataResponse class];
//    request.par
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        ACTCartDataResponse *response = (ACTCartDataResponse *)result;
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)deleteCartGoodById:(NSString *)cartId
                  Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url   = [NSString stringWithFormat:@"/promotion/moreDiscount/buyerCart/clearBuyerCart/%@",cartId];
//    request.param = @{@"id":cartId};
    request.blockResult = ^(XKBaseResponse * _Nonnull result) {
        if (completionBlock)completionBlock(result);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

/**
 多买多折加入购物车
 @param param 参数
 */
- (void)mutilGoodAddCart:(NSDictionary *)param Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url   = @"/promotion/moreDiscount/buyerCart/create";
    request.param = param;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

@end

@implementation ACTCartDataResponse
@synthesize data = _data;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[ACTCartStoreModel class]};
}
@end

@implementation ACTCartStoreModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list":[ACTCartGoodModel class]};
}
@end

@implementation ACTCartGoodModel

@end
