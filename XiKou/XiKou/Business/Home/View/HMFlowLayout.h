//
//  HMFlowLayout.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMFlowLayoutDelegate <NSObject>

- (XKActivityType)activityTypeWithSection:(NSInteger)section;

- (CGSize)sizeForItemAtSection:(NSInteger)section;

@end


@interface HMFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak)id<HMFlowLayoutDelegate> delegate;

@property (nonatomic,assign) CGFloat yInset;

@end

NS_ASSUME_NONNULL_END
