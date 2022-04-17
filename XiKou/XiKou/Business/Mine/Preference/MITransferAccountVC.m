//
//  MITransferAccountVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MITransferAccountVC.h"
#import "MITransferVC.h"
#import "UITextField+XKUnitls.h"
#import "XKUserService.h"

@interface MITransferTextFieldCell : UITableViewCell

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UITextField *textField;

@end

@implementation MITransferTextFieldCell
@synthesize textLabel = _textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.textField];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(80);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mas_right).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.mas_equalTo(-20);
        }];
    }
    return self;
}

- (void)dealloc{
    self.textField.xk_monitor = NO;
}

#pragma mark getter or setter
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = @"对方账号";
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _textLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:15.0f];
        _textField.placeholder = @"请输入手机号码:";
        _textField.xk_monitor = YES;
        _textField.xk_textFormatter = XKTextFormatterMobile;
        _textField.xk_supportContent = XKTextSupportContentNumber;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

@end


@interface MITransferUserCell : UITableViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *textLabel;

@end

@implementation  MITransferUserCell
@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.imageView];
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView.mas_right).offset(15.0f);
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(-20);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15.0f];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
    }
    return _textLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 20.0f;
        _imageView.clipsToBounds = YES;
    }
    return  _imageView;
}


@end

@interface MITransferAccountVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UILabel *hintLabel;

@property (nonatomic,strong)UIButton *button;

@property (nonatomic,strong)NSMutableArray<XKUserInfoData *> *dataSource;

@end

@implementation MITransferAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"转账";
    self.view.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    [self setupUI];
    [self layout];
    
    [self.tableView registerClass:[MITransferTextFieldCell class] forCellReuseIdentifier:@"MITransferTextFieldCell"];
    
    [self.tableView registerClass:[MITransferUserCell class] forCellReuseIdentifier:@"MITransferUserCell"];
    @weakify(self);
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        MITransferTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self searchUserInfoWithMobile:[cell.textField.text deleteSpace]];
    }];
}


- (void)layout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(10);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.top.mas_equalTo(self.hintLabel.mas_bottom).offset(30.0f);
    }];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    [footerView addSubview:self.hintLabel];
    [footerView addSubview:self.button];
    self.tableView.tableFooterView = footerView;
    [self.view addSubview:self.tableView];
}

#pragma mark getter or setter
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MITransferTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MITransferTextFieldCell" forIndexPath:indexPath];
        @weakify(self);
        cell.textField.xk_textDidChangeBlock = ^(NSString * _Nonnull text){
            @strongify(self);
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
        };
        return cell;
    }else{
        MITransferUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MITransferUserCell" forIndexPath:indexPath];
        XKUserInfoData *data = [self.dataSource objectAtIndex:indexPath.row-1];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:data.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        cell.textLabel.text = data.nickName;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)searchUserInfoWithMobile:(NSString *)mobile{
    if ([NSString isNull:mobile]) {
        XKShowToast(@"请输入手机号码");
        return;
    }
    if ([self.dataSource count] > 0) {
        XKUserInfoData *data = [self.dataSource firstObject];
        MITransferVC *controller = [[MITransferVC alloc] initWithUserInfoData:data];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    [XKLoading show];
    [[XKFDataService() userService] queryUserInfoWithMobile:mobile completion:^(XKUserInfoResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObject:response.data];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}



#pragma mark gettor methods
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.rowHeight = 50.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = COLOR_LINE_GRAY;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    }
    return _tableView;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"钱将实时转入对方账户,无法退退款";
        _hintLabel.font = [UIFont systemFontOfSize:12.0f];
        _hintLabel.textColor = HexRGB(0xcccccc, 1.0f);
    }
    return _hintLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"下一步" forState:UIControlStateNormal];
        [_button setBackgroundColor:HexRGB(0x444444, 1.0f)];
        [_button setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _button;
}

- (NSMutableArray<XKUserInfoData *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
