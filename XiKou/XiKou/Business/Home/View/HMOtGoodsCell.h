//
//  HMOtGoodsCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACTDashedView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMOtGoodsCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;
@property (nonatomic,strong,readonly)UIImageView *rankBgView;
@property (nonatomic,strong,readonly)UILabel *rankLabel;
@property (nonatomic,strong,readonly)UILabel *textLabel;
@property (nonatomic,strong,readonly)UILabel *detailTextLabel;
@property (nonatomic,strong,readonly)UILabel *priceLabel;
@property (nonatomic,strong,readonly)UILabel *originalLabel;
@property (nonatomic,strong,readonly)UILabel *transmitLabel;
@property (nonatomic,strong,readonly)ACTDashedView *dashView;
@end

NS_ASSUME_NONNULL_END
