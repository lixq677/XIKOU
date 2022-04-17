//
//  XKOrderModel.m
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKOrderModel.h"

@implementation XKOrderBaseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"consignmentType":@[@"consignmentType",@"goodsVo.consignmentType"],
             };
}


- (NSString *)statusTitle{
    switch (self.state) {
        case OSUnPay:
            return @"待付款";
        case OSUnDeliver:
            return @"待发货";
        case OSUnReceive:
            return @"待收货";
        case OSCancle:
            return @"已取消";
        case OSComlete:
            return @"已完成";
        case OSClose:
            return @"已关闭";
        case OSUnSure:
            return @"待确认";
        case OSUnGroup:
            return @"待成团";
        case OSGroupSus:
            return @"成团成功";
        case OSGroupFail:
            return @"拼团失败";
        case OSConsign:
            return @"已寄卖";
        default:
            break;
    }
}

@end
@implementation XKOrderListModel

@end

@implementation XKOrderDetailModel


@end

@implementation  XKOrderGoodModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"commodityName":@[@"commodityName",@"goodsName"],
             };
}

@end

@implementation MIConsigningGoodModel


@end

@implementation XKOTOData

@end
