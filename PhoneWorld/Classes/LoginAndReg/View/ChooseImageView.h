//
//  ChooseImageView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/20.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseImageViewDelegate <NSObject>

-(void)scanForInformation;

@end

@interface ChooseImageView : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDetail:(NSArray *)details andCount:(NSInteger)count;
@property (nonatomic) NSMutableArray *imageButtons;
@property (nonatomic) NSMutableArray *removeButtons;
@property(nonatomic, strong) NSArray *buttonImages;
@property (nonatomic) NSMutableArray *imageViews;
@property (nonatomic) UILabel *titleLB;
@property (nonatomic) UILabel *lastInstrusctLabel;
@property (nonatomic) NSMutableArray<UILabel *> *titleLabelsArray;

@property(nonatomic, weak) id<ChooseImageViewDelegate> chooseImageViewDelegate;

@property(nonatomic,assign)BOOL watermark;
@property(nonatomic, assign) BOOL isFinished;
@property(nonatomic, strong) NSString *typeString;
    
@end
