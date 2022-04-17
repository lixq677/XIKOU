//
//  ACTWugHeadView.h
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ACTMoudleModel;
@interface ACTWugHeadView : UIView

@property (nonatomic,strong,readonly) UIScrollView *scrollView;

- (void)reloadBanner:(NSArray *)banners;

- (void)reloadMoudleData:(ACTMoudleModel *)model;

@end

NS_ASSUME_NONNULL_END
