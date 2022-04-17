//
//  MIOrderAlertView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIOrderAlertView : UIView

- (instancetype)init;

- (void)show;

@property (nonatomic, copy) void(^sureBlock)(BOOL select1,BOOL select2);

@property (nonatomic, assign) BOOL alwaysSelect1;

@property (nonatomic, assign) BOOL disableShare;

@property (nonatomic, assign) BOOL disableWg;

- (void)setDefaultSelect;

@end


NS_ASSUME_NONNULL_END
