//
//  FMFVideoView.m
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753
#import "FMFVideoView.h"
#import "FMRecordProgressView.h"

@interface FMFVideoView ()<FMFModelDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIButton *turnCamera;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) FMRecordProgressView *progressView;
@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, strong, readwrite) FMFModel *fmodel;

@end

@implementation FMFVideoView

-(instancetype)initWithFMVideoViewType:(FMVideoViewType)type andTypeString:(NSString *)typeString
{

    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self BuildUIWithType:type andTypeString:typeString];
        self.isFirstShowed = NO;
        self.isSecondShowed = NO;
    }
    return self;
}

#pragma mark - view
- (void)BuildUIWithType:(FMVideoViewType)type andTypeString:(NSString *)typeString
{
    self.backgroundColor = [Utils colorRGB:@"#FBFBFB"];
    
    self.fmodel = [[FMFModel alloc] initWithFMVideoViewType:type superView:self andTypeString:typeString];
    self.fmodel.delegate = self;
    
//    self.topView = [[UIView alloc] init];
//    self.topView.frame = CGRectMake(0, 0, kScreenHeight, 44);
//    [self addSubview:self.topView];
    
    self.timeView = [[UIView alloc] init];
    self.timeView.backgroundColor = [Utils colorRGB:@"#DDDDDD"];
//    self.timeView.hidden = YES;
    self.timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [self addSubview:self.timeView];
    
    
//    UIView *redPoint = [[UIView alloc] init];
//    redPoint.frame = CGRectMake(0, 0, 6, 6);
//    redPoint.layer.cornerRadius = 3;
//    redPoint.layer.masksToBounds = YES;
//    redPoint.center = CGPointMake(25, 17);
//    redPoint.backgroundColor = [UIColor redColor];
//    [self.timeView addSubview:redPoint];
    
    self.timelabel =[[UILabel alloc] init];
    self.timelabel.textAlignment = 1;
    self.timelabel.font = [UIFont systemFontOfSize:12];
    self.timelabel.text = @"00:00:00";
    self.timelabel.textColor = [Utils colorRGB:@"#EC6C00"];
    self.timelabel.frame = self.timeView.frame;
    [self.timeView addSubview:self.timelabel];
    
    
//    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.cancelBtn.frame = CGRectMake(15, 14, 16, 16);
//    [self.cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
//    [self.cancelBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
//    [self.topView addSubview:self.cancelBtn];
//
//
//    self.turnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.turnCamera.frame = CGRectMake(SCREEN_WIDTH - 60 - 28, 11, 28, 22);
//    [self.turnCamera setImage:[UIImage imageNamed:@"listing_camera_lens"] forState:UIControlStateNormal];
//    [self.turnCamera addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.turnCamera sizeToFit];
//    [self.topView addSubview:self.turnCamera];
//
//
//    self.flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.flashBtn.frame = CGRectMake(SCREEN_WIDTH - 22 - 15, 11, 22, 22);
//    [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
//    [self.flashBtn addTarget:self action:@selector(flashAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.flashBtn sizeToFit];
//    [self.topView addSubview:self.flashBtn];
    
    UILabel *tipLabel = [UILabel labelWithTitle:@"请根据提示，对准人相框录制10s视频" color:[Utils colorRGB:@"#333333"] font:font14 alignment:1];
    [self addSubview:tipLabel];
    tipLabel.frame = CGRectMake(0, SCREEN_WIDTH-(40*getScale*2)+70*getScale+25, SCREEN_WIDTH, 20);
    
    /*****添加切换按钮****/
    self.progressView = [[FMRecordProgressView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 84)/2, CGRectGetMaxY(tipLabel.frame)+55*getScale, 84, 84)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.layer.cornerRadius = 42;
    self.progressView.layer.masksToBounds = YES;
    [self addSubview:self.progressView];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recordBtn addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchUpInside];
    self.recordBtn.frame = CGRectMake(11, 11, 62, 62);
    self.recordBtn.backgroundColor = [Utils colorRGB:@"#EC6C00"];
    self.recordBtn.layer.cornerRadius = 31;
    self.recordBtn.layer.masksToBounds = YES;
    [self.progressView addSubview:self.recordBtn];
    [self.progressView resetProgress];
    
    if ([typeString isEqualToString:@"工号实名制"] || [typeString isEqualToString:@"靓号"]) {
        
    }else{//写卡激活、成卡
        //切换前后置摄像头
        NSDictionary *modeDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kaihuMode"];
        if (modeDic) {
            NSNumber *isSwitchNum = modeDic[@"shootSwitch"];
            if (isSwitchNum.intValue == 1) {
                self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.switchButton addTarget:self action:@selector(turnCameraAction) forControlEvents:UIControlEventTouchUpInside];
                self.switchButton.frame = CGRectMake(SCREEN_WIDTH-40-30-15, self.progressView.center.y-20, 40+20, 40);
                [self.switchButton setImage:[UIImage imageNamed:@"翻转摄像头"] forState:UIControlStateNormal];
                [self addSubview:self.switchButton];
            }
    }
    
        
    }
    
    
    self.firstImageView = [[UIImageView alloc]init];
    [self addSubview:self.firstImageView];
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-55);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    self.secondImageView = [[UIImageView alloc]init];
    [self addSubview:self.secondImageView];
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-55);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)updateViewWithRecording
{
    self.timeView.hidden = NO;
    self.topView.hidden = NO;
    [self changeToRecordStyle];
}

- (void)updateViewWithStop
{
    self.timeView.hidden = NO;
    self.topView.hidden = NO;
    [self changeToStopStyle];
}

- (void)changeToRecordStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(32, 32);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 4;
        self.recordBtn.center = center;
    }];
}

- (void)changeToStopStyle
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.recordBtn.center;
        CGRect rect = self.recordBtn.frame;
        rect.size = CGSizeMake(62, 62);
        self.recordBtn.frame = rect;
        self.recordBtn.layer.cornerRadius = 31;
        self.recordBtn.center = center;
    }];
}
#pragma mark - action

- (void)dismissVC
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissVC)]) {
        [self.delegate dismissVC];
    }
}

- (void)turnCameraAction
{
     [self.fmodel turnCameraAction];
}

- (void)flashAction
{
    [self.fmodel switchflash];
}

- (void)startRecord
{
    if (self.fmodel.recordState == FMRecordStateInit) {
        self.recordBtn.hidden = YES;
        self.progressView.hidden = YES;
        [self.fmodel startRecord];
    } else if (self.fmodel.recordState == FMRecordStateRecording) {
        self.recordBtn.userInteractionEnabled = NO;
        [self.fmodel stopRecord];
    } else if (self.fmodel.recordState == FMRecordStatePause) {
        
    }
    if (self.switchButton) {
        self.switchButton.userInteractionEnabled = NO;
    }
    
}

- (void)reset
{
    [self.fmodel reset];
}

#pragma mark - FMFModelDelegate

//- (void)updateFlashState:(FMFlashState)state
//{
//    if (state == FMFlashOpen) {
//        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_on"] forState:UIControlStateNormal];
//    }
//    if (state == FMFlashClose) {
//        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_off"] forState:UIControlStateNormal];
//    }
//    if (state == FMFlashAuto) {
//        [self.flashBtn setImage:[UIImage imageNamed:@"listing_flash_auto"] forState:UIControlStateNormal];
//    }
//}


- (void)updateRecordState:(FMRecordState)recordState
{
    if (recordState == FMRecordStateInit) {
        [self updateViewWithStop];
        [self.progressView resetProgress];
    } else if (recordState == FMRecordStateRecording) {
        [self updateViewWithRecording];
    } else if (recordState == FMRecordStatePause) {
         [self updateViewWithStop];
    } else  if (recordState == FMRecordStateFinish) {
        [self updateViewWithStop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordFinishWithvideoUrl:)]) {
            if (self.switchButton) {
                self.switchButton.userInteractionEnabled = YES;
            }
            [self.delegate recordFinishWithvideoUrl:self.fmodel.videoUrl];
        }
    }
}

- (void)updateRecordingProgress:(CGFloat)progress
{
    [self.progressView updateProgressWithValue:progress];
    self.timelabel.text = [self changeToVideotime:progress * RECORD_MAX_TIME];
    if ([self.timelabel.text isEqualToString:@"00:00:00"]&&self.isFirstShowed==NO) {
        [Utils toastview:@"注视屏幕"];
        self.isFirstShowed = YES;
    }
    if ([self.timelabel.text isEqualToString:@"00:00:07"]&&self.isSecondShowed==NO) {
        [Utils toastview:@"微微张口"];
        self.isSecondShowed = YES;
    }
//    [self.timelabel sizeToFit];
}

- (NSString *)changeToVideotime:(CGFloat)videocurrent {
    
    return [NSString stringWithFormat:@"00:%02li:%02li",lround(floor(videocurrent/60.f)),lround(floor(videocurrent/1.f))%60];
    
}
@end
