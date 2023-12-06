//
//  InformationCollectionView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputView.h"
#import "ChooseImageView.h"
#import "MultiAddressView.h"

#define warningText @"1、本人正面免冠照片，用户头像占比不小于照片三分之一。\n2、APP开户后台人工审核，请核对无误后再上传。"

@protocol InformationCollectionViewDelegate <NSObject>

-(void)scanForInformation;

@end

@interface InformationCollectionView : UIView<ChooseImageViewDelegate>

@property (nonatomic) void(^nextCallBack)(NSDictionary *dic);

@property (nonatomic) UIScrollView *baseScrollView;

@property (nonatomic) UIView *containerView;
@property (nonatomic) UILabel *warningLabel;

@property (nonatomic) UIButton *nextButton;
@property (nonatomic) NSMutableArray *inputViews;
@property (nonatomic) MultiAddressView *addressView;//多行地址
@property (nonatomic) ChooseImageView *chooseImageView;
@property(nonatomic, assign) BOOL isFaceCheck;
@property (nonatomic) BOOL isFinished;
@property(nonatomic, strong) NSString *typeString;
@property(nonatomic, assign) int cardType; //普通还是外国人

//是不是靓号


@property(nonatomic, weak) id<InformationCollectionViewDelegate> informationCollectionViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame andIsFinished:(BOOL)isFinished andIsFaceCheck:(BOOL)isFaceCheck;

@end
