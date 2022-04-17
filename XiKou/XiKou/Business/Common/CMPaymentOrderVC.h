//
//  CMPaymentOrderVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMPaymentOrderVC : BaseViewController

- (instancetype)initWithOrder:(XKOrderBaseModel *)displayModel;

@end

NS_ASSUME_NONNULL_END
