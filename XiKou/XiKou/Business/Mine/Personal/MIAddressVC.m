//
//  MIAddressVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIAddressVC.h"
#import "XKUIUnitls.h"
#import "MIBasicCell.h"
#import "MIEditAddressVC.h"
#import "XKAddressService.h"
#import "XKAccountManager.h"


@interface MIAddressVC () <UITableViewDelegate,UITableViewDataSource,MIBasicAddressCellDelegate,XKAddressServiceDelegate>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)UIButton *addressBtn;

@property (nonatomic,strong,readonly)NSMutableArray<XKAddressVoData *> *addresses;

@end

@implementation MIAddressVC

@synthesize tableView = _tableView;
@synthesize addressBtn = _addressBtn;
@synthesize addresses = _addresses;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的地址";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self autoLayout];
    [self loadDataFromCache];
    [self loadDataFromServer];
    [[XKFDataService() addressService] addWeakDelegate:self];
}

- (void)dealloc{
    [[XKFDataService() addressService] removeWeakDelegate:self];
}

#pragma mark UI
- (void)setupUI{
//    self.tableView.rowHeight = 95.0f;
    //self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.separatorColor   = HexRGB(0xe4e4e4, 1.0f);
    self.tableView.tableFooterView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0f)];
    self.tableView.tableFooterView.backgroundColor = HexRGB(0xe4e4e4, 0.5f);
    
    [self.tableView registerClass:[MIBasicAddressCell class] forCellReuseIdentifier:@"MIBasicAddressCell"];
    [self.view addSubview:self.tableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_no_address"]];
    UILabel *label = [[UILabel alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    label.text = @"您还没有收获地址，请新增地址";
    label.textColor = HexRGB(0xcccccc, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [btn setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [btn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
    [btn setBackgroundColor:HexRGB(0x444444, 1.0f)];
    [[btn titleLabel] setFont:[UIFont systemFontOfSize:12.0f]];
    [btn addTarget:self action:@selector(addNewAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    [backgroundView addSubview:btn];
    
    imageView.centerX = kScreenWidth/2.0f;
    imageView.top = 86.0f + kNavBarHeight + [XKUIUnitls safeTop];
    
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = imageView.bottom+10.0f;

    btn.size = CGSizeMake(100.0f, 40.0f);
    btn.centerX = label.centerX;
    btn.top = label.bottom + 25.0f;
    
    self.tableView.backgroundView = backgroundView;
    
    [self.view addSubview:self.addressBtn];
    self.addressBtn.clipsToBounds = YES;
    self.addressBtn.layer.cornerRadius = 2.0f;
    [self.addressBtn setTitle:@"添加收货地址" forState:UIControlStateNormal];
    [self.addressBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
    [[self.addressBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    [self.addressBtn addTarget:self action:@selector(addNewAddressAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.addressBtn.mas_top).offset(-20.0f);
    }];
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.view).offset(-30.0f-[XKUIUnitls safeBottom]);
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.addresses.count == 0) {
        tableView.backgroundView.hidden = NO;
        tableView.tableFooterView.hidden = YES;
        self.addressBtn.hidden = YES;
    }else{
        tableView.backgroundView.hidden = YES;
        tableView.tableFooterView.hidden = NO;
        self.addressBtn.hidden = NO;
    }
    return self.addresses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIBasicAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBasicAddressCell" forIndexPath:indexPath];
    XKAddressVoData *data = [self.addresses objectAtIndex:indexPath.row];
    cell.nameLabel.text = data.consigneeName;
    cell.telLabel.text = data.consigneeMobile;
    XKAddressVoModel *voModel = [[XKAddressVoModel alloc] initWithVoData:data];
    NSString *areaAddress = GetAreaAddressWithVoModel(voModel);
    cell.addrLabel.text =  [NSString stringWithFormat:@"%@-%@",areaAddress,data.address];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data.defaultId.intValue == XKAddressTypeDefault) {
        cell.defaultLabel.hidden = NO;
    }else{
        cell.defaultLabel.hidden = YES;
    }
    
    cell.nameLabel.textColor = COLOR_TEXT_BLACK;
    cell.telLabel.textColor = COLOR_TEXT_BLACK;
    cell.addrLabel.textColor = COLOR_TEXT_GRAY;
    cell.detailTextLabel.hidden = YES;
//    if(data.outRange){
//        cell.nameLabel.textColor = COLOR_TEXT_BLACK;
//        cell.telLabel.textColor = COLOR_TEXT_BLACK;
//        cell.addrLabel.textColor = COLOR_TEXT_GRAY;
//        cell.detailTextLabel.hidden = YES;
//    }else{
//        cell.nameLabel.textColor =  HexRGB(0xcccccc, 1.0f);
//        cell.telLabel.textColor  =  HexRGB(0xcccccc, 1.0f);
//        cell.addrLabel.textColor =  HexRGB(0xcccccc, 1.0f);
//        cell.detailTextLabel.hidden = NO;
//    }
    cell.delegate = self;
    return cell;
}

- (void)cell:(MIBasicAddressCell *)cell editAddressWithSender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XKAddressVoData *voData = [self.addresses objectAtIndex:indexPath.row];
    MIEditAddressVC *addressVC = [[MIEditAddressVC alloc] initWithAddressVoData:voData];
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView beginUpdates];
        XKAddressVoData *voData = [self.addresses objectAtIndex:indexPath.row];
        [self deleteAddress:voData];
        [self.addresses removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }];
    rowAction.backgroundColor = HexRGB(0xcea552, 1.0f);
    return @[rowAction];
}



#pragma mark address service delegate
- (void)addAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data{
    if (data.defaultId.intValue ==  XKAddressTypeDefault) {
        [self.addresses enumerateObjectsUsingBlock:^(XKAddressVoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.defaultId.intValue == XKAddressTypeDefault){
                obj.defaultId = @(XKAddressTypeNone);
            }
        }];
    }
    [self.addresses insertObject:data atIndex:0];
    [self.tableView reloadData];
}


- (void)updateAddressWithSevice:(XKAddressService *)service address:(XKAddressVoData *)data{
    __block NSInteger index = NSNotFound;
    [self.addresses enumerateObjectsUsingBlock:^(XKAddressVoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (data.defaultId.intValue ==  XKAddressTypeDefault && obj.defaultId.intValue == XKAddressTypeDefault) {
            obj.defaultId = @(XKAddressTypeNone);
        }
        if ([data.id isEqualToString:obj.id]) {
            index = (NSInteger)idx;
        }
    }];
    if (index != NSNotFound) {
        [self.addresses replaceObjectAtIndex:index withObject:data];
    }
    [self.tableView reloadData];
}


#pragma mark action
- (void)addNewAddressAction:(id)sender{
    MIEditAddressVC *addressVC = [[MIEditAddressVC alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
}


#pragma mark 请求数据

- (void)loadDataFromServer{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([NSString isNull:userId]) {
        XKShowToast(@"用户id为空");
        return;
    }
  //  [XKLoading show];
    [[XKFDataService() addressService] queryAddressListWithUserId:userId completion:^(XKAddressUserListResponse * _Nonnull response) {
    //    [XKLoading dismiss];
        if (response.isSuccess) {
            [self.addresses removeAllObjects];
            [self.addresses addObjectsFromArray:response.data];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)loadDataFromCache{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    NSArray<XKAddressVoData *> *address = [[XKFDataService() addressService] queryAddressListFromCacheWithUserId:userId];
    if (address) {
        [self.addresses removeAllObjects];
        [self.addresses addObjectsFromArray:address];
    }
}

- (void)deleteAddress:(XKAddressVoData *)voData{
    [[XKFDataService() addressService] deleteAddressWithId:voData.id completion:^(XKAddressDeleteResponse * _Nonnull response) {
        if (response.isSuccess) {
            if (voData.defaultId.intValue != XKAddressTypeDefault) return;
            [self.addresses enumerateObjectsUsingBlock:^(XKAddressVoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([response.data.id isEqualToString:obj.id]) {
                    obj.defaultId = @(XKAddressTypeDefault);
                    *stop = YES;
                }
            }];
            [self.tableView reloadData];
        }else{
            NSMutableString *string = [NSMutableString stringWithFormat:@"删除地址失败:"];
            if([NSString isNull:response.msg]){
                NSError *error = [NSError errorWithCode:response.code.intValue];
                [string appendString:error.domain];
            }else{
                [string appendString:response.msg];
            }
            XKShowToast(string);
        }
    }];
}



#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 95.0f;
    }
    return _tableView;
}

- (UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addressBtn;
}


- (NSMutableArray<XKAddressVoData *> *)addresses{
    if (!_addresses) {
        _addresses = [NSMutableArray array];
    }
    return _addresses;
}

@end

