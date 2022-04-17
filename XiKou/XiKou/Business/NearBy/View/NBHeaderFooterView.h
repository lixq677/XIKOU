//
//  NBHeaderFooterView.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKShopData.h"

NS_ASSUME_NONNULL_BEGIN

@class NBHeaderFooterView;
@protocol NBHeaderFooterViewDelegate <NSObject>

- (void)headerFooterView:(NBHeaderFooterView *)headerFooterView shopRate:(XKShopRate)rate;

- (void)headerFooterView:(NBHeaderFooterView *)headerFooterView shopPop:(XKShopPop)pop;

@end

@interface NBHeaderFooterView : UIView

@property (nonatomic,strong,readonly)UIButton *distanceSortBtn;

@property (nonatomic,strong,readonly)UIButton *discountSortBtn;

@property (nonatomic,strong,readonly)UIButton *popularitySortBtn;

@property (nonatomic,weak)id<NBHeaderFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
