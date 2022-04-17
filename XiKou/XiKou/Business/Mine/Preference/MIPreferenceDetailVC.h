//
//  MIPreferenceDetailVC.h
//  XiKou
//
//  Created by Tony on 2019/6/14.
//  Copyright © 2019年 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class XKPreferenceData;
@interface MIPreferenceDetailVC : BaseViewController

- (instancetype _Nonnull )initWithPreferenceData:(XKPreferenceData *_Nonnull)preferenceData;

//- (instancetype _Nonnull )init DEPRECATED_ATTRIBUTE;

@end
