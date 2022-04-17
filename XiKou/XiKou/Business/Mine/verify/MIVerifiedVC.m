//
//  MIVerifiedVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/5.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIVerifiedVC.h"
#import "MIVerifyVC.h"

@interface MIVerifiedVC ()<XKUserServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fanImageView;
- (IBAction)verifyAction:(id)sender;

@end

@implementation MIVerifiedVC
{
    XKVerifyInfoData *_dataModel;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的认证";
    UIScrollView *scrollview = nil;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollview = (UIScrollView *)view;
            break;
        }
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    CGRect idZRect = CGRectMake(self.zhImageView.frame.origin.x-5, self.zhImageView.frame.origin.y-5, self.zhImageView.width+10, self.zhImageView.height+10);
    self.zhImageView.contentMode = UIViewContentModeScaleAspectFill;
    CAShapeLayer *idzBorder = [CAShapeLayer layer];
    idzBorder.strokeColor = HexRGB(0x979797, 0.32f).CGColor;
    idzBorder.fillColor = [UIColor clearColor].CGColor;
    idzBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, idZRect.size.width, idZRect.size.height) cornerRadius:2.0f].CGPath;
    idzBorder.frame = idZRect;
    idzBorder.lineWidth = 1.f;
    idzBorder.lineDashPattern = @[@4, @2];
    if (scrollview) {
        [scrollview.layer addSublayer:idzBorder];
    }else{
        [self.zhImageView.layer addSublayer:idzBorder];
    }
    CGRect idFRect = CGRectMake(self.fanImageView.frame.origin.x-5, self.fanImageView.frame.origin.y-5, self.fanImageView.width+10, self.fanImageView.height+10);
    self.fanImageView.contentMode = UIViewContentModeScaleAspectFill;
    CAShapeLayer *idfBorder = [CAShapeLayer layer];
    idfBorder.strokeColor = HexRGB(0x979797, 0.32f).CGColor;
    idfBorder.fillColor = [UIColor clearColor].CGColor;
    idfBorder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, idFRect.size.width, idFRect.size.height) cornerRadius:2.0f].CGPath;
    idfBorder.frame = idFRect;
    idfBorder.lineWidth = 1.f;
    idfBorder.lineDashPattern = @[@4, @2];
    if (scrollview) {
        [scrollview.layer addSublayer:idfBorder];
    }else{
        [self.fanImageView.layer addSublayer:idfBorder];
    }
    [[XKFDataService() userService] addWeakDelegate:self];
    [self getVerifyInfo];
}

- (void)verifySuccessWithSevice:(XKUserService *)service userId:(NSString *)userId{
    [self getVerifyInfo];
}


- (void)getVerifyInfo{
    [[XKFDataService() userService]getVerifyInfoWithUserId:[XKAccountManager defaultManager].account.userId completion:^(XKVerifyInfoResponse * _Nonnull response) {
        if ([response isSuccess]) {
            [self reloadInfo:response.data];
        }else{
            XKShowToast(@"获取认证信息失败，请退出重试");
        }
    }];
}

- (void)reloadInfo:(XKVerifyInfoData *)param{
    _dataModel        = param;
    _nameLabel.text   = param.realName;
    NSMutableString *idCard = [NSMutableString string];
    [param.idCard enumerateSubstringsInRange:NSMakeRange(0, param.idCard.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (substringRange.location <= 1 || substringRange.location >= param.idCard.length-2) {
            [idCard appendString:substring];
        }else{
            [idCard appendString:@"*"];
        }
        
    }];
    _idLabel.text     = idCard;
    _statusLabel.text = @"已通过认证";
    _timeLabel.text   = param.createTime;
    [_zhImageView sd_setImageWithURL:[NSURL URLWithString:param.imgFirst] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
    [_fanImageView sd_setImageWithURL:[NSURL URLWithString:param.imgSecond] placeholderImage:[UIImage imageNamed:kPlaceholderImg]];
}

- (IBAction)verifyAction:(id)sender {

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    MIVerifyVC *vc = [story instantiateViewControllerWithIdentifier:@"MIVerifyVC"];
    vc.verifyModel = _dataModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc{
    [[XKFDataService() userService]removeWeakDelegate:self];
}
@end
