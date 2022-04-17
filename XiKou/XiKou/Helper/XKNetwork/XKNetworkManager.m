//
//  XKNetworkManager.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKNetworkManager.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import "NSString+XKNetwork.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "XKNetworkConfig.h"
#import "XKWeakDelegate.h"

@interface XKNetworkManager ()

//当前队列中的任务
@property (nonatomic, strong) NSMutableDictionary<NSURLSessionTask *,NSString *> *allTasks;

@property (nonatomic, strong) NSMutableDictionary<XKBaseRequest *,NSString *> *allRequests;

@property (nonatomic,strong,readonly) XKWeakDelegate *weakDelegates;

@end

@implementation XKNetworkManager
@synthesize weakDelegates = _weakDelegates;

+(XKNetworkManager *)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        //开始监测网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

- (void)addRequest:(XKBaseRequest *)request{
    NSString *URLString = nil;
    if (request.includeDomain) {
        URLString = request.url;
    }else{
        NSString *domain = [[XKNetworkConfig shareInstance] mainDomain];
        URLString = [domain stringByAppendingPathComponent:request.url];
        /*添加基础参数*/
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[[XKNetworkConfig shareInstance] baseParams]];
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970]*1000;
        [params setObject:@([@(timestamp) longLongValue]) forKey:@"timestamp"];
        NSString *uid = [[XKNetworkConfig shareInstance] userId];
        if (![NSString isNull:uid]) {
            [params setObject:uid forKey:@"xkuid"];
        }
        
        URLString = [NSString connectUrl:URLString params:params];
        URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
        
    }
    NSAssert([URLString isValidUrl], @"网络请求URL无效");
     NSLog(@"网络请求URL:%@",URLString);
    id parameters = nil;
    if (request.param) {
        parameters = [request.param yy_modelToJSONObject];
        NSLog(@"网络请求参数:%@",[parameters yy_modelToJSONString]);
    }
    
    XKBlockProgress progress = nil;
    if(request.blockProgress){
        progress = request.blockProgress;
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (request.requestSerializerType == XKRequestSerializerTypeJson) {
        [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    }else{
        [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    }
    if (request.responseSerializerType == XKResponseSerializerTypeJson) {
        [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }else{
        [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    }
    if (request.httpHeaders.count>0) {
        [request.httpHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key,id value,BOOL *stop){
            id headerValue = value;
            if (![value isKindOfClass:[NSString class]]) {
                if ([value respondsToSelector:@selector(stringValue)]) {
                    headerValue = [value stringValue];
                }else{
                    headerValue = value;
                }
            }
            if (headerValue) {
                [[manager requestSerializer] setValue:headerValue forHTTPHeaderField:key];
            }
        }];
    }
    NSString *token = [[XKNetworkConfig shareInstance] token];
    if (token) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    }
    manager.requestSerializer.timeoutInterval = request.timeout;
    [[manager responseSerializer] setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain",@"application/ostet-stream", @"multipart/form-data;",@"text/plain",nil]];
    if (request.requestType == XKHttpRequestTypeGet) {
        [manager GET:URLString parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleRequest:request task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequest:request task:task error:error];
        }];
    }else if (request.requestType == XKHttpRequestTypePost){
        [manager POST:URLString parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleRequest:request task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequest:request task:task error:error];
        }];
    }else if (request.requestType == XKHttpRequestTypePostForUpload){
        [[AFHTTPSessionManager manager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            request.blockConstructingBody(formData);
        } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleRequest:request task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequest:request task:task error:error];
        }];
    
    }else if (request.requestType == XKHttpRequestTypePut){
        [manager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleRequest:request task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequest:request task:task error:error];
        }];

    }else if (request.requestType == XKHttpRequestTypeDelete){
        [manager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleRequest:request task:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleRequest:request task:task error:error];
        }];

    }else if (request.requestType == XKHttpRequestTypeUpload){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
         NSURLRequest *uploadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
//        NSURL *URL = [NSURL URLWithString:@"http://example.com/upload"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
       // NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:uploadRequest fromFile:request.fromFile progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            XKBaseResponse *baseResponse = [[XKBaseResponse alloc] init];
            baseResponse.responseObject = responseObject;
            baseResponse.error = error;
            //baseResponse.suggestedFilename = response.suggestedFilename;
            if (request.blockResult) {
                request.blockResult(baseResponse);
            }
        }];
        [uploadTask resume];
    }else if (request.requestType == XKHttpRequestTypeDownload){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURL *targetFile = [request targetFile];
        //NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
        NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:downloadRequest progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            BOOL isDirectory = NO;
            if([[NSFileManager defaultManager] fileExistsAtPath:targetFile.absoluteString isDirectory:&isDirectory]){
                if (isDirectory) {
                    return [targetFile URLByAppendingPathComponent:[response suggestedFilename]];
                }else{
                    return targetFile;
                }
            }else{
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];

            }
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            NSLog(@"File downloaded to: %@", filePath);
            XKBaseResponse *baseResponse = [[XKBaseResponse alloc] init];
            baseResponse.error = error;
            baseResponse.targetPath = filePath;
            baseResponse.suggestedFilename = response.suggestedFilename;
            if (request.blockResult) {
                request.blockResult(baseResponse);
            }
        }];
        [downloadTask resume];
    }else{
        NSAssert(NO, @"网络请求方式无效");
    }
}


#pragma mark tools methods
/*服务器返回数据加密封装处理*/
- (void)handleRequest:(XKBaseRequest *)request task:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    NSString *responseString = nil;
    XKBaseResponse *response = nil;
    BOOL nomalFormat = NO;
    if([responseObject isKindOfClass:[NSDictionary class]]){
        responseString = [responseObject yy_modelToJSONString];
        if(request.responseClass){
            response = [request.responseClass yy_modelWithJSON:responseObject];
        }else{
            response = [XKBaseResponse yy_modelWithJSON:responseObject];
        }
        nomalFormat = YES;
    }else if ([responseObject isKindOfClass:[NSData class]]) {
        responseString =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }else if ([responseObject isKindOfClass:[NSString class]]){
        responseString = responseObject;
    }else if ([responseObject isKindOfClass:[NSArray class]]){
        responseString = [responseObject yy_modelToJSONString];
    }else{
        NSAssert(NO, @"返回数据类型出错");
    }
    if (response == nil) {
        if(request.responseClass){
            response = [[request.responseClass alloc] init];
        }else{
            response = [[XKBaseResponse alloc] init];
        }
    }
    if (nomalFormat == NO) {//返回的数据不是正常的数据格式
        response.code = @([self statusCodeFromSessionTask:task]);
    }
    response.responseString = responseString;
    response.responseObject = responseObject;
    response.responseHttpHeaders = [self httpHeadersFromSessionTask:task];
    response.error = [NSError errorWithDomain:@"网络请求成功，数据正常返回" code:response.code.intValue userInfo:nil];
    NSLog(@"网络请求返回数据：url:%@ response%@",request.url,response.responseString);
    if (request.blockResult) {
        request.blockResult(response);
    }
    [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
        if ([delegate respondsToSelector:@selector(handleRequest:response:)]) {
            [delegate handleRequest:request response:response];
        }
    }];
}

/*请求服务器失败，数据返回*/
- (void)handleRequest:(XKBaseRequest *)request task:(NSURLSessionDataTask *)task error:(NSError *)error{
    XKBaseResponse *response = [[XKBaseResponse alloc] init];
    response.code = @(error.code);
    if (response.code.intValue == NSURLErrorCannotConnectToHost) {
        response.msg = @"当前网络无连接，请检查手机网络设置";
    }else if (response.code.intValue == NSURLErrorTimedOut){
        response.msg = @"网络连接超时，再试一试吧";
    }else if (response.code.intValue == NSURLErrorCannotFindHost){
        response.msg = @"未能发现主机";
    }else if (response.code.intValue == 500 || response.code.intValue == 503){
        response.msg = @"服务器错误";
    }else{
        if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
            response.msg = @"当前网络无连接，请检查手机网络设置";
        }else if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown){
            response.msg = @"未知网络";
        }else{
            response.msg = @"网络错误";
        }
    }
   
    response.responseHttpHeaders = [self httpHeadersFromSessionTask:task];
    response.error = error;
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"服务器的错误原因:%@",str);
    if (request.blockResult) {
        request.blockResult(response);
    }
    [self.weakDelegates enumerateWithBlock:^(id  _Nonnull delegate) {
        if ([delegate respondsToSelector:@selector(handleRequest:response:)]) {
            [delegate handleRequest:request response:response];
        }
    }];
}

- (NSInteger)statusCodeFromSessionTask:(NSURLSessionDataTask *)task{
    if ([task respondsToSelector:@selector(response)]) {
        NSHTTPURLResponse *httpTask = (NSHTTPURLResponse*)[task response];
        if (httpTask) {
            return httpTask.statusCode;
        }
    }
    return -1;
}

- (NSDictionary *)httpHeadersFromSessionTask:(NSURLSessionDataTask *)task{
    if ([task respondsToSelector:@selector(response)]) {
        NSHTTPURLResponse *httpTask = (NSHTTPURLResponse*)[task response];
        return httpTask.allHeaderFields;
    }
    return nil;
}


#pragma mark get or set methods
- (NSMutableDictionary<NSURLSessionTask *,NSString *> *)allTasks{
    if (!_allTasks) {
        _allTasks = [[NSMutableDictionary alloc] init];
    }
    return _allTasks;
}

#pragma mark set delegate
- (void)addWeakDelegate:(id<XKNetworkManagerDelegate>)delegate{
    [self.weakDelegates addDelegate:delegate];
}

- (void)removeWeakDelegate:(id<XKNetworkManagerDelegate>)delegate{
    [self.weakDelegates removeDelegate:delegate];
}

#pragma mark getter
- (XKWeakDelegate *)weakDelegates{
    if (_weakDelegates == nil) {
        _weakDelegates = [[XKWeakDelegate alloc] init];
    }
    return _weakDelegates;
}

/*实时获取网络状态*/
+ (void)getNetworkStatusWithBlock:(XKNetworkStatus)networkStatus{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkStatus(status);
    }];
}

- (BOOL)isReachable{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}


@end
