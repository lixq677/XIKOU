//
//  MIOrderDetailSectionFooter.h
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKOrderDetailModel;
@interface MIOrderDetailSectionFooter : UITableViewHeaderFooterView

@property (nonatomic, strong) XKOrderDetailModel *model;

@property (nonatomic, copy) void(^remarkBlock)(NSString *text);

@end

NS_ASSUME_NONNULL_END
