//
//  XKPgyUpdateView.h
//  XiKou
//
//  Created by L.O.U on 2019/8/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKPgyUpdateView : UIView

@property (nonatomic, copy) void(^sureBlock)(void);

- (instancetype)initWithContent:(NSString *)content forceUpdate:(BOOL)forceUpdate;

- (void)dismiss;

- (void)show;

@end

NS_ASSUME_NONNULL_END
