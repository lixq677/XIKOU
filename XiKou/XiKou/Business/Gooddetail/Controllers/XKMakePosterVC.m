//
//  XKMakePosterVC.m
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKMakePosterVC.h"
#import "XKQRCode.h"
#import "UILabel+NSMutableAttributedString.h"
#import "UIImage+XKCommon.h"
#import <Photos/Photos.h>
#import "XKShareTool.h"
#import "XKAccountManager.h"
#import "XKShareService.h"

@interface XKMakePosterVC ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIImageView *QRImageView;

@property (nonatomic,strong) UIView *buttonsView;

@property (nonatomic,strong) UIView *infoView;

@property (nonatomic,strong) UIImage *shareImg;

@property (nonatomic,strong) UILabel *shareContentlabel;

@property (nonatomic, strong,readonly) XKGoodModel *model;

@property (nonatomic,strong,readonly) NSString *URLString;
@end

static NSString *const kAdvertisingKey = @"kAdvertisingKey";

@implementation XKMakePosterVC

- (instancetype)initWithGoodModel:(XKGoodModel *)model URLString:(NSString *)URLString;{
    self = [super init];
    if (self) {
        _model = model;
        _URLString = URLString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
    // Do any additional setup after loading the view.
}

- (void)saveAction{
    //保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.shareImg];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            XKShowToast(@"图片保存失败");
        } else {
            XKShowToast(@"图片保存成功");
        }
    }];
}

- (void)shareAction{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.shareContentlabel.text;
    
    [[XKShareTool defaultTool]shareWithTitle:@"文案已复制" Image:self.shareImg andThumb:self.shareImg andNeedPhtot:NO];
}

- (void)clipBoardAction{
    NSMutableString *string = [NSMutableString string];
    if (![NSString isNull:self.shareContentlabel.text]) {
        [string appendString:self.shareContentlabel.text];
    }
    if (![NSString isNull:self.model.commodityName]) {
        [string appendFormat:@" %@",self.model.commodityName];
    }
   
    if (![NSString isNull:self.URLString]) {
        [string appendFormat:@" %@",self.URLString];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    XKShowToast(@"文案已复制到剪贴板");
}

- (UIImage *)shareImg{
    if (!_shareImg) {
        _shareImg = [UIImage snapshotSingleView:self.contentView];
    }
    return _shareImg;
}

- (UIImage *)QRImageWithString:(NSString *)userId{
    UIImage *image = [XKQRCode createQRCodeWithString:userId withImgSize:CGSizeMake(100.f, 100.f)];
    UIImage *logoImage = [UIImage imageNamed:@"code_logo"];
    //根据二维码图片设置生成水印图片rect 这里限制水印的图片为二维码的1/4
    CGRect frame = [XKQRCode getWaterImageRectFromOutputQRImage:image];
    image = [XKQRCode waterImageWithImage:image waterImage:logoImage waterImageRect:frame];
    return image;
}

- (void)getQRContent{
    [[XKFDataService() shareService] getPopularizeShareInfomationCompletion:^(XKPopularizeInfoResponse * _Nonnull response) {
        if ([response isSuccess]) {
            if ([NSString isNull:response.data.jumpUrl]) return;
            NSURL *url = [NSURL URLWithString:response.data.jumpUrl];
            if (url == nil) return;
            
            NSDictionary *params = [url params];
            NSString *URLString = nil;
            NSString *exCode =  [[XKAccountManager defaultManager] extCode];
            if (exCode) {
                [params setValue:exCode forKey:@"extcode"];
            }
            NSString *domain = [[url.absoluteString componentsSeparatedByString:@"?"] firstObject];
            URLString = [NSString connectUrl:domain params:params];
            [[NSUserDefaults standardUserDefaults] setObject:domain forKey:kAdvertisingKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.QRImageView.image = [self QRImageWithString:URLString];
        }
    }];
}

- (void)creatSubViews{
    self.title = @"生成海报";
    self.view.backgroundColor = COLOR_TEXT_BLACK;

    [self.view xk_addSubviews:@[self.infoView,self.contentView,self.buttonsView]];
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(64 + [XKUIUnitls safeBottom]);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.buttonsView.mas_top);
        make.height.mas_equalTo(63);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-25);
        make.bottom.equalTo(self.infoView.mas_top).offset(-13);
    }];
    [self.buttonsView layoutIfNeeded];
    
    _buttonsView.backgroundColor = [UIColor whiteColor];
    _buttonsView.layer.shadowColor = COLOR_VIEW_SHADOW;
    _buttonsView.layer.shadowOffset = CGSizeMake(-0.5,-2);
    _buttonsView.layer.shadowOpacity = 1;
    _buttonsView.layer.shadowRadius = 2.5;
}

- (UIView *)contentView{
    if (!_contentView) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius  = 5.f;
        _contentView = bgView;
        
        self.QRImageView = [UIImageView new];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.font = Font(10.f);
        tipLabel.textColor = COLOR_TEXT_GRAY;
        
        UILabel *idLabel = [UILabel new];
        idLabel.font = FontMedium(15.f);
        idLabel.textColor = COLOR_TEXT_BROWN;
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.font = FontSemibold(17.f);
        priceLabel.textColor = COLOR_TEXT_RED;
        
        UILabel *originalLabel = [UILabel new];
        
        originalLabel.font = Font(10.f);
        originalLabel.textColor = COLOR_PRICE_GRAY;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = Font(12.f);
        titleLabel.textColor = COLOR_TEXT_BLACK;
        titleLabel.numberOfLines = 2;
        
        UIImageView *imgView = [UIImageView new];
        imgView.clipsToBounds= YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        tipLabel.text = @"我已准备好为你服务！";
        
        if ([[XKAccountManager defaultManager] isLogin] && [[XKAccountManager defaultManager] extCode]) {
            NSString *URLString = [[NSUserDefaults standardUserDefaults] objectForKey:kAdvertisingKey];
            if ([NSString isNull:URLString]) {
                URLString = @"https://wx.luluxk.com/index.html";
            }
            URLString =  [[URLString componentsSeparatedByString:@"?"] firstObject];
            
            NSString *exCode =  [[XKAccountManager defaultManager] extCode];
            if (!exCode) exCode = @"";
            
            URLString = [URLString stringByAppendingFormat:@"?extcode=%@",exCode];
            self.QRImageView.image = [self QRImageWithString:[[XKAccountManager defaultManager] extCode]];
            idLabel.text = [NSString stringWithFormat:@"喜扣达人 ID: %@",[[XKAccountManager defaultManager] extCode]];
             [self getQRContent];
        }
        
        if (_model.activityType == Activity_Discount) {
            priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.salePrice floatValue]/100];
            originalLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.marketPrice floatValue]/100];
        }else{
            priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.commodityPrice floatValue]/100];
            originalLabel.text = [NSString stringWithFormat:@"¥%.2f",[_model.salePrice floatValue]/100];
        }
        [priceLabel handleRedPrice:FontSemibold(17.f)];
        [originalLabel addMiddleLineWithSubString:originalLabel.text];
        titleLabel.text = _model.commodityName;
        [imgView sd_setImageWithURL:[NSURL URLWithString:_model.goodsImageUrl]];
        
        [bgView xk_addSubviews:@[self.QRImageView,tipLabel,idLabel,idLabel,priceLabel,originalLabel,titleLabel,imgView]];
        [self.QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.right.bottom.equalTo(bgView).offset(-20);
        }];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(20);
            make.bottom.equalTo(self.QRImageView);
            make.right.equalTo(self.QRImageView.mas_left);
            make.height.mas_equalTo(10);
        }];
        [idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(tipLabel);
            make.height.mas_equalTo(14);
            make.bottom.equalTo(tipLabel.mas_top).offset(-8);
        }];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel);
            make.bottom.equalTo(self.QRImageView.mas_top).offset(-5);
            make.height.mas_equalTo(15);
        }];
        [originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(12);
            make.left.equalTo(priceLabel.mas_right).offset(5);
            make.bottom.equalTo(priceLabel);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLabel);
            make.right.equalTo(self.QRImageView);
            make.bottom.equalTo(priceLabel.mas_top).offset(-10);
        }];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(titleLabel.mas_top).offset(-10);
            make.top.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(imgView.mas_width);
        }];
    }
    return _contentView;
}

- (UIView *)buttonsView{
    if (!_buttonsView) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.layer.masksToBounds = YES;
        saveBtn.layer.cornerRadius  = 2.f;
        [saveBtn setBackgroundColor:COLOR_TEXT_BROWN];
        [saveBtn setTitle:@"保存相册" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn.titleLabel setFont:FontMedium(15.f)];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.layer.masksToBounds = YES;
        shareBtn.layer.cornerRadius  = 2.f;
        [shareBtn setBackgroundColor:COLOR_TEXT_BLACK];
        [shareBtn setTitle:@"分享好友" forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shareBtn.titleLabel setFont:FontMedium(15.f)];
        [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        
        [bgView xk_addSubviews:@[saveBtn,shareBtn]];
        [bgView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:18 tailSpacing:18];
        [bgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(42);
        }];
        _buttonsView = bgView;
    }
    return _buttonsView;
}

- (UIView *)infoView{
    if (!_infoView) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        copyBtn.layer.masksToBounds = YES;
        copyBtn.layer.cornerRadius  = 2.f;
        [copyBtn setBackgroundColor:COLOR_TEXT_BLACK];
        [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [copyBtn.titleLabel setFont:Font(12.f)];
        [copyBtn addTarget:self action:@selector(clipBoardAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label  = [UILabel new];
        label.font      = Font(12.f);
        label.textColor = COLOR_TEXT_GRAY;
        label.numberOfLines = 2;
        
        if (_model.activityType == Activity_WG)       label.text = @"喜扣吾G精品正在热卖中，好货不等人\n快来抢购吧！";
        if (_model.activityType == Activity_Custom)   label.text = @"喜扣定制拼团精品正在热卖中，好货不等人\n快来抢购吧！";
        if (_model.activityType == Activity_Discount) label.text = @"喜扣多买多折精品正在热卖中，好货不等人\n快来抢购吧！";
        if (_model.activityType == Activity_Global)   label.text = @"喜扣全球买手精品正在热卖中，好货不等人\n快来抢购吧！";
        if (_model.activityType == Activity_ZeroBuy)  label.text = @"喜扣0元抢精品正在热拍中，好货不等人\n快来抢拍吧！";
        if (_model.activityType == Activity_Bargain)  label.text = @"喜扣砍立得精品正在热卖中，好货不等人\n快来砍价吧！";
        
        _shareContentlabel = label;
        
        [bgView xk_addSubviews:@[_shareContentlabel,copyBtn]];
        [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(50, 28));
            make.centerY.equalTo(bgView);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.bottom.equalTo(bgView);
            make.right.equalTo(copyBtn.mas_left).offset(-10);
        }];
        _infoView = bgView;
    }
    return _infoView;
}


- (UIImageView *)QRImageView{
    if (!_QRImageView) {
        _QRImageView = [[UIImageView alloc] init];
    }
    return _QRImageView;
}
@end
