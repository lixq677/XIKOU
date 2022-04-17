//
//  XKBargainPersonCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BargainPersonCellDefault, //无图
    BargainPersonCellImage,
} BargainPersonCellType;
@interface XKBargainPersonCell : UITableViewCell

- (instancetype)initWithPersonCellStyle:(BargainPersonCellType)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UILabel *firstLabel;

@property (nonatomic, strong) UILabel *secondLabel;

@property (nonatomic, strong) UILabel *thirdLabel;

@property (nonatomic, strong) UILabel *lastLabel;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIColor *textColor;
@end

NS_ASSUME_NONNULL_END
