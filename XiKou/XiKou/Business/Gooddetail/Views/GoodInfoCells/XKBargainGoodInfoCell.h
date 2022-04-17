//
//  XKGoodInfoBargainCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodInfoCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKBargainGoodInfoCell : XKGoodInfoCell

@property (nonatomic, strong) UILabel *tipLabel;            //附加属性

@property (nonatomic, strong) UILabel *discountLabel;       //折扣

@property (nonatomic, strong) UIButton *ruleBtn;       //砍价规则

@property (nonatomic, strong) UILabel *bargainLabel;       //折扣

@end


@interface XKBargainUserInfoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *detailTextLabel;

@property (nonatomic, strong) UIButton *button;       //折扣

@end

NS_ASSUME_NONNULL_END
