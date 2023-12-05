//
//  FMVideoPlayController.m
//  fmvideo
//
//  Created by qianjn on 2016/12/30.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "FMVideoPlayController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface FMVideoPlayController ()
@property (nonatomic, strong) MPMoviePlayerController *videoPlayer;
@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) UIImage *videoCover;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) NSTimeInterval enterTime;
@property (nonatomic, assign) BOOL hasRecordEvent;
@property(nonatomic, strong) UIButton *submitButton;
@property(nonatomic, assign) BOOL isPlay;
@property(nonatomic, strong) UIImageView *pauseImageView;

@end

@implementation FMVideoPlayController

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人脸识别";
    self.view.backgroundColor = [Utils colorRGB:@"#FBFBFB"];
    self.isPlay = NO;
    
    UILabel *timelabel =[[UILabel alloc] init];
    timelabel.textAlignment = 1;
    timelabel.font = [UIFont systemFontOfSize:12];
    timelabel.text = self.videoTime;
    timelabel.textColor = [Utils colorRGB:@"#EC6C00"];
    timelabel.backgroundColor = [Utils colorRGB:@"#DDDDDD"];
    timelabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [self.view addSubview:timelabel];
    self.timeLabel = timelabel;
    
    self.videoPlayer = [[MPMoviePlayerController alloc] init];
    [self.videoPlayer.view setFrame:CGRectMake(40*getScale, CGRectGetMaxY(timelabel.frame)+40*getScale, SCREEN_WIDTH-(40*getScale*2), SCREEN_WIDTH-(40*getScale*2))];
    self.videoPlayer.view.layer.cornerRadius = (SCREEN_WIDTH-(40*getScale*2))/2;
    self.videoPlayer.view.layer.masksToBounds = YES;
//    self.videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.videoPlayer.view];
    [self.videoPlayer prepareToPlay];
    self.videoPlayer.controlStyle = MPMovieControlStyleNone;
    self.videoPlayer.shouldAutoplay = NO;
    self.videoPlayer.scalingMode = MPMovieScalingModeAspectFill;
    self.videoPlayer.repeatMode = MPMovieRepeatModeNone;
    
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backgroundView];
    self.backgroundView.frame = self.videoPlayer.view.frame;
    self.backgroundView.layer.cornerRadius = (SCREEN_WIDTH-(40*getScale*2))/2;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playOrPause)];
    [self.backgroundView addGestureRecognizer:tap];

    self.videoPlayer.contentURL = self.videoUrl;
//    [self.videoPlayer play];
    
    self.pauseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play"]];
    [self.view addSubview:self.pauseImageView];
    self.pauseImageView.frame = CGRectMake((SCREEN_WIDTH-46)/2, CGRectGetMaxY(self.videoPlayer.view.frame)-23-(SCREEN_WIDTH-(40*getScale*2))/2, 46, 46);
//    self.pauseImageView.hidden = YES;
    
    self.submitButton = [[UIButton alloc]init];
    [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.submitButton.backgroundColor = MainColor;
    self.submitButton.layer.cornerRadius = 4;
    self.submitButton.frame = CGRectMake(103*getScale, CGRectGetMaxY(self.videoPlayer.view.frame)+135*getScale, SCREEN_WIDTH-(103*getScale*2), 40);
    [self.view addSubview:self.submitButton];
    [self.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    _enterTime = [[NSDate date] timeIntervalSince1970];
}

-(void)submit{
    //随机生成两个时间
    NSString *seconds = [self.videoTime componentsSeparatedByString:@":"].lastObject;
    int randomTime1 = arc4random() % (seconds.intValue);
    int randomTime2 = arc4random() % (seconds.intValue);
    CGFloat randomTime3 = 0.0;
    if (randomTime1==randomTime2) {
        randomTime2 = arc4random() % (seconds.intValue);
        if (randomTime1==randomTime2) {
            randomTime3 = [NSString stringWithFormat:@"%d.5",randomTime1].floatValue;
        }
    }
    UIImage *randomImage1 = [Utils testGenerateThumbNailDataWithVideo:self.videoUrl andDurationSeconds:[NSString stringWithFormat:@"%d.0",randomTime1].floatValue];
    UIImage *randomImage2;
    if (randomTime1==randomTime2) {
        randomImage2 = [Utils testGenerateThumbNailDataWithVideo:self.videoUrl andDurationSeconds:randomTime3];
    }else{
        randomImage2 = [Utils testGenerateThumbNailDataWithVideo:self.videoUrl andDurationSeconds:[NSString stringWithFormat:@"%d.0",randomTime2].floatValue];
    }
}

-(void)setVideoTime:(NSString *)videoTime{
    _videoTime = videoTime;
    self.timeLabel.text = videoTime;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayer];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.videoPlayer stop];
    self.videoPlayer = nil;
}

- (void)commit
{
    
}

-(void)playOrPause{
    self.isPlay = !self.isPlay;
    self.pauseImageView.hidden = self.isPlay;
    if (self.isPlay) {
        [self.videoPlayer play];
    }else{
        [self.videoPlayer pause];
    }
}

#pragma mark - notification
#pragma state
- (void)stateChanged
{
    switch (self.videoPlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            [self trackPreloadingTime];
            break;
        case MPMoviePlaybackStatePaused:
            break;
        case MPMoviePlaybackStateStopped:
            break;
        default:
            break;
    }
}

-(void)videoFinished:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonPlaybackEnded) {   // 视频播放结束
        [self.videoPlayer stop];
        self.isPlay = NO;
        self.pauseImageView.hidden = NO;
    }
}


- (void)trackPreloadingTime
{
    
}

- (void)dismissAction
{
    [self.videoPlayer stop];
    self.videoPlayer = nil;
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
//- (void)DoneAction
//{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}


- (void)captureImageAtTime:(float)time
{
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
}

- (void)captureFinished:(NSNotification *)notification
{
    self.videoCover = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    if (self.videoCover == nil) {
        self.videoCover = [self coverIamgeAtTime:1];
    }
}


- (UIImage*)coverIamgeAtTime:(NSTimeInterval)time {
    
    
    [self.videoPlayer requestThumbnailImagesAtTimes:@[@(time)] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : [UIImage new];
    
    return thumbnailImage;
}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
