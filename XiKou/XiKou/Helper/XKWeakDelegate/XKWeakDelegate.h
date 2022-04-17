//
//  XKWeakDelegate.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKWeakDelegate : NSObject

/**
 添加代理弱引用
 
 @param delegate 按后进先处理的原则添加
 */
- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

/**
 移除某一类的监听代理
 
 @param kls 类
 */
- (void)removeDelegateClass:(Class)kls;

/**
 代理关联的数据
 
 @param delegate delegate
 @param extraData extraData
 */
//- (void)addDelegate:(id)delegate withExtraData:(id)extraData;

// 遍历所有delegate，如果非空，且能响应sel则调用block，传入delegate
- (void)enumerateUsingBlock:(void(^)(id delegate))block respond:(nullable SEL)sel;

- (void)enumerateWithBlock:(void(^)(id delegate))block;
/**
 处理delegate
 
 @param block 回调
 @return 是否不需要继续传递
 */
- (BOOL)enumerateUsingBlock:(BOOL(^)(id delegate))block;

//可当做数组弱引用
- (NSInteger)count;

- (void)removeAllDelegates;


@end

/**
 作为虚类，需要实例去实现
 */
@protocol XKWeakDelegateProtocol <NSObject>

@required

- (void)addWeakDelegate:(id)delegate;

@optional
- (void)removeWeakDelegate:(id)delegate;

- (void)enumerateDelegatesUsingBlock:(void(^)(id delegate))block;

@end

NS_ASSUME_NONNULL_END
