//
//  ACTBagainPersonCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XKBargainPersonModel;
@interface ACTBagainPersonCell : UITableViewCell

@property (nonatomic, strong) XKBargainPersonModel *model;

@end

@interface ACTBagainUsersCell : UITableViewCell

@property (nonatomic, strong) NSArray<XKBargainPersonModel *> *models;

@property (nonatomic, assign) NSUInteger maxCount;

- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
