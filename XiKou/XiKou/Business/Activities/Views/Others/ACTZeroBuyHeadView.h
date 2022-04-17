//
//  ACTZeroBuyHeadView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACTTitleView.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    Head_ZeroBuy, //0元购
    Head_Discount //多买多折
} HeadType;

@class ACTMoudleModel;
@class ACTRoundModel;
@interface ACTZeroBuyHeadView : UIView

- (instancetype)initWithType:(HeadType)type;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

@property (nonatomic, strong,readonly) ACTTitleView *timeView;

- (void)reloadBanner:(NSArray *)banners;

- (void)reloadMoudleData:(ACTMoudleModel *)model;

- (void)reloadMoudleData:(ACTMoudleModel *)model roundModel:(nullable ACTRoundModel *)roundModel;

- (void)reloadTimer:(NSString *)endDate;

@end

NS_ASSUME_NONNULL_END
