//
//  MIAddressModel.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/14.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIAddress : NSObject <YYModel>

@property (nonatomic,strong) NSNumber *code;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSArray<MIAddress *> *children;


@end





NS_ASSUME_NONNULL_END
