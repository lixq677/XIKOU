//
//  XKGoodsCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMWgGoodsCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *textLabel;
@property (nonatomic,strong,readonly)UILabel *detailTextLabel;
@property (nonatomic,strong,readonly)UILabel *priceLabel;
@property (nonatomic,strong,readonly)UIButton *buyBtn;

@end

NS_ASSUME_NONNULL_END
