//
//  HMCountTimerView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMCountTimerView : UIView

- (void)startCountDownTime:(NSDate *)date;

- (void)stopCount;

@end

NS_ASSUME_NONNULL_END
