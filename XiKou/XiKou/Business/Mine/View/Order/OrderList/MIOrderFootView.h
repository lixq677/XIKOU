//
//  MIOrderFootView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const footID1 = @"footID1";//包含信息试图
static NSString * const footID2 = @"footID2";//按钮和左边label
static NSString * const footID3 = @"footID3";//仅时间label

@class XKOrderListModel;
@interface MIOrderFootView : UITableViewHeaderFooterView

@property (nonatomic, strong) XKOrderListModel *model;

@end

NS_ASSUME_NONNULL_END
