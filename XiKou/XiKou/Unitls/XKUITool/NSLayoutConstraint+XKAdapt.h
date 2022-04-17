//
//  NSLayoutConstraint+XKAdapt.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/28.
//  Copyright © 2019 李笑清. All rights reserved.
//
//
//给XIB或storyboard添加约束时也能按比例适配

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSLayoutConstraint (XKAdapt)

@property(nonatomic, assign) IBInspectable BOOL adapterScreen;

@end

NS_ASSUME_NONNULL_END
