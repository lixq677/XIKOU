//
//  XKZeroBuyGoodDetailVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKZeroBuyGoodDetailVC.h"
#import "XKZeroBuyRecordVC.h"
#import "MIOrderDetailVC.h"

#import "XKGoodItemTagCell.h"
#import "XKBargainPersonCell.h"
#import "XKZeroBuyGoodInfoCell.h"

#import "XKUserService.h"
#import "UILabel+NSMutableAttributedString.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "XKGCDTimer.h"
#import "XKPropertyService.h"
#import "XKCustomAlertView.h"
#import "CountDownTimerView.h"

@interface XKZeroBuyGoodDetailVC ()

@property (nonatomic, strong) NSString *timerName;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) NSString *locationCity;

@property (nonatomic,strong)CountDownTimerView *dtView;

@end

@implementation XKZeroBuyGoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadBuyButtonTitle];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.dtView];
    
    [self.dtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenWidth + 53.0f);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(33.0f);
        make.width.mas_equalTo(159.0f);
    }];
}

//-----轮询获取当前竞拍信息
- (void)getAuctionInfo{
    NSString *activityGoodId = self.detailModel.activityCommodityAndSkuModel.id;
    [[XKFDataService() actService]getGoodAuctionInfoByActivityGoodId:activityGoodId andUserId:[XKAccountManager defaultManager].account.userId Complete:^(ACTGoodDetailAuctionRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            self.detailModel.activityCommodityAndSkuModel.adctionModel = response.data;
            [self reloadBuyButtonTitle];
            [super reloadData];
            if (response.data.remainingTime.integerValue <= self.detailModel.baseRuleModel.postponeRange) {
                [self.dtView setTimeInterval:response.data.remainingTime.doubleValue];
                [self.dtView startTimer];
            }
        }
        [self reloadTimer];
    }];
}

//-----数据刷新
- (void)reloadData{

    [self getAuctionInfo];
}

- (void)reloadTimer{

    AuctionStatus status = self.detailModel.activityCommodityAndSkuModel.adctionModel.status;
    if (status == Auction_Begin || status == Auction_UnBegin) {
        if (!_timerName) {
            @weakify(self);
            _timerName = @"轮次刷新";
            NSInteger loop = self.detailModel.baseRuleModel.appLoopSeconds ? [self.detailModel.baseRuleModel.appLoopSeconds integerValue]/100 : 10;
            [[XKGCDTimer sharedInstance]scheduleGCDTimerWithName:_timerName interval:loop queue:nil repeats:YES option:MergePreviousTimerAction action:^{
                @strongify(self);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAuctionInfo];
                });
            }];
        }
    }else{
        [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
    }
}
//-----刷新底部购买按钮状态
- (void)reloadBuyButtonTitle{
    
    ACTGoodAuctionModel *model = self.detailModel.activityCommodityAndSkuModel.adctionModel;
    if (!model) {
        return;
    }
    @weakify(self);
    [self.btnsView reloadBlackBtnStatus:^(UIButton * _Nonnull button) {
        @strongify(self);
        if (self.paySwitchData.auction) {
    
            if (model.status == Auction_Begin) {
                
                NSInteger expendNumber = self.detailModel.baseRuleModel.expendNumber;
                NSString *title = [NSString stringWithFormat:@"出价%ld优惠券1次(已出价%ld次)",expendNumber/100,(long)model.recordCountForUser];
                [button setTitle:title forState:UIControlStateNormal];
                [button.titleLabel setAttributedStringWithSubString:[NSString stringWithFormat:@"(已出价%ld次)",(long)model.recordCountForUser] font:Font(10.f)];
                button.enabled = YES;
            }else{
                if ([model.winnerId isEqualToString:[XKAccountManager defaultManager].account.userId]) {
                    [button setTitle:@"竞拍成功,去支付" forState:UIControlStateNormal];
                    button.enabled = YES;
                    [self bottomBlackButtonClick];
                    [[XKGCDTimer sharedInstance]cancelTimerWithName:self->_timerName];
                }else{
                    button.enabled = NO;
                    if (!self.detailModel.activityCommodityAndSkuModel.adctionModel) {
                        return;
                    }
                    [button setTitle:model.statusTitle forState:UIControlStateNormal];
                }
            }
        }else{
            button.enabled = NO;
        }
    }];
}


//购买按钮action
- (void)bottomBlackButtonClick{
    @weakify(self);
    [XKLoading showNeedMask:YES];
    [self checkCoupon:^(BOOL isComplete,NSError *error) {
        @strongify(self);
        if (error) {
            [XKLoading dismiss];
            return;
        }
        if (isComplete) {
            ACTGoodAuctionModel *model = self.detailModel.activityCommodityAndSkuModel.adctionModel;
            if (model.status == Auction_Begin) { //竞价
                if (nil == self->_locationCity) {
                    [self getLocationCityWithCompletion:^(XKBaseResponse * _Nonnull response) {
                        [XKLoading dismiss];
                    }];
                }else{
                    [self auctionActionWithCompletion:^(XKBaseResponse * _Nonnull response) {
                        [XKLoading dismiss];
                    }];
                }
            }else{
                if ([model.winnerId isEqualToString:[XKAccountManager defaultManager].account.userId]) {
                    MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:model.orderNo andType:OTZeroBuy];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }else{
            XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleNoTitle
                                                                     andTitle:nil
                                                                   andContent:@"您没有足够的优惠券 前往吾G限时购-购物即获双倍券"
                                                                  andBtnTitle:@"去看看"];
            alert.sureBlock = ^{
                [MGJRouter openURL:kRouterWg];
            };
            [alert show];
        }
    }];
    
}

- (void)checkCoupon:(void(^)(BOOL isComplete,NSError *error))complete{
    NSString *userId = [XKAccountManager defaultManager].account.userId;
    [[XKFDataService() propertyService]getPreferenceAmountWithId:userId completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {
            CGFloat prefenceSum = [(NSNumber *)response.data intValue];
            if (prefenceSum < self.detailModel.activityCommodityAndSkuModel.adctionModel.expendNumber) {
                complete(NO,nil);
            }else{
                complete(YES,nil);
            }
        }else{
            NSError *error = [NSError errorWithCode:response.code.intValue];
            complete(NO,error);
            [response showError];
        }
    }];
    
}

#pragma mark ---------------------tableview
- (NSInteger)numberOfSectionsInTableView{
    return 3;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) return self.detailModel.activityCommodityAndSkuModel ? 1 : 0;
    if (section == 1) return self.detailModel.activityCommodityAndSkuModel ? 1 : 0;
    if (self.detailModel.activityCommodityAndSkuModel.adctionModel.recordList.count > 2) {
        return 3;
    }else{
        return self.detailModel.activityCommodityAndSkuModel.adctionModel.recordList.count + 1;
    }
}

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath andTableView:(nonnull UITableView *)tableView{
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    if (indexPath.section == 0) {
        XKZeroBuyGoodInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKZeroBuyGoodInfoCell"];
        if (!cell) {
            cell = [[XKZeroBuyGoodInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XKZeroBuyGoodInfoCell"];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
        }
        if (self.detailModel) cell.detailModel = self.detailModel;
        return cell;
    }
    if (indexPath.section == 1) {
        XKGoodItemTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKGoodItemTagCell"];
        if (!cell) {
            cell = [[XKGoodItemTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XKGoodTagCell"];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
        }
        NSString *expendNum = [NSString stringWithFormat:@"%ld优惠券/次",self.detailModel.baseRuleModel.expendNumber/100];
        cell.values = @[[NSString stringWithFormat:@"%.2f元",[gModel.startPrice doubleValue]/100],
                        [NSString stringWithFormat:@"%.2f元",[gModel.biddingNumber doubleValue]/100],
                        expendNum];
        return cell;
    }
    //-----------------仅在0元购时才会走下面的cell
    if (indexPath.section == 2 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = FontMedium(16.f);
            [cell.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
                make.left.equalTo(cell.contentView).offset(20);
                make.top.bottom.equalTo(cell.contentView);
            }];
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        }
        cell.textLabel.text = [NSString stringWithFormat:@"出价记录 (%@)",gModel.adctionModel.recordCount ?gModel.adctionModel.recordCount : @0];
        return cell;
    }
    XKBargainPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKBargainPersonCell"];
    if (!cell) {
        cell = [[XKBargainPersonCell alloc]initWithPersonCellStyle:BargainPersonCellDefault reuseIdentifier:@"XKBargainPersonCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    ACTAuctionRecordModel *model = gModel.adctionModel.recordList[indexPath.row - 1];
    ACTAuctionRecordModel *lastModel = gModel.adctionModel.recordList.lastObject;
    cell.firstLabel.text  = model.userName;
    cell.secondLabel.text = (lastModel == model) ? @"出局" : @"当前";
    cell.thirdLabel.text  = model.area;
    cell.lastLabel.text   = [NSString stringWithFormat:@"¥%.2f",[model.auctionPrice doubleValue]/100];
    return cell;
}

- (void)tableViewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        XKZeroBuyRecordVC *vc = [XKZeroBuyRecordVC new];
        vc.activityGoodId = self.detailModel.activityCommodityAndSkuModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark ---------------------生成订单
- (void)makeOrderClick:(XKGoodSKUModel *)skuModel andNum:(NSInteger)selectNum{

    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    XKMakeOrderParam *makeOrderModel = [XKMakeOrderParam new];
    makeOrderModel.activityGoodsId       = gModel.id;
    makeOrderModel.activityId            = gModel.activityId;
    makeOrderModel.goodsCode             = gModel.goodsCode;
    makeOrderModel.goodsId               = gModel.goodsId;
    makeOrderModel.goodsName             = gModel.commodityName;
    makeOrderModel.goodsImageUrl         = gModel.goodsImageUrl;
    makeOrderModel.merchantId            = gModel.merchantId;
    makeOrderModel.commodityId           = gModel.commodityId;
    makeOrderModel.commodityAuctionPrice = gModel.adctionModel.finishPrice;
    makeOrderModel.commodityModel        = skuModel.commodityModel;
    makeOrderModel.commoditySpec         = skuModel.commoditySpec;
    makeOrderModel.condition             = skuModel.contition;
    makeOrderModel.commodityQuantity     = @(selectNum);
    makeOrderModel.orderSource           = @1;
    makeOrderModel.orderAmount           = 0;
    makeOrderModel.buyerId               = [XKAccountManager defaultManager].account.userId;
    makeOrderModel.activityType          = self.detailModel.activityType;
    makeOrderModel.postage               = self.detailModel.baseRuleModel.postage;
    CMOrderVC *vc = [[CMOrderVC alloc]initWithModel:makeOrderModel];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 高德地图定位获取城市
- (void)getLocationCityWithCompletion:(void(^)(XKBaseResponse * _Nonnull response))completionBlock{
    if (!_locationManager) {
        self.locationManager = [[AMapLocationManager alloc] init];
        //设置期望定位精度
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        //设置不允许系统暂停定位
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        //设置允许在后台定位
        // [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        //设置定位超时时间
        [self.locationManager setLocationTimeout:20];
        //设置逆地理超时时间
        [self.locationManager setReGeocodeTimeout:20];
    }
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSLog(@"逆定理编码");
        @strongify(self);
        if (!error) {
            self.locationCity = regeocode.city;
        }
        [self auctionActionWithCompletion:completionBlock];
    }];
}

//----竞价
- (void)auctionActionWithCompletion:(void(^)(XKBaseResponse * _Nonnull response))completionBlock{
    
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKUserInfoData *userInfo = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    
    XKGoodModel *gModel = self.detailModel.activityCommodityAndSkuModel;
    
    NSDictionary *param = @{@"id":gModel.id,
                            @"activityId":gModel.activityId,
                            @"commodityId":gModel.id,
                            @"userId":userId,
                            @"userName":userInfo.nickName,
                            @"area":self.locationCity ? @" " : self.locationCity,
                            };
    [[XKFDataService() actService]postGoodAuctionListByparam:param Complete:^(XKBaseResponse * _Nonnull response) {
        if (completionBlock) {
            completionBlock(response);
        }
        if ([response isSuccess]) {
            [self getAuctionInfo];
            XKShowToast(@"出价成功");
        }else{
            [response showError];
        }
    }];
}

- (void)dealloc{
    [[XKGCDTimer sharedInstance]cancelTimerWithName:_timerName];
}


- (CountDownTimerView *)dtView{
    if (!_dtView) {
        _dtView = [[CountDownTimerView alloc] init];
        _dtView.hidden = YES;
    }
    return _dtView;
}

@end
