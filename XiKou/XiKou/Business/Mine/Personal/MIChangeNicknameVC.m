//
//  MIChangeNicknameVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIChangeNicknameVC.h"
#import "XKUIUnitls.h"
#import <AFViewShaker.h>

@interface MIChangeNicknameVC ()

@property (nonatomic,strong,readonly)UITextField *textField;

@property (nonatomic,weak)id<MIChangeNicknameDelegate> delegate;

@end

@implementation MIChangeNicknameVC
@synthesize textField = _textField;

- (instancetype)initWithDelegate:(id<MIChangeNicknameDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改昵称";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    [self.view addSubview: self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20.0f);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo(50.0f);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = HexRGB(0xcccccc, 0.5f);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textField);
        make.top.mas_equalTo(self.textField.mas_bottom);
        make.height.mas_equalTo(0.5f);
    }];
}


- (void)saveAction:(id)sender{
    if ([NSString isNull:self.textField.text]) {
        AFViewShaker *viewShaker =  [[AFViewShaker alloc] initWithView:self.textField];
        [viewShaker shake];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(viewController:nickName:)]) {
        [self.delegate viewController:self nickName:self.textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark getter

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = COLOR_TEXT_BROWN;
        _textField.font = [UIFont systemFontOfSize:15.0f];
        _textField.placeholder = @"输入昵称";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.xk_monitor = YES;
        _textField.xk_maximum = 20;
    }
    return _textField;
}

@end
