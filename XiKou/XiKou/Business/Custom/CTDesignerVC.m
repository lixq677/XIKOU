//
//  CTDesignerVC.m
//  XiKou
//
//  Created by 李笑清 on 2019/6/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CTDesignerVC.h"
#import "XKUIUnitls.h"
#import "CTDesignerModel.h"
#import "CTBaseCell.h"
#import "CTDesignerHomeVC.h"
#import "XKDataService.h"
#import <SDWebImage.h>
#import "MJDIYFooter.h"
#import "XKDesignerService.h"

@interface CTDesignerVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray<XKDesignerBriefData *> *designers;

@property (nonatomic,assign)NSUInteger curPage;

@end

@implementation CTDesignerVC
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设计师圈";
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    [self setupUI];
    [self autoLayout];
    [self initDataFromCache];
    [self initDataWithServer];
}


- (void)setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PIC"]];
    self.tableView.tableHeaderView = imageView;
    [self.tableView registerClass:[CTDesignerCellStyle1Cell class] forCellReuseIdentifier:@"CTDesignerCellStyle1Cell"];
    [self.tableView registerClass:[CTDesignerCellStyle2Cell class] forCellReuseIdentifier:@"CTDesignerCellStyle2Cell"];
    [self.tableView registerClass:[CTDesignerCellStyle3Cell class] forCellReuseIdentifier:@"CTDesignerCellStyle3Cell"];
    
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJDIYFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)autoLayout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)initDataFromCache{
    NSArray<XKDesignerBriefData *> *designers = [[XKFDataService() designerService] queryLastestDesignerFromCache];
    [self.designers removeAllObjects];
    [self.designers addObjectsFromArray:designers];
}

- (void)initDataWithServer{
    [XKLoading show];
    @weakify(self);
    [[XKFDataService() designerService] queryDesignersWithPage:0 limit:10 completion:^(XKDesignerBriefResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if ([response isSuccess]) {
            [self.designers removeAllObjects];
            [self.designers addObjectsFromArray:response.data];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

- (void)loadNewData{
   [self loadDataForUpdate:YES];
}


- (void)loadMoreData{
    [self loadDataForUpdate:NO];
}

- (void)loadDataForUpdate:(BOOL)update{
    NSUInteger page = 0;
    if (!update) {
        page = self.curPage + 1;
    }
    @weakify(self);
    [[XKFDataService() designerService] queryDesignersWithPage:page limit:10 completion:^(XKDesignerBriefResponse * _Nonnull response) {
        @strongify(self);
        if (update) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([response isSuccess]) {
            NSArray *result = response.data;
            //刷新数据时，需要清理旧的数据
            if(result.count > 0) {
                if (update) {
                    [self.designers removeAllObjects];
                }
                self.curPage = page;
                [self.designers addObjectsFromArray:response.data];
                [self.tableView reloadData];
            }
            if (result.count < K_REQUEST_PAGE_COUNT ) {
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
    }];
}



#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.designers.count < K_REQUEST_PAGE_COUNT ) {
        tableView.mj_footer.hidden = YES;
    }else{
        tableView.mj_footer.hidden = NO;
    }
    return self.designers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier  = nil;
    if (indexPath.row % 4 == 1){
        identifier = @"CTDesignerCellStyle2Cell";
    }else if (indexPath.row %4 == 3){
        identifier = @"CTDesignerCellStyle3Cell";
    }else{
        identifier = @"CTDesignerCellStyle1Cell";
    }
    CTDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    XKDesignerBriefData *designer = [self.designers objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:designer.headUrl] placeholderImage:[UIImage imageNamed:kPlaceholderImg] options:SDWebImageAvoidDecodeImage];
    cell.pinyinLabel.text = designer.pinyin;
    cell.nameLabel.text = designer.pageName;
    [cell.commentsBtn setTitle:[designer.commentCount stringValue] forState:UIControlStateNormal];
    [cell.thumbsupBtn setTitle:[designer.fabulousCount stringValue] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XKDesignerBriefData *data = [self.designers objectAtIndex:indexPath.row];
    CTDesignerHomeVC *controller = [[CTDesignerHomeVC alloc] initWithDesignerBriefData:data];
    [self.navigationController pushViewController:controller animated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 250.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (NSMutableArray<XKDesignerBriefData *> *)designers{
    if (!_designers) {
        _designers = [NSMutableArray array];
    }
    return _designers;
}

@end
