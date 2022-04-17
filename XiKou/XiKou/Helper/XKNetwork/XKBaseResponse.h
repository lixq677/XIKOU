//
//  XKBaseResponse.h
//  XiKou
//
//  Created by 李笑清 on 2019/5/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKBaseResponse : NSObject<YYModel>

/*自定义的返回json等数据格式，可以直接使用responseString自行去转换*/
@property (nonatomic, strong) NSString *responseString;

/*返回的数据模型：如果有定义responseClass，则转换成responseClass；如果定义返回Json，则返回的为Dictionary，否则直接返回的就是String*/
@property (nonatomic, strong) id responseObject;

/*返回的http头*/
@property (nonatomic, strong) NSDictionary *responseHttpHeaders;

/*下载路径*/
@property (nonatomic, strong) NSURL *targetPath;

/*下载文件名字*/
@property (nonatomic, strong) NSString *suggestedFilename;

@property (nonatomic,strong) NSError *error;

@property (nonatomic,assign) NSNumber *code;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,strong) id data;

/*判断返回数据是否成功*/
- (BOOL)isSuccess;

- (BOOL)isNotSuccess;

@end

NS_ASSUME_NONNULL_END
