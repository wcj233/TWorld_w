//
//  LiangSelectView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LiangSelectView.h"
#import "NormalLeadCell.h"
#import "NormalInputCell.h"
#import "ChooseTypeCell.h"

static const CGFloat rowHeight = 56;

@interface LiangSelectView ()

@property (nonatomic) NSString *currentSelectTitle;
@property (nonatomic) NSArray *currentSelectArray;
@property (nonatomic) NSIndexPath *currentSelectIndexPath;

@end

@implementation LiangSelectView

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)leftTitlesArray andDataDictionary:(NSDictionary *)dataDictionary
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentSelectArray = [NSArray array];
        self.leftTitlesArray = leftTitlesArray;
        self.dataDictionary = [dataDictionary mutableCopy];
        [self backView];
        [self selectTableView];
        [self tableFooterView];
        [self resetButton];
        [self inquiryButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
        lineView.backgroundColor = COLOR_BACKGROUND;
        [self.tableFooterView addSubview:lineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
        [self.backView addGestureRecognizer:tap];
    }
    return self;
}

- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.4;
    }
    return _backView;
}

- (UITableView *)selectTableView{
    if (_selectTableView == nil) {
        _selectTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_selectTableView];
        [_selectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(self.leftTitlesArray.count * rowHeight + 65);
        }];
        _selectTableView.bounces = NO;
        _selectTableView.tableFooterView = [UIView new];
        _selectTableView.delegate = self;
        _selectTableView.dataSource = self;
        _selectTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _selectTableView;
}

- (UIView *)tableFooterView{
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 65)];
        self.selectTableView.tableFooterView = _tableFooterView;
        _tableFooterView.backgroundColor = [UIColor whiteColor];
    }
    return _tableFooterView;
}

/*----重置按钮--------*/
- (UIButton *)resetButton{
    if (_resetButton == nil) {
        _resetButton = [[UIButton alloc] init];
        _resetButton.backgroundColor = [UIColor clearColor];
        _resetButton.layer.cornerRadius = 4;
        _resetButton.layer.borderColor = [Utils colorRGB:@"#979797"].CGColor;
        _resetButton.layer.borderWidth = 1.0;
        _resetButton.layer.masksToBounds = YES;
        
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [_resetButton setTitleColor:[Utils colorRGB:@"#979797"] forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:textfont15];
        [self.tableFooterView addSubview:_resetButton];
        [_resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(17);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo((screenWidth - 60) / 2.0);
        }];
        
        [_resetButton addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

/*----查询按钮--------*/
- (UIButton *)inquiryButton{
    if (_inquiryButton == nil) {
        _inquiryButton = [[UIButton alloc] init];
        _inquiryButton.backgroundColor = MainColor;
        _inquiryButton.layer.cornerRadius = 4;
        _inquiryButton.layer.masksToBounds = YES;
        
        [_inquiryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_inquiryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inquiryButton.titleLabel.font = [UIFont systemFontOfSize:textfont15];
        [self.tableFooterView addSubview:_inquiryButton];
        [_inquiryButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(17);
            make.width.mas_equalTo((screenWidth - 60) / 2.0);
            make.height.mas_equalTo(30);
        }];
        [_inquiryButton addTarget:self action:@selector(inquiryAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inquiryButton;
}

- (UIView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 64, screenWidth, 220)];
        [self addSubview:_pickerView];
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (AddressPickerView *)addressPickerView{
    if (_addressPickerView == nil) {
        _addressPickerView = [[AddressPickerView alloc] init];
        _addressPickerView.backgroundColor = [UIColor whiteColor];
        [self.pickerView addSubview:_addressPickerView];
        [_addressPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
        }];
    }
    return _addressPickerView;
}

- (UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 176)];
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        }
        _datePicker.frame = CGRectMake(0, 44, screenWidth, 176);
        // 背景色是透明的
        _datePicker.backgroundColor = [UIColor whiteColor];
        // 设置UIDatePicker的显示模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
        // 设置时区
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        // 设置当前显示时间
        [_datePicker setDate:[NSDate date] animated:YES];
        [_datePicker setValue:[UIColor blackColor] forKey:@"textColor"];
        
        [self.pickerView addSubview:_datePicker];
    }
    return _datePicker;
}

- (UIPickerView *)otherPickerView{
    if (_otherPickerView == nil) {
        _otherPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, screenWidth, 176)];
        [self.pickerView addSubview:_otherPickerView];
        _otherPickerView.delegate = self;
        _otherPickerView.dataSource = self;
        _otherPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _otherPickerView;
}

- (UIButton *)sureButton{
    if (_sureButton == nil) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 70, 0, 70, 44)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[Utils colorRGB:@"#0081eb"] forState:UIControlStateNormal];
        [self.pickerView addSubview:_sureButton];
        [_sureButton addTarget:self action:@selector(pickerSureClickedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[Utils colorRGB:@"#0081eb"] forState:UIControlStateNormal];
        [self.pickerView addSubview:_cancelButton];
        [_cancelButton addTarget:self action:@selector(dismissPickerViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleString = self.leftTitlesArray[indexPath.row];
    
    id dataObj = self.dataDictionary[titleString];
    
    if ([dataObj isKindOfClass:[NSArray class]] && [titleString isEqualToString:@"类型"]) {
        ChooseTypeCell *cell = [[ChooseTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChooseTypeCell" andTitleArray:dataObj];
        return cell;
    }else if ([dataObj isKindOfClass:[NSString class]] && [dataObj isEqualToString:@"phoneNumber"]) {
        //手机号类型的cell
        NormalInputCell *cell = [[NormalInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalInputCell"];
        
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTextField.delegate = self;
        cell.inputTextField.placeholder = @"请输入手机号码";
        
        cell.leftLabel.text = titleString;
        
        return cell;
    }else{
        NormalLeadCell *cell = [[NormalLeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalLeadCell"];
        cell.inputTextField.userInteractionEnabled = NO;
        cell.inputTextField.placeholder = [NSString stringWithFormat:@"请选择%@",titleString];
        cell.leftLabel.text = titleString;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *titleString = self.leftTitlesArray[indexPath.row];
    
    self.currentSelectIndexPath = indexPath;
    self.currentSelectTitle = titleString;
    
    //在这个方法中已经做了判断是否要显示pickerView
    [self showPickerViewActionWithTitle:titleString];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.currentSelectArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSAttributedString *astring = [[NSAttributedString alloc] initWithString:self.currentSelectArray[row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:24]}];
    return astring;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 250, 30)];
    
    if (component == 0) {
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = self.currentSelectArray[row];
        myView.font = [UIFont systemFontOfSize:20];//用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
        myView.textColor = [UIColor blackColor];
    }
    
    return myView;
}

#pragma mark - UITextFieldDelegate --------------

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //手机号 11位
    //如果文本长度已经是11而且不是删除文本操作，返回NO
    if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    //如果文本长度10而且正在输入
    if (textField.text.length == 10 && ![string isEqualToString:@""]) {
        return YES;
    }
    return YES;
}

#pragma mark - Method --------

- (void)resetAction{
    [self.selectTableView reloadData];
    _SelectResetCallBack(@"重置");
}

- (void)inquiryAction{
    _SelectInquiryCallBack(@"查询");
}

- (void)dismissAction{
    [self dismissPickerViewAction];
    self.hidden = YES;
    [self endEditing:true];
}

//展示pickerView
- (void)showPickerViewActionWithTitle:(NSString *)title{
    
    id dataObj = self.dataDictionary[title];
    
    if ([dataObj isKindOfClass:[NSString class]] && [dataObj isEqualToString:@"phoneNumber"]) {
        return;
    }
    if ([title isEqualToString:@"类型"]) {
        return;
    }
    
    [self sureButton];
    [self cancelButton];
    
    self.addressPickerView.hidden = YES;
    self.datePicker.hidden = YES;
    self.otherPickerView.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, screenHeight - 64 - 220, screenWidth, 220);
        self.pickerView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    if ([dataObj isKindOfClass:[NSString class]]) {
        if ([dataObj isEqualToString:@"cityPicker"]) {
            //省市选择
            self.addressPickerView.hidden = NO;
        }
        if ([dataObj isEqualToString:@"timePicker"]) {
            //时间选择
            self.datePicker.hidden = NO;
        }
    }else if([dataObj isKindOfClass:[NSArray class]]){
        self.currentSelectArray = dataObj;
        self.otherPickerView.hidden = NO;
        [self.otherPickerView reloadAllComponents];
    }
}

- (void)pickerSureClickedAction{
    [self dismissPickerViewAction];
    
    id dataObj = self.dataDictionary[self.currentSelectTitle];
    NormalLeadCell *cell = [self.selectTableView cellForRowAtIndexPath:self.currentSelectIndexPath];

    if ([dataObj isKindOfClass:[NSString class]]) {
        if ([dataObj isEqualToString:@"cityPicker"]) {
            //省市选择
            cell.inputTextField.text = [NSString stringWithFormat:@"%@，%@",self.addressPickerView.currentProvinceModel.provinceName,self.addressPickerView.currentCityModel.cityName];
        }
        if ([dataObj isEqualToString:@"timePicker"]) {
            //时间选择
            NSString *dateString = [[NSString stringWithFormat:@"%@",self.datePicker.date] componentsSeparatedByString:@" "].firstObject;
            cell.inputTextField.text = [NSString stringWithFormat:@"%@",dateString];
        }
    }else if([dataObj isKindOfClass:[NSArray class]]){
        NSInteger row = [self.otherPickerView selectedRowInComponent:0];
        cell.inputTextField.text = self.currentSelectArray[row];
    }
    
}

- (void)dismissPickerViewAction{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, screenHeight - 64, screenWidth, 220);
        self.pickerView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

@end
