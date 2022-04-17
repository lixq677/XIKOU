//
//  CTSearchResultVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTSearchResultVC.h"

@interface CTSearchResultVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *searchDataSource;

@end

@implementation CTSearchResultVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdz"]];
    imageView.frame = CGRectMake(CGRectGetMidX(backgroundView.frame)-35.0f, 95.0f+[XKUIUnitls safeTop] + kNavBarHeight, 70.f, 55.0f);
    
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"没有找到相关作品";
    hintLabel.font = [UIFont systemFontOfSize:12.0f];
    hintLabel.textColor = HexRGB(0x999999, 1.0f);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [hintLabel sizeToFit];
    hintLabel.frame = CGRectMake(CGRectGetMidX(imageView.frame)-hintLabel.width*0.5f, imageView.bottom+8.0f, hintLabel.width, hintLabel.height);
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:hintLabel];
    
    self.tableView.backgroundView = backgroundView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray *)searchDataSource{
    if (_searchDataSource == nil) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.searchDataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"%@", [NSThread currentThread]);
    [self.searchDataSource removeAllObjects];
    if ([NSString isNull:searchController.searchBar.text]) {
        
    }else{
        
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", self.searchDataSource[indexPath.row]);
}

@end
