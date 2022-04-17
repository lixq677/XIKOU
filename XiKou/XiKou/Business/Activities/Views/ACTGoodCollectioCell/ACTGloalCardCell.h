//
//  ACTGloalCardCell.h
//  XiKou
//
//  Created by L.O.U on 2019/7/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class XKGoodListModel;
@interface ACTGloalCardCell : XKBaseCollectionViewCell

@property(nonatomic,copy) NSArray<XKGoodListModel *> *goodlist;

@end

NS_ASSUME_NONNULL_END
