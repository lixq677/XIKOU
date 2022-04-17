//
//  ACTZeroBuyChildVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "XKEnum.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ACTZeroBuyChildVC :BaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic,copy) NSString *roundId;

@property (nonatomic,copy) NSArray *dataArray;
@end

NS_ASSUME_NONNULL_END
