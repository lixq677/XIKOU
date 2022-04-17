//
//  HMXkProfitVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMXkProfitVC.h"
#import "XKUIUnitls.h"

@interface HMXkCell : UITableViewCell

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIImageView *imageView;

@end


@implementation HMXkCell
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.imageView];
}


- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.width.height.mas_equalTo(35.0f);
        make.top.mas_equalTo(18.0f);
        make.centerY.equalTo(self.contentView);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
        make.top.equalTo(self.imageView);
        make.height.mas_equalTo(14.0f);
    }];
    
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.mas_equalTo(self.textLabel.mas_bottom).offset(8.0f);
        make.height.mas_equalTo(12.0f);
    }];
}

#pragma mark getter
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

- (UILabel *)detailTextLabel{
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] init];
        _detailTextLabel.textColor = HexRGB(0x999999, 1.0f);
        _detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        
    }
    return _detailTextLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end



@interface HMXkProfitVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly)UITableView *tableView;

@end

@implementation HMXkProfitVC
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"喜扣赚";
    [self setupUI];
    [self autoLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark UI
- (void)setupUI{
    self.tableView.rowHeight = 70.0f;
    self.tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
    [self.tableView registerClass:[HMXkCell class] forCellReuseIdentifier:@"HMXkCell"];
    [self.view addSubview:self.tableView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xkp_banner"]];
    imageView.frame = CGRectMake(15.0f, 10.0f, kScreenWidth-30.0f, 120.0f/345.0f*(kScreenWidth-30.0f));
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(imageView.frame)+15.0f)];
    [headerView addSubview:imageView];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMXkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMXkCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"xkp_wg"];
        cell.textLabel.text = @"吾G限量购";
        cell.detailTextLabel.text = @"买货的券 卖货赚钱";
    }else if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"xkp_zhe"];
        cell.textLabel.text = @"多买多折";
        cell.detailTextLabel.text = @"最低折扣 折上折技巧";
    }else if(indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"xkp_0yuanbuy"];
        cell.textLabel.text = @"0元抢";
        cell.detailTextLabel.text = @"巧拍超值物品";
    }else{
        cell.imageView.image = [UIImage imageNamed:@"xkp_groball"];
        cell.textLabel.text = @"全球买手购";
        cell.detailTextLabel.text = @"折扣最多 券抵现金";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [MGJRouter openURL:kRouterWg];
    }else if (indexPath.row == 1){
        [MGJRouter openURL:kRouterMutilBuy];
    }else if (indexPath.row == 2){
        [MGJRouter openURL:kRouterZeroBuy];
    }else if (indexPath.row == 3){
        [MGJRouter openURL:kRouterGlobalBuy];
    }else{
        NSLog(@"其它事项");
    }
}


#pragma mark action

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}


@end
