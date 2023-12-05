//
//  WorkerSignInTableView.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfoModel.h"
#import "DatePickerView.h"


@interface WorkerSignInView : UIView<UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate>

@property(nonatomic, strong) UIButton *submitButton;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PersonalInfoModel *model;
@property(nonatomic, strong) DatePickerView *pikerView;
@property(nonatomic, strong) UIView *backWindowView;
@property(nonatomic, strong) NSString *selectedPro;
@property(nonatomic, strong) NSString *selectedCity;


@end


