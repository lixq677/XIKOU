//
//  MIOrderDetailVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKOrderService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderDetailVC : BaseViewController

- (instancetype)initWithOrderID:(NSString *)orderNo andType:(XKOrderType)type;

@end


NS_ASSUME_NONNULL_END
