//
//  AVCaptureViewController.m
//  实时视频Demo
//
//  Created by HanJunqiang on 2017/2/16.
//  Copyright © 2017年 HaRi. All rights reserved.
//  身份证-正面

#import "AVCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LHSIDCardScaningView.h"
#import "UIImage+Extend.h"
#import "RectManager.h"
#import "UIAlertController+Extend.h"
#import "JQIDCardScaningView.h"

@interface AVCaptureViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

// 摄像头设备
@property (nonatomic,strong) AVCaptureDevice *device;

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong) AVCaptureSession *session;

// 输出格式
@property (nonatomic,strong) NSNumber *outPutSetting;

// 出流对象
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;

// 元数据（用于人脸识别）
@property (nonatomic,strong) AVCaptureMetadataOutput *metadataOutput;

// 预览图层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

// 人脸检测框区域
@property (nonatomic,assign) CGRect faceDetectionFrame;

// 队列
@property (nonatomic,strong) dispatch_queue_t queue;

// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;

@property (nonatomic,strong) UIButton *flashButton;
@property (nonatomic,strong) UIImage *captureImage;

@end

@implementation AVCaptureViewController

#pragma mark - 检测是模拟器还是真机
#if TARGET_IPHONE_SIMULATOR
// 是模拟器的话，提示“请使用真机测试！！！”
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫描身份证";
    
    __weak __typeof__(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"模拟器没有摄像设备" message:@"请使用真机测试！！！" okAction:okAction cancelAction:nil];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

#else

#pragma mark - 懒加载
#pragma mark device
-(AVCaptureDevice *)device {
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            if ([_device isSmoothAutoFocusSupported]) {// 平滑对焦
                _device.smoothAutoFocusEnabled = YES;
            }
            
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {// 自动持续对焦
                _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) {// 自动持续曝光
                _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }
            
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {// 自动持续白平衡
                _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            }
            
//            NSError *error1;
//            CMTime frameDuration = CMTimeMake(1, 30); // 默认是1秒30帧
//            NSArray *supportedFrameRateRanges = [_device.activeFormat videoSupportedFrameRateRanges];
//            BOOL frameRateSupported = NO;
//            for (AVFrameRateRange *range in supportedFrameRateRanges) {
//                if (CMTIME_COMPARE_INLINE(frameDuration, >=, range.minFrameDuration) && CMTIME_COMPARE_INLINE(frameDuration, <=, range.maxFrameDuration)) {
//                    frameRateSupported = YES;
//                }
//            }
//
//            if (frameRateSupported && [self.device lockForConfiguration:&error1]) {
//                [_device setActiveVideoMaxFrameDuration:frameDuration];
//                [_device setActiveVideoMinFrameDuration:frameDuration];
////                [self.device unlockForConfiguration];
//            }
            
            [_device unlockForConfiguration];
        }
    }
    
    return _device;
}

#pragma mark outPutSetting
-(NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    }
    
    return _outPutSetting;
}

#pragma mark metadataOutput
-(AVCaptureMetadataOutput *)metadataOutput {
    if (_metadataOutput == nil) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        
        [_metadataOutput setMetadataObjectsDelegate:self queue:self.queue];
    }
    
    return _metadataOutput;
}

#pragma mark videoDataOutput
-(AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:self.outPutSetting};
    }
    
    return _videoDataOutput;
}

#pragma mark session
-(AVCaptureSession *)session {
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        // 2、设置输入：由于模拟器没有摄像头，因此最好做一个判断
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        if (error) {
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [self alertControllerWithTitle:@"没有摄像设备" message:error.localizedDescription okAction:okAction cancelAction:nil];
        }else {
            if ([_session canAddInput:input]) {
                [_session addInput:input];
            }
            
            if ([_session canAddOutput:self.videoDataOutput]) {
                [_session addOutput:self.videoDataOutput];
            }
            
            if ([_session canAddOutput:self.metadataOutput]) {
                [_session addOutput:self.metadataOutput];
                // 输出格式要放在addOutPut之后，否则奔溃
                self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
            }
        }
    }
    
    return _session;
}

#pragma mark previewLayer
-(AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        _previewLayer.frame = self.view.frame;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewLayer;
}

#pragma mark queue
-(dispatch_queue_t)queue {
    if (_queue == nil) {
//        _queue = dispatch_queue_create("AVCaptureSession_Start_Running_Queue", DISPATCH_QUEUE_SERIAL);
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return _queue;
}

#pragma mark - 运行session
// session开始，即输入设备和输出设备开始数据传递
- (void)runSession {
    if (![self.session isRunning]) {
        dispatch_async(self.queue, ^{
            [self.session startRunning];
        });
    }
}

#pragma mark - 停止session
// session停止，即输入设备和输出设备结束数据传递
-(void)stopSession {
    if ([self.session isRunning]) {
        dispatch_async(self.queue, ^{
            [self.session stopRunning];
        });
    }
}

#pragma mark - 打开／关闭手电筒
-(void)turnOnOrOffTorch {
    self.torchOn = !self.isTorchOn;
    
    if ([self.device hasTorch]){ // 判断是否有闪光灯
        [self.device lockForConfiguration:nil];// 请求独占访问硬件设备
        
        if (self.isTorchOn) {
            [self.flashButton setImage:[UIImage imageNamed:@"nav_torch_on"] forState:UIControlStateNormal];
            [self.device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [self.flashButton setImage:[UIImage imageNamed:@"nav_torch_off"] forState:UIControlStateNormal];
            [self.device setTorchMode:AVCaptureTorchModeOff];
        }
        [self.device unlockForConfiguration];// 请求解除独占访问硬件设备
    }else {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [self alertControllerWithTitle:@"提示" message:@"您的设备没有闪光设备，不能提供手电筒功能，请检查" okAction:okAction cancelAction:nil];
    }
}

#pragma mark - view即将出现时
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 将AVCaptureViewController的navigationBar调为透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 每次展现AVCaptureViewController的界面时，都检查摄像头使用权限
    [self checkAuthorizationStatus];
    
    // rightBarButtonItem设为原样
    self.torchOn = NO;
}

#pragma mark - view即将消失时
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 将AVCaptureViewController的navigationBar调为不透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self stopSession];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // 添加预览图层
    [self.view.layer addSublayer:self.previewLayer];
    
    // 添加自定义的扫描界面（中间有一个镂空窗口和来回移动的扫描线）
    LHSIDCardScaningView *IDCardScaningView = [[LHSIDCardScaningView alloc] initWithFrame:self.view.frame andType:self.type];
    self.faceDetectionFrame = IDCardScaningView.facePathRect;
    [self.view addSubview:IDCardScaningView];
    
    // 设置人脸扫描区域
    /*
     
     为什么做人脸扫描？
       
     经实践证明，由于预览图层是全屏的，当用户有时没有将身份证对准拍摄框边缘时，也会成功读取身份证上的信息，即也会捕获到不完整的身份证图像。
     因此，为了截取到比较完整的身份证图像，在自定义扫描界面的合适位置上加了一个身份证头像框，让用户将该小框对准身份证上的头像，最终目的是使程序截取到完整的身份证图像。
     当该小框检测到人脸时，再对比人脸区域是否在这个小框内，若在，说明用户的确将身份证头像放在了这个框里，那么此时这一帧身份证图像大小正好合适且完整，接下来才捕获该帧，就获得了完整的身份证截图。（若不在，那么就不捕获此时的图像）
    
     理解：检测身份证上的人脸是为了获得证上的人脸区域，获得人脸区域是为了希望人脸区域能在小框内，这样的话，才截取到完整的身份证图像。
     
     个人认为：有了文字、拍摄区域的提示，99%的用户会主动将身份证和拍摄框边缘对齐，就能够获得完整的身份证图像，不做人脸区域的检测也可以。。。
    
     ps: 如果你不想加入人脸识别这一功能，你的app无需这么精细的话或者你又想读取到身份证反面的信息（签发机关，有效期），请这样做：
     
     1、请注释掉所有metadataOutput的代码及其下面的那个代理方法（-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection）
     
     2、请在videoDataOutput的懒加载方法的if(_videoDataOutput == nil){}语句块中添加[_videoDataOutput setSampleBufferDelegate:self queue:self.queue];
     
     3、请注释掉AVCaptureVideoDataOutputSampleBufferDelegate下的那个代理方法中的
     if (self.videoDataOutput.sampleBufferDelegate) {
         [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
     }
     
     4、运行程序，身份证正反两面皆可被检测到，请查看打印的信息。
     
     */
//    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification* _Nonnull note) {
//        __weak __typeof__(self) weakSelf = self;
        self.metadataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:IDCardScaningView.facePathRect];
//    }];
    
    // 添加闪光灯等按钮
    [self addOtherButtons];
    
}

#pragma mark - 添加闪光灯等按钮
-(void)addOtherButtons {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kStatusBarHeight+40);
    }];
    
    UIButton *flashBtn = [[UIButton alloc] init];
    [flashBtn setImage:[UIImage imageNamed:@"nav_torch_off"] forState:UIControlStateNormal];
    [topView addSubview:flashBtn];
    flashBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(49, 49));
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(150*PX_WIDTH+kButton_bottom);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
    [bottomView addSubview:sureBtn];
    sureBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(49, 49));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-kButton_bottom-10);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bottomView addSubview:closeBtn];
    [closeBtn sizeToFit];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(sureBtn);
    }];
    
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [flashBtn addTarget:self action:@selector(turnOnOrOffTorch) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 绑定“关闭按钮”的方法
-(void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sure {
    //传回图片
    if (self.captureImage) {
        _myBlock(self.captureImage);
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [Utils toastview:@"未扫描到图片"];
    }
    
}

#pragma mark - 检测摄像头权限
-(void)checkAuthorizationStatus {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:[self showAuthorizationNotDetermined]; break;// 用户尚未决定授权与否，那就请求授权
        case AVAuthorizationStatusAuthorized:[self showAuthorizationAuthorized]; break;// 用户已授权，那就立即使用
        case AVAuthorizationStatusDenied:[self showAuthorizationDenied]; break;// 用户明确地拒绝授权，那就展示提示
        case AVAuthorizationStatusRestricted:[self showAuthorizationRestricted]; break;// 无法访问相机设备，那就展示提示
        }
}

#pragma mark - 相机使用权限处理
#pragma mark 用户还未决定是否授权使用相机
-(void)showAuthorizationNotDetermined {
    __weak __typeof__(self) weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        granted? [weakSelf runSession]: [weakSelf showAuthorizationDenied];
    }];
}

#pragma mark 被授权使用相机
-(void)showAuthorizationAuthorized {
    [self runSession];
}

#pragma mark 未被授权使用相机
-(void)showAuthorizationDenied {
    NSString *title = @"相机未授权";
    NSString *message = @"请到系统的“设置-隐私-相机”中授权此应用使用您的相机";
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 跳转到该应用的隐私设授权置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];

    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
}

#pragma mark 使用相机设备受限
-(void)showAuthorizationRestricted {
    NSString *title = @"相机设备受限";
    NSString *message = @"请检查您的手机硬件或设置";
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:nil];
}

#pragma mark - 展示UIAlertController
-(void)alertControllerWithTitle:(NSString *)title message:(NSString *)message okAction:(UIAlertAction *)okAction cancelAction:(UIAlertAction *)cancelAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
#pragma mark 从输出的元数据中捕捉人脸
// 检测人脸是为了获得“人脸区域”，做“人脸区域”与“身份证人像框”的区域对比，当前者在后者范围内的时候，才能截取到完整的身份证图像
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        
        AVMetadataObject *transformedMetadataObject = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        CGRect faceRegion = transformedMetadataObject.bounds;
        
        if (metadataObject.type == AVMetadataObjectTypeFace) {
            NSLog(@"是否包含头像：%d, facePathRect: %@, faceRegion: %@",CGRectContainsRect(self.faceDetectionFrame, faceRegion),NSStringFromCGRect(self.faceDetectionFrame),NSStringFromCGRect(faceRegion));
            
            if (CGRectContainsRect(self.faceDetectionFrame, faceRegion)) {// 只有当人脸区域的确在小框内时，才再去做捕获此时的这一帧图像
                // 为videoDataOutput设置代理，程序就会自动调用下面的代理方法，捕获每一帧图像
                if (!self.videoDataOutput.sampleBufferDelegate) {
                    [self.videoDataOutput setSampleBufferDelegate:self queue:self.queue];
                }
            }
        }
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
#pragma mark 从输出的数据流捕捉单一的图像帧
// AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] || [self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        if ([captureOutput isEqual:self.videoDataOutput]) {
            // 身份证信息识别
            [self IDCardRecognit:imageBuffer];
            
            // 身份证信息识别完毕后，就将videoDataOutput的代理去掉，防止频繁调用AVCaptureVideoDataOutputSampleBufferDelegate方法而引起的“混乱”
            if (self.videoDataOutput.sampleBufferDelegate) {
                [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
            }
        }
    } else {
        NSLog(@"输出格式不支持");
    }
}

#pragma mark - 身份证信息识别
- (void)IDCardRecognit:(CVImageBufferRef)imageBuffer {
    CVBufferRetain(imageBuffer);
    
    // Lock the image buffer
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
        size_t width= CVPixelBufferGetWidth(imageBuffer);// 1920
        size_t height = CVPixelBufferGetHeight(imageBuffer);// 1080
        
        CGRect effectRect = [RectManager getEffectImageRect:CGSizeMake(width, height)];
        CGRect rect = [RectManager getGuideFrame:effectRect];
        
        UIImage *image = [UIImage getImageStream:imageBuffer];
        //身份证图片
        UIImage *subImage = [UIImage getSubImage:rect inImage:image];
        self.captureImage = subImage;
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    
    CVBufferRelease(imageBuffer);
}


#endif

@end
