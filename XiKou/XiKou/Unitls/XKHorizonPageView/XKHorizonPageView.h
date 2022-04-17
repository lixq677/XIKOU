//
//  XKHorizonPageView.h
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static CGFloat const pageInsert  = 15;
static CGFloat const pageSpace   = 15;
static CGFloat const controlHeight  = 20;

@class XKHorizonPageView;
@protocol HorizonPageDelegate <NSObject>

@required

/** 自定义cell的class */
- (Class)customCollectionViewCellClassForPageView:(XKHorizonPageView *)view;

/** item 个数 */
- (NSInteger)numberOfItemsInPageView:(XKHorizonPageView *)pageView;

/** cell赋值 */
- (void)setupCustomCell:(UICollectionViewCell *)cell
               forIndex:(NSInteger)index
               pageView:(XKHorizonPageView *)view;

/** cell高度 */
- (CGFloat)heightOfitemsInPageView:(XKHorizonPageView *)view;

@optional

/** 点击 */
- (void)pageView:(XKHorizonPageView *)pageView didSelectItemAtIndex:(NSInteger)index;

@end

@interface XKHorizonPageView : UIView

@property (nonatomic, assign) id <HorizonPageDelegate> pageDelegate;

/** 最大行数 默认3 */
@property (nonatomic, assign) NSInteger maxRow;

/** 最大列数 默认1 */
@property (nonatomic, assign) NSInteger maxColumn;

/** 抛出来解决手势问题 */
@property (nonatomic,strong,readonly) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
