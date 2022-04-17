//
//  MITaskVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/21.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MITaskVC.h"
#import "XKUIUnitls.h"
#import "MIBasicCell.h"
#import "XKOtherService.h"
#import "XKAccountManager.h"

@interface MITaskVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong,readonly)UITableView *tableView;

@property (nonatomic,strong) XKTaskData *taskData;

@property (nonatomic,strong) UILabel *myTaskLabel;

@property (nonatomic,strong) UILabel *maxTaskValueLabel;

@property (nonatomic,strong) UILabel *taskValueLabel;

@end

@implementation MITaskVC
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务中心";
    self.tableView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    self.view.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    self.navigationBarStyle = XKNavigationBarStyleDefault;
    [self setupUI];
    [self autoLayout];
    if ([[XKAccountManager defaultManager] isLogin]) {
         [self queryTasksFromServer];
    }
}


#pragma mark UI
- (void)setupUI{
    [self.tableView registerClass:[MITaskCell class] forCellReuseIdentifier:@"MITaskCell"];
    [self.view addSubview:self.tableView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"task_bitmap"]];
    imageView.frame = CGRectMake(0.0f, 10.0f, kScreenWidth-20.0f, 120.0f/345.0f*(kScreenWidth-30.0f));
    
    UILabel *myTaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 32.0f, 160.0f, 19.0f)];
    myTaskLabel.textColor = HexRGB(0xffffff, 1.0f);
    myTaskLabel.font = FontMedium(19.f);
    myTaskLabel.text = @"我的任务值";
    self.myTaskLabel = myTaskLabel;
    
    UILabel *hintTaskLabel = [[UILabel alloc] initWithFrame:CGRectMake(myTaskLabel.left, myTaskLabel.bottom+9.0f, 153.0f, 35.0f)];
    hintTaskLabel.textColor = HexRGB(0xffffff, 1.0f);
    hintTaskLabel.font = FontMedium(12.f);
    hintTaskLabel.text = @"任务值越高，获得寄卖权 \n优先排序得几率越大。";
    hintTaskLabel.numberOfLines = 0;
    
    [imageView addSubview:myTaskLabel];
    [imageView addSubview:hintTaskLabel];
    
    UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.left, imageView.bottom+25.0f, 80.0f, 17.0f)];
    taskLabel.textColor = HexRGB(0x444444, 1.0f);
    taskLabel.font = FontMedium(16.f);
    taskLabel.text = @"提升任务值";
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskLabel.right+10, taskLabel.top, 66.0f, 17.0f)];
    countLabel.textColor = HexRGB(0x999999, 1.0f);
    countLabel.font = Font(14.f);
    countLabel.textAlignment = NSTextAlignmentLeft;
    self.taskValueLabel = countLabel;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(countLabel.frame)+10.0f)];
    [headerView addSubview:imageView];
    [headerView addSubview:taskLabel];
    [headerView addSubview:countLabel];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40.0f)];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40.0f, 1/[UIScreen mainScreen].scale)];
    line.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
    [footerView addSubview:line];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20.0f, kScreenWidth, 12.0f)];
    footerLabel.font = [UIFont systemFontOfSize:12.0f];
    footerLabel.textColor = HexRGB(0xcccccc, 1.0f);
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLabel];
    self.maxTaskValueLabel = footerLabel;
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    
}

- (void)setupWithTaskData:(XKTaskData *)taskData{
    self.myTaskLabel.text = [NSString stringWithFormat:@"我的任务值  %d",taskData.taskValue];
    self.taskValueLabel.text = [NSString stringWithFormat:@"(%d/%d)",taskData.todayTotalValue,taskData.maxLimitValue];
    self.maxTaskValueLabel.text = [NSString stringWithFormat:@"每日最高获得%d个任务值",taskData.maxLimitValue];
    [self.tableView reloadData];
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.left.mas_equalTo(10.0f);
        make.right.mas_equalTo(-10.0f);
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskData.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MITaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MITaskCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XKTaskModel *taskModel = [[self.taskData list] objectAtIndex:indexPath.row];
    cell.textLabel.text = taskModel.taskExplain;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *tvATS = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%d",taskModel.award] attributes:@{NSForegroundColorAttributeName:COLOR_TEXT_BROWN,NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    NSAttributedString *thATS = [[NSAttributedString alloc] initWithString:@"任务值" attributes:@{NSForegroundColorAttributeName:HexRGB(0xcccccc, 1.0f),NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    [attributedString appendAttributedString:tvATS];
    [attributedString appendAttributedString:thATS];
    cell.detailTextLabel.attributedText = attributedString;
    
    if (taskModel.maxTimes <= 0) {
        cell.taskValueLabel.hidden = YES;
    }else{
        cell.taskValueLabel.hidden = NO;
        cell.taskValueLabel.text = [NSString stringWithFormat:@"%d/%d",taskModel.curTimes,taskModel.maxTimes];
    }
    
    if (taskModel.completeStatus == XKTaskStatuCompleted) {
        [cell.finishBtn setEnabled:NO];
    }else{
        [cell.finishBtn setEnabled:YES];
    }
    cell.finishBlock = ^{
        XKTaskModel *taskModel = [[self.taskData list] objectAtIndex:indexPath.row];
        if([XKGlobalModuleRouter isValidScheme:taskModel.url]){
            [MGJRouter openURL:taskModel.url];
        }else{
            [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":taskModel.url} completion:nil];
        }
    };
    
    UIImage *image = nil;
    switch (taskModel.type) {
        case XKTaskTypeShare:{
            image = [UIImage imageNamed:@"task_share"];
        }
            break;
        case XKTaskTypeInviteRegister:{
            image = [UIImage imageNamed:@"task_register"];
        }
            break;
        case XKTaskTypeConsume:{
            image = [UIImage imageNamed:@"task_pay"];
        }
            break;
        case XKTaskTypeActivity:{
            image = [UIImage imageNamed:@"task_comment"];
        }
            break;
        case XKTaskTypeCertification:{
            image = [UIImage imageNamed:@"task_verify"];
        }
            break;
        default:
            image = [UIImage imageNamed:@"task_comment"];
            break;
    }
    cell.imageView.image = image;
    if(indexPath.row == [self.taskData.list count]-1){
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, -kScreenWidth);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    UIBezierPath *bezierPath;
    CGRect rect = CGRectMake(0, 0, cell.width, cell.height);
    if (indexPath.row == 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(7.0f, 7.0f)];
    }else if (indexPath.row == numberOfRows - 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(7.0f, 7.0f)];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    cell.layer.mask = layer;
    cell.backgroundColor = HexRGB(0xffffff, 1.0f);
}


- (void)queryTasksFromServer{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    @weakify(self);
    [[XKFDataService() otherService] queryTasksWithUserId:userId completion:^(XKTaskResponse * _Nonnull response) {
        if (response.isSuccess) {
            @strongify(self);
            self->_taskData = response.data;
            [self setupWithTaskData:response.data];
        }else{
            [response showError];
        }
    }];
}

#pragma mark action

#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = HexRGB(0xececec, 1.0f);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.rowHeight = 70.0f;
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}


@end
