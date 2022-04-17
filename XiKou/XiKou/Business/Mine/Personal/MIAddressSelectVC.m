//
//  MIAddressSelectVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIAddressSelectVC.h"
#import "XKUIUnitls.h"
#import <LKDBHelper.h>
#import "XKDataService.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "XKAddressService.h"

static NSTimeInterval  kDefaultLocationTimeout = 10;
static NSTimeInterval kDefaultReGeocodeTimeout = 5;

#define kSheetWidth (kScreenWidth)

#define kSheetHeight (429.0f+[XKUIUnitls safeBottom])

@interface MIAddressSelectVC ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic,strong)UIView *sheetView;

@property (nonatomic,strong)UIView *backgroundView;

@property (nonatomic,strong,readonly) UIImageView *icon;

@property (nonatomic,strong,readonly) UILabel *addressLabel;

@property (nonatomic,strong,readonly) UIButton *dismissBtn;

@property (nonatomic,strong,readonly) UIButton *oneLevelBtn;

@property (nonatomic,strong,readonly) UIButton *twoLevelBtn;

@property (nonatomic,strong,readonly) UIButton *threeLevelBtn;

@property (nonatomic,strong,readonly) UIView *spreadLine1;

@property (nonatomic,strong,readonly) UIView *spreadLine2;

@property (nonatomic,strong,readonly) UIView *bottomLine;

@property (nonatomic,strong,readonly) UIScrollView *scrollView;

@property (nonatomic,strong,readonly) UITableView *oneLevelTableView;

@property (nonatomic,strong,readonly) UITableView *twoLevelTableView;

@property (nonatomic,strong,readonly) UITableView *threeLevelTableView;


@property (nonatomic,strong,readonly) UIView *backView;

@property (nonatomic, strong,readonly)AMapLocationManager *locationManager;

@property (nonatomic, strong,readonly)AMapSearchAPI *searchAPI;

@property (nonatomic,strong) NSArray<XKAddressInfoData *> *provinces;

@property (nonatomic,strong) NSArray<XKAddressInfoData *> *cities;

@property (nonatomic,strong) NSArray<XKAddressInfoData *> *districts;

@property (nonatomic,strong) XKAddressVoModel *voData;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,assign,getter=isShow)BOOL showIt;

@end

@implementation MIAddressSelectVC
@synthesize icon = _icon;
@synthesize addressLabel = _addressLabel;
@synthesize titleLabel = _titleLabel;
@synthesize dismissBtn = _dismissBtn;
@synthesize oneLevelBtn = _oneLevelBtn;
@synthesize twoLevelBtn = _twoLevelBtn;
@synthesize threeLevelBtn = _threeLevelBtn;
@synthesize spreadLine1 = _spreadLine1;
@synthesize spreadLine2 = _spreadLine2;
@synthesize bottomLine = _bottomLine;
@synthesize scrollView = _scrollView;
@synthesize oneLevelTableView = _oneLevelTableView;
@synthesize twoLevelTableView = _twoLevelTableView;
@synthesize threeLevelTableView = _threeLevelTableView;
@synthesize backView = _backView;
@synthesize locationManager = _locationManager;
@synthesize searchAPI = _searchAPI;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _addressLevel = XKAddressLevelDistrict;
        _autoLocation = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    self.sheetView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), kSheetWidth, kSheetHeight);
    [self layout];
    [[XKFDataService() addressService] queryAllAddressInfoWithLevel:XKAddressLevelProvince completion:^(XKAddressInfoListResponse * _Nonnull response) {
        if(response.isSuccess){
            NSLog(@"请求省");
        }
    }];
    
    [[XKFDataService() addressService] queryAllAddressInfoWithLevel:XKAddressLevelCity completion:^(XKAddressInfoListResponse * _Nonnull response) {
        if(response.isSuccess){
            NSLog(@"请求市");
        }
    }];
    [[XKFDataService() addressService] queryAllAddressInfoWithLevel:XKAddressLevelDistrict completion:^(XKAddressInfoListResponse * _Nonnull response) {
        if(response.isSuccess){
            NSLog(@"请求区");
        }
    }];
    XKAddressVoModel *voData = [[XKAddressVoModel alloc] init];
    [self editVoData:voData];
    if (self.autoLocation) {
        [self configLocationManager];
        [self reGeocodeAction];
        self.titleLabel.hidden = YES;
    }else{
        self.icon.hidden = YES;
        self.addressLabel.hidden = YES;
    }
    
}

- (void)dealloc{
    [self cleanUpAction];
}


- (void)editVoData:(XKAddressVoModel *)voData{
    _voData = voData;
    self.provinces = [XKAddressInfoData searchWithWhere:@{@"level":@(XKAddressLevelProvince)}];
    [self refreshUIForDataSource:voData];
    if (self.districts.count > 0 && self.addressLevel >= XKAddressLevelDistrict) {
        self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.scrollView.bounds), 0);
        [self.scrollView setContentOffset:CGPointMake(CGRectGetMaxX(self.twoLevelTableView.frame), 0) animated:NO];
        
        NSInteger dIndex = [self areaId:self.voData.districtId indexOfArray:self.districts];
        if(dIndex != NSNotFound){
            [self.threeLevelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        NSInteger cIndex = [self areaId:self.voData.cityId indexOfArray:self.cities];
        if(cIndex != NSNotFound){
            [self.twoLevelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        NSInteger pIndex = [self areaId:self.voData.provinceId indexOfArray:self.provinces];
        if(pIndex != NSNotFound){
            [self.oneLevelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:pIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        return;
    }
    if (self.cities.count > 0 && self.addressLevel >= XKAddressLevelCity) {
        self.scrollView.contentSize = CGSizeMake(2*CGRectGetWidth(self.scrollView.bounds), 0);
        [self.scrollView setContentOffset:CGPointMake(CGRectGetMaxX(self.oneLevelTableView.frame), 0) animated:YES];
        
        NSInteger cIndex = [self areaId:self.voData.cityId indexOfArray:self.cities];
        if(cIndex != NSNotFound){
            [self.twoLevelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        NSInteger pIndex = [self areaId:self.voData.provinceId indexOfArray:self.provinces];
        if(pIndex != NSNotFound){
            [self.oneLevelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:pIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        return;
    }
    if (self.provinces.count > 0 && self.addressLevel >= XKAddressLevelProvince) {
        NSInteger pIndex = [self areaId:self.voData.provinceId indexOfArray:self.provinces];
        if(pIndex != NSNotFound){
            [self.oneLevelTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:pIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 0);
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return;
}

- (void)refreshUIForDataSource:(XKAddressVoModel *)voData{
    if (voData.provinceId) {
        self.cities = [XKAddressInfoData searchWithWhere:@{@"parentId":voData.provinceId}];
    }else{
        self.cities = nil;
    }
    if (voData.cityId) {
        self.districts = [XKAddressInfoData searchWithWhere:@{@"parentId":voData.cityId}];
    }else{
        self.districts = nil;
    }
    [self.oneLevelTableView reloadData];
    [self.twoLevelTableView reloadData];
    [self.threeLevelTableView reloadData];
    [self setupBtns];
}


- (NSInteger)areaId:(NSNumber *)areaId indexOfArray:(NSArray<XKAddressInfoData *> *)array{
    if (areaId == nil) return NSNotFound;
    __block NSInteger index = NSNotFound;
    [array enumerateObjectsUsingBlock:^(XKAddressInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaId isEqualToNumber:areaId]) {
            index = (NSInteger)idx;
            *stop = YES;
        }
    }];
    return index;
}

- (XKAddressInfoData *)areaId:(NSNumber *)areaId objctOfArray:(NSArray<XKAddressInfoData *> *)array{
    if (areaId == nil) return nil;
    __block XKAddressInfoData *data = nil;
    [array enumerateObjectsUsingBlock:^(XKAddressInfoData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.areaId isEqualToNumber:areaId]) {
            data = obj;
            *stop = YES;
        }
    }];
    return data;
}


- (void)setupUI{
    self.sheetView.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.sheetView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.sheetView.layer.borderWidth = 0.5f;
    
    [self.sheetView addSubview:self.icon];
    
    self.addressLabel.text = @"正在定位中...";
    [self.sheetView addSubview:self.addressLabel];
    
    [self.sheetView addSubview:self.titleLabel];
    
    [self.dismissBtn setImage:[UIImage imageNamed:@"diss"] forState:UIControlStateNormal];
    [self.sheetView addSubview:self.dismissBtn];
    
    [self.spreadLine1 setBackgroundColor:HexRGB(0xe4e4e4, 1.0f)];
    [self.sheetView addSubview:self.spreadLine1];
    
    [self.spreadLine2 setBackgroundColor:HexRGB(0xe4e4e4, 1.0f)];
    [self.sheetView addSubview:self.spreadLine2];
    
    [self.bottomLine setBackgroundColor:COLOR_TEXT_BROWN];
    [self.sheetView addSubview:self.bottomLine];
    
    [self.sheetView addSubview:self.oneLevelBtn];
    [self.sheetView addSubview:self.twoLevelBtn];
    [self.sheetView addSubview:self.threeLevelBtn];
    
    [self.sheetView addSubview:self.scrollView];
    [self.scrollView addSubview:self.oneLevelTableView];
    [self.scrollView addSubview:self.twoLevelTableView];
    [self.scrollView addSubview:self.threeLevelTableView];
    
    [self.oneLevelTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OneLevel"];
    [self.twoLevelTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TwoLevel"];
    [self.threeLevelTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ThreeLevel"];
    
    [self.oneLevelBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateSelected];
    [self.twoLevelBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateSelected];
    [self.threeLevelBtn setTitleColor:COLOR_TEXT_BROWN forState:UIControlStateSelected];
    
    [self.oneLevelBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.twoLevelBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.threeLevelBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
    [self.oneLevelBtn addTarget:self action:@selector(oneLevelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoLevelBtn addTarget:self action:@selector(twoLevelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.threeLevelBtn addTarget:self action:@selector(threeLevelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissBtn addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layout];
}

- (void)layout{
    self.icon.frame = CGRectMake(20.0f, 17.5f, 15.0f, 15.0f);
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame)+6.0f, CGRectGetMidY(self.icon.frame)-7.0f, CGRectGetWidth(self.sheetView.bounds)-100.0f, 14.0f);
    
    self.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.sheetView.bounds), 50.0f);
    
    self.dismissBtn.frame = CGRectMake(kScreenWidth-20.0f-30.0f, 0, 30.0f, 50.0f);
    self.spreadLine1.frame = CGRectMake(15.0f, 50.0f, CGRectGetWidth(self.sheetView.bounds)-30.0f, 0.5f);
    self.spreadLine2.frame = CGRectMake(15.0f, 100.0f, CGRectGetWidth(self.sheetView.bounds)-30.0f, 0.5f);
    
    CGSize btn1Size = [self.oneLevelBtn sizeThatFits:CGSizeMake(100.0f, 21.0f)];
    CGSize btn2Size = [self.twoLevelBtn sizeThatFits:CGSizeMake(100.0f, 21.0f)];
    CGSize btn3Size = [self.threeLevelBtn sizeThatFits:CGSizeMake(100.0f, 21.0f)];
    
    self.oneLevelBtn.frame = CGRectMake(20.0f, CGRectGetMaxY(self.spreadLine1.frame)+17.0f, btn1Size.width, btn1Size.height);
    
    self.twoLevelBtn.frame = CGRectMake(CGRectGetMaxX(self.oneLevelBtn.frame)+20.0f, CGRectGetMaxY(self.spreadLine1.frame)+17.0f, btn2Size.width, btn2Size.height);
    
    self.threeLevelBtn.frame = CGRectMake(CGRectGetMaxX(self.twoLevelBtn.frame)+20.0f, CGRectGetMaxY(self.spreadLine1.frame)+17.0f, btn3Size.width, btn3Size.height);
    
    if (self.oneLevelBtn.isSelected) {
        self.bottomLine.frame = CGRectMake(CGRectGetMinX(self.oneLevelBtn.frame), CGRectGetMinY(self.spreadLine2.frame)-2, CGRectGetWidth(self.oneLevelBtn.frame), 3.0f);
    }else if (self.twoLevelBtn.isSelected){
        self.bottomLine.frame = CGRectMake(CGRectGetMinX(self.twoLevelBtn.frame), CGRectGetMinY(self.spreadLine2.frame)-2, CGRectGetWidth(self.twoLevelBtn.frame), 3.0f);
    }else{
        self.bottomLine.frame = CGRectMake(CGRectGetMinX(self.threeLevelBtn.frame), CGRectGetMinY(self.spreadLine2.frame)-2, CGRectGetWidth(self.threeLevelBtn.frame), 3.0f);
    }
    
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.spreadLine2.frame), CGRectGetWidth(self.sheetView.bounds), CGRectGetHeight(self.sheetView.bounds)-CGRectGetMaxY(self.spreadLine2.frame));
    self.oneLevelTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    self.twoLevelTableView.frame = CGRectMake(CGRectGetWidth(self.scrollView.bounds), 0,CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    self.threeLevelTableView.frame = CGRectMake(2*CGRectGetWidth(self.scrollView.bounds), 0,CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
}




#pragma mark tableView data source or delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.oneLevelTableView) {
        return self.provinces.count;
    }else if (tableView == self.twoLevelTableView){
        return self.cities.count;
    }else{
        return self.districts.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.oneLevelTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneLevel" forIndexPath:indexPath];
        XKAddressInfoData *address = [self.provinces objectAtIndex:indexPath.row];
        cell.textLabel.text = address.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        cell.tintColor = COLOR_TEXT_BROWN;
        if ([self.voData.provinceId isEqualToNumber:address.areaId]) {
            cell.textLabel.textColor = COLOR_TEXT_BROWN;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else if (tableView ==  self.twoLevelTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwoLevel" forIndexPath:indexPath];
         XKAddressInfoData *address = [self.cities objectAtIndex:indexPath.row];
        cell.textLabel.text = address.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        cell.tintColor = COLOR_TEXT_BROWN;
        if ([self.voData.cityId isEqualToNumber:address.areaId]) {
            cell.textLabel.textColor = COLOR_TEXT_BROWN;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThreeLevel" forIndexPath:indexPath];
        XKAddressInfoData *address = [self.districts objectAtIndex:indexPath.row];
        cell.textLabel.text = address.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        cell.tintColor = COLOR_TEXT_BROWN;
        if ([self.voData.districtId isEqualToNumber:address.areaId]) {
            cell.textLabel.textColor = COLOR_TEXT_BROWN;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.textLabel.textColor = HexRGB(0x444444, 1.0f);
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.oneLevelTableView) {
        XKAddressInfoData *data = [self.provinces objectAtIndex:indexPath.row];
        self.voData.provinceId = data.areaId;
        self.voData.cityId = nil;
        self.voData.districtId = nil;
        [self refreshUIForDataSource:self.voData];
        [self setupBtns];
        if (self.cities.count == 0 || self.addressLevel == XKAddressLevelProvince) {
            [self doneIt];
        }else{
            self.scrollView.contentSize = CGSizeMake(2*CGRectGetWidth(self.scrollView.bounds), 0);
            [self.scrollView setContentOffset:CGPointMake(CGRectGetMaxX(self.oneLevelTableView.frame), 0) animated:YES];
        }
    }else if (tableView == self.twoLevelTableView){
        XKAddressInfoData *data = [self.cities objectAtIndex:indexPath.row];
        self.voData.cityId = data.areaId;
        self.voData.districtId = nil;
        [self refreshUIForDataSource:self.voData];
        [self setupBtns];
        if (self.districts.count == 0 || self.addressLevel == XKAddressLevelCity) {
            [self doneIt];
        }else{
            self.scrollView.contentSize = CGSizeMake(3*CGRectGetWidth(self.scrollView.bounds), 0);
            [self.scrollView setContentOffset:CGPointMake(CGRectGetMaxX(self.twoLevelTableView.frame), 0) animated:YES];
        }
    }else{
        XKAddressInfoData *data = [self.districts objectAtIndex:indexPath.row];
        self.voData.districtId = data.areaId;
        [self refreshUIForDataSource:self.voData];
        [self setupBtns];
        [self doneIt];
    }
}


#pragma mark private methods

- (void)setupBtns{
    void (^block)(void) = ^{
        CGSize btn1Size = [self.oneLevelBtn sizeThatFits:CGSizeMake(100.0f, 21.0f)];
        CGSize btn2Size = [self.twoLevelBtn sizeThatFits:CGSizeMake(100.0f, 21.0f)];
        CGSize btn3Size = [self.threeLevelBtn sizeThatFits:CGSizeMake(100.0f, 21.0f)];
        self.oneLevelBtn.frame = CGRectMake(20.0f, CGRectGetMaxY(self.spreadLine1.frame)+17.0f, btn1Size.width, btn1Size.height);
        self.twoLevelBtn.frame = CGRectMake(CGRectGetMaxX(self.oneLevelBtn.frame)+20.0f, CGRectGetMaxY(self.spreadLine1.frame)+17.0f, btn2Size.width, btn2Size.height);
        self.threeLevelBtn.frame = CGRectMake(CGRectGetMaxX(self.twoLevelBtn.frame)+20.0f, CGRectGetMaxY(self.spreadLine1.frame)+17.0f, btn3Size.width, btn3Size.height);
    };
    
    if (self.voData.provinceId == nil) {
        [self.oneLevelBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [self.oneLevelBtn setSelected:YES];
        [self.twoLevelBtn setSelected:NO];
        [self.threeLevelBtn setSelected:NO];
        [self.oneLevelBtn setHidden:NO];
        [self.twoLevelBtn setHidden:YES];
        [self.threeLevelBtn setHidden:YES];
        block();
        return;
    }
    if (self.voData.cityId == nil) {
        XKAddressInfoData *data = [self areaId:self.voData.provinceId objctOfArray:self.provinces];
        [self.oneLevelBtn setTitle:data.name forState:UIControlStateNormal];
        if (self.cities.count > 0) {
            [self.twoLevelBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
        [self.oneLevelBtn setSelected:NO];
        [self.twoLevelBtn setSelected:YES];
        [self.threeLevelBtn setSelected:NO];
        [self.oneLevelBtn setHidden:NO];
        [self.twoLevelBtn setHidden:NO];
        [self.threeLevelBtn setHidden:YES];
        block();
        return;
    }
    if (self.voData.districtId == nil) {
        XKAddressInfoData *provinceData = [self areaId:self.voData.provinceId objctOfArray:self.provinces];
        XKAddressInfoData *cityData = [self areaId:self.voData.cityId objctOfArray:self.cities];
        if (self.districts.count > 0) {
            [self.threeLevelBtn setTitle:@"请选择" forState:UIControlStateNormal];
            [self.threeLevelBtn setHidden:NO];
        }else{
            [self.threeLevelBtn setHidden:YES];
        }
        [self.oneLevelBtn setSelected:NO];
        [self.twoLevelBtn setSelected:NO];
        [self.threeLevelBtn setSelected:YES];
        [self.oneLevelBtn setHidden:NO];
        [self.twoLevelBtn setHidden:NO];
        [self.oneLevelBtn setTitle:provinceData.name forState:UIControlStateNormal];
        [self.twoLevelBtn setTitle:cityData.name forState:UIControlStateNormal];
        block();
        return;
    }
    
    XKAddressInfoData *provinceData = [self areaId:self.voData.provinceId objctOfArray:self.provinces];
    XKAddressInfoData *cityData = [self areaId:self.voData.cityId objctOfArray:self.cities];
    XKAddressInfoData *districtData = [self areaId:self.voData.districtId objctOfArray:self.districts];

    [self.threeLevelBtn setHidden:NO];
    [self.oneLevelBtn setSelected:NO];
    [self.twoLevelBtn setSelected:NO];
    [self.threeLevelBtn setSelected:YES];
    [self.oneLevelBtn setHidden:NO];
    [self.twoLevelBtn setHidden:NO];
    [self.oneLevelBtn setTitle:provinceData.name forState:UIControlStateNormal];
    [self.twoLevelBtn setTitle:cityData.name forState:UIControlStateNormal];
    [self.threeLevelBtn setTitle:districtData.name forState:UIControlStateNormal];
    block();
}

- (void)oneLevelAction:(id)sender{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)twoLevelAction:(id)sender{
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0) animated:YES];
}

- (void)threeLevelAction:(id)sender{
    [self.scrollView setContentOffset:CGPointMake(2*CGRectGetWidth(self.scrollView.bounds), 0) animated:YES];
}

- (void)dismissAction:(id)sender{
    [self dismiss];
}

- (void)setCurrentAddress:(NSString *)currentAddress{
    self.addressLabel.text = currentAddress;
}


-(void)doneIt{
    [self dismiss];
    if (self.voData.provinceId) {
        self.voData.province = GetAreaAddress(self.voData.provinceId, nil, nil);
    }
    if (self.voData.cityId) {
        self.voData.city = GetAreaAddress(nil, self.voData.cityId, nil);
    }
    if (self.voData.districtId) {
        self.voData.district = GetAreaAddress(nil, nil, self.voData.districtId);
    }
    
    if ([self.delegate respondsToSelector:@selector(addressSelectViewController:finishEditAddress:)]) {
        [self.delegate addressSelectViewController:self finishEditAddress:self.voData];
    }
    if ([self.delegate respondsToSelector:@selector(addressSelectViewController:finishEditAddress:location:)]) {
        NSString *address = [self getAddressWithVoData:self.voData];
        [self geocodeAddressString:address];
    }
}


- (NSString *)getAddressWithVoData:(XKAddressVoModel *)voData{
     NSMutableString *string = [NSMutableString string];
    if (self.voData.provinceId) {
        XKAddressInfoData *provinceData = [self areaId:self.voData.provinceId objctOfArray:self.provinces];
        if (![NSString isNull:provinceData.name]) {
            [string appendString:provinceData.name];
        }
    }
    if (self.voData.cityId) {
        XKAddressInfoData *cityData = [self areaId:self.voData.cityId objctOfArray:self.cities];
        if (![NSString isNull:cityData.name]) {
            [string appendString:@"-"];
            [string appendString:cityData.name];
        }
    }
    if (self.voData.districtId) {
        XKAddressInfoData *districtData = [self areaId:self.voData.districtId objctOfArray:self.districts];
        if (![NSString isNull:districtData.name]) {
            [string appendString:@"-"];
            [string appendString:districtData.name];
        }
    }
    return string;
}



#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < CGRectGetWidth(scrollView.bounds)) {
        CGFloat distance = CGRectGetMidX(self.twoLevelBtn.frame) - CGRectGetMidX(self.oneLevelBtn.frame);
        CGFloat x = distance * scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
        CGFloat centerX = CGRectGetMidX(self.oneLevelBtn.frame) + x;
        
        if(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds)<0.5){
            self.bottomLine.width =  CGRectGetWidth(self.oneLevelBtn.frame);
        }else{
            self.bottomLine.width = CGRectGetWidth(self.twoLevelBtn.frame);
        }
        self.bottomLine.centerX = centerX;
    }else{
        CGFloat distance = CGRectGetMidX(self.threeLevelBtn.frame) - CGRectGetMidX(self.twoLevelBtn.frame);
        CGFloat x = distance * (scrollView.contentOffset.x/ CGRectGetWidth(scrollView.bounds)-1.0f);
        CGFloat centerX = CGRectGetMidX(self.twoLevelBtn.frame) + x;
        if(isnan(x))x = 0.0f;
        if (isnan(centerX))centerX = 0.0f;
        if(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds)<1.5){
            self.bottomLine.width =  CGRectGetWidth(self.twoLevelBtn.frame);
        }else{
            self.bottomLine.width = CGRectGetWidth(self.threeLevelBtn.frame);
        }
        self.bottomLine.centerX = centerX;
    }
}



#pragma mark 高德地图
- (void)configLocationManager{
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    // [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:kDefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:kDefaultReGeocodeTimeout];
}

- (void)cleanUpAction{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
}

- (void)reGeocodeAction{
    //进行单次带逆地理定位请求
    @weakify(self);
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        NSLog(@"逆定理编码");
        @strongify(self);
        if (error) {
            self.addressLabel.text = @"自动定位失败";
            if([self.delegate respondsToSelector:@selector(addressSelectViewController:locationError:)]){
                [self.delegate addressSelectViewController:self locationError:error];
            }
        }else{
            NSString *address = [NSString stringWithFormat:@"自动定位:%@%@%@",regeocode.province,regeocode.city,regeocode.district];
            self.addressLabel.text = address;
            XKAddressVoModel *defaultVoData = [[XKAddressVoModel alloc] init];
            defaultVoData.province = regeocode.province;
            defaultVoData.city = regeocode.city;
            defaultVoData.district = regeocode.city;
            if(regeocode.province){
                XKAddressInfoData *infoData = [XKAddressInfoData searchSingleWithWhere:@{@"name":regeocode.province} orderBy:nil];
                if (infoData) {
                    defaultVoData.provinceId = infoData.areaId;
                    defaultVoData.province =  infoData.name;
                }
            }
            if (regeocode.city) {
                XKAddressInfoData *infoData = [XKAddressInfoData searchSingleWithWhere:@{@"name":regeocode.city} orderBy:nil];
                if (infoData) {
                    defaultVoData.cityId = infoData.areaId;
                    defaultVoData.city = infoData.name;
                }
            }
            if (regeocode.district) {
                XKAddressInfoData *infoData = [XKAddressInfoData searchSingleWithWhere:@{@"name":regeocode.district} orderBy:nil];
                if (infoData) {
                    defaultVoData.districtId = infoData.areaId;
                     defaultVoData.district =  infoData.name;
                }
            }
            defaultVoData.location = location;
            if ([self.delegate respondsToSelector:@selector(addressSelectViewController:locationAddress:location:)]) {
                [self.delegate addressSelectViewController:self locationAddress:defaultVoData location:location];
            }
        }
    }];
}

//地理编码
- (void)geocodeAddressString:(NSString *)address{
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    [self.searchAPI AMapGeocodeSearch:geo];
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0){
        return;
    }
    AMapGeocode *geocode = [response.geocodes firstObject];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geocode.location.latitude longitude:geocode.location.longitude];
    self.voData.location = location;
    if ([self.delegate respondsToSelector:@selector(addressSelectViewController:finishEditAddress:location:)]) {
        [self.delegate addressSelectViewController:self finishEditAddress:self.voData location:location];
    }
}


#pragma mark getter

- (void)setSheetTitle:(NSString *)sheetTitle{
    _sheetTitle = sheetTitle;
    self.titleLabel.text = sheetTitle;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_nearby_default"]];
    }
    return _icon;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = HexRGB(0x999999, 1.0f);
        _addressLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _addressLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _titleLabel;
}

-(UIButton *)dismissBtn{
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _dismissBtn;
}

-(UIButton *)oneLevelBtn{
    if (!_oneLevelBtn) {
        _oneLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oneLevelBtn.hidden = YES;
        _oneLevelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _oneLevelBtn;
}

-(UIButton *)twoLevelBtn{
    if (!_twoLevelBtn) {
        _twoLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _twoLevelBtn.hidden = YES;
        _twoLevelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _twoLevelBtn;
}

-(UIButton *)threeLevelBtn{
    if (!_threeLevelBtn) {
        _threeLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _threeLevelBtn.hidden = YES;
        _threeLevelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _threeLevelBtn;
}

- (UIView *)spreadLine1{
    if (!_spreadLine1) {
        _spreadLine1 = [[UIView alloc] init];
    }
    return _spreadLine1;
}

- (UIView *)spreadLine2{
    if (!_spreadLine2) {
        _spreadLine2 = [[UIView alloc] init];
    }
    return _spreadLine2;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
    }
    return _bottomLine;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UITableView *)oneLevelTableView{
    if (!_oneLevelTableView) {
        _oneLevelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _oneLevelTableView.separatorColor = [UIColor clearColor];
        _oneLevelTableView.showsVerticalScrollIndicator = NO;
        _oneLevelTableView.delegate = self;
        _oneLevelTableView.dataSource = self;
    }
    return _oneLevelTableView;
}

- (UITableView *)twoLevelTableView{
    if (!_twoLevelTableView) {
        _twoLevelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _twoLevelTableView.separatorColor = [UIColor clearColor];
        _twoLevelTableView.showsVerticalScrollIndicator = NO;
        _twoLevelTableView.delegate = self;
        _twoLevelTableView.dataSource = self;
    }
    return _twoLevelTableView;
}

- (UITableView *)threeLevelTableView{
    if (!_threeLevelTableView) {
        _threeLevelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _threeLevelTableView.separatorColor = [UIColor clearColor];
        _threeLevelTableView.showsVerticalScrollIndicator = NO;
        _threeLevelTableView.delegate = self;
        _threeLevelTableView.dataSource = self;
    }
    return _threeLevelTableView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.6f;
    }
    return _backView;
}




- (void)show{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.showIt = YES;
    UIViewController *topVC = [self appRootViewController];
    self.sheetView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), kSheetWidth, kSheetHeight);
    self.backgroundView.frame = topVC.view.bounds;
    [topVC.view addSubview:self.backgroundView];
    [topVC.view addSubview:self.sheetView];
    [self.view setNeedsLayout];
    CGRect afterFrame = CGRectMake(0, (CGRectGetHeight(topVC.view.bounds)-kSheetHeight),kSheetWidth, kSheetHeight);
    [UIView animateWithDuration:0.2f animations:^{
        self.sheetView.frame = afterFrame;
    }];
}

- (void)dismiss{
    self.showIt = NO;
    [self.backgroundView removeFromSuperview];
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake(0,CGRectGetHeight(topVC.view.bounds), kSheetWidth, kSheetHeight);
    [UIView animateWithDuration:0.2F animations:^{
        self.sheetView.frame = afterFrame;
    }completion:^(BOOL finished) {
        [self.sheetView removeFromSuperview];
    }];
}


- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (UIView *)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc] init];
    }
    return _sheetView;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = HexRGB(0x0, 0.3);
        _backgroundView.userInteractionEnabled = YES;
        //UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
       // [_backgroundView addGestureRecognizer:gesture];
    }
    return _backgroundView;
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
    }
    return _locationManager;
}

- (AMapSearchAPI *)searchAPI{
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

@end


FOUNDATION_EXPORT NSString *GetAreaAddressWithVoModel(XKAddressVoModel *voModel){
    NSMutableString *string = [NSMutableString string];
    if (voModel.provinceId) {
        XKAddressInfoData *provinceData = [XKAddressInfoData searchSingleWithWhere:@{@"areaId":voModel.provinceId} orderBy:nil];
        if (![NSString isNull:provinceData.name]) {
            [string appendString:provinceData.name];
        }
    }
    if (voModel.cityId) {
        XKAddressInfoData *cityData = [XKAddressInfoData searchSingleWithWhere:@{@"areaId":voModel.cityId} orderBy:nil];
        if (![NSString isNull:cityData.name]) {
            [string appendString:@"-"];
            [string appendString:cityData.name];
        }
    }
    if (voModel.districtId) {
        XKAddressInfoData *districtData = [XKAddressInfoData searchSingleWithWhere:@{@"areaId":voModel.districtId} orderBy:nil];
        if (![NSString isNull:districtData.name]) {
            [string appendString:@"-"];
            [string appendString:districtData.name];
        }
    }
    return string;
}

FOUNDATION_EXPORT NSString *GetAreaAddress(NSNumber *provinceId,NSNumber *cityId,NSNumber *districtId){
    NSMutableString *string = [NSMutableString string];
    if (provinceId) {
        XKAddressInfoData *provinceData = [XKAddressInfoData searchSingleWithWhere:@{@"areaId":provinceId} orderBy:nil];
        if (![NSString isNull:provinceData.name]) {
            [string appendString:provinceData.name];
        }
    }
    if (cityId) {
        XKAddressInfoData *cityData = [XKAddressInfoData searchSingleWithWhere:@{@"areaId":cityId} orderBy:nil];
        if (![NSString isNull:cityData.name]) {
            [string appendString:cityData.name];
        }
    }
    if (districtId) {
        XKAddressInfoData *districtData = [XKAddressInfoData searchSingleWithWhere:@{@"areaId":districtId} orderBy:nil];
        if (![NSString isNull:districtData.name]) {
            [string appendString:districtData.name];
        }
    }
    return string;
}
