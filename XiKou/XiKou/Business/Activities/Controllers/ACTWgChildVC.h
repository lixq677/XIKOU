//
//  ACTWgChildVC.h
//  XiKou
//
//  Created by 李笑清 on 2019/11/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACTWgChildVC : UIViewController

@property (nonatomic,strong)NSString *moduleId;

- (void)refreshDataWithBlock:(nullable void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
