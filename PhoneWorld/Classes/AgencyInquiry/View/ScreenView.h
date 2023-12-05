//
//  ScreenView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/26.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenView : UIView <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

/*
 contentDic中保存标题(和lefttitles一致)和标题下的选项
 如果是选择时间  选项内容为@"timePicker"
 如果是手机号  选项内容为@"phoneNumber"
 */

@property (nonatomic) void(^ScreenCallBack) (NSDictionary *conditions, NSString *string);//点击查询或者重置按钮

@property (nonatomic) void(^ScreenDismissCallBack) (id obj);//点击灰色背景时的操作

- (instancetype)initWithFrame:(CGRect)frame andContent:(NSDictionary *)content andLeftTitles:(NSArray *)titles andRightDetails:(NSArray *)details;

@property (nonatomic) UIView *backPickView;//灰色半透明背景
@property (nonatomic) UIPickerView *pickerView;//状态选取
@property (nonatomic) UIDatePicker *datePickerView;//日期选取
@property (nonatomic) UIButton *sureButton;
@property (nonatomic) UIButton *cancelButton;

@property (nonatomic) NSDictionary *contentDic;
@property (nonatomic) NSArray *leftTitles;
@property (nonatomic) NSArray *rightDetails;//修改时刷新screentableview
@property (nonatomic) UITableView *screenTableView;

@property (nonatomic) UIView *dismissView;//点击背景隐藏

@end
