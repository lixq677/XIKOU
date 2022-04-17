//
//  XKGoodDetailVC.h
//  XiKou
//  子类化来分开处理不通商品详情的逻辑
//  Created by L.O.U on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import "ACTCartVC.h"
#import "CMOrderVC.h"
#import "XKZeroBuyRecordVC.h"

#import "XKGoodSkuView.h"
#import "XKGoodDetailNavView.h"
#import "XKGoodDetailBtnView.h"
#import "XKGoodInfoCell.h"

#import "XKOtherService.h"
#import "XKActivityService.h"
#import "XKMakeOrderParam.h"
#import "XKEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKGoodDetailVC : BaseViewController


- (instancetype)initWithActivityGoodID:(NSString *)activityGoodID
                       andActivityType:(XKActivityType)type;

@property (nonatomic, strong) UITableView *tableView;

/**
 自定义导航栏
 */
@property (nonatomic, strong) XKGoodDetailNavView *navView;
/**
 底部按钮，方便更改按钮样式
 */
@property (nonatomic, strong) XKGoodDetailBtnView *btnsView;

/**
 数据模型
 */
@property (nonatomic, strong) ACTGoodDetailModel *detailModel;

/**
 控制活动是否可以进行下一步的开关数据
 */
@property (nonatomic, strong) XKPaySwitchData *paySwitchData;

/**
  记录需要显示的行标签（图，文字）
 */
@property (nonatomic, strong) NSMutableArray *rowDataArray;

/**
 数据请求方法，跑出来方便重新刷新
 */
- (void)dataRequest;

/**
 数据请求完成交给子类处理
 */
- (void)handleData;

/**
 刷新商品信息
 */
- (void)reloadData;

/**
 动态刷新底部按钮
 */
- (void)reloadBuyButtonTitle;

/**
 底部黑色按钮点击事件
 */
- (void)bottomBlackButtonClick;

/**
 底部棕色按钮点击事件
 */
- (void)bottomBrownButtonClick;

#pragma mark tableView 代理方法

/**
 tableView 组数

 @return <#return value description#>
 */
- (NSInteger)numberOfSectionsInTableView;

/**
 每组cell数

 @param section <#section description#>
 @return <#return value description#>
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/**
 cell

 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath andTableView:(UITableView *)tableView;

/**
 tableView 点击

 @param indexPath <#indexPath description#>
 */
- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
