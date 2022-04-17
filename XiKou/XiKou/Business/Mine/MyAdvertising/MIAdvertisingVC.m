//
//  MIAdvertising.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIAdvertisingVC.h"
#import "UILabel+NSMutableAttributedString.h"
#import "XKQRCode.h"
#import "XKShareTool.h"
#import <Photos/Photos.h>
#import "UIImage+XKCommon.h"
#import "XKUserService.h"
#import "XKShareService.h"

@interface MIAdvertisingVC ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UIImageView *qrImageView;

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIImageView *middleImageView;

@property (nonatomic, strong) UILabel *codeLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *desLabel;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) UIButton *shareBtn;

@end

static NSString *const kAdvertisingKey = @"kAdvertisingKey";

@implementation MIAdvertisingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setData];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self layout];
}

- (void)setupUI{
    
    self.title = @"我的推广";
    
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hm_share"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    
    self.navigationBarStyle = XKNavigationBarStyleDefault;
    [self.view addSubview:self.imageView];
    [self.imageView xk_addSubviews:@[self.topImageView,self.middleImageView]];
    [self.middleImageView xk_addSubviews:@[self.nameLabel,self.avatarImageView,self.qrImageView,self.codeLabel,self.desLabel]];
    [self.view addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)layout{
    CGFloat screenHeight = CGRectGetHeight(self.view.bounds) - [XKUIUnitls safeBottom];
    CGFloat wid = kScreenWidth-2*scalef(37.0f);
    CGFloat height = wid/300.0f * 483.0f;
    CGFloat y = 0.5 * (screenHeight * 0.8 - height);
    self.imageView.frame = CGRectMake(scalef(37.0f), y, wid, height);
    
    self.topImageView.frame = CGRectMake(scalef(20), scalef(43.0f), CGRectGetWidth(self.imageView.frame)-2*scalef(20.0f), (CGRectGetWidth(self.imageView.frame)-2*scalef(20.0f))/260.0f*152.0f);

    self.middleImageView.frame = CGRectMake(scalef(26.0f), CGRectGetMaxY(self.topImageView.frame), CGRectGetWidth(self.imageView.frame)-2*scalef(26.0f), CGRectGetWidth(self.imageView.frame)-2*scalef(26.0f));
    
    CGFloat top2 = CGRectGetWidth(self.middleImageView.frame)/309.0f * 165.0f;
    self.codeLabel.frame = CGRectMake(scalef(20.0f), scalef(15.f), CGRectGetWidth(self.middleImageView.frame)-2*scalef(20.0f), scalef(90.0f));
    
    CGSize size = [self.nameLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.codeLabel.frame)-30.0f, 30.0f)];
    CGFloat width = size.width + 25.0f;
    self.avatarImageView.frame = CGRectMake(0.5*CGRectGetWidth(self.middleImageView.frame)-0.5*width, CGRectGetMaxY(self.codeLabel.frame), 19.0f, 19.0f);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 6.0f, CGRectGetMidY(self.avatarImageView.frame)-0.5*size.height, size.width, size.height);
    
    self.qrImageView.frame = CGRectMake((CGRectGetWidth(self.middleImageView.frame) - scalef(83.0f))*0.5, top2+5.0f, scalef(83.0f), scalef(83.0f));
    
    self.desLabel.frame = CGRectMake(scalef(20.0f), CGRectGetMaxY(self.qrImageView.frame)+5.0f, CGRectGetWidth(self.middleImageView.frame)-2*scalef(20.0f), 11.0f);
    
    self.shareBtn.frame = CGRectMake(self.imageView.x, self.imageView.bottom+31.0f, self.imageView.width, 40.0f);
}

- (void)setData{
    
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKUserInfoData *info = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:info.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
    
    self.nameLabel.text   = [NSString stringWithFormat:@"%@ 邀请您加入喜扣",info.nickName];
    self.codeLabel.text   = [NSString stringWithFormat:@"邀请码\n%@",[[XKAccountManager defaultManager] extCode]?:@""];
    
    [self.codeLabel setAttributedStringWithSubString:[[XKAccountManager defaultManager] extCode] font:FontMedium(35.f)];
    [self.codeLabel setAttributedStringWithSubString:[[XKAccountManager defaultManager] extCode] color:COLOR_TEXT_RED];
    
    // https://m.luluxk.com/login.html?code=WYAP
    
    NSString *URLString = [[NSUserDefaults standardUserDefaults] objectForKey:kAdvertisingKey];
    if ([NSString isNull:URLString]) {
        URLString = @"https://wx.luluxk.com/index.html";
    }
    URLString =  [[URLString componentsSeparatedByString:@"?"] firstObject];
    
    NSString *exCode =  [[XKAccountManager defaultManager] extCode];
    if (!exCode) exCode = @"";
    
    URLString = [URLString stringByAppendingFormat:@"?extcode=%@",exCode];
    
    self.qrImageView.image = [self QRImageWithString:URLString];
    [self getQRContent];
    
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
            self.qrImageView.image = [self QRImageWithString:URLString];
        }
    }];
}

- (UIImage *)QRImageWithString:(NSString *)string{
    UIImage *image = [XKQRCode createQRCodeWithString:string withImgSize:CGSizeMake(80.0f, 80.0f)];
    UIImage *logoImage = [UIImage imageNamed:@"code_logo"];
    //根据二维码图片设置生成水印图片rect 这里限制水印的图片为二维码的1/4
    CGRect frame = [XKQRCode getWaterImageRectFromOutputQRImage:image];
    image = [XKQRCode waterImageWithImage:image waterImage:logoImage waterImageRect:frame];
    return image;
}

/*合成图片*/
- (UIImage *)shareImage{
    if (!_shareImage) {
        _shareImage = [UIImage snapshotSingleView:self.imageView];
    }
    //返回图片
    return _shareImage;
}

- (void)rightItemAction:(id)sender{
    XKShareTool *shareTool = [XKShareTool defaultTool];
    shareTool.photoCallBack = ^(NSString *url){
        [self saveAction];
    };
    [shareTool shareWithTitle:@"分享到好友" Image:self.shareImage andThumb:self.shareImage andNeedPhtot:YES];
}

- (void)saveAction{
    //保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.shareImage];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            XKShowToast(@"图片保存失败");
        } else {
            XKShowToast(@"图片保存成功");
        }
    }];
}


#pragma mark getter or setter
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mi_advertising"]];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode     = UIViewContentModeScaleAspectFill;
       // _imageView.clipsToBounds   = YES;
    }
    return _imageView;
}

- (UIImageView *)qrImageView{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
    }
    return _qrImageView;
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"populariz_top"]];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImageView;
}

- (UIImageView *)middleImageView{
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"populariz_card"]];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _middleImageView;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 12.f;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = COLOR_TEXT_BLACK;
        _codeLabel.font = FontMedium(15.f);
        _codeLabel.numberOfLines = 0;
        _codeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _codeLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = Font(10.f);
        _nameLabel.textColor = COLOR_TEXT_BLACK;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = Font(8.f);
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.text = @"扫码注册喜扣商城";
        _desLabel.textColor = COLOR_TEXT_GRAY;
    }
    return _desLabel;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:HexRGB(0xffffff, 1.0f) forState:UIControlStateNormal];
        _shareBtn.backgroundColor = HexRGB(0x444444, 1.0f);
        _shareBtn.layer.cornerRadius = 4.f;
        _shareBtn.clipsToBounds = YES;
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _shareBtn;
}
@end
