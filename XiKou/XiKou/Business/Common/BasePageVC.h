//
//  BasePageVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import <JXPagerView.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat JXheightForHeaderInSection = 50;
@interface BasePageVC : BaseViewController<JXPagerViewDelegate, JXPagerMainTableViewGestureDelegate>

@property (nonatomic, strong) JXPagerView *pagerView;

@end

NS_ASSUME_NONNULL_END
