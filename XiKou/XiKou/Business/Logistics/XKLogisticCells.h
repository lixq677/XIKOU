//
//  XKLogisticCells.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKLogisticContentView : UIView

@property (assign, nonatomic) BOOL hasUpLine;
@property (assign, nonatomic) BOOL hasDownLine;
@property (assign, nonatomic) BOOL currented;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@end

@interface XKLogisticCell : UITableViewCell

@property (assign, nonatomic) BOOL hasUpLine;
@property (assign, nonatomic) BOOL hasDownLine;
@property (assign, nonatomic) BOOL currented;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@end

@interface XKLogisticConsigneeCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@end

@interface XKLogisticSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@property (nonatomic,strong)UIButton *copyBtn;

@property (nonatomic,strong,readonly)UIView *contentV;

@end


NS_ASSUME_NONNULL_END
