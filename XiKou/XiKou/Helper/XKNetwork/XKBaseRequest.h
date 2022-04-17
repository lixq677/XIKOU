//
//  XKBaseRequest.h
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKBaseResponse.h"
#import <AFNetworking.h>

typedef void(^XKBlockResult)(XKBaseResponse * _Nonnull result);

typedef void(^XKBlockProgress)(NSProgress * _Nullable progress);

typedef void (^XKBlockConstructingBody)(id<AFMultipartFormData>  _Nonnull formData);

typedef NS_ENUM(NSInteger,XKHttpRequestType) {
    XKHttpRequestTypeGet            = 0,
    XKHttpRequestTypePost           = 1,
    XKHttpRequestTypePut            = 2,
    XKHttpRequestTypeDelete         = 3,
    XKHttpRequestTypeDownload       = 4,
    XKHttpRequestTypeUpload         = 5,
    XKHttpRequestTypePostForUpload  = 6,
};

typedef NS_ENUM(NSInteger,XKRequestSerializerType) {
    XKRequestSerializerTypeJson =   0,
    XKRequestSerializerTypeHttp =   1
};

typedef NS_ENUM(NSInteger,XKResponseSerializerType) {
    XKResponseSerializerTypeJson =   0,
    XKResponseSerializerTypeHttp =   1
};

NS_ASSUME_NONNULL_BEGIN

@interface XKBaseRequest : NSObject

@property (nonatomic,strong)NSString *url;

@property (nonatomic,strong)id param;

/*声明url是否包含了域名，若包含，不再在url前面添加默认域名，默认不包含域名*/
@property (nonatomic,assign)BOOL includeDomain;

@property (nonatomic,assign)NSTimeInterval timeout;

@property (nonatomic,assign)XKHttpRequestType requestType;

@property (nonatomic,copy)XKBlockResult blockResult;

@property (nonatomic,copy)XKBlockProgress blockProgress;

@property (nonatomic,copy)XKBlockConstructingBody blockConstructingBody;

@property (nonatomic,copy) Class responseClass; //default = nil

//http请求头
@property (nonatomic,strong) NSDictionary *httpHeaders;

//上传文件时的文件路径
@property (nonatomic,strong)NSURL *fromFile;

//下载文件时存放的路径,用于指定文件下载存放位置
@property (nonatomic,strong)NSURL *targetFile;

@property (nonatomic,assign)XKRequestSerializerType requestSerializerType;

@property (nonatomic,assign)XKResponseSerializerType responseSerializerType;

@end

NS_ASSUME_NONNULL_END
