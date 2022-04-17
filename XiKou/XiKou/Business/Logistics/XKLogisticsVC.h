//
//  XKLogisticsVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XKOrderBaseModel;

@interface XKLogisticsVC : BaseViewController

- (instancetype)initWithOrderModel:(XKOrderBaseModel *)orderModel;

@end

NS_ASSUME_NONNULL_END
