//
//  LiangSelectView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiangSelectView : UIView <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic) void(^SelectInquiryCallBack) (id obj);

@property (nonatomic) void(^SelectResetCallBack) (id obj);


- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)leftTitlesArray andDataDictionary:(NSDictionary *)dataDictionary;

@property (nonatomic) NSArray *leftTitlesArray;//左标题数组
@property (nonatomic) NSMutableDictionary *dataDictionary;//筛选框的数据
/*
 
 {
 省市选择 -- @"cityPicker"
 靓号规则 -- @[@"规则1",@"规则2",...]//其他picker
 手机号码 -- @"phoneNumber"
 开始时间／截止时间 -- @"timePicker"
 类型 -- @[@"全部",@"待开户",@"已开户"]//类型的行
 }
 
 */

@property (nonatomic) UIView *backView;

@property (nonatomic) UITableView *selectTableView;
@property (nonatomic) UIView *tableFooterView;
@property (nonatomic) UIButton *resetButton;
@property (nonatomic) UIButton *inquiryButton;

@property (nonatomic) UIView *pickerView;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *sureButton;
@property (nonatomic) AddressPickerView *addressPickerView;//地址选择器
@property (nonatomic) UIDatePicker *datePicker;//时间选择器
@property (nonatomic) UIPickerView *otherPickerView;//其他的选择器

@end
