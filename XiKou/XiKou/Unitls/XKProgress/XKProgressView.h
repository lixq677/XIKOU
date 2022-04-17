//
//  XKProgressView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKProgressView : UIView

@property (nonatomic,strong)UIColor *trackColor;

@property (nonatomic,assign)float progress;

- (void)setProgress:(float)progress animate:(BOOL)animate;
@end

NS_ASSUME_NONNULL_END
