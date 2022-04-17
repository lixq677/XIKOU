//
//  ACTGlobalGoodListVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACTGlobalGoodListVC : BaseViewController

- (instancetype)initWithClassID:(NSString *)classID andActivityId:(NSString *)activityid;

@property (nonatomic, copy) NSString *className;

@end

NS_ASSUME_NONNULL_END
