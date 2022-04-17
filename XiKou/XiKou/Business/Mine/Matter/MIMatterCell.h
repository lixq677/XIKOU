//
//  MIMatterCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIMatterCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *nameLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *signatureLabel;

@property (nonatomic,strong,readonly)UIButton *saveBtn;

@property (nonatomic,strong,readonly)UIButton *shareBtn;

@property (nonatomic,strong)NSArray<UIImage *> *images;

- (void)sizeToFit;

@end

NS_ASSUME_NONNULL_END
