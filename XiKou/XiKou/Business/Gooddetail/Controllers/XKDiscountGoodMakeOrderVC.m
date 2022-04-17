//
//  ACTMutilBuyMakeOrderVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDiscountGoodMakeOrderVC.h"
#import "MIEditAddressVC.h"
#import "CMPaidByOtherVC.h"
#import "CMOrderCells.h"
#import "XKChooseAddressPopView.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKCartButtonsView.h"
#import "XKCustomAlertView.h"

#import "XKMakeOrderParam.h"
#import "XKAccountManager.h"
#import "XKActivityCartData.h"
#import "XKOrderService.h"
#import "XKAddressService.h"
#import "CMOrderCommentsVC.h"
#import "MIBasicCell.h"

@interface XKDiscountGoodMakeOrderVC ()
<UITableViewDelegate,
UITableViewDataSource,
XKAddressServiceDelegate,
CMOrderCommentsVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XKCartButtonsView *bottomView;

@property (nonatomic, strong) NSMutableArray<XKMutilBuyMakeOrderModel *> *storeArray;

@property (nonatomic, strong) CMOrderDeliveryCell *editCell;

@end

static NSString *const AddrCellID = @"AddrCellID";
static NSString *const GoodCellID = @"GoodCellID";
static NSString *const StoreNameCellID = @"NameCellID";
static NSString *const PostageCellID = @"PostageCellID";
@implementation XKDiscountGoodMakeOrderVC
{
    NSInteger _currentSection;//新增地址时用于标记选的哪一个组
}
- (instancetype)initWithGoods:(NSArray<ACTCartGoodModel *> *)goods{
    self = [super init];
    if (self) {
        _storeArray   = [NSMutableArray array];
        
        XKAddressVoData *(^getAddressVoData)(NSArray<XKAddressVoData *> *addresses) = ^(NSArray<XKAddressVoData *> *addresses){
            XKAddressVoData *voData = nil;
            for (XKAddressVoData *data in addresses) {
                if ([data.defaultId isEqualToNumber:@1]) {
                       voData = data;
                       break;
                }
                if (voData == nil && addresses.count > 0) {
                    voData = [addresses firstObject];
                }
            }
            return voData;
        };
        
        void(^block)(XKAddressVoData *voData) = ^(XKAddressVoData *voData){
            [goods enumerateObjectsUsingBlock:^(ACTCartGoodModel *gModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        BOOL isContail = NO;
                        for (XKMutilBuyMakeOrderModel *storeModel in self.storeArray) {
                            if ([storeModel.merchantId isEqualToString:gModel.merchantId]) {
                                [storeModel.orderGoodList addObject:gModel];
                                ACTCartGoodModel *subModel  = [ACTCartGoodModel yy_modelWithJSON:[gModel yy_modelToJSONObject]];
                                subModel.selectNum = subModel.indexs.count;
                                subModel.selectIndex = [[subModel.indexs lastObject] integerValue];
                                if (subModel.selectIndex == 0) subModel.currentDiscount = subModel.rateOne;
                                if (subModel.selectIndex == 1) subModel.currentDiscount = subModel.rateTwo;
                                if (subModel.selectIndex == 2) subModel.currentDiscount = subModel.rateThree;
                                [storeModel.list addObject:subModel];
                                //subModel.selectIndex = [subModel.indexs[i] integerValue];
            //                    for (int i = 0; i<gModel.indexs.count; i++) {
            //                        ACTCartGoodModel *subModel  = [ACTCartGoodModel yy_modelWithJSON:[gModel yy_modelToJSONObject]];
            //                        subModel.selectNum = 1;
            //                        subModel.selectIndex = [subModel.indexs[i] integerValue];
            //                        if (subModel.selectIndex == 0) subModel.currentDiscount = subModel.rateOne;
            //                        if (subModel.selectIndex == 1) subModel.currentDiscount = subModel.rateTwo;
            //                        if (subModel.selectIndex == 2) subModel.currentDiscount = subModel.rateThree;
            //                        [storeModel.list addObject:subModel];
            //                    }
                                isContail = YES;
                                break;
                            }
                        }
                        if (!isContail) {
                            XKMutilBuyMakeOrderModel *storeModel = [XKMutilBuyMakeOrderModel new];
                            storeModel.addressModel = voData;
                            storeModel.merchantId   = gModel.merchantId;
                            storeModel.merchantName = gModel.merchantName;
                            storeModel.postage      = gModel.postage;
                            [storeModel.orderGoodList addObject:gModel];
                            ACTCartGoodModel *subModel  = [ACTCartGoodModel yy_modelWithJSON:[gModel yy_modelToJSONObject]];
                            subModel.selectNum = subModel.indexs.count;
                            subModel.selectIndex = [[subModel.indexs lastObject] integerValue];
                            if (subModel.selectIndex == 0) subModel.currentDiscount = subModel.rateOne;
                            if (subModel.selectIndex == 1) subModel.currentDiscount = subModel.rateTwo;
                            if (subModel.selectIndex == 2) subModel.currentDiscount = subModel.rateThree;
                            [storeModel.list addObject:subModel];
            //                for (int i = 0; i<gModel.indexs.count; i++) {
            //                    ACTCartGoodModel *subModel  = [ACTCartGoodModel yy_modelWithJSON:[gModel yy_modelToJSONObject]];
            //                    subModel.selectIndex = [subModel.indexs[i] integerValue];
            //                    subModel.selectNum = 1;
            //                    NSInteger index = [subModel.indexs[i] integerValue];
            //                    if (index == 0) subModel.currentDiscount = subModel.rateOne;
            //                    if (index == 1) subModel.currentDiscount = subModel.rateTwo;
            //                    if (index == 2) subModel.currentDiscount = subModel.rateThree;
            //                    [storeModel.list addObject:subModel];
            //                }
                            [self.storeArray addObject:storeModel];
                        }
                    }];
        };
        
        
            @weakify(self);
            NSString *userId = [[XKAccountManager defaultManager] userId];
            [[XKFDataService() addressService] queryAddressListWithUserId:userId completion:^(XKAddressUserListResponse * _Nonnull response) {
                if (response.isSuccess) {
                    @strongify(self);
                    XKAddressVoData *voData = getAddressVoData(response.data);
                    block(voData);
                    [self.tableView reloadData];
                }
            }];
        #if 0
            NSString *userId = [[XKAccountManager defaultManager] userId];
            NSArray<XKAddressVoData *> *addresss = [[XKFDataService() addressService]queryAddressListFromCacheWithUserId:userId];
            XKAddressVoData *voData = getAddressVoData(addresss);
            if (voData) {
                _addressModel = voData;
            }else{
                @weakify(self);
                [[XKFDataService() addressService] queryAddressListWithUserId:userId completion:^(XKAddressUserListResponse * _Nonnull response) {
                    if (response.isSuccess) {
                        @strongify(self);
                        XKAddressVoData *voData = getAddressVoData(response.data);
                        self->_addressModel = voData;
                        [self.tableView reloadData];
                    }
                }];
            }
        #endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认订单";
    [[XKFDataService() addressService] addWeakDelegate:self];
    [self setUI];
    [self reloadPice];
}


- (void)setUI{
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self.view xk_addSubviews:@[self.tableView,self.bottomView]];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo([XKUIUnitls safeBottom]+66.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.equalTo(self.view).mas_offset(-15.0f);
        make.height.mas_equalTo(kScreenHeight);
        make.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    @weakify(self);
    self.bottomView.actionBlock = ^{
        @strongify(self);
        [self orderAction];
    };
}
- (void)reloadPice{
    self.bottomView.priceLabel.text = [NSString stringWithFormat:@"合计  ¥%.2f",self.totalAmount/100];
    [self.bottomView.priceLabel setAttributedStringWithSubString:@"合计" color:COLOR_TEXT_BLACK font:Font(12.f)];
    [self.bottomView.priceLabel handleRedPrice:FontSemibold(17.f)];
}

#pragma mark getter or setter
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _storeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    XKMutilBuyMakeOrderModel *storeModel = _storeArray[section];
    return storeModel.list.count + 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    XKMutilBuyMakeOrderModel *storeModel = _storeArray[indexPath.section];
    if (indexPath.row == 0) {
        if (storeModel.addressModel == nil) {
            CMOrderAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:AddrCellID forIndexPath:indexPath];
            cell.hasAddress = NO;
            return cell;
        }else{
            MIBasicAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBasicAddressCell" forIndexPath:indexPath];
            cell.nameLabel.text = storeModel.addressModel.consigneeName;
            cell.telLabel.text = storeModel.addressModel.consigneeMobile;
            XKAddressVoModel *voModel = [[XKAddressVoModel alloc] initWithVoData:storeModel.addressModel];
            NSString *areaAddress = GetAreaAddressWithVoModel(voModel);
            cell.addrLabel.text = [NSString stringWithFormat:@"%@ %@",areaAddress,storeModel.addressModel.address];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.defaultLabel.hidden = YES;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editBtn.hidden = YES;
            if(storeModel.addressModel.outRange){
                cell.nameLabel.textColor = COLOR_TEXT_BLACK;
                cell.telLabel.textColor = COLOR_TEXT_BLACK;
                cell.addrLabel.textColor = COLOR_TEXT_GRAY;
                cell.detailTextLabel.hidden = YES;
            }else{
                cell.nameLabel.textColor =  HexRGB(0xcccccc, 1.0f);
                cell.telLabel.textColor  =  HexRGB(0xcccccc, 1.0f);
                cell.addrLabel.textColor =  HexRGB(0xcccccc, 1.0f);
                cell.detailTextLabel.hidden = NO;
            }
            return cell;
        }
    }else if(indexPath.row == 1){
        CMOrderDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:StoreNameCellID forIndexPath:indexPath];
        cell.textLabel.font = FontMedium(14.f);
        cell.textLabel.text = storeModel.merchantName;
        return cell;
    }else if (indexPath.row == storeModel.list.count + 2){
        CMOrderDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:PostageCellID forIndexPath:indexPath];
        cell.detailTextLabel.textColor = COLOR_TEXT_GRAY;
        cell.textLabel.text = @"配送方式";
        cell.detailTextLabel.text = (storeModel.postage && [storeModel.postage doubleValue]>0) ? [NSString stringWithFormat:@"邮费 %.2f元",[storeModel.postage doubleValue]/100] : @"全国包邮";
        cell.bottomCell = NO;
        return cell;
    }else if (indexPath.row == storeModel.list.count + 3){
        CMOrderDeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:PostageCellID forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, kScreenWidth);
        cell.textLabel.text = @"订单备注:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.bottomCell = YES;
        return cell;
    }else{
        CMOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:GoodCellID forIndexPath:indexPath];
        ACTCartGoodModel *gModel = storeModel.list[indexPath.row - 2];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:gModel.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
        cell.textLabel.text = gModel.commodityName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@  原价: ¥%.2f",gModel.commodityModel,gModel.commoditySpec,gModel.salePrice.doubleValue/100.00];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[gModel.activityPrice doubleValue]/100];
        cell.countLabel.text = [NSString stringWithFormat:@"x%ld",gModel.selectNum];
        cell.discountLabel.hidden = NO;
        cell.discountLabel.text = [NSString stringWithFormat:@" 折扣: %@折 ",gModel.currentDiscount];

        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKMutilBuyMakeOrderModel *storeModel = _storeArray[indexPath.section];
    if (indexPath.row == 0) {
        [self chooseAddressWithSection:indexPath.section];
    }else if (indexPath.row == storeModel.list.count + 3){
        CMOrderCommentsVC *controller = [[CMOrderCommentsVC alloc] initWithDelegate:self];
        CMOrderDeliveryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.editCell = cell;
        [controller setText:cell.detailTextLabel.text];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)chooseAddressWithSection:(NSInteger)section{
    XKChooseAddressPopView *addressView = [[XKChooseAddressPopView alloc]init];
    @weakify(self);
    _currentSection = section;
    [addressView showWithTitle:@"选择地址" chooseComplete:^(XKAddressVoData * _Nonnull data) {
        @strongify(self);
        XKMutilBuyMakeOrderModel *model = self.storeArray[section];
        model.addressModel = data;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
    } addBlock:^{
        @strongify(self);
        MIEditAddressVC *vc = [[MIEditAddressVC alloc]initWithAddressVoData:[XKAddressVoData new]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark -------------- add Address
- (void)addAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data{
    [self chooseAddressWithSection:_currentSection];
}

- (void)commentsViewController:(CMOrderCommentsVC *)controller commentText:(NSString *)text{
    self.editCell.detailTextLabel.text = text;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.editCell];
    XKMutilBuyMakeOrderModel *model = [self.storeArray objectAtIndex:indexPath.section];
    model.remarks = text;
}

- (void)orderAction{
    BOOL addressIsAll = YES;
    for (XKMutilBuyMakeOrderModel *model in self.storeArray) {
        if (!model.addressModel) {
            XKShowToast(@"请选择%@店铺商品的收获地址",model.merchantName);
            addressIsAll = NO;
            return;
        }
    }
    if (addressIsAll) {
        if (self.storeArray.count == 1) {
            [self makeOrder];
            return;
        }
        NSString *content = @"对于不同店铺的商品系统将拆分成 不同的子订单合并支付。";
        XKCustomAlertView *view = [[XKCustomAlertView alloc]initWithType:CanleAndTitle
                                                                andTitle:@"支付确认"
                                                              andContent:content
                                                             andBtnTitle:@"继续购买"];
        @weakify(self);
        view.sureBlock = ^{
            @strongify(self);
            [self makeOrder];
        };
        [view show];
    }
}
- (void)makeOrder{
    NSMutableArray *goods = [NSMutableArray array];
    __block NSString *activityID = @"";

    [self.storeArray enumerateObjectsUsingBlock:^(XKMutilBuyMakeOrderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *rate;
        for (int i = 0; i< obj.list.count; i++) {
            ACTCartGoodModel *model = obj.list[i];
            activityID = model.activityId;
            if (i == 0) rate = model.rateOne;
            if (i == 1) rate = model.rateTwo;
            if (i == 2) rate = model.rateThree;
            NSDictionary *param = @{
                                    @"activityGoodsId":model.activityGoodsId,
                                    @"buyerCartId":    model.id,
                                    @"commodityId":    model.commodityId,
                                    @"commodityModel": model.commodityModel,
                                    @"commoditySpec":  model.commoditySpec,
                                    @"goodsId":        model.goodsId,
                                    @"goodsImageUrl":  model.goodsImageUrl,
                                    @"goodsName":      model.commodityName,
                                    @"merchantId":     model.merchantId,
                                    @"salePrice":      model.activityPrice,
                                    @"buyNumber":      @(model.selectNum),
                                    @"orderNo":        @(model.selectIndex),
                                    @"orderAmount":    @([model.activityPrice floatValue]*[rate integerValue]/10),
                                    @"orderSource":    @1,
                                    @"discount":       rate,
                                    @"receiptAddressRef":obj.addressModel.id,
                                    @"remarks":obj.remarks?:@"",
                                    };
            [goods addObject:param];
        }
    }];
    self.bottomView.payBtn.enabled = NO;
    [[XKFDataService() orderService]creatMutilBuyOrderWithActivityID:activityID andTotalAmount:_totalAmount andBuyid:[XKAccountManager defaultManager].account.userId andGoods:goods comlete:^(XKBaseResponse * _Nonnull response) {
        self.bottomView.payBtn.enabled = YES;
        if ([response isSuccess]) {
            self.makeOrderSuccess();
            XKMakeOrderResultModel *model = [XKMakeOrderResultModel yy_modelWithJSON:response.data];
            model.type = OTDiscount;
            model.payAmount = @(self.totalAmount);
            CMOrderPaidByOtherCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.storeArray.count]];
            if (cell.paidSelect) {
                [MGJRouter openURL:kRouterPayByOther withUserInfo:nil completion:nil];
            }else{
                XKOrderBaseModel *disModel = [XKOrderBaseModel new];
                disModel.payAmount = model.payAmount;
                disModel.type      = OTDiscount;
                disModel.orderNo   = model.tradeNo;
                disModel.goodsName = @"";
                [model.list enumerateObjectsUsingBlock:^(XKMakeOrderResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    disModel.goodsName = [disModel.goodsName stringByAppendingString:obj.goods.goodsName];
                    if (obj != model.list.lastObject) {
                        disModel.goodsName = [disModel.goodsName stringByAppendingString:@","];
                    }
                }];
                [MGJRouter openURL:kRouterPay withUserInfo:@{@"key":disModel} completion:nil];
            }
        }else{
            [response showError];
        }
    }];
    
}
#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[MIBasicAddressCell class] forCellReuseIdentifier:@"MIBasicAddressCell"];
        [_tableView registerClass:[CMOrderGoodCell class] forCellReuseIdentifier:GoodCellID];
        [_tableView registerClass:[CMOrderDeliveryCell class] forCellReuseIdentifier:PostageCellID];
        [_tableView registerClass:[CMOrderDeliveryCell class] forCellReuseIdentifier:StoreNameCellID];
        [_tableView registerClass:[CMOrderAddrCell class] forCellReuseIdentifier:AddrCellID];
    }
    return _tableView;
}

- (XKCartButtonsView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[XKCartButtonsView alloc]init];
        [_bottomView.payBtn setTitle:@"确认订单" forState:UIControlStateNormal];
    }
    return _bottomView;
}

- (void)dealloc{
    [[XKFDataService() addressService] removeWeakDelegate:self];
}
@end

@implementation XKMutilBuyMakeOrderModel

- (NSMutableArray<ACTCartGoodModel *> *)list{
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (NSMutableArray<ACTCartGoodModel *> *)orderGoodList{
    if (!_orderGoodList) {
        _orderGoodList = [NSMutableArray array];
    }
    return _orderGoodList;
}
@end
