//
//  FMFVideoView.h
//  FMRecordVideo
//
//  Created by qianjn on 2017/3/12.
//  Copyright © 2017年 SF. All rights reserved.
//
//  Github:https://github.com/suifengqjn
//  blog:http://gcblog.github.io/
//  简书:http://www.jianshu.com/u/527ecf8c8753
#import <UIKit/UIKit.h>
#import "FMFModel.h"


@protocol FMFVideoViewDelegate <NSObject>

-(void)dismissVC;
-(void)recordFinishWithvideoUrl:(NSURL *)videoUrl;

@end


@interface FMFVideoView : UIView

@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, assign) FMVideoViewType viewType;
@property (nonatomic, strong, readonly) FMFModel *fmodel;
@property (nonatomic, weak) id <FMFVideoViewDelegate> delegate;
@property(nonatomic, strong) UIImageView *firstImageView;
@property(nonatomic, strong) UIImageView *secondImageView;
@property(nonatomic, assign) BOOL isFirstShowed;
@property(nonatomic, assign) BOOL isSecondShowed;

- (instancetype)initWithFMVideoViewType:(FMVideoViewType)type andTypeString:(NSString *)typeString;
- (void)reset;

@end
