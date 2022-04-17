//
//  MIOrderDetailTableSectionHeader.h
//  XiKou
//
//  Created by L.O.U on 2019/7/25.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MIAddressInfoView;
@class MIOrderUserDetailView;
@class MIOrderDetailSectionHeader;
@protocol MIOrderDetailSectionHeaderDelegate <NSObject>

- (void)orderDetailSectionHeader:(MIOrderDetailSectionHeader *)header clickIt:(id)sender;

@end

@interface MIOrderDetailSectionHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) MIAddressInfoView *addressView;

@property (nonatomic, strong) MIOrderUserDetailView *userView;

@property (nonatomic, strong) UIView *topBgView;//黑色背景

@property (nonatomic, strong) UILabel *titleLabel;//店铺名字

@property (nonatomic, weak) id<MIOrderDetailSectionHeaderDelegate> delegate;

- (void)showUserViewNamePhone:(NSString *)namePhone
                isBuyer:(BOOL)isBuyer
            userIcon:(NSString *)userIcon
              status:(NSString *)status;

@end

@interface MIAddressInfoView : UIView

@property (nonatomic, strong,readonly) UILabel *nameLabel;

@property (nonatomic, strong,readonly) UILabel *phoneLabel;

@property (nonatomic, strong,readonly) UILabel *addressLabel;

@property (nonatomic, strong,readonly) UIImageView *imageView;

@property (nonatomic,strong,readonly)UIImageView *icon;

@property (nonatomic,strong,readonly)UIImageView *arrow;

@property (nonatomic,strong,readonly)UILabel *hintLabel;

@property (nonatomic,assign)BOOL hasAddress;

@end


NS_ASSUME_NONNULL_END
