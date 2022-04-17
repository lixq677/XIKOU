//
//  XKLogisticsVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKLogisticsVC.h"
#import "XKLogisticCells.h"
#import "XKOtherService.h"
#import "XKOrderModel.h"

@interface XKLogisticsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)XKLogisticsData  *logicticsData;

@property (nonatomic,strong)XKOrderBaseModel  *baseModel;

@end

@implementation XKLogisticsVC

- (instancetype)initWithOrderModel:(XKOrderBaseModel *)orderModel{
    if (self = [super init]) {
        self.baseModel = orderModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"物流信息";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    [self.tableView registerClass:[XKLogisticCell class] forCellReuseIdentifier:@"XKLogisticCell"];
    [self.tableView registerClass:[XKLogisticConsigneeCell class] forCellReuseIdentifier:@"XKLogisticConsigneeCell"];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_no_logistics"]];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无物流信息";
    label.textColor = HexRGB(0x999999, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    imageView.centerX = kScreenWidth/2.0f;
    imageView.centerY = kScreenHeight/2.0f;
    
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = imageView.bottom+10.0f;
    
    self.tableView.backgroundView = backgroundView;
    [self queryLogistics];
}

#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (self.logicticsData.data.count > 0) {
            self.tableView.backgroundView.hidden = YES;
        }else{
            self.tableView.backgroundView.hidden = NO;
        }
        return self.logicticsData.data.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        XKLogisticConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKLogisticConsigneeCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",self.logicticsData.consigneeName?:@"",self.logicticsData.consigneeMobile?:@""];
        NSMutableString *address = [NSMutableString string];
        if (![NSString isNull:self.logicticsData.provinceName]) {
            [address appendString:self.logicticsData.provinceName];
        }
        if (![NSString isNull:self.logicticsData.cityName]) {
            [address appendString:self.logicticsData.cityName];
        }
        if (![NSString isNull:self.logicticsData.areaName]) {
            [address appendString:self.logicticsData.areaName];
        }
        if (![NSString isNull:self.logicticsData.address]) {
            [address appendString:self.logicticsData.address];
        }
        cell.detailTextLabel.text = address;
        return cell;
    }else{
        XKLogisticCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKLogisticCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.hasUpLine = NO;
            cell.currented = YES;
        } else {
            cell.hasUpLine = YES;
            cell.currented = NO;
        }
        if (indexPath.row == self.logicticsData.data.count - 1) {
            cell.hasDownLine = NO;
        } else {
            cell.hasDownLine = YES;
        }
        XKLogisticsContextData *data = [self.logicticsData.data objectAtIndex:indexPath.row];
        cell.textLabel.text = data.context;
        cell.detailTextLabel.text = data.ftime;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10.0f;
    }else{
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [UIView new];
    }else{
        XKLogisticSectionHeaderView *headerView = (XKLogisticSectionHeaderView *)[tableView dequeueReusableCellWithIdentifier:@"XKLogisticSectionHeaderView"];
        if (!headerView) {
            headerView = [[XKLogisticSectionHeaderView alloc] initWithReuseIdentifier:@"XKLogisticSectionHeaderView"];
        }
        headerView.textLabel.text = self.logicticsData.logisticsCompany;
        headerView.detailTextLabel.text = self.logicticsData.logisticsNo;
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)[tableView dequeueReusableCellWithIdentifier:@"footerView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView"];
    }
    if (section == 0) {
        footerView.backgroundColor = [UIColor clearColor];
    }else{
        footerView.backgroundColor = HexRGB(0xffffff, 1.0f);
    }
    return footerView;
}



- (void)queryLogistics{
    [[XKFDataService() otherService] queryLogisticsWithOrderNo:self.baseModel.orderNo orderType:self.baseModel.type completion:^(XKLogisticsResponse * _Nonnull response) {
        if (response.isSuccess) {
            self.logicticsData = response.data;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //_tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        _tableView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


@end
