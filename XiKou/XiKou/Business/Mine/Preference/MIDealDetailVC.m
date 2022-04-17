//
//  MIDealDetailVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/7.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIDealDetailVC.h"
#import "MIRedCells.h"
#import "MICashoutDetailInfoVC.h"
#import "UIButton+Position.h"
#import "XKItemsPopView.h"
#import "XKRowPopView.h"
#import "XKDatePickerView.h"

@interface MIDealDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) UIButton *timeBtn;

@property (nonatomic,strong,readonly) UIButton *businessBtn;

@property (nonatomic,strong,readonly) UIButton *balanceBtn;

@end

@implementation MIDealDetailVC
{
    NSInteger _selectIndex1;
    NSInteger _selectIndex2;
    NSInteger _selectIndex3;
}
@synthesize tableView = _tableView;
@synthesize timeBtn = _timeBtn;
@synthesize balanceBtn = _balanceBtn;
@synthesize businessBtn = _businessBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易明细";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10.0f)];
    
    [self.view addSubview:self.timeBtn];
    [self.view addSubview:self.balanceBtn];
    [self.view addSubview:self.businessBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[MIRedCell class] forCellReuseIdentifier:@"MIRedCell"];
    [self.tableView registerClass:[MIRedRecordHeaderView class] forHeaderFooterViewReuseIdentifier:@"MIRedRecordHeaderView"];
   
    [self layout];
    
}

- (void)layout{
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20.0f);
        make.height.mas_equalTo(45.0f);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(100.0f);
    }];
    
    [self.balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(45.0f);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(100.0f);
    }];
    
    [self.businessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(45.0f);
        make.top.equalTo(self.view);
        make.width.mas_equalTo(100.0f);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.timeBtn.mas_bottom);
    }];
}
#pragma mark action
- (void)sortAction:(UIButton *)sender{
    if (sender == self.timeBtn) {
        XKDatePickerView *popView = [[XKDatePickerView alloc]init];
        [popView showWithTitle:@"选择月份" andSelectDate:[NSDate date] andComplete:^(NSDate * _Nonnull date) {
            
        }];
    }
    if (sender == self.balanceBtn) {
        XKRowPopView *popView = [[XKRowPopView alloc]init];
        NSArray *array = @[@"收入明细",@"支出明细"];
        [popView showWithTitle:@"请选择" andItems:array andSelectIndex:_selectIndex2 andComplete:^(NSInteger index) {
            self->_selectIndex2 = index;
        }];
    }
    if (sender == self.businessBtn) {
        XKItemsPopView *popView = [[XKItemsPopView alloc]init];
        NSArray *array = @[@"吾G限时购",@"全球买手",@"多买多折",@"0元抢",@"砍立得",@"定制拼团",@"O2O线下"];
        [popView showWithTitle:@"业务类型" andItems:array andSelectIndex:_selectIndex3 andComplete:^(NSInteger index) {
            self->_selectIndex3 = index;
        }];
    }
}
#pragma mark UITableView delegate && dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MIRedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIRedCell" forIndexPath:indexPath];
    if (indexPath.row %2) {
        cell.imageView.image = [UIImage imageNamed:@"yinhangka_online"];
        cell.textLabel.text = @"商城订单";
        cell.detailTextLabel.text = @"多买多折";
        cell.timeLabel.text = @"06-18 15:30";
        cell.amountLabel.text = @"-85.00";
        cell.amountLabel.textColor = HexRGB(0x444444, 1.0f);
    }else{
        cell.imageView.image = [UIImage imageNamed:@"yinhangka_offline"];
        cell.textLabel.text = @"线下订单";
        cell.detailTextLabel.text = @"O2O买单";
        cell.timeLabel.text = @"06-18 15:30";
        cell.amountLabel.text = @"-185.00";
        cell.amountLabel.textColor = HexRGB(0xf94119, 1.0f);
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MIRedRecordHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MIRedRecordHeaderView"];
    headerView.textLabel.text = @"本月";
    headerView.detailTextLabel.text = @"已提现¥230.00  提现中 ¥230.00";
    headerView.contentView.backgroundColor = HexRGB(0xffffff, 1.0f);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 120.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_timeBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_timeBtn setTitle:@"选择月份" forState:UIControlStateNormal];
        [_timeBtn XK_imagePositionStyle:XKImagePositionStyleRight spacing:5];
        [_timeBtn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}

- (UIButton *)balanceBtn{
    if (!_balanceBtn) {
        _balanceBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _balanceBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_balanceBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_balanceBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_balanceBtn setTitle:@"收支类型" forState:UIControlStateNormal];
        [_balanceBtn XK_imagePositionStyle:XKImagePositionStyleRight spacing:5];
        [_balanceBtn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _balanceBtn;
}

- (UIButton *)businessBtn{
    if (!_businessBtn) {
        _businessBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        _businessBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_businessBtn setTitleColor:HexRGB(0x444444, 1.0f) forState:UIControlStateNormal];
        [_businessBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_businessBtn setTitle:@"业务类型" forState:UIControlStateNormal];
        [_businessBtn XK_imagePositionStyle:XKImagePositionStyleRight spacing:5];
        [_businessBtn addTarget:self action:@selector(sortAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _businessBtn;
}


@end

