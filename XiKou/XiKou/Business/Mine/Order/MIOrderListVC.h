//
//  MIOrderListVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderListVC : BaseViewController

- (instancetype)initWithOrderType:(XKOrderType)type
                   andOrderStatus:(XKOrderStatus)status;

@end

NS_ASSUME_NONNULL_END
