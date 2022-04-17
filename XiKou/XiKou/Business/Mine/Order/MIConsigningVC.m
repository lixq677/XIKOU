//
//  MIConsigningVC.m
//  XiKou
//  寄卖中
//  Created by L.O.U on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIConsigningVC.h"
#import "MIOrderGoodCell.h"
#import "MIOrderHeadView.h"
#import "MIConsignIngSctionFooter.h"
#import "XKCustomAlertView.h"
#import "MJDIYFooter.h"
#import "UILabel+NSMutableAttributedString.h"

#import "XKOrderService.h"
#import "XKAccountManager.h"
#import "XKShareTool.h"
#import "MIOrderDetailVC.h"

@interface MIConsigningVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray<MIConsigningGoodModel *> *dataArray;

@end

@implementation MIConsigningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self addRefresh];
    [self getConsignIngList];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark UI
- (void)setUI{
    
    self.title = @"寄卖中商品";
    _dataArray = [NSMutableArray array];
    _page = 1;
    
    [self.view addSubview:self.tableView];
    _tableView.ly_emptyView = [XKEmptyView orderListNoDataView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark dataRequest
- (void)addRefresh{
    @weakify(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self getConsignIngList];
    }];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self getConsignIngList];
    }];
}

//获取寄卖中的商品
- (void)getConsignIngList{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    [[XKFDataService() orderService]getConsignIngByUserId:userId andPage:_page andLimit:10 comlete:^(XKConsignGoodResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKConsigningGoodData *data = response.data;
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            if (self.page <= data.pageCount && self.dataArray.count < data.totalCount) {
                self.page++;
                [self.dataArray addObjectsFromArray:data.result];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else{
            [response showError];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView ly_endLoading];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count < K_REQUEST_PAGE_COUNT ) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MIOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:[MIOrderGoodCell identify]];
    MIConsigningGoodModel *model  = _dataArray[indexPath.section];
    //    cell.numLabel.text   = [NSString stringWithFormat:@"x%@",model.commodityQuantity ? model.commodityQuantity : @1];
    cell.nameLabel.text  = model.commodityName;
    [cell.nameLabel setLineSpace:8.5];
    [cell.coverView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    cell.desLabel.text   = [NSString stringWithFormat:@"原价: ¥%.2f 折扣价: ¥%.2f 优惠券: ¥%.2f",[model.salePrice floatValue]/100,[model.commodityPrice floatValue]/100,[model.couponValue floatValue]/100];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MIOrderHeadView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MIOrderHeadView identify]];
    MIConsigningGoodModel *model  = _dataArray[section];
    head.titleLabel.text = model.merchantName;
    if (model.shareModel.intValue == XKShareModeForDeliver ){
        head.subLabel.text = @"已寄卖到吾G";
    }else{
        head.subLabel.text = @"已分享给好友";
    }
    return head;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    MIConsigningGoodModel *model  = _dataArray[section];
    MIConsignIngSctionFooter *foot = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ConsignIngFooterID];
    @weakify(self);
    NSArray *titles = nil;
    if (model.shareModel.intValue == XKShareModeForDeliver || model.shareModel.intValue == XKShareModeForAll) {
        if(model.consignmentType == XKConsignTypeWg){
            titles = @[@"发货"];
        }else{
            titles = @[@"给好友购买",@"发货"];
        }
        [foot setButtonsTitle:titles];
    }else{
        if(model.consignmentType == XKConsignTypeShare){
            titles = @[@"给好友购买",@"发货"];
        }else if (model.consignmentType == XKConsignTypeWg){
            titles = @[@"寄卖到吾G",@"发货"];
        }else{
            titles = @[@"给好友购买",@"寄卖到吾G",@"发货"];
        }
        [foot setButtonsTitle:titles];
    }
    foot.buttonAction = ^(NSString * _Nonnull title) {
        @strongify(self);
        if (![NSString isNull:title] && [title isEqualToString:@"发货"]) {
            [self takeOverMyself:model section:section];
        }
        if (![NSString isNull:title] && [title isEqualToString:@"寄卖到吾G"]) {
            [self deliverToWgWithModel:model section:section];
        }
        if (![NSString isNull:title] && [title isEqualToString:@"给好友购买"]) {
            [self deliverToFriendsWithModel:model section:section];
        }
    };
    return foot;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MIConsigningGoodModel *model  = [self.dataArray objectAtIndex:indexPath.section];
//    MIOrderDetailVC *vc = [[MIOrderDetailVC alloc]initWithOrderID:model.orderNo andType:model.type];
//    [self.navigationController pushViewController:vc animated:YES];
}


- (void)rankListWithModel:(MIConsigningGoodModel *)model{
    XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleAndTitle andTitle:@"" andContent:@"确认消耗50任务值购买寄卖 前50排名？" andBtnTitle:@"确定"];
    alert.sureBlock = ^{
        [XKLoading show];
        [[XKFDataService() orderService]consignIngGoodPromoteRankById:model.id comlete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if ([response isSuccess]) {
                if ([response.data isKindOfClass:[NSDictionary class]]) {
                    XKShowToast(@"排名提升成功");
                    NSArray *array = [response.data allKeys];
                    if ([array containsObject:@"ranking"]) {
                        model.ranking = [response.data[@"ranking"] integerValue];
                        model.consumptionNum = @(model.consumptionNum.intValue +1);
                        [self.tableView reloadData];
                    }
                }else{
                   [self failAlert:model];
                }
            }else{
                [self failAlert:model];
            }
        }];
    };
    [alert show];
}

- (void)deliverToWgWithModel:(MIConsigningGoodModel *)model section:(NSInteger)section {
    XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"寄卖到吾G" andAttributeContent:[[NSAttributedString alloc] initWithString:@"寄卖到吾G后，您分享给好友的链接将会失效。" attributes:@{NSForegroundColorAttributeName:HexRGB(0x9b9b9b, 1.0f),NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}] andBtnTitle:@"确定" otherBtnTitle:@"取消"];
    @weakify(self);
    [alert setSureBlock:^{
        [XKLoading show];
        [[XKFDataService() orderService] updateCosignStateByOrderNo:model.originalId andBuyerId:[XKAccountManager defaultManager].account.userId andProcessingMethod:@(2) comlete:^(XKBaseResponse * _Nonnull response) {
            @strongify(self);
            [XKLoading dismiss];
            if (response.isSuccess) {
                XKShowToastCompletionBlock(@"您的商品已进入寄卖序列中，请耐心等待...", ^{
                    model.shareModel = @2;
                    [self.dataArray replaceObjectAtIndex:section withObject:model];
                    [self.tableView reloadData];
                });
            }else{
                [response showError];
            }
        }];
       
    }];
    [alert show];
}

- (void)deliverToFriendsWithModel:(MIConsigningGoodModel *)model section:(NSInteger)section {
    if (model.shareModel.intValue == XKShareModeForFriend){
        [XKLoading show];
        [[XKFDataService() orderService] updateCosignStateByOrderNo:model.originalId andBuyerId:[XKAccountManager defaultManager].account.userId andProcessingMethod:@(3) comlete:^(XKBaseResponse * _Nonnull response) {
            [XKLoading dismiss];
            if (response.isSuccess) {
                model.shareModel = @1;
                [self.dataArray replaceObjectAtIndex:section withObject:model];
                [[XKShareTool defaultTool] shareWithData:response.data andCallbackModel:nil andTitle:@"分享给好友购买" andContent:nil andNeedSina:NO andNeedPhoto:NO];
            }else{
                [response showError];
            }
        }];
    }else{
        XKCustomAlertView *alert = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"分享给好友" andAttributeContent:[[NSAttributedString alloc] initWithString:@"分享给好友购买后，您的商品将在吾G购中下架" attributes:@{NSForegroundColorAttributeName:HexRGB(0x9b9b9b, 1.0f),NSFontAttributeName:[UIFont systemFontOfSize:10.0f]}] andBtnTitle:@"确定分享" otherBtnTitle:@"取消分享"];
        [alert setSureBlock:^{
            [XKLoading show];
            [[XKFDataService() orderService] updateCosignStateByOrderNo:model.originalId andBuyerId:[XKAccountManager defaultManager].account.userId andProcessingMethod:@(3) comlete:^(XKBaseResponse * _Nonnull response) {
                [XKLoading dismiss];
                if (response.isSuccess) {
                    model.shareModel = @1;
                    [self.dataArray replaceObjectAtIndex:section withObject:model];
                    [self.tableView reloadData];
                    [[XKShareTool defaultTool] shareWithData:response.data andCallbackModel:nil andTitle:@"分享给好友购买" andContent:nil andNeedSina:NO andNeedPhoto:NO];
                }else {
                    [response showError];
                }
            }];
        }];
        [alert show];
        
    }
    
}
- (void)takeOverMyself:(MIConsigningGoodModel *)model section:(NSInteger)section {
    XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleNoTitle andTitle:nil andContent:@"确认申请改商品自用收货?" andBtnTitle:@"确定"];
       @weakify(self);
       alertView.sureBlock= ^{
           [[XKFDataService() orderService] updateCosignStateByOrderNo:model.originalId andBuyerId:[XKAccountManager defaultManager].account.userId andProcessingMethod:@(1) comlete:^(XKBaseResponse * _Nonnull response) {
               @strongify(self);
               if (response.isSuccess) {
                   XKShowToastCompletionBlock(@"申请发货成功", ^{
                       [self.dataArray removeObjectAtIndex:section];
                       [self.tableView reloadData];

                   });
               }else{
                   [response showError];
               }
            }];
       };
       [alertView show];
}

- (void)failAlert:(MIConsigningGoodModel *)model{
    NSString *content = [NSString stringWithFormat:@"您的任务值不足%@，请前往任务 中心获取任务值",model.consumptionNum];
    XKCustomAlertView *alert = [[XKCustomAlertView alloc]initWithType:CanleAndTitle andTitle:@"提示" andContent:content andBtnTitle:@"确定"];
    [alert show];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.rowHeight       = 101;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        _tableView.sectionHeaderHeight = 40;
        _tableView.sectionFooterHeight = 54;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[MIOrderGoodCell class] forCellReuseIdentifier:[MIOrderGoodCell identify]];
        [_tableView registerClass:[MIOrderHeadView class] forHeaderFooterViewReuseIdentifier:[MIOrderHeadView identify]];
        [_tableView registerClass:[MIConsignIngSctionFooter class] forHeaderFooterViewReuseIdentifier:ConsignIngFooterID];
    }
    return _tableView;
}
@end
