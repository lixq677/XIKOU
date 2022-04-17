//
//  NBShopBriefCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NBShopBriefCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *distanceLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UIImageView *imageView2;

@property (nonatomic,strong,readonly)UIImageView *imageView3;

@end


@interface NBShopBriefStyle1Cell : NBShopBriefCell

@end

@interface NBShopBriefStyle2Cell : NBShopBriefCell


@end

@interface NBConsumeCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UITextField *textField;

@end

@interface NBPreferentialCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UIButton *selectBtn;

@property (nonatomic,strong,readonly)UITextField *textField;

@property (nonatomic,copy)void(^selectBlock)(void);

@end

@interface NBBalanceCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIView *bottomLine;

@end

NS_ASSUME_NONNULL_END
