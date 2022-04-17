//
//  MIChangeNicknameVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MIChangeNicknameDelegate <NSObject>

- (void)viewController:(UIViewController *)viewController nickName:(NSString *)nickName;

@end

@interface MIChangeNicknameVC : BaseViewController

- (instancetype)initWithDelegate:(id<MIChangeNicknameDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
