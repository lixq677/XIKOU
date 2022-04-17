//
//  CTCustomGroupChildVC.h
//  XiKou
//
//  Created by L.O.U on 2019/7/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@class XKGoodListModel;
@interface CTCustomGroupChildVC : BaseViewController<JXPagerViewListViewDelegate>

@property (nonatomic, copy) NSString *categoryid;

@property (nonatomic, strong,readonly) NSMutableArray<XKGoodListModel *> *dataArray;

@end

NS_ASSUME_NONNULL_END
