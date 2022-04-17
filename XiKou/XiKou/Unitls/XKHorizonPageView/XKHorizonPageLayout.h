//
//  XKHorizonPageLayout.h
//  XiKou
//
//  Created by L.O.U on 2019/8/16.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSUInteger numberOfPages(NSUInteger itemsInPage, NSUInteger totalCount);

@interface XKHorizonPageLayout : UICollectionViewFlowLayout

/**
 每页的缩进
 */
@property (nonatomic, assign) UIEdgeInsets pageInset;
/**
 每个页面所包含的数量
 */
@property (nonatomic, assign) NSUInteger numberOfItemsInPage;
/**
 每页分多少列
 */
@property (nonatomic, assign) NSUInteger columnsInPage;

@end

NS_ASSUME_NONNULL_END
