//
//  NBShopDetailDesCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBShopDetailDesCell : UITableViewCell

@property (nonatomic, copy) void(^expandBlock)(BOOL isExpand);

@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, strong) UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
