//
//  MIUserProtocolVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIUserProtocolVC.h"
#import <WebKit/WebKit.h>

@interface MIUserProtocolVC ()<WKUIDelegate,WKNavigationDelegate>

//protocol提示
@property (nonatomic,strong,readonly)UILabel *protocolHintLabel;

@property (nonatomic,strong,readonly)UIButton *checkBox;

@property (nonatomic,strong,readonly) WKWebView * webView;

@property (nonatomic,weak)id<MIUserProtocolVCDelegate> delegate;

@end

@implementation MIUserProtocolVC
@synthesize protocolHintLabel = _protocolHintLabel;
@synthesize checkBox = _checkBox;
@synthesize webView = _webView;

- (instancetype)initWithDelegate:(id<MIUserProtocolVCDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户协议";
    [self setupUI];
    [self layout];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.luluxk.com/agreement/service.html"]]];
}

- (void)setupUI{
    [self.view addSubview:self.checkBox];
    [self.view addSubview:self.protocolHintLabel];
    [self.view addSubview:self.webView];
}

- (void)layout{
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.0f);
        make.bottom.mas_equalTo(-(14+[XKUIUnitls safeBottom]));
        make.width.height.mas_equalTo(30.0f);
    }];
    
    [self.protocolHintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.checkBox.mas_right).offset(2.0f);
        make.centerY.mas_equalTo(self.checkBox);
        make.height.mas_equalTo(17.0f);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-(60+[XKUIUnitls safeBottom]));
    }];
}

#pragma mark getter
- (UILabel *)protocolHintLabel{
    if (!_protocolHintLabel) {
        _protocolHintLabel = [[UILabel alloc] init];
        _protocolHintLabel.text = @"我已阅读并同意喜扣用户协议";
        _protocolHintLabel.textColor = HexRGB(0xcccccc, 1.0f);
        _protocolHintLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _protocolHintLabel;
}


- (UIButton *)checkBox{
    if (!_checkBox) {
        _checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBox.clipsToBounds = YES;
        _checkBox.layer.cornerRadius = 15.0f;
        [_checkBox setImage:[UIImage imageNamed:@"Oval_deselect"] forState:UIControlStateNormal];
        [_checkBox setImage:[UIImage imageNamed:@"Oval_select"] forState:UIControlStateSelected];
        @weakify(self);
        [[_checkBox rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            x.selected = !x.selected;
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(userProtocolAgree:)]) {
                [self.delegate userProtocolAgree:x.selected];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _checkBox;
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}
@end
