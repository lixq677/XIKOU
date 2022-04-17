//
//  MIConsignIngSctionFooter.h
//  XiKou
//
//  Created by L.O.U on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const ConsignIngFooterID = @"MIConsignIngSctionFooter";
@interface MIConsignIngSctionFooter : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic,copy) void(^buttonAction)(NSString *title);

- (void)setBtnBackStyle:(UIButton *)btn;

- (void)setBtnLightStyle:(UIButton *)btn;

- (void)setButtonsTitle:(NSArray *)titles;


@end

NS_ASSUME_NONNULL_END
