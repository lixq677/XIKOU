//
//  XKBargainPersonVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/9.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKZeroBuyRecordVC.h"
#import "XKBargainPersonCell.h"
#import "XKActivityRulerModel.h"
#import "XKActivityService.h"

@interface XKZeroBuyRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation XKZeroBuyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)getData{
    [[XKFDataService() actService]getGoodAuctionListByActivityGoodId:self.activityGoodId Complete:^(ACTGoodAuctionRecondRespnse * _Nonnull response) {
        if ([response isSuccess]) {
            self.dataArray = response.data;
            self.title = [NSString stringWithFormat:@"出价记录 (%ld)",self.dataArray.count];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initialize{
    
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 0)];
    [path addLineToPoint:CGPointMake(kScreenWidth, 87+kTopHeight)];
    [path addLineToPoint:CGPointMake(0, 87+kTopHeight)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path fill];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = COLOR_TEXT_BLACK.CGColor;
    [self.view.layer addSublayer:layer];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(7+ kTopHeight);
    }];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    XKBargainPersonCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"XKBargainPersonCell"];
    if (!cell) {
        cell = [[XKBargainPersonCell alloc]initWithPersonCellStyle:BargainPersonCellImage reuseIdentifier:@"XKBargainPersonCell"];
    }
    if (indexPath.row == 0) {
        cell.textColor = COLOR_TEXT_BROWN;
        cell.imgView.image    = [UIImage imageNamed:@"phoneYellow"];
        cell.secondLabel.text = @"领先";
    }else{
        cell.textColor        = COLOR_TEXT_GRAY;
        cell.imgView.image    = [UIImage imageNamed:@"phoneBlack"];
        cell.secondLabel.text = @"出局";
    }
    ACTAuctionRecordModel *model = _dataArray[indexPath.row];
    cell.firstLabel.text = model.userName;
    cell.thirdLabel.text = model.area;
    cell.lastLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.auctionPrice doubleValue]/100];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    
    UIBezierPath *bezierPath;
    CGRect rect = CGRectMake(0, 0, cell.width, cell.height);
    if (indexPath.row == 0) {
        if (numberOfRows == 1) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(4, 4)];
        }else{
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
        }
        cell.separatorInset  = UIEdgeInsetsMake(0, 10, 0, 10);
    }else if (indexPath.row == numberOfRows - 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
        cell.separatorInset  = UIEdgeInsetsMake(0, kScreenWidth, 0, 10);
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
        cell.separatorInset  = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezierPath.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    cell.layer.mask = layer;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.separatorColor  = COLOR_LINE_GRAY;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight       = 55;
        _tableView.clipsToBounds   = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [XKUIUnitls safeBottom])];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
