//
//  MIMatterVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/4.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIMatterVC.h"
#import "XKUIUnitls.h"
#import "MIMatterCell.h"
#import "XKSegmentView.h"

@interface MIMatterVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)XKSegmentView *segmentView;

@end

@implementation MIMatterVC
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"喜扣素材";
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.navigationBarStyle = XKNavigationBarStyleDefault;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xx_matter"]];
    imageView.frame = CGRectMake(30.0f, 10.0f, self.view.width-60.0f, (self.view.width-60.0f)*1000/630);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    /*喜扣素材，暂时不做*/
#if 0
    [self setupUI];
    [self autoLayout];
#endif
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segmentView];
    self.tableView.backgroundColor = HexRGB(0xffffff, 1.0f);
    
    [self.tableView registerClass:[MIMatterCell class] forCellReuseIdentifier:@"MIMatterCell"];
}

- (void)autoLayout{
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(45.0f);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *images = nil;
    MIMatterCell *cell = nil;
    if (indexPath.row %4 == 0) {
        images = @[[UIImage imageNamed:@"custom_designer_test"],[UIImage imageNamed:@"custom_designer_test"],[UIImage imageNamed:@"custom_designer_test"],[UIImage imageNamed:@"custom_designer_test"]];
    }else if (indexPath.row%4 == 1){
        images = @[[UIImage imageNamed:@"custom_designer_test"]];
    }else if (indexPath.row%4 == 2){
        images = @[[UIImage imageNamed:@"custom_designer_test"],[UIImage imageNamed:@"custom_designer_test"]];
    }else{
        images = @[[UIImage imageNamed:@"custom_designer_test"],[UIImage imageNamed:@"custom_designer_test"],[UIImage imageNamed:@"custom_designer_test"]];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:@"MIMatterCell" forIndexPath:indexPath];
    cell.images = images;
    cell.imageView.image = [UIImage imageNamed:@"custom_avatar"];
    cell.nameLabel.text = @"王二狗子";
    cell.timeLabel.text = @"1分钟前";
    cell.signatureLabel.text = @"因为工作需要，常常会搜集创意灵感和视觉呈现， 丰富的素材帮助我减轻很多负担。";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell sizeToFit];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 250.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = COLOR_VIEW_GRAY;
        _tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0.0f;
    }
    return _tableView;
}

- (XKSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[XKSegmentView alloc] initWithTitles:@[@"全部",@"产品素材",@"宣传素材"]];
        _segmentView.style = XKSegmentViewStyleDivide;
    }
    return _segmentView;
}


@end
