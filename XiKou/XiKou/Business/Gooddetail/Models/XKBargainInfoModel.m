//
//  XKBargainInfoModel.m
//  XiKou
//
//  Created by L.O.U on 2019/7/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBargainInfoModel.h"

@implementation XKBargainInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"userBargainRecordVoList":[XKBargainPersonModel class],
             };
}
@end

@implementation XKBargainPersonModel

@end
