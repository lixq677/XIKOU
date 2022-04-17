//
//  HMQRInfoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/8/6.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMQRInfoVC.h"

@interface HMQRInfoVC ()

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)NSString *text;

@end

@implementation HMQRInfoVC
@synthesize textLabel = _textLabel;
@synthesize text = _text;

- (instancetype)initWithText:(NSString *)text{
    if (self = [super init]) {
        _text = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    self.title = @"扫描信息";
    self.textLabel.text = self.text;
    [self.view addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HexRGB(0x444444, 1.0f);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:20.0f];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}


@end
