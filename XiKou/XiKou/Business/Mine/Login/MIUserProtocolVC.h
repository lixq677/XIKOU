//
//  MIUserProtocolVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MIUserProtocolVCDelegate <NSObject>

- (void)userProtocolAgree:(BOOL)agree;

@end

@interface MIUserProtocolVC : BaseViewController

- (instancetype)initWithDelegate:(id<MIUserProtocolVCDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
