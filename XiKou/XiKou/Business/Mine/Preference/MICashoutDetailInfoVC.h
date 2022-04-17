//
//  MICashoutDetailInfoVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XKCashOutData;
@interface MICashoutDetailInfoVC : BaseViewController

- (instancetype)initWithCashOutData:(XKCashOutData *)cashoutData;

@end

NS_ASSUME_NONNULL_END
