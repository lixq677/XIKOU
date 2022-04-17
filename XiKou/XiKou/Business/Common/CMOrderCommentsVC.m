//
//  CMOrderCommentsVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "CMOrderCommentsVC.h"

@interface CMOrderCommentsVC ()

@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)id<CMOrderCommentsVCDelegate> delegate;

@end

@implementation CMOrderCommentsVC

- (instancetype)initWithDelegate:(id<CMOrderCommentsVCDelegate>) delegate{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单备注";
    self.view.backgroundColor = HexRGB(0xf4f4f4, 1.0f);
    [self.view addSubview:self.textView];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.confirmBtn];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.top.mas_equalTo(10.0f);
        make.height.mas_equalTo((kScreenWidth-30)*180/345);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView).mas_equalTo(-11.0f);
        make.right.equalTo(self.textView).offset(-17.0f);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textView);
        make.height.mas_equalTo(40.0f);
        make.top.mas_equalTo(self.textView.mas_bottom).offset(10);
    }];
    
    [self.textView setXk_monitor:YES];
    [self.textView setXk_maximum:50];
    [self.textView setXk_calspace:YES];
    @weakify(self);
    [self.textView setXk_textDidChangeBlock:^(NSString * _Nonnull text) {
        @strongify(self);
        self.textLabel.text = [NSString stringWithFormat:@"%ld/50",(long)text.length];
//        if (text.length == 0) {
//            self.confirmBtn.enabled = NO;
//        }else{
//            self.confirmBtn.enabled = YES;
//        }
    }];
    
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(commentsViewController:commentText:)]) {
            [self.delegate commentsViewController:self commentText:self.textView.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)setText:(NSString *)text{
    [self.textView setText:text];
}

- (void)canEdit:(BOOL)edit{
    [self.textView setEditable:edit];
    if (edit) {
        self.confirmBtn.hidden = NO;
         self.textLabel.hidden = NO;
    }else{
        self.confirmBtn.hidden = YES;
         self.textLabel.hidden = YES;
    }
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.layer.cornerRadius = 2.0f;
        _textView.font = [UIFont systemFontOfSize:13.0f];
        _textView.textColor = HexRGB(0x888888, 1.0f);
    }
    return _textView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentRight;
        _textLabel.textColor = HexRGB(0xE1E0CD, 1.0f);
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.text = @"0/50";
    }
    return _textLabel;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _confirmBtn.layer.cornerRadius = 2;
        //_confirmBtn.enabled = NO;
    }
    return _confirmBtn;
}

@end
