//
//  XKGoodModel.m
//  XiKou
//
//  Created by L.O.U on 2019/7/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodModel.h"
#import "NSDate+Extension.h"
#import <LKDBHelper.h>


@implementation XKGoodListModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activityType" : @[@"activityModule",@"activityType"],
             @"id":@[@"id",@"activityGoodsId"],
             };
}

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSArray *)getPrimaryKeyUnionArray{
    return @[@"id",@"userId"];
}

@end
@implementation XKGoodModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{
             @"imageList":[XKGoodImageModel class],
             @"skuList":[XKGoodSKUModel class],
             @"models":[XKGoodSKUSpec class],
             @"recordList":[ACTAuctionRecordModel class]
             };
}


/**
 详情里面不返回商品主图，需要自己去取一张，下单的时候需要传给服务器

 @param imageList <#imageList description#>
 */
- (void)setImageList:(NSArray<XKGoodImageModel *> *)imageList{
    _imageList = imageList;
    if (imageList.count > 0 && !self.goodsImageUrl) {
        XKGoodImageModel *model = imageList[0];
        self.goodsImageUrl = model.url;
    }
}
@end

@implementation XKGoodImageModel


@end

@implementation XKGoodSKUModel


@end

@implementation XKGoodSKUSpec

@end

@implementation ACTAuctionRecordModel


@end

