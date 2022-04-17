//
//  XKMessageService.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKMessageService.h"
#import "XKNetworkManager.h"
#import <LKDBHelper.h>
#import "XKWeakDelegate.h"

@interface XKMessageService ()

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKMessageService
@synthesize weakDelegates = _weakDelegates;

- (void)queryUnReadMsgNumWithUserId:(NSString *)userId completion:(void (^)(XKMsgUnReadResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = [NSString stringWithFormat:@"/user/users/messageTpyesAndUnreadNum/%@",userId];
    request.responseClass = [XKMsgUnReadResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKMsgUnReadResponse *resp = (XKMsgUnReadResponse *)response;
        if (response.isSuccess) {
            
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

- (void)queryMsgsWithParams:(XKMsgParams *)params completion:(void (^)(XKMsgResponse * _Nonnull response))completionBlock{
    XKBaseRequest *request = [[XKBaseRequest alloc] init];
    request.requestType = XKHttpRequestTypeGet;
    request.url = @"/user/users/message/list";
    request.param = params;
    request.responseClass = [XKMsgResponse  class];
    request.blockResult = ^(XKBaseResponse *response){
        XKMsgResponse  *resp = (XKMsgResponse *)response;
        if (response.isSuccess) {
            [resp.data enumerateObjectsUsingBlock:^(XKMsgData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.msgType = params.typeId;
                obj.userId = params.userId;
            }];
            if (params.page.intValue == 1) {
                [XKMsgData deleteWithWhere:@{@"userId":params.userId?:@"",@"msgType":@(params.typeId)}];
            }
            if (resp.data.count > 0) {
                [XKMsgData insertArrayByAsyncToDB:resp.data];
            }
        }
        if (completionBlock)completionBlock(resp);
    };
    [[XKNetworkManager sharedInstance] addRequest:request];
};

- (NSArray<XKMsgData *> *)queryMsgsWithParamsFromCache:(XKMsgParams *)params{
    NSArray<XKMsgData *> *array = [XKMsgData searchWithWhere:@{@"userId":params.userId?:@"",@"msgType":@(params.typeId)} orderBy:@"sendTime desc" offset:((params.page.integerValue-1)*params.limit.integerValue) count:params.limit.integerValue];
    return array;
}

- (void)readMsgWithMsgId:(NSString *)msgId{
    XKMsgData *data = [XKMsgData searchSingleWithWhere:@{@"id":msgId} orderBy:nil];
    if (data == nil || data.isRead)return;
    data.isRead = YES;
    [data updateToDB];
    [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
        if([delegate respondsToSelector:@selector(readUnreadMsgWithService:msgData:)]){
            [delegate readUnreadMsgWithService:self msgData:data];
        }
    }];
}

- (void)readMsgs:(XKMsgTypeModel *)msgModel{
    [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
        if([delegate respondsToSelector:@selector(readUnreadMsgWithService:msgTypeModel:)]){
            [delegate readUnreadMsgWithService:self msgTypeModel:msgModel];
        }
    }];
}



#pragma mark set delegate
- (void)addWeakDelegate:(id<XKMessageServiceDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKMessageServiceDelegate>)delegate{
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
