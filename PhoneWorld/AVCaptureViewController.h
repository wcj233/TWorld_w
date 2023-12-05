//
//  AVCaptureViewController.h
//  实时视频Demo
//
//  Created by HanJunqiang on 2017/2/16.
//  Copyright © 2017年 HaRi. All rights reserved.
//
//  

#import <UIKit/UIKit.h>

@interface AVCaptureViewController : UIViewController

@property (nonatomic, copy) void(^myBlock)(UIImage *captureImage);
@property (nonatomic, strong) NSString *type;//正面还是反面

@end

