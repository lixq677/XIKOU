//
//  XKCategoryView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    CategorySingleTitle,
    CategorySubTitle,
} CategoryStyle;
@protocol XKCategoryDelegate <NSObject>

@required;
- (NSInteger)numberOfItems;

- (NSString *)titleOfSegementAtIndex:(NSInteger)index;

- (void)categorySelectIndex:(NSInteger)index;

@optional;
- (NSString *)subTitleOfSegementAtIndex:(NSInteger)index;

@end

@interface XKCategoryView : UIView

- (instancetype)initWithStyle:(CategoryStyle)style
                  andDelegate:(id<XKCategoryDelegate>)delegate
                     andFrame:(CGRect)rect;

@property (nonatomic, strong,readonly) UICollectionView *collectionView;

@property (nonatomic, weak) id <XKCategoryDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIScrollView *contentScrollView;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
