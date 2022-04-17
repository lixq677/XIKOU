//
//  XKPropertyService.m
//  XiKou
//
//  Created by Tony on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPropertyService.h"
#import "XKAccountManager.h"
#import "XKWeakDelegate.h"
#import <LKDBHelper.h>

@interface XKPropertyService ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKPropertyService
@synthesize weakDelegates = _weakDelegates;

- (void)getPreferenceWithParams:(XKPrefrenceParams *)params  prefrenceState:(XKPreferenceState)prefrenceState completion:(void (^)(XKPreferenceResponse * _Nonnull response))completionBlock {
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    if (prefrenceState == XKPreferenceStateUsed) {
        request.url = @"/user/users/selectUnusableBySelective";
    }else if (prefrenceState == XKPreferenceStateUnused){
        request.url = @"/user/users/selectUsableBySelective";
    }else{
        request.url = @"/user/users/selectLostEfficacyBySelective";
    }
    request.param = params;
    request.responseClass = [XKPreferenceResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKPreferenceResponse *resp = (XKPreferenceResponse *)response;
        if (resp.isSuccess) {
            [resp.data.result enumerateObjectsUsingBlock:^(XKPreferenceData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.state = prefrenceState;
            }];
            if (params.page.intValue == 1 && resp.data.result.count < params.limit.intValue) {
                [XKPreferenceData deleteWithWhere:@{@"state":@(prefrenceState),@"userId":params.userId}];
            }
            if (resp.data.result.count > 0) {
                [XKPreferenceData insertArrayByAsyncToDB:resp.data.result];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (NSArray<XKPreferenceData *> *)queryPreferenceFromCacheWithPrefrenceState:(XKPreferenceState)prefrenceState userId:(NSString *)userId{
    NSArray<XKPreferenceData *> *preferences = [XKPreferenceData searchWithWhere:@{@"state":@(prefrenceState),@"userId":userId}];
    return preferences;
}


- (void)getPreferenceRecordWithId:(NSString *)preferenceId completion:(void (^)(XKPreferenceDetailResponse * _Nonnull response))completionBlock {
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/queryCouponRecordByUserId/%@",preferenceId];
    request.responseClass = [XKPreferenceDetailResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKPreferenceDetailResponse *resp = (XKPreferenceDetailResponse *)response;
        if (resp.isSuccess) {
            if ([resp.data isExistsFromDB]) {//存入数据库
                [resp.data updateToDB];
            }else{
                [resp.data saveToDB];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

-(XKPreferenceDetailData *)queryPreferenceDetailDataFromCacheWithId:(NSString *)prefenceId{
    if (prefenceId == nil)return nil;
    XKPreferenceDetailData *detailData = [XKPreferenceDetailData searchSingleWithWhere:@{@"id":prefenceId} orderBy:nil];
    return detailData;
}

- (void)getTicketTotalWithUserId:(NSString *)userId completion:(void (^)(XKTicketTotalResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
       request.requestType = XKHttpRequestTypeGet;
       request.url = [NSString stringWithFormat:@"/user/users/queryCouponSumNumByUserId/%@",userId];
       request.responseClass = [XKTicketTotalResponse class];
       request.blockResult = ^(XKBaseResponse *response){
           if (completionBlock)completionBlock((XKTicketTotalResponse *)response);
       };
       [[XKNetworkManager sharedInstance] addRequest:request];
}

//取消用户关注信息
- (void)cancelConcernWithUserId:(NSString *)userId followedUserId:(NSString *)followedUserId completion:(void (^)(XKConcernResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/users/unfollowUser";
    request.param = @{@"userId":userId,@"followedUserId":followedUserId};
    request.responseClass = [XKBaseResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKConcernResponse *resp = (XKConcernResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

//根据用户ID查询账户信息
- (void)getRedBagWithUserId:(NSString *)userId completion:(void (^)(XKRedBagResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/selectAccountByUserId/%@",userId];
    request.responseClass = [XKRedBagResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKRedBagResponse *resp = (XKRedBagResponse *)response;
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

//根据用户id 查询用户优惠券总额
- (void)getPreferenceAmountWithId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/queryUsableCouponSumByUserId/%@",userId];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryAccountUnSettledWithParams:(XKAmountParams *)params completion:(void (^)(XKAmountResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/queryAccountOnWayDetailByUserId";
    request.param = params;
    request.responseClass = [XKAmountResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKAmountResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryAccountRedBagWithParams:(XKAmountParams *)params completion:(void (^)(XKAmountResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/queryAccountReaPacket";
    request.param = params;
    request.responseClass = [XKAmountResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKAmountResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}



- (void)queryAccountCashoutWithParams:(XKCashOutParams *)params completion:(void (^)(XKCashOutResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/cash/queryCashOrderList";
    request.param = params;
    request.responseClass = [XKCashOutResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKCashOutResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryAccountCashoutDetailWithId:(NSString *)id completion:(void (^)(XKCashOutDetailResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/cash/queryCashOrderDetail/%@",id];
    request.responseClass = [XKCashOutDetailResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKCashOutDetailResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}



- (void)queryAccountIncomeAndExpenditurMonthlyTotalWithParams:(XKAmountMonthlyTotalParams *)params completion:(void (^)(XKAmountMonthlyTotalResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/queryMonthAccountCount";
    request.param = params;
    request.responseClass = [XKAmountMonthlyTotalResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKAmountMonthlyTotalResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryAccountCashoutMonthlyTotalWithParams:(XKAmountMonthlyTotalParams *)params completion:(void (^)(XKAmountMonthlyTotalResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/cash/queryCashCount/%@/%@",params.userId,params.searchTime];
   // request.param = params;
    request.responseClass = [XKAmountMonthlyTotalResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKAmountMonthlyTotalResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryRedbagCategoryWithCompletion:(void (^)(XKRedbagCategoryResponse * _Nonnull))completionBlock{
     XKBaseRequest *request = [[XKBaseRequest alloc] init];
     request.requestType = XKHttpRequestTypeGet;
    request.url =  @"/user/users/queryAccountPaymentType";
     request.responseClass = [XKRedbagCategoryResponse class];
     request.blockResult = ^(XKBaseResponse *response){
         if (completionBlock)completionBlock((XKRedbagCategoryResponse *)response);
     };
     [[XKNetworkManager sharedInstance] addRequest:request];
}


/**********银行卡**************/

/**
 请求验证码
 
 @param mobile <#mobile description#>
 @param completionBlock <#completionBlock description#>
 */

- (void)requestSendValidCode:(NSString *)mobile  completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/sendValidCode";
    request.param = @{@"mobile":mobile?:@""};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}

- (void)queryMyBankCardsWithUserId:(NSString *)userId  completion:(void (^)(XKBankResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/selectSettleChannel/%@",userId];
    request.responseClass = [XKBankResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKBankResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
    
}


- (void)addBankCardWithParams:(XKBankBindParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/users/saveSettleChannel";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if ([delegate respondsToSelector:@selector(propertyService:bindBankCardSuccess:)]) {
                    [delegate propertyService:self bindBankCardSuccess:params];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)getValidCodeWithNumber:(NSString *)number completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/sendValidCode";
    request.param = @{@"mobile":number};
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)verifyPayPassword:(NSString *)password userId:(NSString *)userId completion:(void (^)(XKBaseResponse * _Nonnull))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/verifyPayPassword";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![NSString isNull:password]) {
        [params setObject:password forKey:@"payPassword"];
    }
    if (![NSString isNull:userId]) {
        [params setObject:userId forKey:@"userId"];
    }
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)cashoutWithParams:(XKCashVoParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
       request.requestType = XKHttpRequestTypePost;
       request.url = @"/user/cash/createCashOrder";
       request.param = params;
       request.blockResult = ^(XKBaseResponse *response){
           if (response.isSuccess) {
               [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                    if ([delegate respondsToSelector:@selector(propertyService:cashoutSuccess:)]) {
                        [delegate propertyService:self cashoutSuccess:params];
                    }
               }];
           }
           if (completionBlock)completionBlock(response);
       };
       [[XKNetworkManager sharedInstance] addRequest:request];
}



- (void)changeBankCardWithParams:(XKBankBindParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/users/modifySettleChannel";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)removeBankCardWithBankId:(NSString *)bankId completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = [NSString stringWithFormat:@"/user/users/deleteSettleChannel/%@",bankId];
    request.param = @{@"id":bankId};
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                 if ([delegate respondsToSelector:@selector(propertyService:deleteBankCardSuccess:)]) {
                     [delegate propertyService:self deleteBankCardSuccess:bankId];
                 }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryBankListDataWithCompletion:(void (^)(XKBankListResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/bankcode";
    request.param = @{@"page":@1,@"limit":@200};
    request.responseClass = [XKBankListResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            [XKBankListData deleteWithWhere:nil];
            [XKBankListData insertArrayByAsyncToDB:response.data];
        }
        if (completionBlock)completionBlock((XKBankListResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)queryRedPacketDetailWithParams:(XKRedPacketDetailParams *)params completion:(void (^)(XKRedPacketDetailResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.param = params;
    request.url = @"/user/users/queryRedPacketDetail";
    request.responseClass = [XKRedPacketDetailResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock((XKRedPacketDetailResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}





- (void)transportAccountWithParams:(XKTransportAccounParams *)params completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/users/accountTransport";
    request.param = params;
    request.blockResult = ^(XKBaseResponse *response){
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (NSArray<XKBankListData *> *)queryBankListDataFromCache{
    return [XKBankListData searchWithWhere:nil];
}


static  NSString *const kBalanceHiddenKey = @"BalanceHiddenKey";

- (void)setUserId:(NSString *)userId amountHidden:(BOOL)hidden{
    NSString *key = kBalanceHiddenKey;
    if (![NSString isNull:userId]) {
        key = [kBalanceHiddenKey stringByAppendingString:userId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(hidden) forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
        if ([delegate respondsToSelector:@selector(changeAmountStateWithService:userId:isHidden:)]) {
            [delegate changeAmountStateWithService:self userId:userId isHidden:hidden];
        }
    }];
}

- (BOOL)amountHiddenByUserId:(NSString *)userId{
    NSString *key = kBalanceHiddenKey;
    if (![NSString isNull:userId]) {
        key = [kBalanceHiddenKey stringByAppendingString:userId];
    }
    BOOL hidden = [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
    return hidden;
}

- (NSString *)imageNameFromBankName:(NSString *)bankName{
    if ([NSString isNull:bankName]) return @"default_bank";
    NSDictionary<NSString *,NSString *> *bankImages = @{
    @"工商银行":@"gs_bank",
    @"建设银行":@"js_bank",
    @"招商银行":@"zs_bank",
    @"农业银行":@"ny_bank",
    @"浦发银行":@"pf_bank",
    @"中国银行":@"zg_bank",
    @"民生银行":@"ms_bank",
    @"兴业银行":@"xy_bank",
    @"交通银行":@"jt_bank",
    @"光大银行":@"gd_bank",
    @"中信银行":@"zx_bank",
    @"华夏银行":@"hx_bank",
    @"中国人民银行":@"zgrm_bank",
    @"深圳发展银行":@"szfz_bank",
    @"国家开发银行":@"gjkf_bank",
    @"邮政银行":@"yz_bank",
    @"长沙银行":@"cs_bank"
    };
    NSString *imageName = bankImages[bankName];
    if ([NSString isNull:imageName]) {
        imageName = @"default_bank";
    }
    return imageName;
}

#pragma mark set delegate
- (void)addWeakDelegate:(id<XKPropertyServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKPropertyServiceDelegate>)delegate{
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

