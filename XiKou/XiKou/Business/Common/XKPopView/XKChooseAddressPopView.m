//
//  XKChooseAddressPopView.m
//  XiKou
//
//  Created by L.O.U on 2019/7/20.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKChooseAddressPopView.h"
#import "XKEmptyView.h"
#import "XKAddressService.h"
#import "XKAccountManager.h"
#import "XKDataService.h"
#import "MIBasicCell.h"


typedef void(^chooseCompleteBlock)(XKAddressVoData *data);
@interface XKChooseAddressPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)chooseCompleteBlock completeBlock;
@property (nonatomic, copy)NSArray *dataArray;
@end

@implementation XKChooseAddressPopView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self layoutByContentHeight:348];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MIBasicAddressCell class] forCellReuseIdentifier:@"MIBasicAddressCell"];
        
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.equalTo(self.sureBtn.mas_top).offset(-13);
        }];
        [self.sureBtn setTitle:@"添加收货地址" forState:UIControlStateNormal];
        [self getAddressData];
        _tableView.ly_emptyView = [XKEmptyView addressListNoDataView];
    }
    return self;
}

- (void)getAddressData{
    [[XKFDataService() addressService] queryAddressListWithUserId:[XKAccountManager defaultManager].account.userId completion:^(XKAddressUserListResponse * _Nonnull response) {
        if (response.isSuccess) {
            self.dataArray = response.data;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}
#pragma mark UITableView delegate && dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIBasicAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBasicAddressCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    XKAddressVoData *data = self.dataArray[indexPath.row];
    cell.nameLabel.text = data.consigneeName;
    cell.telLabel.text  = data.consigneeMobile;
    NSMutableString *string = [NSMutableString string];
    if (NO == [NSString isNull:data.provinceName]) {
        [string appendString:data.provinceName];
    }
    if (NO == [NSString isNull:data.cityName]) {
        [string appendString:data.cityName];
    }
    
    if (NO == [NSString isNull:data.areaName]) {
        [string appendString:data.areaName];
    }
    if (NO == [NSString isNull:data.address]) {
        [string appendString:data.address];
    }
    cell.addrLabel.text = string;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.editBtn.hidden = YES;
    cell.defaultLabel.hidden = (![data.defaultId isEqualToNumber:@1]);
    if(data.outRange){
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XKAddressVoData *data = self.dataArray[indexPath.row];
    if (data.outRange == NO){
        XKShowToast(@"地址超出配送范围，请重新选择");
        return;
    }
    self.completeBlock(self.dataArray[indexPath.row]);
}

- (void)showWithTitle:(NSString *)title
       chooseComplete:(nonnull void (^)(XKAddressVoData *data))complete
             addBlock:(nonnull void (^)(void))addBlock{
    
    self.titleLabel.text = title;
    [self show];
    @weakify(self);
    self.sureBlock = ^{
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kScreenHeight);
            }];
            self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            @strongify(self);
            addBlock();
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    };
    self.completeBlock = ^(XKAddressVoData *data) {
        [UIView animateWithDuration:.3 animations:^{
            @strongify(self);
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kScreenHeight);
            }];
            self.backgroundColor = COLOR_RGB(0, 0, 0, 0);
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            @strongify(self);
            complete(data);
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    };
}
@end
