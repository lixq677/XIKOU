//
//  MIBanksVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIBanksVC.h"
#import "XKPropertyService.h"

@interface MIBankCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@end

@implementation MIBankCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.textLabel];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25.0f);
            make.centerY.equalTo(self.contentView);
            make.top.mas_equalTo(21.0f);
            make.left.mas_equalTo(15.0f);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.imageView);
            make.left.mas_equalTo(self.imageView.mas_right).offset(10.0f);
            make.height.mas_equalTo(16.0f);
        }];
    }
    return self;
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _textLabel;
}

@end

@interface MIBanksVC ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (strong, nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray<XKBankListData *> *banks;

@property (strong,nonatomic) NSMutableArray<XKBankListData *> *results;

@property (nonatomic, strong)UISearchController *searchController;

@property (nonatomic,weak)id<MIBankVCDelegate> delegate;

@end

@implementation MIBanksVC

- (instancetype)initWithDelegate:(id<MIBankVCDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.definesPresentationContext = YES;
    [self setupUI];
    NSArray<XKBankListData *> *array = [[XKFDataService() propertyService] queryBankListDataFromCache];
    if (array.count > 0) {
        [self.banks addObjectsFromArray:array];
    }
    [self quryBankListData];
}

- (void)quryBankListData{
    [[XKFDataService() propertyService] queryBankListDataWithCompletion:^(XKBankListResponse * _Nonnull response) {
        if (response.isSuccess) {
            [self.banks removeAllObjects];
            [self.banks addObjectsFromArray:response.data];
            [self.tableView reloadData];
        }
    }];
}

- (void)setupUI{
    self.title = @"选择银行";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [self.tableView registerClass:[MIBankCell class] forCellReuseIdentifier:@"MIBankCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return self.results.count;
    }else{
        return self.banks.count;
    }
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKBankListData *listData = nil;
     if (self.searchController.active) {
        listData = [self.results objectAtIndex:indexPath.row];
    }else{
        listData = [self.banks objectAtIndex:indexPath.row];
    }
    MIBankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBankCell" forIndexPath:indexPath];
    cell.textLabel.text = listData.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:listData.image] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKBankListData *listData = nil;
     if (self.searchController.active) {
        listData = [self.results objectAtIndex:indexPath.row];
    }else{
        listData = [self.banks objectAtIndex:indexPath.row];
    }
    [self.delegate bankVC:self selectBankListData:listData];
   // self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self searchText:searchController.searchBar.text];
}

- (void)searchText:(NSString *)searchText{
    //需要事先清空存放搜索结果的数组
    [self.results removeAllObjects];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
       dispatch_async(globalQueue, ^{
           if (searchText!=nil && searchText.length>0) {
               //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
               for (XKBankListData *data in self.banks) {
                   if ([data.name containsString:searchText]) {
                       [self.results addObject:data];
                   }else{
                       NSString *tempStr = data.name;
                       //----------->把所有的搜索结果转成成拼音
                       NSString *pinyin = [tempStr chineseCapitalizedString];
                       NSLog(@"pinyin--%@",pinyin);
                       if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                           //把搜索结果存放self.resultArray数组
                           [self.results addObject:data];
                       }
                   }
               }
           }else{
               self.results = [NSMutableArray arrayWithArray:self.banks];
           }
           //回到主线程
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.tableView reloadData];
           });
       });
}


#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.rowHeight      = 66;
        _tableView.sectionHeaderHeight = 10.0f;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 20);
        _tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (NSMutableArray<XKBankListData *> *)banks{
    if (!_banks) {
        _banks = [NSMutableArray array];
    }
    return _banks;
}

- (NSMutableArray<XKBankListData *> *)results{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.tintColor = HexRGB(0x444444, 1.0f);
        _searchController.searchBar.barTintColor = HexRGB(0xffffff, 1.0f);
        //_searchController.view.backgroundColor = HexRGB(0xffffff, 1.0f);
        _searchController.searchBar.placeholder = @"请输入银行名称";
        _searchController.searchResultsUpdater = self;
    }
    return _searchController;
}

@end
