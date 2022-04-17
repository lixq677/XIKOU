//
//  MIFunctionDesc.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

/*功能列表*/
typedef NS_ENUM(int, MIFunctionCategory){
    MIFunctionCategoryZeroYuanBuy            =     0,//0元抢
    MIFunctionCategoryMultiBuyDiscount       =     1,//多拍多折
    MIFunctionCategoryBargain                =     2,//砍立得
    MIFunctionCategoryGlobalSeller           =     3,//全球买手
    MIFunctionCategoryWgArea                 =     4,//5G专区
    MIFunctionCategoryAssemble               =     5,//定制拼团
    MIFunctionCategoryNewUser                =     6,//新人专区
    
    MIFunctionCategoryCanConsign             =     10,//我要寄卖
    MIFunctionCategoryConsigning             =     11,//我的寄卖
    MIFunctionCategoryConsigned              =     12,//我的订单
    
    MIFunctionCategoryAdvertising            =     20,//我的推广
    MIFunctionCategoryTask                   =     21,//我的任务
    MIFunctionCategoryAddress                =     22,//我的地址
    MIFunctionCategoryConcern                =     23,//我的关注
    MIFunctionCategoryOTOSpending            =     24,//OTO消费
    MIFunctionCategoryXiKouMatter            =     25,//喜扣素材
    MIFunctionCategorySocialData             =     26,//社交流量
    MIFunctionCategoryCustomer               =     27,//客服
    MIFunctionCategoryPayForOther            =     28,//我的代付
};

NS_ASSUME_NONNULL_BEGIN

@interface MIFunctionDesc : NSObject

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) NSString *descText;

@property (nonatomic,assign) MIFunctionCategory functionCategory;

@end

NS_ASSUME_NONNULL_END
