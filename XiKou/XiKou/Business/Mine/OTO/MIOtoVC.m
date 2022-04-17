//
//  MIOtoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIOtoVC.h"
#import "MIAddressSelectVC.h"
#import "MJDIYFooter.h"
#import "XKDataService.h"
#import "XKOrderService.h"
#import "XKAccountManager.h"

static const int kPageCount =   20;

@interface MIOtoCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIImageView *accessoryImgView;

@property (nonatomic,strong)UILabel *statusLabel;

@property (nonatomic,strong)UIView *line1;

@property (nonatomic,strong)UIView *line2;

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *text1Label;
@property (nonatomic,strong)UILabel *text2Label;
@property (nonatomic,strong)UILabel *text3Label;

@property (nonatomic,strong)UILabel *detailLabel;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation MIOtoCell
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.layer.cornerRadius = 5.0f;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.accessoryImgView];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.text1Label];
    [self.contentView addSubview:self.text2Label];
    [self.contentView addSubview:self.text3Label];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
}

- (void)layout{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.right.equalTo(self).offset(-15.0f);
        make.top.equalTo(self).offset(10.0f);
        make.bottom.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0f);
        make.top.equalTo(self.contentView).offset(18.0f);
    }];
    
    [self.accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(8.0f);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).mas_equalTo(-15.0f);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.statusLabel);
        make.height.mas_equalTo(0.5f);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(16.0f);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15.0f);
        make.width.height.mas_equalTo(60.0f);
    }];
    
    [self.text1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(15.0f);
        make.top.equalTo(self.imageView).offset(4.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.text2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text1Label);
        make.top.mas_equalTo(self.text1Label.mas_bottom).offset(9.0f);
        make.height.mas_equalTo(12.0f);
    }];
    [self.text3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.text2Label);
        make.top.mas_equalTo(self.text2Label.mas_bottom).offset(9.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.line1);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(15.0f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(15.0f);
        make.bottom.equalTo(self.contentView).offset(-15.0f);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.centerY.equalTo(self.detailLabel);
    }];
    
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HexRGB(0x999999, 1.0f);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HexRGB(0x444444, 1.0f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    }
    return _titleLabel;
}
- (UILabel *)text1Label{
    if (!_text1Label) {
        _text1Label = [[UILabel alloc] init];
        _text1Label.textColor = HexRGB(0x444444, 1.0f);
        _text1Label.textAlignment = NSTextAlignmentLeft;
        _text1Label.font = [UIFont systemFontOfSize:12.0f];
    }
    return _text1Label;
}

- (UILabel *)text2Label{
    if (!_text2Label) {
        _text2Label = [[UILabel alloc] init];
        _text2Label.textColor = HexRGB(0x444444, 1.0f);
        _text2Label.textAlignment = NSTextAlignmentLeft;
        _text2Label.font = [UIFont systemFontOfSize:12.0f];
    }
    return _text2Label;
}

- (UILabel *)text3Label{
    if (!_text3Label) {
        _text3Label = [[UILabel alloc] init];
        _text3Label.textColor = HexRGB(0x444444, 1.0f);
        _text3Label.textAlignment = NSTextAlignmentLeft;
        _text3Label.font = [UIFont systemFontOfSize:12.0f];
    }
    return _text3Label;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _detailLabel;
}

- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HexRGB(0x999999, 1.0f);
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _statusLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius  = 30.f;
    }
    return _imageView;
}

- (UIImageView *)accessoryImgView{
    if (!_accessoryImgView) {
        _accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    }
    return _accessoryImgView;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    }
    return _line2;
}

@end

@interface MIOtoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong,readonly)NSMutableArray<XKOTOData *> *orders;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation MIOtoVC
@synthesize tableView = _tableView;
@synthesize orders = _orders;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self autoLayout];
    [self loadNewData];
}

- (void)setupUI{
    self.title = @"O2O联盟";
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.tableView.rowHeight = 190.0f;
    self.tableView.backgroundColor = COLOR_VIEW_GRAY;
    [self.tableView registerClass:[MIOtoCell class] forCellReuseIdentifier:@"MIOtoCell"];
    [self.view addSubview:self.tableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wuyouhuiquan"]];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"还没有订单记录哦";
    label.textColor = HexRGB(0x999999, 1.0f);
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:label];
    imageView.centerX = kScreenWidth/2.0f;
    imageView.top = 75.0f;
    
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = imageView.bottom+10.0f;
    
    self.tableView.backgroundView = backgroundView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.orders.count < kPageCount) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    if(self.orders.count > 0){
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    return self.orders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIOtoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIOtoCell" forIndexPath:indexPath];
    XKOTOData *data = [self.orders objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = data.shopName;
    if (data.state == XKOTOStateNoPay) {
        cell.statusLabel.text = @"待支付";
        cell.statusLabel.textColor = COLOR_TEXT_BROWN;
    }else if(data.state == XKOTOStateFinshed){
        cell.statusLabel.text = @"已完成";
        cell.statusLabel.textColor = HexRGB(0x999999, 1.0f);
    }else{
        cell.statusLabel.text = nil;
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
    cell.text1Label.text = [NSString stringWithFormat:@"消费金额: ¥%.2f",data.totalAmount/100.00f];
    cell.text2Label.text = [NSString stringWithFormat:@"优惠券支付: ¥%.2f",data.offerAmount/100.00f];
    cell.text3Label.text = [NSString stringWithFormat:@"实付金额: ¥%.2f",data.payAmount/100.00f];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@  %@",data.areaName ? :@"",data.industryName?:@""];
    cell.timeLabel.text = data.payTime;
    return cell;
}

//下拉刷新数据
- (void)loadNewData{
    [self loadDataIsUpdate:YES];
}

//上拉加载更多数据
- (void)loadMoreData{
    [self loadDataIsUpdate:NO];
}

//请求网络数据
- (void)loadDataIsUpdate:(BOOL)update {
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    if ([NSString isNull:userId]) return;
    
    @weakify(self);
    XKOTOParams *params = [[XKOTOParams alloc] init];
    params.buyerAccount = [[XKAccountManager defaultManager] mobile];
    params.limit= @(kPageCount);
    if (update) {
        params.page = @1;
    }else{
        params.page = @(self.curPage+1);
    }
    [[XKFDataService() orderService] queryOTOWithParams:params completion:^(XKOTOResponse * _Nonnull response) {
        @strongify(self);
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if (response.isSuccess) {
            if ([response isSuccess]) {
                //刷新数据时，需要清理旧的数据
                if (update) {
                    [self.orders removeAllObjects];
                }
                self.curPage = params.page.intValue;
                [self.orders addObjectsFromArray:response.data];
                [self.tableView reloadData];
                if (response.data.count < kPageCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                if(!update){
                    [self.tableView.mj_footer endRefreshing];
                }
                [response showError];
            }
        }
    }];
}


#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<XKOTOData *> *)orders{
    if (!_orders) {
        _orders = [NSMutableArray array];
    }
    return _orders;
}

@end
