//
//  ACTGoodCardCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"
#import "XKGoodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACTGoodCardCell : XKBaseCollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *discountLabel;

@property (nonatomic,strong,readonly) UILabel *sellOutLabel;

@end

@class ACTBrainCardCell;
@protocol ACTBrainCardCellDelegate <NSObject>

- (void)clickGoodsCell:(ACTBrainCardCell *)cell atIndex:(NSUInteger)index;

@end

@interface ACTBrainCardCell : XKBaseCollectionViewCell

@property (nonatomic,strong,readonly)UICollectionView *collectionView;

@property (nonatomic,weak)id<ACTBrainCardCellDelegate> delegate;
//
@property (nonatomic,strong)NSArray<XKGoodListModel *> *dataSource;

@end



NS_ASSUME_NONNULL_END
