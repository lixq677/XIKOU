//
//  CustomSheet.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/22.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomSheet : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic,copy)void(^actionAssembleBlock)(void);

@property (nonatomic,copy)void(^actionHallBlock)(void);

@property (nonatomic,copy)void(^actionDesignerBlock)(void);

@end

NS_ASSUME_NONNULL_END
