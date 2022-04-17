//
//  HMQRVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "HMQRVC.h"
#import "XKWeakProxy.h"
#import "XKQRCode.h"
#import "XKQRWhiteList.h"
#import "HMQRInfoVC.h"

@import AVFoundation;
@import Photos;

static const CGFloat kScanAreaWidth     =    260.f;
static const CGFloat kScanAreaHeight    =    260.f;

static const float kBrightnessThresholdValue    =    0.2f;

@interface HMQRVC ()
<AVCaptureMetadataOutputObjectsDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate,
AVCapturePhotoCaptureDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic, assign)CGRect rectScan;
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureDeviceInput *input;
@property (nonatomic,strong)AVCaptureMetadataOutput *output;
@property (nonatomic,strong)AVCaptureVideoDataOutput *lightOutput;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic,strong)AVCapturePhotoOutput *photoOutput;//拍照

@property (strong,nonatomic,readonly)NSTimer *timer;

@property (strong,nonatomic,readonly)CAShapeLayer *shapeLayer;

@property (strong,nonatomic,readonly)UIImageView *scanImageView;

@property (strong,nonatomic,readonly)UIImageView *line;

@property (strong,nonatomic,readonly)UILabel *hintLabel;

@property (strong,nonatomic,readonly)UILabel *hintLightLabel;

@property (strong,nonatomic,readonly)UIImagePickerController *ipc;

@end

@implementation HMQRVC{
    BOOL _up;
    BOOL lightOn;
    BOOL amp;
}
@synthesize timer = _timer;
@synthesize shapeLayer = _shapeLayer;
@synthesize scanImageView = _scanImageView;
@synthesize line = _line;
@synthesize hintLabel = _hintLabel;
@synthesize hintLightLabel = _hintLightLabel;
@synthesize ipc = _ipc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫描二维码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(actionForRecognise)];
    [self configDevice];
   
    [self setupUI];
    [self startTimer];
    
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self.view addGestureRecognizer:singleGesture];
    
    if ([self.device hasTorch]) {
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleGesture.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:doubleGesture];
        [singleGesture requireGestureRecognizerToFail:doubleGesture];
    }
}

- (void)dealloc{
    if (self.device.isTorchActive) {
        [self turnOff];
    }
}

- (void)setupUI{
    [self setNavigationBarStyle:XKNavigationBarStyleTranslucent];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *hollowPath = [UIBezierPath bezierPathWithRect:self.rectScan];
    [path appendPath:hollowPath];
    path.usesEvenOddFillRule = YES;
    self.shapeLayer.path = [path CGPath];
    [self.view.layer addSublayer:self.shapeLayer];
    self.scanImageView.frame = self.rectScan;
    [self.view addSubview:self.scanImageView];
    [self.view addSubview:self.line];
    self.hintLabel.frame = CGRectMake(CGRectGetMinX(self.rectScan), CGRectGetMaxY(self.rectScan)+10, CGRectGetWidth(self.rectScan), 15.0f);
    [self.view addSubview:self.hintLabel];
    
    self.hintLightLabel.frame = CGRectMake(CGRectGetMinX(self.hintLabel.frame), CGRectGetMaxY(self.hintLabel.frame)+10, CGRectGetWidth(self.hintLabel.frame), 15.0f);
    [self.view addSubview:self.hintLightLabel];
}

- (void)configDevice{
    //默认使用后置摄像头进行扫描,使用AVMediaTypeVideo表示视频
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //设备输入 初始化
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //设备输出 初始化，并设置代理和回调，当设备扫描到数据时通过该代理输出队列，一般输出队列都设置为主队列，也是设置了回调方法执行所在的队列环境
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置视频输出，检测当前光线
    self.lightOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.lightOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    if (@available(iOS 10.0, *)) {
        // 图片输出格式,如果支持使用HEIF(HEIC)那么使用,否则使用JPEG
        NSDictionary *format = @{AVVideoCodecKey: AVVideoCodecJPEG};
        NSArray<AVVideoCodecType> *availablePhotoCodecTypes = self.photoOutput.availablePhotoCodecTypes;
        if (@available(iOS 11.0, *)) {
            if ([availablePhotoCodecTypes containsObject:AVVideoCodecHEVC]) {
                format = @{AVVideoCodecKey: AVVideoCodecHEVC};
            }
        }
//        AVCapturePhotoSettings *avSettings = [AVCapturePhotoSettings photoSettingsWithFormat:format];
//        avSettings.autoStillImageStabilizationEnabled = YES;//默认值就是yes
//        avSettings.flashMode = AVCaptureFlashModeOff;//关闭闪光灯
        self.photoOutput = [[AVCapturePhotoOutput alloc] init];
        //[self.photoOutput capturePhotoWithSettings:avSettings delegate:self];
    }
   
    
    //会话 初始化，通过 会话 连接设备的 输入 输出，并设置采样质量为 高
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //会话添加设备的 输入 输出，建立连接
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    if([self.session canAddOutput:self.lightOutput]){
        [self.session addOutput:self.lightOutput];
    }
    if ([self.session canAddOutput:self.photoOutput]) {
        [self.session addOutput:self.photoOutput];
    }
    
    //指定设备的识别类型 这里只指定二维码识别这一种类型 AVMetadataObjectTypeQRCode
    //指定识别类型这一步一定要在输出添加到会话之后，否则设备的课识别类型会为空，程序会出现崩溃
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Preview
    self.preview =[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    /*设置自动对焦和白平衡*/
    //  [self setAutoFocusAndWhiteBalance];
    [self.session startRunning];
    
    @weakify(self);
    id __block token = nil;
    token =  [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self);
        CGRect interest = [self.preview metadataOutputRectOfInterestForRect:self.rectScan];
        if (interest.size.width != 0.0 && interest.size.height != 0.0) {
            self.output.rectOfInterest = interest;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:token];
    }];
}

- (void)stopScanning{
    [self pauseTimer];
    [self.session stopRunning];
}

- (void)startScanning{
    [self startTimer];
    [self.session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue = nil;
    if ([metadataObjects count] >0){
        NSArray *tempObjects = [NSArray arrayWithArray:metadataObjects];
        for (id obj in tempObjects) {
            if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                AVMetadataMachineReadableCodeObject *metadataObject = (AVMetadataMachineReadableCodeObject *)obj;
                stringValue = metadataObject.stringValue;
                break;
            }
        }
    }
    if ([NSString isNull:stringValue]) return;
    [self stopScanning];
    NSLog(@"扫描信息:%@",stringValue);
    [self dealString:stringValue];
}

#pragma AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    NSLog(@"当前亮度值 : %f",brightnessValue);
    if (brightnessValue < kBrightnessThresholdValue && [self.device isTorchActive] == NO) {
        self.hintLightLabel.hidden = NO;
    }else{
        self.hintLightLabel.hidden = YES;
    }
}


/**
 * 改变设备属性的统一操作方法
 */
- (void)changeDeviceProperty:(void(^)(AVCaptureDevice *device))block{
    AVCaptureDevice *captureDevice = [self.input device];
    NSError *error = nil;
    if ([captureDevice lockForConfiguration:&error]) {//注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
        if(block)block(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/*设置自动对焦和白平衡*/
- (void)setAutoFocusAndWhiteBalance{
    [self changeDeviceProperty:^(AVCaptureDevice *device) {
        //自动对焦
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        //设置白平衡
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //曝光模式
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
    }];
}

/*设置手动对焦*/
- (void)setFocusPointOfInterest:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *device) {
        /*设置聚焦点*/
        CGPoint cameraPoint= [self.preview captureDevicePointOfInterestForPoint:point];
        if ([device isFocusPointOfInterestSupported]) {
            [device setFocusPointOfInterest:cameraPoint];
        }
//        //自动对焦
//        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
//            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
//        }
        //曝光点的位置
        if ([self.device isExposurePointOfInterestSupported]) {
            [self.device setExposurePointOfInterest:cameraPoint];
        }
//        //曝光模式
//        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
//            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
//        }
        //设置白平衡
        if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
    }];
}

- (void)setVideoAmpScale:(BOOL)amp{
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    [self.input.device lockForConfiguration:nil];
    CGFloat scale = 1.0f;
    if (amp) {
        scale = 2.0f;
    }else{
        scale = 1.0f;
    };
    
    //获取放大最大倍数
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.photoOutput connections]];
    CGFloat maxScaleAndCropFactor = ([videoConnection videoMaxScaleAndCropFactor])/16;
    if (scale > maxScaleAndCropFactor)
        scale = maxScaleAndCropFactor;
    videoConnection.videoScaleAndCropFactor = scale;
    
    [self.input.device unlockForConfiguration];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3f];
    self.preview.transform = CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0f);
    [CATransaction commit];
}



- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections{
    for ( AVCaptureConnection *connection in connections ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [[port mediaType] isEqual:mediaType] ) {
                return connection;
            }
        }
    }
    return nil;
}

#pragma mark 相册
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        NSString *imei = [XKQRCode parseCodeFromImage:image];
        NSLog(@"识别二维码:%@",imei);
        if ([NSString isNull:imei] == NO) {
            [self dealString:imei];
        }
    }];
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
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.ipc animated:YES completion:nil];
    }
}


- (void)alertAlbum {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)animationScanning{
    if (_up) {
        _line.y -= 1;
        if (_line.y<=CGRectGetMinY(self.rectScan)) {
            _up = NO;
        }
    }else{
        _line.y += 1;
        if (_line.y>=CGRectGetMaxY(self.rectScan)) {
            _up = YES;
        }
    }
}

- (void)singleTapAction:(UIGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    if(!CGRectContainsPoint(self.rectScan, point)){
        amp = !amp;
        [self setVideoAmpScale:amp];
    }else{
        [self setFocusPointOfInterest:point];
    }
}

- (void)doubleTapAction:(UIGestureRecognizer *)gesture{
    if (lightOn) {
        lightOn = NO;
        [self turnOff];
    }else{
        lightOn = YES;
        [self turnOn];
    }
}

- (void)startTimer{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)pauseTimer{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)turnOn{
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode:AVCaptureTorchModeOn];
    [self.device unlockForConfiguration];
}

-(void)turnOff{
    [self.device lockForConfiguration:nil];
    [self.device setTorchMode: AVCaptureTorchModeOff];
    [self.device unlockForConfiguration];
}

- (void)dealString:(NSString *)string{
    if ([NSString isNull:string]) return;
    if ([XKGlobalModuleRouter isValidScheme:string]) {
        [MGJRouter openURL:string];
    }else if ([string isUrl]){
        if(NO == [[XKQRWhiteList sharedInstance] handleIt:string]){
            if([string containsString:@"luluxk.com"]){
                [MGJRouter openURL:kRouterWeb withUserInfo:@{@"url":string} completion:nil];
            }else{
                if (@available(iOS 10.0,*)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:@{} completionHandler:nil];
                }else{
                    [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:string]];
                }
            }
        }
    }else{
        HMQRInfoVC *controller = [[HMQRInfoVC alloc] initWithText:string];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [self.rt_navigationController removeViewController:self];
}


#pragma mark action
- (void)actionForRecognise{
    [self checkAlbumPermission];
}

#pragma mark - getters and setters
- (NSTimer *)timer{
    if (!_timer) {
         _timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:[XKWeakProxy proxyWithTarget:self] selector:@selector(animationScanning) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (CGRect)rectScan{
    return CGRectMake(CGRectGetMidX(self.view.bounds)-kScanAreaWidth*0.5f, CGRectGetMidY(self.view.bounds)-kScanAreaHeight*0.5f, kScanAreaWidth, kScanAreaHeight);
}

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [HexRGB(0x0, 0.3) CGColor];
        _shapeLayer.fillRule = kCAFillRuleEvenOdd;
    }
    return _shapeLayer;
}

- (UIImageView *)scanImageView{
    if (!_scanImageView) {
        UIImage *imageScan = [UIImage imageNamed:@"land_scanning_box"];
        imageScan = [imageScan stretchableImageWithLeftCapWidth:imageScan.size.width/2 topCapHeight:imageScan.size.height/2];
        _scanImageView = [[UIImageView alloc] initWithImage:imageScan];
    }
    return _scanImageView;
}

- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"land_scanning_wire"]];
        _line.x = self.rectScan.origin.x;
        _line.y = self.rectScan.origin.y;
      //  _line.height = 3;
        _line.width = self.rectScan.size.width;
    }
    return _line;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.textColor = HexRGB(0xffffff, 1.0f);
        _hintLabel.font = [UIFont systemFontOfSize:12.0f];
        _hintLabel.text = @"将二维码/条码放入框内,即可自动扫描";
        _hintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLabel;
}

- (UILabel *)hintLightLabel{
    if (!_hintLightLabel) {
        _hintLightLabel = [[UILabel alloc] init];
        _hintLightLabel.textColor = COLOR_TEXT_BROWN;
        _hintLightLabel.font = [UIFont systemFontOfSize:15.0f];
        _hintLightLabel.text = @"双击屏幕点亮";
        _hintLightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLightLabel;
}

- (UIImagePickerController *)ipc{
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.delegate = self;
    }
    return _ipc;
}


@end
