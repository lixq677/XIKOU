//
//  UIView+XKXib.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/29.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//IB_DESIGNABLE
@interface UIView (XKXib)

@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat  borderWidth;

@property (nonatomic, strong) IBInspectable UIColor  *borderColor;

@end

NS_ASSUME_NONNULL_END
