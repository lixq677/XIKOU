//
//  XKKeyValue.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKKeyValue : NSObject

@property (nonatomic,strong)id<NSCopying> key;

@property (nonatomic,strong)id value;

@end

NS_ASSUME_NONNULL_END
