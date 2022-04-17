//
//  MIOrderDetailsVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKOrderService.h"
NS_ASSUME_NONNULL_BEGIN

@interface MIOrderDetailsVC : BaseViewController

- (instancetype)initWithOrderID:(NSString *)orderNo andType:(XKOrderType)type;

@end

NS_ASSUME_NONNULL_END
