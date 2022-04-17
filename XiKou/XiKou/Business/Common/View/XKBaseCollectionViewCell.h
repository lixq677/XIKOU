//
//  XKBaseCollectionViewCell.h
//  XiKou
//
//  Created by L.O.U on 2019/8/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKBaseCollectionViewCell : UICollectionViewCell

/**
 复用ID
 
 @return return value description
 */
+ (NSString *)identify;

@end

NS_ASSUME_NONNULL_END
