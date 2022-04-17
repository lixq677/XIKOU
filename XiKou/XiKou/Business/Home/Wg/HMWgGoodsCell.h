//
//  XKGoodsCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CellWG,
    CellBargain,
    CellGlobal,
} CellStyle;

@class XKGoodListModel;
@interface HMWgGoodsCell : UITableViewCell

- (instancetype)initWithCellStyle:(CellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) XKGoodListModel *model;

@end

@interface CMGoodsListCell : UITableViewCell

@property (nonatomic, strong) XKGoodListModel *model;

@end

NS_ASSUME_NONNULL_END
