//
//  CMPayStateVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKEnum.h"

typedef NS_ENUM(int,CMState) {
    CMStatePaySuccess   =   0,
    CMStatePayFaild     =   1,
    CMStateCashSuccess  =   2,
    CMStateCashFaild    =   3,
    CMStateTransportSuccess =   4,
    CMStateTransportFailed  =   5,
};

NS_ASSUME_NONNULL_BEGIN

@interface CMPayStateVC : BaseViewController

- (instancetype)initWithPayState:(CMState)state;

@property (nonatomic, strong) NSNumber *payAmount;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, assign) XKOrderType orderType;

@property (nonatomic, assign) BOOL isPayByOthers;

@property (nonatomic, assign) BOOL bargain;

@property (nonatomic, copy) NSString *scheduleId;//砍价进度id

@end

NS_ASSUME_NONNULL_END
