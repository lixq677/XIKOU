//
//  NBShopDetailHeaderView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBShopDetailSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic,assign) BOOL concern;

@property (nonatomic,copy)void(^block)(void);

@end

NS_ASSUME_NONNULL_END
