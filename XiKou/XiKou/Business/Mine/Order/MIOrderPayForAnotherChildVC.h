//
//  MIOrderPayForAnotherChildVC.h
//  XiKou
//
//  Created by L.O.U on 2019/8/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderPayForAnotherChildVC : BaseViewController

@property (nonatomic, assign) XKOrderStatus status;

@property (nonatomic, copy) void (^requestSuccessBlock)(NSInteger totalPay,NSInteger totalUnPay);

@end

NS_ASSUME_NONNULL_END
