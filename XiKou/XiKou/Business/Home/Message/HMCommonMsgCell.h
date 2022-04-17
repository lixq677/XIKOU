//
//  HMCommonMsgCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, HMMsgState) {
    HMMsgStateNone      =   0,
    HMMsgStateUnread    =   1,
    HMMsgStateRead      =   2,
};

@interface HMCommonMsgCell : UITableViewCell


@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *seeDetailLabel;

@property (nonatomic,strong,readonly)UIView *line;

@property (nonatomic,strong,readonly)UIImageView  *arrowImageView;

@property (nonatomic,strong,readonly)UILabel *stateLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,assign)BOOL hasImage;

@property (nonatomic,assign)HMMsgState msgState;

@property (nonatomic,strong)UIView *contentV;

@end

NS_ASSUME_NONNULL_END
