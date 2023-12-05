//
//  PersonalInfoView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/15.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfoModel.h"
#import "DatePickerView.h"

@interface PersonalInfoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic, strong) UIButton *saveButton;
@property (nonatomic) NSMutableArray *inputViews;
@property (nonatomic) PersonalInfoModel *personModel;

@property(nonatomic, strong) DatePickerView *pikerView;
@property(nonatomic, strong) UIView *backWindowView;
@property(nonatomic, strong) NSString *selectedPro;
@property(nonatomic, strong) NSString *selectedCity;

@property (nonatomic, strong) UITableView *tableView;

@end
