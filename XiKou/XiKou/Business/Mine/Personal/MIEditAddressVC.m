//
//  MIEditAddressVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIEditAddressVC.h"
#import "XKUIUnitls.h"
#import "MIBasicCell.h"
#import "MIAddressSelectVC.h"
#import <AFViewShaker.h>
#import "XKAccountManager.h"
#import "XKAddressService.h"

@interface MITextFieldCell : UITableViewCell

@property (nonatomic,strong,readonly)UITextField *textField;

@end

@implementation MITextFieldCell
@synthesize textField = _textField;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.textField];
        self.textField.xk_monitor = YES;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(20, 0, CGRectGetWidth(self.contentView.bounds)-40, CGRectGetHeight(self.contentView.bounds));
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = COLOR_TEXT_BROWN;
        _textField.font = [UIFont systemFontOfSize:15.0f];
    }
    return _textField;
}

@end

@interface MIEditAddressVC () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MIAddressSelectViewControllerDelegate>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)UIButton *saveBtn;

@property (nonatomic,strong,readonly)UIButton *selectBtn;

@property (nonatomic,strong,readonly)UILabel *label;

@property (nonatomic,strong,readonly) MIAddressSelectVC *addressSelectVC;

@property (nonatomic,strong,readonly) XKAddressVoData *voData;

@end

@implementation MIEditAddressVC
@synthesize tableView = _tableView;
@synthesize saveBtn = _saveBtn;
@synthesize selectBtn = _selectBtn;
@synthesize label = _label;
@synthesize addressSelectVC = _addressSelectVC;
@synthesize voData = _voData;

- (instancetype)initWithAddressVoData:(XKAddressVoData *)addressVoData{
    if (self = [super init]) {
        if (addressVoData) {
            _voData = [addressVoData copy];
        }else{
            _voData = [[XKAddressVoData alloc] init];
        }
    }
    return self;
}

- (instancetype)init{
    if(self = [super init]){
        _voData = [[XKAddressVoData alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*添加子控制器*/
    [self addChildViewController:self.addressSelectVC];
    [self.view addSubview:self.addressSelectVC.view];
    [self.addressSelectVC didMoveToParentViewController:self];
    
    [self setupUI];
    [self autoLayout];
    if ([NSString isNull:self.voData.id]) {
        self.title = @"新增地址";
    }else{
        self.title = @"编辑地址";
    }
    
    if (self.voData.defaultId.intValue == XKAddressTypeDefault) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
}

- (void)dealloc{
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:NO];
}

#pragma mark UI
- (void)setupUI{
    self.tableView.rowHeight = 60.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    UIView *footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    UIView *line =  [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40.0f, 0.5f)];
    line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    [footerView addSubview:line];
    self.tableView.tableFooterView  = footerView;
    [self.view addSubview:self.tableView];
    
    [self.selectBtn setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.label];
    
    [self.view addSubview:self.saveBtn];
    self.saveBtn.clipsToBounds = YES;
    self.saveBtn.layer.cornerRadius = 2.0f;
    [self.saveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
    [self.saveBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
    [[self.saveBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    
    [self.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(280.0f);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23.0f);
        make.width.height.mas_equalTo(18.0f);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(10.0f);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectBtn.mas_right).offset(7.0f);
        make.centerY.equalTo(self.selectBtn);
        make.width.mas_equalTo(216.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.view).offset(-(20+[XKUIUnitls safeBottom]));
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"identifier-%ld",(long)indexPath.row];
    if (indexPath.row == 2) {
        MIBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MIBasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = @"选择地址";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = HexRGB(0x444444, 1.0f);
        XKAddressVoModel *voModel = [[XKAddressVoModel alloc] initWithVoData:self.voData];
        cell.detailTextLabel.text = GetAreaAddressWithVoModel(voModel);
        return cell;
    }else{
        MITextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[MITextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.row == 0) {
            cell.textField.placeholder = @"姓名";
            cell.textField.xk_maximum = 20;
            cell.textField.text = self.voData.consigneeName;
        }else if (indexPath.row == 1){
            cell.textField.placeholder = @"手机号码";
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            cell.textField.xk_maximum = 20;
            cell.textField.text = self.voData.consigneeMobile;
        }else{
            cell.textField.placeholder = @"详细地址，如街道，楼牌号等";
            cell.textField.xk_maximum = 60;
            cell.textField.text = self.voData.address;
        }
        cell.textField.delegate = self;
        cell.textField.returnKeyType = UIReturnKeyDone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        XKAddressVoModel *voModel = [[XKAddressVoModel alloc] initWithVoData:self.voData];
        [self.addressSelectVC editVoData:voModel];
        [self.addressSelectVC show];
    }
}

#pragma mark textField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark 地址选择器代理
- (void)addressSelectViewController:(MIAddressSelectVC *)controller finishEditAddress:(XKAddressVoModel *)voModel{
    MIBasicCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.detailTextLabel.text = GetAreaAddressWithVoModel(voModel);
    self.voData.provinceId = voModel.provinceId;
    self.voData.cityId = voModel.cityId;
    self.voData.areaId = voModel.districtId;
}

- (void)addressSelectViewController:(MIAddressSelectVC *)controller locationAddress:(XKAddressVoModel *)voModel location:(CLLocation *)location{
    MIBasicCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([NSString isNull:cell.detailTextLabel.text]) {
        cell.detailTextLabel.text = GetAreaAddressWithVoModel(voModel);
        self.voData.provinceId = voModel.provinceId;
        self.voData.cityId = voModel.cityId;
        self.voData.areaId = voModel.districtId;
    }
}

#pragma mark action
- (void)selectAction:(id)sender{
    self.selectBtn.selected = !self.selectBtn.isSelected;
}

- (void)saveAction:(id)sender{
    
    MITextFieldCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([NSString isNull:cell1.textField.text]) {
        AFViewShaker *sharker = [[AFViewShaker alloc] initWithView:cell1.textField];
        [sharker shake];
        return;
    }
    MITextFieldCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (NO == [cell2.textField.text isMobileNumber]) {
        AFViewShaker *sharker = [[AFViewShaker alloc] initWithView:cell2.textField];
        [sharker shake];
        XKShowToast(@"请输入正确的手机号码");
        return;
    }
    
    MIBasicCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([NSString isNull:cell3.detailTextLabel.text]) {
        AFViewShaker *sharker = [[AFViewShaker alloc] initWithView:cell3.textLabel];
        [sharker shake];
        XKShowToast(@"请选择地址");
        return;
    }
    
    MITextFieldCell *cell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if ([NSString isNull:cell4.textField.text]) {
        AFViewShaker *sharker = [[AFViewShaker alloc] initWithView:cell4.textField];
        [sharker shake];
        return;
    }
    
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    self.voData.userId = userId;
    self.voData.consigneeName = cell1.textField.text;
    self.voData.consigneeMobile = cell2.textField.text;
    self.voData.address = cell4.textField.text;
    if (self.selectBtn.isSelected) {
        self.voData.defaultId = @(XKAddressTypeDefault);
    }else{
        self.voData.defaultId = @(XKAddressTypeNone);
    }
    
    if ([NSString isNull:self.voData.id]) {
        [[XKFDataService() addressService] addAddress:self.voData completion:^(XKBaseResponse * _Nonnull response) {
            if (response.isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [response showError];
            }
        }];
    }else{
        [[XKFDataService() addressService] updateAddress:self.voData completion:^(XKBaseResponse * _Nonnull response) {
            if (response.isSuccess) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [response showError];
            }
        }];
    }
}


#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _saveBtn;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _selectBtn;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"设置为默认购物收货地址";
        _label.font = [UIFont systemFontOfSize:12.0f];
        _label.textColor = HexRGB(0x444444, 1.0f);
    }
    return _label;
}


- (MIAddressSelectVC *)addressSelectVC{
    if (!_addressSelectVC) {
        _addressSelectVC = [[MIAddressSelectVC alloc] init];
        _addressSelectVC.delegate = self;
    }
    return _addressSelectVC;
}


@end
