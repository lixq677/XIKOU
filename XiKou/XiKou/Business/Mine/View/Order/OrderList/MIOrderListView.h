//
//  MIOrderListView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class XKOrderListModel;
@protocol OrderListDelegate <NSObject>

- (void)selectOrder:(XKOrderListModel *)model;

@end

@interface MIOrderListView : UITableView<UITableViewDelegate>

@property (nonatomic,copy) NSArray<XKOrderListModel *> *orderArray;

@property (nonatomic, weak) id <OrderListDelegate> orderDelegate;
@end

NS_ASSUME_NONNULL_END
