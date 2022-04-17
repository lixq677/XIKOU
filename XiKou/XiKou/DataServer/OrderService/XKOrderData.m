//
//  XKOrderData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/26.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKOrderData.h"

@implementation XKOrderListResponse
@synthesize data = _data;

@end

@implementation XKOrderListData
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"result":[XKOrderListModel class]};
}
@end

@implementation XKOrderDetailResponse
@synthesize data = _data;

@end

@implementation XKMutilOrderDetailResponse
@synthesize data = _data;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKOrderDetailModel class]};
}
@end

@implementation XKConsignGoodResponse
@synthesize data = _data;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[MIConsigningGoodModel class]};
}
@end

@implementation XKConsigningGoodData
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"result":[MIConsigningGoodModel class]};
}

@end
@implementation XKWugOderLimitBanalceData
@synthesize data = _data;
+ (id)modelContainerPropertyGenericClass{
    return @{@"data":[XKWugOderLimitBanalce class]};
}
@end
@implementation XKWugOderLimitBanalce

@end

@implementation XKOTOParams

@end


@implementation XKOTOResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKOTOData class]};
}

@end

@implementation XKOrderPayRequestParam
//@synthesize clientType = _clientType;
//@synthesize osType     = _osType;
//@synthesize payType    = _payType;
//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        _clientType = @"ios";
//        _osType     = OS_Ios;
//        _payType    = App;
//    }
//    return self;
//}

@end


@implementation XKInsteadPaymentParams

@end


@implementation XKOrderPaymentModel

@end

@implementation XKInsteadPaymentData
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"insteadPaymentOrderPageModels":[XKOrderPaymentModel class]};
}
@end

@implementation XKInsteadPaymentResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKInsteadPaymentData class]};
}

@end

@implementation XKAddOrModifyAddressVoParams

@end
