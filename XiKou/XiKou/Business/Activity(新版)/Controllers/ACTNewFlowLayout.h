//
//  ACTNewFlowLayout.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ACTNewFlowLayout;
@protocol ACTNewFlowLayoutDelegate <NSObject>

- (CGSize)flowLayout:(ACTNewFlowLayout *)flowLayout sizeForItemAtSection:(NSInteger)section;

- (CGSize)flowLayout:(ACTNewFlowLayout *)flowLayout  sizeForHeaderAtSection:(NSInteger)section;

@optional
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

@end


@interface ACTNewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak)id<ACTNewFlowLayoutDelegate> delegate;

@property (nonatomic,assign)CGFloat offsetY;

@property (nonatomic,assign)CGFloat bottom;

@property (nonatomic,assign)NSUInteger lineCount;

@end

NS_ASSUME_NONNULL_END
