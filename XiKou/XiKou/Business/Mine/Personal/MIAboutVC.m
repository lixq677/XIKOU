//
//  MIAboutVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/11.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIAboutVC.h"
#import "XKUIUnitls.h"
#import "UILabel+NSMutableAttributedString.h"

@interface MIAboutVC ()

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *textLabel1;

@property (nonatomic,strong,readonly)UILabel *textLabel2;

@property (nonatomic,strong,readonly)UILabel *copyrightLabel;

@property (nonatomic,strong,readonly)UIScrollView *scrollView;

@end

@implementation MIAboutVC
@synthesize imageView = _imageView;
@synthesize textLabel1 = _textLabel1;
@synthesize textLabel2 = _textLabel2;
@synthesize copyrightLabel = _copyrightLabel;
@synthesize scrollView = _scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于喜扣";
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView addSubview:self.textLabel1];
    [self.scrollView addSubview:self.textLabel2];
    [self.scrollView addSubview:self.copyrightLabel];
    [self.view setBackgroundColor:HexRGB(0xffffff, 1.0f)];
    [self.scrollView setBackgroundColor:HexRGB(0xffffff, 1.0f)];
    
    NSString *string1 = @"\t “喜扣商城”是中国喜扣控股集团（香港）拟在湖南长沙全资成立陆陆网络科技有限公司（外资企业），商城与众多全球轻奢品牌厂商和品牌商合作（DIOR（迪奥）、SWAROVSKI（施华洛世奇）、Zwilling（双立人）、COACH（蔻驰）、Burberry（博柏利）.........），以定制消费为核心，精选全球高品质正品和轻奢品牌，打造集个性定制消费+电商+店商于一体的新零售商业平台。";
    self.textLabel1.text = string1;
    self.textLabel1.font = Font(14.f);
    self.textLabel1.textColor = COLOR_HEX(0x666666);
    self.textLabel1.textAlignment = NSTextAlignmentLeft;
    self.textLabel1.numberOfLines = 0;
    [self.textLabel1 setLineSpace:11.5];
    
    NSString *string2 = @"\t 该平台构建“互联网+实体经济”的大商业营销模式，与合作伙伴共同打造分布式商业生态环境、助推实体企业健康发展。通过“产品供应链、互联网技术供应链、商业营销供应链”三大核心优势资源，实现喜扣商城“让定制成为消费主流”的愿景，秉承“个性定制，标准智造”为使命，践行“共识、共鸣、共振、共赢”的价值观，致力于让消费者、商家、供应商，让所有参与者，都享有成长获益的机会。以定制提升人们生活个性追求、以定制实现人们品质生活，改变人民的生活态度和生活方式；积极打造全球”高端定制个性化，物超所值不高价”的消费体验，成为定制新零售风口引领者。";
    
    self.textLabel2.text = string2;
    self.textLabel2.font = Font(14.f);
    self.textLabel2.textColor = COLOR_HEX(0x666666);
    self.textLabel2.textAlignment = NSTextAlignmentLeft;
    self.textLabel2.numberOfLines = 0;
    [self.textLabel2 setLineSpace:11.5];
    
    NSString *string3 = @"喜扣商城 版权所有\ncopyright@2018-2019 xikou Ail Right Reserved";
    self.copyrightLabel.text = string3;
    self.copyrightLabel.font  = Font(10.f);
    self.copyrightLabel.textColor = COLOR_HEX(0xCCCCCC);
    self.copyrightLabel.numberOfLines = 0;
    
    [self.copyrightLabel setAttributedStringWithSubString:@"喜扣商城 版权所有" font:Font(9)];
    [self.copyrightLabel setLineSpace:6];
    self.copyrightLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(70.0f);
        make.top.mas_equalTo(40.0f);
        make.centerX.equalTo(self.view);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(15.0f);
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
    }];
    [self.textLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textLabel1);
        make.top.mas_equalTo(self.textLabel1.mas_bottom).offset(10.0f);
        make.left.mas_equalTo(20.0f);
        make.right.mas_equalTo(-20.0f);
    }];
    
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_greaterThanOrEqualTo(self.textLabel2.mas_bottom).offset(40.0f);
        make.bottom.mas_equalTo(-43.0f-[XKUIUnitls safeBottom]);
        make.left.mas_equalTo(30.0f);
        make.right.mas_equalTo(-30.0f);
    }];
    
}

#pragma mark getter or setter

- (UILabel *)textLabel1{
    if (!_textLabel1) {
        _textLabel1 = [[UILabel alloc] init];
    }
    return _textLabel1;
}

- (UILabel *)textLabel2{
    if (!_textLabel2) {
        _textLabel2 = [[UILabel alloc] init];
    }
    return _textLabel2;
}

- (UILabel *)copyrightLabel{
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] init];
    }
    return _copyrightLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _imageView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}


@end
