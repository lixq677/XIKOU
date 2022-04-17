//
//  NSObject+CombineObject.m
//  gangzhi
//
//  Created by Xun on 16/2/20.
//  Copyright © 2016年 gangzhi. All rights reserved.
//

#import "NSObject+CombineObject.h"
#import <objc/runtime.h>

static const char * combineObject = "COMBINE_OBJECT";

@implementation NSObject (CombineObject)


- (void)combineObject:(id)object
{
    objc_setAssociatedObject(self, combineObject, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)combineObject:(id)object withKey:(const char *)key
{
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}

- (id)getCombineObject
{
    return objc_getAssociatedObject(self, combineObject);
}

- (id)getCombineObjectByKey:(const char *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)removeCombineObjects
{
    objc_removeAssociatedObjects(self);
}

@end
