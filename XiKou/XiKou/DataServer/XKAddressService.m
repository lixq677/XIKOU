//
//  XKAddressService.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKAddressService.h"
#import "XKNetworkManager.h"
#import "XKUnitls.h"
#import <LKDBHelper.h>
#import "XKWeakDelegate.h"

@interface XKAddressService ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKAddressService
@synthesize weakDelegates = _weakDelegates;

- (void)queryAddressListWithUserId:(NSString *)userId completion:(void (^)(XKAddressUserListResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/userAddress/userAddressList/%@",userId];
    request.responseClass = [XKAddressUserListResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            XKAddressUserListResponse *resp = (XKAddressUserListResponse *)response;
            [XKAddressVoData deleteWithWhere:@{@"userId":userId}];
            if (resp.data.count > 0) {
                [XKAddressVoData insertArrayByAsyncToDB:response.data];
            }
        }
        if (completionBlock)completionBlock((XKAddressUserListResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (NSArray<XKAddressVoData *> *)queryAddressListFromCacheWithUserId:(NSString *)userId{
    if ([NSString isNull:userId]) {
        return nil;
    }
    NSArray<XKAddressVoData *> *array = [XKAddressVoData searchWithWhere:@{@"userId":userId}];
    return array;
}

- (XKAddressVoData *)queryAddressVoDataWithId:(NSString *)id{
    if([NSString isNull:id])return nil;
    return [XKAddressVoData searchSingleWithWhere:@{@"id":id} orderBy:nil];
}


- (void)queryAllAddressInfoWithLevel:(XKAddressLevel)level completion:(void (^)(XKAddressInfoListResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/base/queryAreaByIevel/%@",@(level)];
    request.responseClass = [XKAddressInfoListResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            XKAddressInfoListResponse *resp = (XKAddressInfoListResponse *)response;
            if (resp.data.count > 0) {
                [XKAddressInfoData insertArrayByAsyncToDB:response.data];
            }
        }
        if (completionBlock)completionBlock((XKAddressInfoListResponse *)response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)addAddress:(XKAddressVoData *)voData completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = @"/user/userAddress/createUserAddress";
    request.param = voData;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            voData.id = response.data;
            if (voData.defaultId.intValue == XKAddressTypeDefault) {
                XKAddressVoData *voD = [XKAddressVoData searchSingleWithWhere:@{@"userId":voData.userId,@"defaultId":@(XKAddressTypeDefault)} orderBy:nil];
                if (voD) {
                    voD.defaultId = @(XKAddressTypeNone);
                    [voD updateToDB];
                }
            }
            [voData saveToDB];
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(addAddressWithSevice:address:)]){
                    [delegate addAddressWithSevice:self address:voData];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}

- (void)updateAddress:(XKAddressVoData *)voData completion:(void (^)(XKBaseResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = [NSString stringWithFormat:@"/user/userAddress/update/%@",voData.id];
    request.param = voData;
    request.blockResult = ^(XKBaseResponse *response){
        if (response.isSuccess) {
            if (voData.defaultId.intValue == XKAddressTypeDefault) {
                XKAddressVoData *voD = [XKAddressVoData searchSingleWithWhere:@{@"userId":voData.userId,@"defaultId":@(XKAddressTypeDefault)} orderBy:nil];
                if (voD && [voD.id isEqualToString:voData.id] == NO) {
                    voD.defaultId = @(XKAddressTypeNone);
                    [voD updateToDB];
                }
            }
            [voData updateToDB];
            [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
                if([delegate respondsToSelector:@selector(addAddressWithSevice:address:)]){
                    [delegate updateAddressWithSevice:self address:voData];
                }
            }];
        }
        if (completionBlock)completionBlock(response);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


- (void)deleteAddressWithId:(NSString *)id completion:(void (^)(XKAddressDeleteResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypePost;
    request.url = [NSString stringWithFormat:@"/user/userAddress/delete/%@",id];
    request.param = @{@"id":id};
    request.responseClass = [XKAddressDeleteResponse class];
    request.blockResult = ^(XKBaseResponse *response){
        XKAddressDeleteResponse *resp = (XKAddressDeleteResponse *)response;
        if (response.isSuccess) {
            XKAddressVoData *voData = [XKAddressVoData searchSingleWithWhere:@{@"id":id} orderBy:nil];
            if(voData.defaultId.intValue == XKAddressTypeDefault && ![NSString isNull:resp.data.id]){
                XKAddressVoData *voD = [XKAddressVoData searchSingleWithWhere:@{@"id":resp.data.id} orderBy:nil];
                voD.defaultId = @(XKAddressTypeDefault);
                [voD updateToDB];
            }
            [XKAddressVoData deleteWithWhere:@{@"id":id}];
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
}


#pragma mark set delegate
- (void)addWeakDelegate:(id<XKAddressServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKAddressServiceDelegate>)delegate{
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
