//
//  MIBindVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "XKUserService.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIBindVC : BaseViewController

- (instancetype)initWithThirdId:(NSString *)thirdId type:(XKThirdPlatformType)platformType;

@end

NS_ASSUME_NONNULL_END
