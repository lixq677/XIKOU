//
//  HMViews.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKBannerView.h"
#import "HMFlowLayout.h"
#import "XKHomeData.h"
#import "CGGoodsView.h"

NS_ASSUME_NONNULL_BEGIN
@class XKGoodListModel;
@class HMReusableView;
@protocol HMReusableViewDelegate <NSObject>

- (void)reusableView:(HMReusableView *)reusableView clickIt:(id)sender;

@end

@interface HMReusableView  : UICollectionReusableView

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly) UIImageView *imageView;

@property (nonatomic,weak)id<HMReusableViewDelegate> delegate;

@end


/*********************************************************************/


@protocol HMCellDelegate <NSObject>

- (void)clickGoodsCell:(CGGoodsCell *)cell atIndex:(NSInteger)index activityType:(XKActivityType)activityType;

- (void)seeMoreGoodsWithActivityType:(XKActivityType)activityType;

@end

@interface HMNewUserCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@end

@interface HMWgCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,weak)id<HMCellDelegate> delegate;

@property (nonatomic,strong)NSArray<XKGoodListModel *> *dataSource;

@end

@interface HMBrainCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,weak)id<HMCellDelegate> delegate;

@property (nonatomic,strong)NSArray<XKGoodListModel *> *dataSource;

@end

@interface HMZeroBuyCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,weak)id<HMCellDelegate> delegate;

@property (nonatomic,strong)NSArray<XKGoodListModel *> *dataSource;

- (void)startCountDownTime:(NSDate *)date;

@end


#if 0
@interface HMGlobleBuyerCell : UICollectionViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,strong)NSArray *dataSource;

@property (nonatomic,weak)id<HMCellDelegate> delegate;

@end

#else

@interface HMGlobleBuyerCell : CGGlobleBuyerCell

@end

#endif


@interface HMMultiDiscountCell : CGMultiDiscountCell


@end


NS_ASSUME_NONNULL_END
