//
//  MIPreferenceDetailVC.m
//  XiKou
//
//  Created by Tony on 2019/6/14.
//  Copyright © 2019年 李笑清. All rights reserved.
//

#import "MIPreferenceDetailVC.h"
#import "XKDataService.h"
#import "XKPropertyService.h"


@interface MIPreferenceDetailCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *priceLabel;


@end

@implementation MIPreferenceDetailCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize timeLabel = _timeLabel;
@synthesize priceLabel = _priceLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.detailTextLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.imageView];
        [self layout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.top.mas_equalTo(18.0f);
        make.height.width.mas_equalTo(30.0f);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.left.mas_equalTo(self.imageView.mas_right).offset(15.0f);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-20.0f);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(5.0f);
        make.left.equalTo(self.textLabel);
        make.height.mas_equalTo(12.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailTextLabel.mas_bottom).offset(11.0f);
        make.left.equalTo(self.detailTextLabel);
        make.height.mas_equalTo(12.0f);
        make.bottom.mas_equalTo(-24.0f);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.0f);
        make.width.mas_lessThanOrEqualTo(100);
        make.right.equalTo(self.contentView).offset(-20.0f);
        make.height.mas_equalTo(17.0f);
    }];
    [self.textLabel setContentCompressionResistancePriority:(UILayoutPriorityDefaultLow) forAxis:(UILayoutConstraintAxisHorizontal)];
    [self.priceLabel setContentCompressionResistancePriority:(UILayoutPriorityDefaultHigh) forAxis:(UILayoutConstraintAxisHorizontal)];
}


#pragma mark getter or setter

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailTextLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
    return _detailTextLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
        _timeLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
    return _timeLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HexRGB(0xf94119, 1.0f);
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    return _priceLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 15.0f;
    }
    return _imageView;
}


@end



@interface MIPreferenceDetailVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *headerView;

@property (nonatomic,strong,readonly)UIImageView *backgroud;

@property (nonatomic,strong,readonly)UIImageView *icon;

@property (nonatomic,strong,readonly)UILabel *pricelabel;//价钱

@property (nonatomic,strong,readonly)UILabel *validitylabel;//有效期

@property (nonatomic,strong,readonly)UILabel *sectionTitleLabel;

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)XKPreferenceData *preferenceData;

@property (nonatomic,strong,readonly)XKPreferenceDetailData *preferenceDetailData;

@end

@implementation MIPreferenceDetailVC
@synthesize backgroud = _backgroud;
@synthesize icon = _icon;
@synthesize pricelabel = _pricelabel;
@synthesize validitylabel = _validitylabel;
@synthesize sectionTitleLabel = _sectionTitleLabel;
@synthesize tableView = _tableView;

- (instancetype)initWithPreferenceData:(XKPreferenceData *)preferenceData{
    if (self = [super init]) {
        _preferenceData = preferenceData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券明细";
    [self setupUI];
    [self autoLayout];
    [self.tableView layoutIfNeeded];
    [self initDataFromCache];
    [self initDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.headerView addSubview:self.backgroud];
    [self.headerView addSubview:self.icon];
    [self.headerView addSubview:self.pricelabel];
    [self.headerView addSubview:self.validitylabel];
    [self.headerView addSubview:self.sectionTitleLabel];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    
    UIView *(^createViewBlock)(void) = ^UIView *{
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_no_preference"]];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"此优惠券暂时还没有明细记录哦!";
        label.textColor = HexRGB(0x999999, 1.0f);
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentCenter;
        
        [backgroundView addSubview:imageView];
        [backgroundView addSubview:label];
        imageView.centerX = kScreenWidth/2.0f;
        imageView.top = 210.0f;
        
        [label sizeToFit];
        label.centerX = imageView.centerX;
        label.top = imageView.bottom+10.0f;
        return backgroundView;
    };
    self.tableView.backgroundView = createViewBlock();
    self.tableView.tableFooterView = [UIView new];
    
    
    [self.tableView registerClass:[MIPreferenceDetailCell class] forCellReuseIdentifier:@"MIPreferenceDetailCell"];
    UIColor *color1 = HexRGB(0xffffff, 1.0f);
    UIColor *color2 = HexRGB(0x999999, 1.0f);
    //价钱
    NSString *price = [NSString stringWithFormat:@"%.2f/优惠券%.2f",self.preferenceData.balance.doubleValue/100.00f,self.preferenceData.total.doubleValue/100.00f];
    NSMutableAttributedString *attributedString = [self getPriceAttribute:price];
    if (self.preferenceData.state == XKPreferenceStateUnused) {
        self.backgroud.image = [UIImage imageNamed:@"preference_bg"];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:color1} range:NSMakeRange(0, attributedString.length)];
        self.validitylabel.textColor = color1;
        self.icon.image = [UIImage imageNamed:@"preference"];
    }else if (self.preferenceData.state == XKPreferenceStateUsed){
        self.backgroud.image = [UIImage imageNamed:@"preference_bg_unvalid"];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:color2} range:NSMakeRange(0, attributedString.length)];
        self.validitylabel.textColor = color2;
        self.icon.image = [UIImage imageNamed:@"preference_unvalid"];
    }else{
        self.backgroud.image = [UIImage imageNamed:@"preference_bg_unvalid"];
        [attributedString addAttributes:@{NSForegroundColorAttributeName:color2} range:NSMakeRange(0, attributedString.length)];
        self.validitylabel.textColor = color2;
        self.icon.image = [UIImage imageNamed:@"preference_unvalid"];
    }
    self.pricelabel.attributedText = attributedString;
    //有效期
    NSString *startTime = [self changeDateFormatter:[self.preferenceData.startTime substringToIndex:10]];
    NSString *endTime = [self changeDateFormatter:[self.preferenceData.endTime substringToIndex:10]];
    self.validitylabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)autoLayout {
    [self.backgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.0f);
        make.right.mas_equalTo(-20.0f);
        make.left.mas_equalTo(20.0f);
        make.bottom.mas_equalTo(-56.0f);
        make.height.mas_equalTo(70.0f);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backgroud);
        make.left.equalTo(self.backgroud).offset(20.0f);
        make.width.height.mas_equalTo(40.0f);
    }];
    [self.pricelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroud.mas_left).offset(70.0f);
        make.top.mas_equalTo(self.backgroud.mas_top).offset(18.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.validitylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pricelabel);
        make.top.equalTo(self.pricelabel.mas_bottom).offset(8.f);
        make.height.mas_equalTo(10.0f);
    }];
    
    [self.sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroud);
        make.top.mas_equalTo(self.backgroud.mas_bottom).offset(24.0f);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(135.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initDataFromCache{
    _preferenceDetailData = [[XKFDataService() propertyService] queryPreferenceDetailDataFromCacheWithId:self.preferenceData.id];
}

- (void)initDataFromServer{
    [self queryPreferenceDetailDataWithId:self.preferenceData.id];
}


- (void)loadData{
    @weakify(self);
    [[XKFDataService() propertyService] getPreferenceRecordWithId:self.preferenceData.id completion:^(XKPreferenceDetailResponse * _Nonnull response) {
         @strongify(self);
        [self.tableView.mj_header endRefreshing];
        if ([response isSuccess]) {
            self->_preferenceDetailData = response.data;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)queryPreferenceDetailDataWithId:(NSString *)id{
    @weakify(self);
    [XKLoading show];
    [[XKFDataService() propertyService] getPreferenceRecordWithId:id completion:^(XKPreferenceDetailResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {
            @strongify(self);
            self->_preferenceDetailData = response.data;
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}



#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.preferenceDetailData.recordModelList.count > 0){
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    return self.preferenceDetailData.recordModelList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIPreferenceDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIPreferenceDetailCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"ic_price_mx"];
    XKPreferenceDetailRecordModel  *recordModel = [self.preferenceDetailData.recordModelList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"订单号 %@",recordModel.primaryKey];
    cell.detailTextLabel.text = [recordModel moduleIdFromString];
    cell.timeLabel.text = recordModel.createTime;
    if (recordModel.operateType == XKPreferenceOperateTypeGet) {
        cell.priceLabel.text = [NSString stringWithFormat:@"+%.2f",recordModel.cost.doubleValue/100.00f];
        cell.priceLabel.textColor = HexRGB(0xf94119, 1.0f);
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"-%.2f",recordModel.cost.doubleValue/100.00f];
        cell.priceLabel.textColor = HexRGB(0xf94119, 1.0f);//HexRGB(0x444444, 1.0f);
    }
    return cell;
}

#pragma mark private
//富文本
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [string rangeOfString:@"/"];
    
    if (IS_IPHONE_MIN) {
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, range.location)];
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8.0f] range:NSMakeRange(range.location,string.length-range.location)];
    }else{
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0, range.location)];
        [attribut addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(range.location,string.length-range.location)];
    }
    
    
    return attribut;
}
//转换日期格式
- (NSString *)changeDateFormatter :(NSString *)stringDate {
    // 实例化NSDateFormatter
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    // 设置日期格式
    [formatter1 setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd HH:mm:ss
    // NSDate形式的日期
    NSDate *date =[formatter1 dateFromString:stringDate];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString2 = [formatter2 stringFromDate:date];
    NSLog(@"%@",dateString2);
    return dateString2;
}



#pragma mark getter 方法
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 150.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.separatorColor  = COLOR_LINE_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (UIImageView *)backgroud{
    if (!_backgroud) {
        _backgroud = [[UIImageView alloc] init];
    }
    return _backgroud;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)pricelabel{
    if (!_pricelabel) {
        _pricelabel = [[UILabel alloc] init];
        _pricelabel.font = [UIFont systemFontOfSize:10.0f];
        _pricelabel.textColor = COLOR_TEXT_BROWN;
    }
    return _pricelabel;
}

- (UILabel *)validitylabel{
    if (!_validitylabel) {
        _validitylabel = [[UILabel alloc] init];
        _validitylabel.font = [UIFont systemFontOfSize:13.0f];
        _validitylabel.textColor = COLOR_TEXT_BROWN;
    }
    return _validitylabel;
}

- (UILabel *)sectionTitleLabel{
    if (!_sectionTitleLabel) {
        _sectionTitleLabel = [[UILabel alloc] init];
        _sectionTitleLabel.font = [UIFont systemFontOfSize:16.0f];
        _sectionTitleLabel.textColor = HexRGB(0x444444, 1.0f);
        _sectionTitleLabel.text = @"使用记录";
    }
    return _sectionTitleLabel;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _headerView;
}

@end
