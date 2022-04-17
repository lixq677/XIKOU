//
//  NSObject+CombineObject.h
//  gangzhi
//
//  Created by Xun on 16/2/20.
//  Copyright © 2016年 gangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CombineObject)

/**
 *  关联对象
 *
 *  @param object 对象
 */
- (void)combineObject:(id)object;

/**
 *  关联对象
 *
 *  @param object 对象
 *  @param key    键
 */
- (void)combineObject:(id)object withKey:(const char *)key;

/**
 *  获取关联对象
 *
 *  @return 关联对象
 */
- (id)getCombineObject;

/**
 *  获取关联对象
 *
 *  @param key 键
 *
 *  @return 关联对象
 */
- (id)getCombineObjectByKey:(const char *)key;

/**
 *  移除所有关联对象
 */
- (void)removeCombineObjects;

@end
