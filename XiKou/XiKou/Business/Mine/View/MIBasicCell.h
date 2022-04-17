//
//  MIBasicCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKPropertyData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIBasicCell : UITableViewCell



@end

@interface MIBasicAvatarCell : MIBasicCell


@end

@class MIBasicAddressCell;
@protocol MIBasicAddressCellDelegate <NSObject>

- (void)cell:(MIBasicAddressCell *)cell editAddressWithSender:(id)sender;

//- (void)cell:(MIBasicAddressCell *)cell watchAddressBoundaryWithSender:(id)sender;

@end

@interface MIBasicAddressCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *nameLabel;

@property (nonatomic,strong,readonly)UILabel *telLabel;

@property (nonatomic,strong,readonly)UILabel *addrLabel;

@property (nonatomic,strong,readonly)UIButton *editBtn;

@property (nonatomic,strong,readonly)UILabel *defaultLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;
    
@property (nonatomic,weak)id<MIBasicAddressCellDelegate> delegate;

@end

@class MIPreferenceCell;
@protocol MIPreferenceCellDelegate <NSObject>

- (void)cell:(MIPreferenceCell *)cell detailWithSender:(id)sender;

@end

@interface MIPreferenceCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *backgroud;

@property (nonatomic,strong,readonly)UIImageView *icon;

@property (nonatomic,strong,readonly)UILabel *pricelabel;//价钱

@property (nonatomic,strong,readonly)UILabel *validitylabel;//有效期

@property (nonatomic,strong,readonly)UIView *lineView;

@property (nonatomic,strong,readonly)UILabel *scopelabel;//适用范围

@property (nonatomic,strong,readonly)UIButton *detailBtn;

@property (nonatomic,weak)id<MIPreferenceCellDelegate> delegate;

@property (nonatomic,assign)XKPreferenceState state;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@end

@class MIConcernCell;
@protocol MIConcernCellDelegate <NSObject>

- (void)cell:(MIConcernCell *)cell clickConcernWithSender:(id)sender;

- (void)cell:(MIConcernCell *)cell clickAvatarWithSender:(id)sender;

@end

@interface MIConcernCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *icon;

@property (nonatomic,strong,readonly)UILabel *namelabel;

@property (nonatomic,strong,readonly)UILabel *describelabel;

@property (nonatomic,strong,readonly)UIButton *concernBtn;

@property (nonatomic,weak)id<MIConcernCellDelegate> delegate;

@end

@interface MITaskCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *taskValueLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UIButton *finishBtn;

@property (nonatomic,copy)void(^finishBlock)(void);

@end


NS_ASSUME_NONNULL_END
