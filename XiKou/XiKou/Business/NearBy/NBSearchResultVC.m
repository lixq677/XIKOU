//
//  NBSearchResultVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "NBSearchResultVC.h"
#import "XKShopService.h"
#import "MIAddressSelectVC.h"
#import "NBSearchShopsVC.h"
#import "CMSearchResultCell.h"

@interface NBSearchResultVC ()
<UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, strong,readonly) UITableView *tableView;

@property (nonatomic, strong,readonly) NSMutableArray<XKShopBriefData *> *shops;

@end

@implementation NBSearchResultVC
@synthesize shops = _shops;
@synthesize tableView = _tableView;

- (instancetype)initWithDelegate:(id<NBSearchResultDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdz"]];
    imageView.frame = CGRectMake(CGRectGetMidX(backgroundView.frame)-35.0f, 95.0f, 70.f, 55.0f);
    
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"没有找到相关店铺";
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
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.shops.count > 0) {
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    return self.shops.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMSearchResultCell" forIndexPath:indexPath];
    XKShopBriefData *briefData = [self.shops objectAtIndex:indexPath.row];
    cell.textLabel.text = briefData.shopName;
    cell.detailTextLabel.text = GetAreaAddress(nil, nil, briefData.area);
    return cell;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if (NO == [NSString isNull:searchController.searchBar.text]) {
       
        XKAddressVoModel *voModel = [XKAddressVoModel voModelFromCache];
        XKShopSearchParams *params = [[XKShopSearchParams alloc] init];
        params.limit = 10;
        params.page = 1;
        params.latitude = @(voModel.location.coordinate.latitude);
        params.longitude = @(voModel.location.coordinate.longitude);
        params.shopName = searchController.searchBar.text;
        [[XKFDataService() shopService] searchShopWithParams:params completion:^(XKShopBriefResponse * _Nonnull response) {
            if (response.isSuccess) {
                [self.shops removeAllObjects];
                [self.shops addObjectsFromArray:response.data];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKShopBriefData *briefData = [self.shops objectAtIndex:indexPath.row];
    [self searchShopName:briefData.shopName];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchShopName:searchBar.text];
}

- (void)searchShopName:(NSString *)name{
    if ([NSString isNull:name]) {
        return;
    }
    [[XKFDataService() shopService] saveKeyworkdToCache:name];
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
        _tableView.rowHeight = 50.0f;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<XKShopBriefData *> *)shops{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

@end
