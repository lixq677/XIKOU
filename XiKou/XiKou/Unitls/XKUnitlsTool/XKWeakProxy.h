//
//  NSString+XKUnitls.h
//  XiKou
//
//  Created by 李笑清 on 2019/6/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

/*XKWeakProxy过重载methodSignatureForSelector和forwardInvocation实现对象的弱引用
 避免循环引用，或是没有销毁，比如定义了Repeat的定时器，就有可能没有销毁掉，需要使用weak引用
 */
@interface XKWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

+ (instancetype)proxyWithTarget:(id)target;

- (instancetype)initWithTarget:(id)target;

@end
