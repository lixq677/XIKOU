//
//  NBIndustrysVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XKAddressVoModel;
@class XKShopIndustryData;
@interface NBIndustrysVC : UIViewController

@property (nonatomic,strong)XKAddressVoModel *addressVoModel;

@property (nonatomic,strong)XKShopIndustryData *industryData;

@property (nonatomic,assign)BOOL loadDataFromServer;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
