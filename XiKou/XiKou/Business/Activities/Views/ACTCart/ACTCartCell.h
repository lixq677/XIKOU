//
//  ACTCartCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol CartCellDetagate <NSObject>

- (void)cartSelected:(UITableViewCell *)cell andSelected:(BOOL)isSelected;

- (void)cartNumberUpdate:(UITableViewCell *)cell andNumber:(NSInteger)number complete:(void (^)(void))complete;

@end

@class ACTCartGoodModel;
@interface ACTCartCell : UITableViewCell

@property (nonatomic, weak) id <CartCellDetagate> delegate;

@property (nonatomic, strong) ACTCartGoodModel *model;

@end

NS_ASSUME_NONNULL_END
