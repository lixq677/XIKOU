//
//  MICashSheet.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSuperSheet.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,XKCashOutTime){
    XKCashOutTimeNone               =   0,
    XKCashOutTimeImmediately        =   1,
    XKCashOutTimeThreeDay           =   2,
    XKCashOutTimeAWeek              =   3,
};

@protocol MICashSheetDelegate <NSObject>

- (void)didSelectCashOutTime:(XKCashOutTime)outtime;

@end

@interface MICashSheet : XKSuperSheet

- (instancetype)initWithDelegate:(id<MICashSheetDelegate>)delegate;

@end





NS_ASSUME_NONNULL_END
