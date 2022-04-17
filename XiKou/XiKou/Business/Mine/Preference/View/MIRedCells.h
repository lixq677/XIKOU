//
//  MIRedCells.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIRedCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *amountLabel;

@end

@interface MIRedRecordHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@end


@interface MIRedTableViewCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@end

NS_ASSUME_NONNULL_END
