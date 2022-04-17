//
//  XKPropertyData.m
//  XiKou
//
//  Created by Tony on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKPropertyData.h"
#import <LKDBHelper.h>

//优惠券
@implementation XKPreferenceDataModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"result":[XKPreferenceData class]};
}

@end

@implementation XKPreferenceData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}
@end

@implementation XKPreferenceResponse
@synthesize data = _data;

//
//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
//    return @{@"data":@"XKPreferenceData"};
//}
@end

@implementation XKPreferenceDetailRecordModel

- (NSString *)moduleIdFromString{
    NSString *string = nil;
    switch (self.moduleId) {
        case Activity_WG:
            string = @"吾G";
            break;
        case Activity_Global:
            string = @"全球买手";
            break;
        case Activity_ZeroBuy:
            string = @"0元竞拍";
            break;
        case Activity_Discount:
            string = @"多买多折";
            break;
        case Activity_Bargain:
            string = @"砍立得";
            break;
        case Activity_Custom:
            string = @"定制拼团";
            break;
        case UIActivity_O2O:
            string = @"O2O线下";
            break;
        case Activity_NewUser:
            string = @"新人专区";
            break;
        default:
            break;
    }
    return string;
}

@end

@implementation XKPreferenceDetailData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"recordModelList":[XKPreferenceDetailRecordModel class]};
}

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

@end

@implementation XKPreferenceDetailResponse
@synthesize data = _data;

@end

@implementation XKTicketTotalData

@end


@implementation XKTicketTotalResponse
@synthesize data = _data;

@end

//关注
@implementation XKConcernDataModel
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"result":[XKConcernData class]};
}

@end

@implementation XKConcernData

@end

@implementation XKConcernResponse
@synthesize data = _data;

@end

//关注

@implementation MICashOutTypeModel

@end

@implementation XKRedBagData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"bankCardList":[XKBankData  class],@"cashTypeList":[MICashOutTypeModel class]};
}

@end

@implementation XKRedBagResponse
@synthesize data = _data;

@end

@implementation XKPrefrenceParams

@end


@implementation XKAmountParams

@end

@implementation XKAmountData

@end

@implementation XKAmountResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKAmountData  class]};
}

@end


@implementation XKAmountMonthlyTotalParams

@end



@implementation XKAmountMonthlyTotalData



@end

@implementation XKAmountMonthlyTotalResponse
@synthesize data = _data;

@end


@implementation XKBankBindParams

@end

@implementation XKBankData


@end

@implementation XKBankResponse
@synthesize data = _data;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKBankData  class]};
}

@end

@implementation XKCashVoParams

- (instancetype)init{
    if (self = [super init]) {
        self.state = 1;
        self.userType = 5;
    }
    return self;
}

@end

@implementation XKCashOutParams
- (instancetype)init{
    if (self = [super init]) {
        self.userType = 5;
    }
    return self;
}

@end

@implementation XKCashOutData

//- (NSString *)stringFromCashoutState{
//    NSString *string = nil;
//    switch (self.state) {
//        case XKCashOutStateApproving:
//            string = @"审批中";
//            break;
//        case XKCashOutStateApproveSuccess:
//            string = @"审批通过";
//            break;
//        case XKCashOutStatePaySuccess:
//            string = @"支付成功";
//            break;
//        case XKCashOutStateAbolish:
//            string = @"废止";
//            break;
//        case XKCashOutStateReject:
//            string = @"驳回";
//            break;
//        case XKCashOutStatePayFailed:
//            string = @"支付失败";
//            break;
//        default:
//            break;
//    }
//    return string;
//}


@end

@implementation XKCashOutResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKCashOutData  class]};
}

@end

@implementation XKCashOutDetailData

@end

@implementation XKCashOutDetailResponse
@synthesize data = _data;


@end

@implementation XKBankListData
+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

@end

@implementation XKBankListResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKBankListData  class]};
}

@end

@implementation XKTransportAccounParams


@end

@implementation XKRedbagCategoryTitle

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"select"];
}

@end

@implementation XKRedbagCategoryData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"income":[XKRedbagCategoryTitle  class],@"outcome":[XKRedbagCategoryTitle  class]};
}

@end


@implementation XKRedbagCategoryResponse
@synthesize data = _data;

@end

@implementation XKRedPacketDetailParams

@end

@implementation XKRedPacketDetailResponse
@synthesize data = _data;

@end




