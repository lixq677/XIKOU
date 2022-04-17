//
//  HMSearchResultVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMSearchResultVC.h"
#import "XKHomeService.h"
#import "CMSearchResultCell.h"

@interface HMSearchResultVC ()
<UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, strong,readonly) UITableView *tableView;

@property (nonatomic, strong,readonly) NSMutableArray<XKGoodsSearchData *> *goods;

@end

@implementation HMSearchResultVC
@synthesize goods = _goods;
@synthesize tableView = _tableView;

- (instancetype)initWithDelegate:(id<HMSearchResultDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.view addSubview:self.tableView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdz"]];
    imageView.frame = CGRectMake(CGRectGetMidX(backgroundView.frame)-35.0f, 95.0f, 70.f, 55.0f);
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"没有找到相关商品";
    hintLabel.font = [UIFont systemFontOfSize:12.0f];
    hintLabel.textColor = HexRGB(0x999999, 1.0f);
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [hintLabel sizeToFit];
    hintLabel.frame = CGRectMake(CGRectGetMidX(imageView.frame)-hintLabel.width*0.5f, imageView.bottom+8.0f, hintLabel.width, hintLabel.height);
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:hintLabel];
    
    self.tableView.backgroundView = backgroundView;
    [self.tableView registerClass:[CMSearchResultCell class] forCellReuseIdentifier:@"CMSearchResultCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.offsetY);
    }];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.goods.count > 0) {
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    return self.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMSearchResultCell" forIndexPath:indexPath];
    XKGoodsSearchData *goodsData = [self.goods objectAtIndex:indexPath.row];
    cell.textLabel.text = goodsData.commodityName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"销量:%lu件",(unsigned long)goodsData.salesVolume];
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if (NO == [NSString isNull:searchController.searchBar.text]) {
        XKGoodsSearchParams *params = [[XKGoodsSearchParams alloc] init];
        params.limit = 10;
        params.page = 1;
        params.commodityName = searchController.searchBar.text;
        [[XKFDataService() homeService] searchGoodsWithParams:params completion:^(XKGoodsSearchResponse * _Nonnull response) {
            if (response.isSuccess) {
                [self.goods removeAllObjects];
                [self.goods addObjectsFromArray:response.data];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKGoodsSearchData *briefData = [self.goods objectAtIndex:indexPath.row];
    [self searchGoodsName:briefData.commodityName];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchGoodsName:searchBar.text];
}

- (void)searchGoodsName:(NSString *)name{
    if ([NSString isNull:name]) {
        return;
    }
    [[XKFDataService() homeService] saveKeyworkdToCache:name];
    if ([self.delegate respondsToSelector:@selector(searchResult:searchText:)]) {
        [self.delegate searchResult:self searchText:name];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (void)panAction{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark getter
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

- (NSMutableArray<XKGoodsSearchData *> *)goods{
    if (_goods == nil) {
        _goods = [NSMutableArray array];
    }
    return _goods;
}


@end
