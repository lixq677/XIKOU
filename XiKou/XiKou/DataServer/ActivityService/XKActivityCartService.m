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


/**
 根据ID修改购物车商品数量

 @param cartId <#cartId description#>
 @param num <#num description#>
 @param completionBlock <#completionBlock description#>
 */
- (void)updateCartGoodNumById:(NSString *)cartId
                       andNum:(NSInteger)num
                     Complete:(void(^)(XKBaseResponse *_Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url   = @"/promotion/moreDiscount/buyerCart/modifyBuyerNumInBuyerCart";
    request.param = @{@"buyerCartId":cartId,
                      @"buyerNumber":@(num)};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}
@end

