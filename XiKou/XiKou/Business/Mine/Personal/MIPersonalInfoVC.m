//
//  MIPersonalInfoVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/12.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MIPersonalInfoVC.h"
#import "XKUIUnitls.h"
#import "MIBasicCell.h"
#import "XKAlertController.h"
#import "MIChangeNicknameVC.h"
#import "MIAddressVC.h"
#import <AFNetworking.h>
#import "WXApiManager.h"
#import "MIBindVC.h"
#import "MIReferrerInfoVC.h"
#import "XKCustomAlertView.h"

@import AVFoundation;
@import Photos;

//static NSString *GetImageKey(NSString *userId){
//    return [NSString stringWithFormat:@"avatar_key_%@",userId];
//}

@interface MIPersonalInfoVC ()
<UITableViewDelegate,
UITableViewDataSource,
MIChangeNicknameDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
XKUserServiceDelegate>

@property (nonatomic,strong,readonly)UITableView *tableView;
@property (nonatomic,strong,readonly)UIButton *saveBtn;
@property (nonatomic,strong,readonly)UIImagePickerController *picker;


@end

@implementation MIPersonalInfoVC
{
    XKUserInfoData *_currentUserInfo;
    XKUserInfoData *_changedUserInfo;
}
@synthesize tableView = _tableView;
@synthesize saveBtn = _saveBtn;
@synthesize picker = _picker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    self.hidesBottomBarWhenPushed = YES;
    [self setupUI];
    [self autoLayout];
    [self initDataFromCache];
    [self initDataFromServer];
    [[XKFDataService() userService] addWeakDelegate:self];
    
}

- (void)dealloc{
    [[XKFDataService() userService] removeWeakDelegate:self];
}

#pragma mark UI
- (void)setupUI{
    self.tableView.rowHeight = 60.0f;
    self.tableView.sectionHeaderHeight = 10.0f;
    self.tableView.separatorColor = HexRGB(0xe4e4e4, 1.0f);
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(15.0f, 0, kScreenWidth-30.0f, 0.5f)];
    lineBottom.backgroundColor = HexRGB(0xe4e4e4, 1.0f);
   
    UIView *footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:lineBottom];
    self.tableView.tableFooterView  = footerView;
    [self.tableView registerClass:[MIBasicCell class] forCellReuseIdentifier:@"MIBasicCell"];
    [self.tableView registerClass:[MIBasicAvatarCell class] forCellReuseIdentifier:@"MIBasicAvatarCell"];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.saveBtn];
    self.saveBtn.clipsToBounds = YES;
    self.saveBtn.layer.cornerRadius = 2.0f;
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setBackgroundColor:HexRGB(0x444444, 1.0f)];
    [[self.saveBtn titleLabel] setFont:[UIFont systemFontOfSize:14.0f]];
    [self.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)autoLayout{
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.0f);
        make.right.equalTo(self.view).offset(-20.0f);
        make.height.mas_equalTo(40.0f);
        make.bottom.equalTo(self.view).offset(-(30+[XKUIUnitls safeBottom]));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.mas_equalTo(self.saveBtn.mas_top).mas_offset(-10.0f);
    }];
}

- (void)initDataFromCache{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    _currentUserInfo = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    _changedUserInfo = [_currentUserInfo copy];
}

- (void)initDataFromServer{
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    @weakify(self);
    [[XKFDataService() userService] getUserBasicInfomationWithId:userId completion:^(XKUserInfoResponse * _Nonnull response) {
        @strongify(self);
        if ([response isSuccess]) {//成功
            self->_currentUserInfo = response.data;
            self->_changedUserInfo = [self->_currentUserInfo copy];
            [self.tableView reloadData];
        }else{
            [response showError];
        }
    }];
}

#pragma mark tableView data source or delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
         MIBasicAvatarCell *cell = (MIBasicAvatarCell *)[tableView dequeueReusableCellWithIdentifier:@"MIBasicAvatarCell" forIndexPath:indexPath];
        cell.textLabel.text = @"头像";
        if (_changedUserInfo.userType.intValue == XKUserTypeVIP) {
            cell.detailTextLabel.text = @"喜扣会员";
        }else{
            cell.detailTextLabel.text = @"普通用户";
        }
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_currentUserInfo.headUrl] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MIBasicCell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"用户ID";
            cell.detailTextLabel.text = _currentUserInfo.id;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"昵称";
            cell.detailTextLabel.text = _currentUserInfo.nickName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"性别";
            if (_changedUserInfo.sex.intValue == XKSexTypeMale) {
                cell.detailTextLabel.text = @"男";
            }else if (_changedUserInfo.sex.intValue == XKSexTypeFemale){
                cell.detailTextLabel.text = @"女";
            }else{
                cell.detailTextLabel.text = @"请选择";
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else if (indexPath.row == 4){
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = _changedUserInfo.mobile;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else if (indexPath.row == 5){
            cell.textLabel.text = @"微信号";
            if (_changedUserInfo.isBindWX) {
                cell.detailTextLabel.text = @"已绑定";
            }else{
                cell.detailTextLabel.text = @"未绑定";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else if (indexPath.row == 6){
            cell.textLabel.text = @"推荐人信息";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }else{
            cell.textLabel.text = @"地址管理";
            cell.detailTextLabel.text = @"无";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
         return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80.0f;
    }else{
        return 60.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//头像
        XKAlertController *controller = [XKAlertController alertControllerWithTitle:nil message:@"修改头像" preferredStyle:UIAlertControllerStyleActionSheet];
        
        XKAlertAction *takePhoto = [XKAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkCameraPermission];
        }];
        XKAlertAction *photos = [XKAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkAlbumPermission];
        }];
        
        XKAlertAction *cancel = [XKAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:takePhoto];
        [controller addAction:photos];
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
    }else if (indexPath.row == 2){//昵称
        MIChangeNicknameVC *controller = [[MIChangeNicknameVC alloc] initWithDelegate:self];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 3){//性别
        XKAlertController *controller = [XKAlertController alertControllerWithTitle:nil message:@"选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
        @weakify(self);
        XKAlertAction *male = [XKAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            self->_changedUserInfo.sex = @(XKSexTypeMale);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = @"男";
        }];
        XKAlertAction *female = [XKAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
             self->_changedUserInfo.sex = @(XKSexTypeFemale);
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = @"女";
        }];
        
        XKAlertAction *cancel = [XKAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:male];
        [controller addAction:female];
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
    }else if (indexPath.row == 4){//手机号
        
    }else if (indexPath.row == 5){//微信号
        if (self->_changedUserInfo.isBindWX == NO) {
            [self bindWeXin];
        }else{
            [self unBindWeXin];
        }
    }else if (indexPath.row == 6){//推荐人信息
        [self.navigationController pushViewController:[MIReferrerInfoVC new] animated:YES];
    }else if (indexPath.row == 7){//地址管理
        [self.navigationController pushViewController:[MIAddressVC new] animated:YES];
    }
}

- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    if (self->_changedUserInfo) {
        self->_changedUserInfo.isBindWX = YES;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        if (cell) {
            if (_changedUserInfo.isBindWX) {
                cell.detailTextLabel.text = @"已绑定";
            }else{
                cell.detailTextLabel.text = @"未绑定";
            }
        }
    }
}

//- (void)queryUserBasicInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData{
//    if (self->_changedUserInfo) {
//        self->_changedUserInfo.isBindWX = userInfoData.isBindWX;
//         UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
//        if (cell) {
//            if (_changedUserInfo.isBindWX) {
//                cell.detailTextLabel.text = @"已绑定";
//            }else{
//                cell.detailTextLabel.text = @"未绑定";
//            }
//        }
//    }
//}

#pragma mark action
- (void)saveAction:(id)sender{
    [XKLoading show];
    NSString *userId = [[[XKAccountManager defaultManager] account] userId];
    XKModifyUserVoParams *params = [[XKModifyUserVoParams alloc] init];
    //if (![_currentUserInfo.headUrl isEqualToString:_changedUserInfo.headUrl]) {
        params.headUrl = _changedUserInfo.headUrl;
    //}
   // if (![_currentUserInfo.nickName isEqualToString:_changedUserInfo.nickName]) {
        params.nickName = _changedUserInfo.nickName;
   // }
   // if ([_currentUserInfo.sex intValue] != [_changedUserInfo.sex intValue]) {
        params.sex = _changedUserInfo.sex;
   // }
    if (![_currentUserInfo.barthday isEqualToString:_changedUserInfo.barthday]) {
        params.barthday = _changedUserInfo.barthday;
    }
    XKUserInfoData *userInfoData = [[XKFDataService() userService] queryUserInfoFromCacheWithId:userId];
    params.mobile = userInfoData.mobile;
    params.id = userId;
    [[XKFDataService() userService] modifyUserInfomation:params withUserId:userId completion:^(XKBaseResponse * _Nonnull response) {
        [XKLoading dismiss];
        if ([response isSuccess]) {//成功
            XKShowToast(@"保存成功");
        }else{
            [response showError];
        }
    }];
}

- (void)uploadImage:(UIImage *)image{
    [XKLoading showNeedMask:YES];
    @weakify(self);
    MIBasicAvatarCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImage *oldImage = [cell.imageView image];
    cell.imageView.image = image;
    NSData *data = UIImagePNGRepresentation(image);
    NSString *folder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Avatar"];
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
            self->_changedUserInfo.headUrl = [dict objectForKey:@"url"];
        }else{
            XKShowToast(@"上传头像失败");
            MIBasicAvatarCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if (cell && oldImage) {
                cell.imageView.image = oldImage;
            }
        }
    }];
}

- (void)bindWeXin{
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        @weakify(self);
        NSString *appId = [[WXApiManager defaultManager] appKey];
        [[WXApiManager defaultManager] getCodeCompletion:^(NSString * _Nonnull code, NSError * _Nonnull error) {
            if (error == nil && code) {
                [[XKFDataService() userService] loginWithWXAppid:appId code:code completion:^(XKCodeResponse * _Nonnull response) {
                    @strongify(self);
                    if ([response isSuccess]) {//成功
                        XKShowToast(@"绑定成功");
                        self->_changedUserInfo.isBindWX = YES;
                        [self.tableView reloadData];
                    }else if (response.code.intValue == CodeStatus_WeChatNotBind){
                        MIBindVC *controller = [[MIBindVC alloc] initWithThirdId:response.msg type:XKThirdPlatformTypeWeXin];
                        [self.navigationController pushViewController:controller animated:YES];
                    }else{
                        [response showError];
                    }
                }];
            }else{
                XKShowToast(error.domain);
            }
        }];
    }else{
        //提示：未安装微信应用或版本过低
        XKShowToast(@"未安装微信应用或版本过低");
    }
}

- (void)unBindWeXin{
    XKCustomAlertView *alertView = [[XKCustomAlertView alloc] initWithType:CanleAndTitle andTitle:@"提示" andContent:@"为保证账户安全，90天内只可解绑 一次账户，确认要解绑吗?" andBtnTitle:@"确定"];
    [alertView setSureBlock:^{
        NSString *userId = [[XKAccountManager defaultManager] userId];
        [XKLoading show];
        @weakify(self);
        [[XKFDataService() userService] unBindThirdRelationWithUserId:userId type:XKThirdPlatformTypeWeXin completion:^(XKBaseResponse * _Nonnull response) {
            @strongify(self);
            [XKLoading dismiss];
            if ([response isSuccess]) {//成功
                XKShowToast(@"解绑成功");
                self->_changedUserInfo.isBindWX = NO;
                [self.tableView reloadData];
            }else{
                [response showError];
            }
        }];
    }];
    [alertView show];
}


#pragma mark MIChangeNicknameDelegate
- (void)viewController:(UIViewController *)viewController nickName:(NSString *)nickName{
    if (![NSString isNull:_currentUserInfo.nickName]  || ![nickName isEqualToString:_currentUserInfo.nickName]) {
        _changedUserInfo.nickName = nickName;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if (cell) {
            cell.detailTextLabel.text = nickName;
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat width = editedImage.size.width;
        CGFloat height = editedImage.size.height;
        if (width != height) {
            CGFloat w = 0,x = 0,y = 0;
            if (width > height) {
                w = height;
                x = (width - height)/2.0f;
                y = 0;
            }else{
                w = width;
                x = 0;
                y = (height - width)/2.0f;
            }
            editedImage = [UIImage imageWithImage:editedImage cutToRect:CGRectMake(x, y, w, w)];
            editedImage = [UIImage imageWithImage:editedImage ratioToSize:CGSizeMake(60.0f, 60.0f)];
        }
        [self uploadImage:editedImage];
    });
}

- (void)checkCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self takePhoto];
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self alertCamera];
    } else {
        [self takePhoto];
    }
}

- (void)takePhoto {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    } else {
        NSLog(@"不能使用模拟器进行拍照");
    }
}

#pragma mark - Album
- (void)checkAlbumPermission {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self selectAlbum];
                }
            });
        }];
    } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        [self alertAlbum];
    } else {
        [self selectAlbum];
    }
}

- (void)selectAlbum {
    //判断相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}

- (void)alertCamera {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)alertAlbum {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}





#pragma mark getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //_tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _saveBtn;
}

- (UIImagePickerController *)picker{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.allowsEditing = YES;
        _picker.delegate = self;
    }
    return _picker;
}


@end
