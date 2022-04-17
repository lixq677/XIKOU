//
//  CMBargainAlertView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKOtherService.h"

NS_ASSUME_NONNULL_BEGIN

@interface CMBargainAlertView : UIView

- (instancetype)init;

@property (nonatomic,strong)NSArray<XKBargainScheduleData *> *scheduleDatas;

- (void)show;


@end

NS_ASSUME_NONNULL_END
