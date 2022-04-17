//
//  HMMessageVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XKMsgUnReadData;
@interface HMMessageVC : BaseViewController

- (instancetype)initWithUnreadData:(XKMsgUnReadData *)unreadData;

@end

NS_ASSUME_NONNULL_END
