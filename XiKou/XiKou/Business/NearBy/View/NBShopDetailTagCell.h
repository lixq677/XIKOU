//
//  NBShopDetailTagCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XKShopServiceModel;
@interface NBShopDetailTagCell : UITableViewCell

@property (nonatomic,strong)NSArray<XKShopServiceModel *> *serviceModels;

@end

@interface NBTagCell: UIView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end
NS_ASSUME_NONNULL_END
