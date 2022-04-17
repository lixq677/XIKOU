//
//  HMMessageVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/8.
//  Copyright © 2019 李笑清. All rights reserved.
//
#import "HMMessageVC.h"
#import "XKMessageData.h"
#import "HMMessageListVC.h"
#import "XKMessageService.h"

@interface HMMessageCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UILabel *detailTextLabel;

@property (nonatomic,strong)UILabel *redHintLabel;

@end


@implementation HMMessageCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(25.0f, 23.0f, 40.0f, 40.0f);
    self.textLabel.frame = CGRectMake(75.0f, 27.0f, 200, 15.0f);
    self.detailTextLabel.frame = CGRectMake(75.0f, 48.0f, 200, 12.0f);
    [self.redHintLabel sizeToFit];
    if (self.redHintLabel.width+9.0f > 18.0f) {
        self.redHintLabel.width+=9.0f;
    }else{
        self.redHintLabel.width = 18.0f;
    }
    self.redHintLabel.frame = CGRectMake(self.contentView.width-25.0f-self.redHintLabel.width, self.contentView.centerY-9.0f, self.redHintLabel.width, 18.0f);
}

- (void)setupUI{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.detailTextLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.redHintLabel];
}

#pragma mark getter
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
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
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

- (UILabel *)redHintLabel{
    if (!_redHintLabel) {
        _redHintLabel = [[UILabel alloc] init];
        _redHintLabel.textColor = HexRGB(0xffffff, 1.0f);
        _redHintLabel.backgroundColor = HexRGB(0xf94119, 1.0f);
        _redHintLabel.font = [UIFont systemFontOfSize:12.0f];
        _redHintLabel.textAlignment = NSTextAlignmentCenter;
        _redHintLabel.layer.cornerRadius = 9.0f;
        _redHintLabel.clipsToBounds = YES;
    }
    return _redHintLabel;
}

@end


static XKMsgType const ids[4] = {XKMsgTypeOrder,XKMsgTypeActivity,XKMsgTypeSystem,XKMsgTypeNotice};
static NSString *const titles[4] = {@"订单助手",@"活动消息",@"系统消息",@"公告"};
static NSString *const detailTitles[4] = {@"支付、订单信息看这里",@"最新活动、推荐信息看这里",@"系统消息",@"公告通知看这里"};
static NSString *const imageNames[4] = {@"ic_activity_message",@"ic_notice_message",@"ic_order_message",@"ic_system_message"};

@interface HMMessageVC ()<UITableViewDelegate,UITableViewDataSource,XKMessageServiceDelegate>

@property (nonatomic,strong,readonly) UITableView *tableView;

@property (nonatomic,strong,readonly) UIView *backView;

@property (nonatomic,strong,readonly)XKMsgUnReadData *unreadData;

@end

@implementation HMMessageVC
@synthesize tableView = _tableView;
@synthesize backView = _backView;

- (instancetype)initWithUnreadData:(XKMsgUnReadData *)unreadData{
    if (self = [super init]) {
        _unreadData = unreadData;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"客服" style:UIBarButtonItemStylePlain target:self action:@selector(customerService:)];
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
    [self.navigationController.navigationBar.layer setShadowColor:[UIColor clearColor].CGColor];
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    [self.view addSubview:self.backView];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HMMessageCell class] forCellReuseIdentifier:@"HMMessageCell"];
    [[XKFDataService() messageService] addWeakDelegate:self];
}

- (void)dealloc{
    [[XKFDataService() messageService] removeWeakDelegate:self];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.backView.frame = CGRectMake(0, 0, kScreenWidth, 135.0f+[XKUIUnitls safeTop]);
    self.tableView.frame = CGRectMake(15.0f, 55.0f+[XKUIUnitls safeTop], kScreenWidth-30.0f, 346.0f);
}



#pragma mark getter or setter
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HMMessageCell" forIndexPath:indexPath];
    int ids[4] = {XKMsgTypeOrder,XKMsgTypeActivity,XKMsgTypeSystem,XKMsgTypeNotice};
    cell.imageView.image = [UIImage imageNamed:imageNames[indexPath.row]];
    cell.textLabel.text = titles[indexPath.row];
    cell.detailTextLabel.text = detailTitles[indexPath.row];
    __block NSInteger unreadNum = 0;
    if (self.unreadData.typesList.count > 0) {
        int idt = ids[indexPath.row];
        [self.unreadData.typesList enumerateObjectsUsingBlock:^(XKMsgTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.id == idt) {
                unreadNum = obj.unreadNum;
                *stop = YES;
            }
        }];
    }
    if (unreadNum > 0) {
        cell.redHintLabel.text = @(unreadNum).stringValue;
        cell.redHintLabel.hidden = NO;
    }else{
        cell.redHintLabel.text = nil;
        cell.redHintLabel.hidden = YES;
    }
    if (indexPath.row == 3) {
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
    }else{
        cell.separatorInset = UIEdgeInsetsMake(0, 15.0f, 0, 15.0f);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.unreadData.typesList.count > 0) {
        XKMsgType idt = ids[indexPath.row];
        [self.unreadData.typesList enumerateObjectsUsingBlock:^(XKMsgTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.id == idt) {
                [[XKFDataService() messageService] readMsgs:obj];
                HMMessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.redHintLabel.text = nil;
                cell.redHintLabel.hidden = YES;
                *stop = YES;
            }
        }];
    }
    HMMessageListVC *controller = [[HMMessageListVC alloc] initWithTypeMsgType:ids[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 消息代理
- (void)readUnreadMsgWithService:(XKMessageService *)service msgData:(XKMsgData *)msgData{
    NSInteger index = NSNotFound;
    for (NSInteger i = 0; i< 4; i++) {
        XKMsgType type = ids[i];
        if(type  == msgData.msgType){
            index = i;
            break;
        }
    }
    if (index == NSNotFound)return;
    HMMessageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    __block NSInteger unreadNum = 0;
    [self.unreadData.typesList enumerateObjectsUsingBlock:^(XKMsgTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.id == msgData.msgType) {
            if (obj.unreadNum -1 >= 0) {
                obj.unreadNum -= 1;
            }
            unreadNum = obj.unreadNum;
            *stop = YES;
        }
    }];
    if (unreadNum > 0) {
        cell.redHintLabel.text = @(unreadNum).stringValue;
        cell.redHintLabel.hidden = NO;
    }else{
        cell.redHintLabel.text = nil;
        cell.redHintLabel.hidden = YES;
    }
}



#pragma mark action

- (void)customerService:(id)sender{
    [MGJRouter openURL:kRouterCustomer];
}


#pragma mark getter or setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.rowHeight = 85.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}


- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HexRGB(0x444444, 1.0f);
    }
    return _backView;
}

@end
