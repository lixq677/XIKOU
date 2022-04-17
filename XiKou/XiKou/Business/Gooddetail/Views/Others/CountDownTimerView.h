//
//  CountDownTimerView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountDownTimerView : UIView

@property (nonatomic,assign)NSTimeInterval timeInterval;

- (void)startTimer;

@end

NS_ASSUME_NONNULL_END
