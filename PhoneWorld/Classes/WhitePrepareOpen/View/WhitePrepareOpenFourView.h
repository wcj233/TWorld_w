//
//  WhitePrepareOpenFourView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseImageView.h"
//#import "PayWayView.h"

@protocol WhitePrepareOpenFourViewDelegate <NSObject>

-(void)scanForInformation;

@end

@interface WhitePrepareOpenFourView : UIView <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate,ChooseImageViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type isFaceVerify:(BOOL)isFaceVerify;

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) UIView *tableFooterView;

@property (nonatomic) ChooseImageView *chooseImageView;

@property (nonatomic) UILabel *warningLabel;

@property (nonatomic) UIButton *openButton;

@property (nonatomic, assign) BOOL isIDCardEnable;
@property (nonatomic, assign) int cardType; //普通还是外国人

@property (nonatomic) NSMutableArray *infoArray;
@property(nonatomic, weak) id<WhitePrepareOpenFourViewDelegate> whitePrepareOpenFourViewDelegate;

@end
