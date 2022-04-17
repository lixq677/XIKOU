//
//  MIVerifyVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIVerifyVC.h"
#import "NSString+Common.h"
#import "XKAlertController.h"
#import "LYLPhotoTailoringTool.h"
#import "NSString+Common.h"

@interface MIVerifyVC ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UIImageView *idzImageView;
@property (weak, nonatomic) IBOutlet UIImageView *idfImageView;
@property (weak, nonatomic) IBOutlet UILabel *topInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomInfoLabel;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) XKVerifyParams *param;
@end

@import AVFoundation;
@import Photos;
@implementation MIVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    _param = [XKVerifyParams new];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    if (self.verifyModel) {
        _nameTextField.text   = self.verifyModel.realName;
        _idTextField.text     = self.verifyModel.idCard;
        [_idzImageView sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.imgFirst] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
        [_idfImageView sd_setImageWithURL:[NSURL URLWithString:self.verifyModel.imgSecond] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
        self.topInfoLabel.hidden    = YES;
        self.bottomInfoLabel.hidden = YES;
        
        _param.imgFirst  = self.verifyModel.imgFirst;
        _param.imgSecond = self.verifyModel.imgSecond;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)initUI{
    self.title = @"我的认证";
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.idzImageView.contentMode = UIViewContentModeScaleAspectFill;
    CAShapeLayer *idzBorder = [CAShapeLayer layer];
    idzBorder.strokeColor = HexRGB(0x979797, 0.32f).CGColor;
    CGRect idzRect = CGRectMake(self.idzImageView.frame.origin.x-10, self.idzImageView.frame.origin.y, self.idzImageView.width+20, self.idzImageView.height);
    idzBorder.fillColor = [UIColor clearColor].CGColor;
    idzBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, idzRect.size.width, idzRect.size.height) cornerRadius:2.0f].CGPath;
    idzBorder.frame = idzRect;
    idzBorder.lineWidth = 1.f;
    idzBorder.lineDashPattern = @[@4, @2];
    [self.idzImageView.layer addSublayer:idzBorder];
    [self.view.layer addSublayer:idzBorder];
    CGRect idfRect = CGRectMake(self.idfImageView.frame.origin.x-10, self.idfImageView.frame.origin.y, self.idfImageView.width+20, self.idfImageView.height);
    self.idfImageView.contentMode = UIViewContentModeScaleAspectFill;
    CAShapeLayer *idfBorder = [CAShapeLayer layer];
    idfBorder.strokeColor = HexRGB(0x979797, 0.32f).CGColor;
    idfBorder.fillColor = [UIColor clearColor].CGColor;
    idfBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, idfRect.size.width, idfRect.size.height) cornerRadius:2.0f].CGPath;
    idfBorder.frame = idfRect;
    idfBorder.lineWidth = 1.f;
    idfBorder.lineDashPattern = @[@4, @2];
    [self.view.layer addSublayer:idfBorder];
    
}

- (void)setVerifyModel:(XKVerifyInfoData *)verifyModel{
    _verifyModel = verifyModel;
}

#pragma mark action
- (IBAction)clickForIdZh:(id)sender {

    [[LYLPhotoTailoringTool sharedTool]photoTailoring:^(UIImage *image) {
        [self uploadImage:image andIsFront:YES];
        self.topInfoLabel.hidden = YES;
    }];
}
- (IBAction)clickForIdFan:(id)sender {
    [[LYLPhotoTailoringTool sharedTool]photoTailoring:^(UIImage *image) {
        [self uploadImage:image andIsFront:NO];
        self.bottomInfoLabel.hidden = YES;
    }];
}
- (IBAction)submiteAction:(id)sender {
    if (_nameTextField.text.length == 0) {
        XKShowToast(@"请输入实名");
        return;
    }
    if (![_nameTextField.text isVaildRealName]) {
        XKShowToast(@"请输入合法姓名");
        return;
    }
    if (_idTextField.text.length == 0) {
        XKShowToast(@"请输入证件号码");
        return;
    }
    if (![_idTextField.text checkUserID]) {
        XKShowToast(@"请输入合法身份证号");
        return;
    }
    if (!_param.imgFirst) {
        XKShowToast(@"请上传身份证人物面");
        return;
    }
    if (!_param.imgSecond) {
        XKShowToast(@"请上传身份证国徽面");
        return;
    }
    _param.userId   = [XKAccountManager defaultManager].account.userId;
    _param.realName = _nameTextField.text;
    _param.idCard   = _idTextField.text;
    _param.idType   = @"1";
    _param.mobile   = [[XKFDataService() userService] queryUserInfoFromCacheWithId:_param.userId].mobile;
    [[XKFDataService() userService]verifyWithParams:_param completion:^(XKBaseResponse * _Nonnull response) {
        if ([response isSuccess]) {
            XKShowToast(@"实名认证成功");
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [response showError];
        }
    }];
}

// textField代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // string.length为0，表明没有输入字符，应该是正在删除，应该返回YES。
    if (string.length == 0) {
        return YES;
    }
    // length为当前输入框中的字符长度
    NSUInteger length = textField.text.length + string.length;
    // 如果该页面中还有其他的输入框，则需要做这个判断
    if (textField == self.idTextField) {
        // str为当前输入框中的字符
        NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
        // 当输入到17位数的时候，通过theLastIsX方法判断最后一位是不是X
        if (length == 17 && [self theLastIsX:str]) {
            // 如果是17位，并通过前17位计算出18位为X，自动补全，并返回NO，禁止编辑。
            textField.text = [NSString stringWithFormat:@"%@%@X", textField.text, string];
            return NO;
        }
        // 如果是其他情况则直接返回小于等于18（最多输入18位）
        return length <= 18;
    }
    return YES;
}
// 判断最后一个是不是X
- (BOOL)theLastIsX:(NSString *)IDNumber {
    NSMutableArray *IDArray = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    if (sum % 11 == 2) return YES;
    else return NO;
}

- (void)uploadImage:(UIImage *)image andIsFront:(bool)isFront{
    [XKLoading show];
    @weakify(self);
    UIImageView *imageView = isFront ? self.idzImageView : _idfImageView;
    UIImage *oldImage = [imageView image];
    imageView.image = image;
    NSData *data = UIImagePNGRepresentation(image);
    NSString *folder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:isFront ? @"CardFront" : @"CardBack"];
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
    if (isExist == NO || isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [XKUnitls createUUID];
    XKImageType imageType = [UIImage imageTypeFromData:data];
    if (imageType == XKImageTypeJpg) {
        fileName = [fileName stringByAppendingPathExtension:@"jpg"];
    }else if (imageType == XKImageTypeWebP){
        fileName = [fileName stringByAppendingPathExtension:@"wep"];
    }else if (imageType == XKImageTypeGif){
        fileName = [fileName stringByAppendingPathExtension:@"gif"];
    }else if (imageType == XKImageTypeTiff){
        fileName  =  [fileName stringByAppendingPathExtension:@"tiff"];
    }else{
        fileName =  [fileName stringByAppendingPathExtension:@"png"];
    }
    //将图片保存在本地
    NSString *filePath = [folder stringByAppendingPathComponent:fileName];
    [data writeToFile:filePath atomically:YES];
    [[XKFDataService() userService] uploadWithConstructingBodyBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" error:nil];
    } completion:^(XKBaseResponse * _Nonnull response) {
        @strongify(self);
        [XKLoading dismiss];
        if (response.isSuccess) {
            NSDictionary *dict = (NSDictionary *)[response  data];
            if (isFront) {
                self.param.imgFirst = [dict objectForKey:@"url"];
//                [SVProgressHUD xk_showInfoWithStatus:@"证件照正面上传成功"];
            }else{
                self.param.imgSecond = [dict objectForKey:@"url"];
//                [SVProgressHUD xk_showInfoWithStatus:@"证件照反面上传成功"];
            }
        }else{
            if (imageView && oldImage) {
                imageView.image = oldImage;
            }
            XKShowToast(@"证件照上传失败");
        }
    }];
}

@end
