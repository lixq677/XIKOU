//
//  XKActivityCartData.m
//  XiKou
//
//  Created by L.O.U on 2019/8/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKActivityCartData.h"

@implementation ACTCartDataResponse
@synthesize data = _data;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[ACTCartStoreModel class]};
}
@end

@implementation ACTCartStoreModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"list":[ACTCartGoodModel class]};
}

- (NSMutableArray<ACTCartGoodModel *> *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}
@end

@implementation ACTCartGoodModel
- (NSMutableArray *)indexs{
    if (!_indexs) {
        _indexs = [NSMutableArray array];
    }
    return _indexs;
}
@end

