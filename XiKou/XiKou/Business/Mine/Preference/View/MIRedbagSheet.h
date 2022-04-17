//
//  MIRedbagSheet.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKPropertyData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIRedbagSheet : UIView

- (void)showAtView:(UIView *)view;

- (void)dismiss;

@property (nonatomic,copy)void(^sureBlock)(XKRedbagCategoryTitle *categoryTitleModel);

@property (nonatomic,strong)XKRedbagCategoryData *categoryData;

@property (nonatomic,assign)BOOL isShow;

@end

NS_ASSUME_NONNULL_END
