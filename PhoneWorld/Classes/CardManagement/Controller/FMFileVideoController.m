//
//  FMFileVideoController.m
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753
#import "FMFileVideoController.h"
#import "FMFVideoView.h"
#import "FMVideoPlayController.h"
#import "FailedView.h"
#import "WatermarkMaker.h"
#import "NewFinishedCardResultViewController.h"
@interface FMFileVideoController ()<FMFVideoViewDelegate>
@property (nonatomic, strong) FMFVideoView *videoView;
@property(nonatomic, strong) FailedView *processView;
@property (nonatomic) FailedView *successView;//成功弹窗

@end

@implementation FMFileVideoController

- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脸识别";
    //    self.navigationController.navigationBar.hidden = YES;
    //    self.view.backgroundColor = [UIColor blackColor];
    _videoView = [[FMFVideoView alloc] initWithFMVideoViewType:3 andTypeString:self.typeString];
    _videoView.delegate = self;
    [self.view addSubview:_videoView];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.videoView.fmodel stopRecord];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _videoView.recordBtn.userInteractionEnabled = YES;
    if (_videoView.fmodel.recordState == FMRecordStateFinish) {
        [_videoView reset];
    }
    
}
#pragma mark - FMFVideoViewDelegate
- (void)dismissVC
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)recordFinishWithvideoUrl:(NSURL *)videoUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *titleString = @"录制成功";
        [Utils showOpenSucceedViewWithTitle:titleString];
    });
    //    self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"人脸识别中" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
    //    FMVideoPlayController *playVC = [[FMVideoPlayController alloc] init];
    //    playVC.videoUrl =  videoUrl;
    //    playVC.videoTime = self.videoView.timelabel.text;
    //    [self.navigationController pushViewController:playVC animated:YES];
    //    self.videoView.timelabel.text = @"00:00:00";
    int randomTime1 = arc4random() % 6;
    int randomTime2 = (arc4random() % 3) + 7;
    
    UIImage *randomImage1 = [Utils testGenerateThumbNailDataWithVideo:videoUrl andDurationSeconds:[NSString stringWithFormat:@"%d.0",randomTime1].floatValue];
    UIImage *randomImage2 = [Utils testGenerateThumbNailDataWithVideo:videoUrl andDurationSeconds:[NSString stringWithFormat:@"%d.0",randomTime2].floatValue];
    self.videoView.firstImageView.image = [WatermarkMaker otherStyleWatermarkImageForImage:randomImage1];
    self.videoView.secondImageView.image = [WatermarkMaker otherStyleWatermarkImageForImage:randomImage2];
    
    if ([self.typeString isEqualToString:@"靓号"]) {
        
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在开户中" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
        //靓号
        NSMutableDictionary *sendDictionary = [self.collectionInfoDictionary mutableCopy];
        NSString *autoString = @"App人脸识别";
        
        [sendDictionary setObject:autoString forKey:@"authenticationType"];
        [sendDictionary setObject:self.orderNo forKey:@"orderNo"];
        
        [sendDictionary setObject:self.imsiDictionary[@"simId"] forKey:@"simId"];
        
        [sendDictionary setObject:self.imsiDictionary[@"imsi"] forKey:@"imsi"];
        [sendDictionary setObject:self.iccidString forKey:@"iccid"];
        
        [sendDictionary setObject:self.currentPackageDictionary[@"id"] forKey:@"packageId"];
        [sendDictionary setObject:self.currentPromotionDictionary[@"id"] forKey:@"promotionsId"];
        
        [sendDictionary setObject:self.numberModel.prestore forKey:@"orderAmount"];
        [sendDictionary setObject:self.numberModel.prestore forKey:@"payAmount"];
        [sendDictionary setObject:self.numberModel.number forKey:@"number"];
        [sendDictionary setObject:[NSString stringWithFormat:@"%d",self.payMethod] forKey:@"payMethod"];
        [sendDictionary setObject:[Utils imagechange:self.videoView.firstImageView.image] forKey:@"videoPhotos1"];
        [sendDictionary setObject:[Utils imagechange:self.videoView.secondImageView.image] forKey:@"videoPhotos2"];
        
        @WeakObj(self);
        [WebUtils requestHJSJLiangOpenWithDictionary:sendDictionary andCallBack:^(id obj) {
            @StrongObj(self);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                
                @StrongObj(self);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.processView removeFromSuperview];
                });
                
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"购买成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }];
                        
                        [ac addAction:action1];
                        [self presentViewController:ac animated:YES completion:nil];
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                        [Utils toastview:mes];
                    });
                }
            }
        }];
        
        
    }else if([self.typeString isEqualToString:@"写卡激活"]){
        if (_callBackImageURLs) {
            
            NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
            [sendDic setObject:[Utils imagechange:self.videoView.firstImageView.image] forKey:@"videoPhotos1"];
            [sendDic setObject:[Utils imagechange:self.videoView.secondImageView.image] forKey:@"videoPhotos2"];
            @WeakObj(self);
            [WebUtils uploadVideoImagesWithDic:sendDic andcallBack:^(id obj) {
                @StrongObj(self);
                if (obj) {
                    //                    self.callBackImageURLs(sendDic);
                    self.callBackImageURLs(obj);
                }
            }];
            
            
        }
    }else if ([self.typeString isEqualToString:@"工号实名制"]){
        if (_callBackImageURLs) {
            NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
            [sendDic setObject:[Utils imagechange:self.videoView.firstImageView.image] forKey:@"photo4"];
            [sendDic setObject:[Utils imagechange:self.videoView.secondImageView.image] forKey:@"photo5"];
            self.callBackImageURLs(sendDic);
        }
    }else if([self.typeString isEqualToString:@"过户"]){
        NSMutableDictionary *sendDic = [NSMutableDictionary dictionary];
        [sendDic setObject:[Utils imagechange:self.videoView.firstImageView.image] forKey:@"videoPhotos1"];
        [sendDic setObject:[Utils imagechange:self.videoView.secondImageView.image] forKey:@"videoPhotos2"];
        
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
        
        @WeakObj(self);
        [WebUtils requestTransferInfoWithDic:self.collectionInfoDictionary andVideoDic:sendDic andCallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.processView removeFromSuperview];
            });

            if (![obj isKindOfClass:[NSError class]]) {

                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    //提交成功弹窗
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.successView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"提交成功" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
                        [[UIApplication sharedApplication].keyWindow addSubview:self.successView];
                        
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeGrayView) userInfo:nil repeats:NO];
                    });

                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }else{
        //上传图片
        NSMutableDictionary *updateDic = [NSMutableDictionary dictionary];
        [updateDic setObject:[Utils imagechange:self.videoView.firstImageView.image] forKey:@"videoPhotos1"];
        [updateDic setObject:[Utils imagechange:self.videoView.secondImageView.image] forKey:@"videoPhotos2"];
        [WebUtils uploadVideoImagesWithDic:updateDic andcallBack:^(id obj) {
            if (obj) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *videoImageDic = obj;
                    
                    UIStoryboard* story = [UIStoryboard storyboardWithName:@"NewFinishedCard" bundle:nil];
                    NewFinishedCardResultViewController *viewController=[story instantiateViewControllerWithIdentifier:@"NewFinishedCardResultViewController"];
                    viewController.isFace = YES;
                    viewController.detailModel = self.detailModel;
                    if (self.infosArray && self.infosArray.count > 0) {
                        viewController.infosArray = self.infosArray;
                    }
                    viewController.currentPackageDictionary = self.currentPackageDictionary;
                    viewController.currentPromotionDictionary = self.currentPromotionDictionary;
                    NSMutableDictionary *updateDic = [self.collectionInfoDictionary mutableCopy];
                    [updateDic setObject:[Utils imagechange:self.videoView.firstImageView.image] forKey:@"videoPhotos1"];
                    [updateDic setObject:[Utils imagechange:self.videoView.secondImageView.image] forKey:@"videoPhotos2"];
                    viewController.collectionInfoDictionary = updateDic;
                    viewController.moneyString = self.moneyString;
                    viewController.isAuto = self.isAuto;
                    
                    viewController.fourImageDic = self.fourImageDic;
                    viewController.videoImageDic = videoImageDic;
                    
                    [self.navigationController pushViewController:viewController animated:YES];
                });
            }
        }];
        
        
        
    }
    
}

- (void)removeGrayView{
    [UIView animateWithDuration:0.5 animations:^{
        self.successView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.successView removeFromSuperview];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
