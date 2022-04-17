//
//  XKLoading.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLoading : UIView

+ (void)show;

+ (void)showNeedMask:(BOOL)mask;

+ (void)dismiss;

+ (BOOL)isShow;

- (void)stopAnimating;

- (void)startAnimating;

@property(nonatomic) BOOL hidesWhenStopped;

@property(nonatomic) BOOL progressAnimating;

@property(nonatomic) BOOL mask;

/*进度条*/
@property(nonatomic) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
