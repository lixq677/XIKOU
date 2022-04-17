//
//  XKActivityRulerModel.m
//  XiKou
//
//  Created by L.O.U on 2019/7/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKActivityRulerModel.h"
#import "XKGoodModel.h"

@implementation XKActivityRulerModel

@end

@implementation ACTGoodAuctionModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"recordList":[ACTAuctionRecordModel class]};
}

- (NSString *)statusTitle{
    switch (self.status) {
        case Auction_UnBegin:
            return @"未开始";
        case Auction_Begin:
            return @"抢拍";
        case Auction_End:
            return @"已结束";
        case Auction_Cancle:
            return @"已取消";
        case Auction_Abortive:
            return @"已流拍";
        default:
            return @"";
            break;
    }
}
@end

@implementation ACTMutilBuyDiscountModel


@end
