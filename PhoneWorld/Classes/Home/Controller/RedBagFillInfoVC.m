//
//  RedBagFillInfoVC.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/22.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class RedBagFillInfoVC
// @abstract 红包抽奖 补登记资料 VC
//

#import "RedBagFillInfoVC.h"

// Controllers
#import "LuckdrawViewController.h"
#import "FMFileVideoController.h"

// Model
#import "RedBagFillInfoModel.h"

// Views
#import "RedBagFillInfoTBCell.h"
#import "DatePickerView.h"
#import "RedBagFillInfoVCodeCell.h"
#import "RedBagFillInfoPhotoCell.h"
#import "RedBagFillInfoImageCell.h"

@interface RedBagFillInfoVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *infoModelArray;

@property (nonatomic) AddressPickerView *addressPickerView;//地址选择器
@property (nonatomic) UIView *pickerBackView;
@property (nonatomic) UIButton *sureButton;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) CityModel *currentCityModel;
@property (nonatomic) ProvinceModel *currentProvinceModel;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) RedBagFillInfoPhotoVM *photoVM;

@property (nonatomic, assign) NSInteger tmpIamgeType;

@property (nonatomic, assign) BOOL isCompare;

@end


@implementation RedBagFillInfoVC

#pragma mark - View Controller LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configNav];
    
    [self createMain];
}

- (instancetype )initWithForType:(RedBagFillInfoVCType)type isCompare:(BOOL)isCompare{
    if (self = [super init]) {
        _isCompare = NO;
        switch (type) {
            case RedBagFillInfoVCTypeRealName:{
                self.navigationItem.title = @"工号实名制";
                _isCompare = isCompare;
                //需要判断 isCompare=Y 录制视频
            }
                break;
            case RedBagFillInfoVCTypeRegistration:{
                self.navigationItem.title = @"补登记资料";
            }
                break;
            default:
                break;
        }
    }
    return self;
}


#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)configNav {
    
    self.photoVM = RedBagFillInfoPhotoVM.new;
}

- (void)createMain {
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isCompare) {
        [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }else{
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    submitBtn.backgroundColor = kSetColor(@"EC6C00");
    submitBtn.layer.cornerRadius = 4;
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-90);
        make.size.mas_equalTo(CGSizeMake(172, 42));
    }];
    
    self.tableView = UITableView.new;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 34 + 7)];
    UILabel *footerLab = [UILabel labelWithTitle:@"注：依据工信部要求，所有渠道工号必须实名认证。未实名认证工号无法使用，烦请尽快实名。" color:rgba(255, 38, 38, 1) fontSize:12];
    footerLab.textAlignment = NSTextAlignmentLeft;
    footerLab.numberOfLines = 0;
    [footerView addSubview:footerLab];
    [footerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.centerX.mas_equalTo(footerView);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
    }];
    self.tableView.tableFooterView = footerView;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(submitBtn.mas_top).mas_equalTo(-10);
    }];
    [self.tableView registerClass:RedBagFillInfoTBCell.class forCellReuseIdentifier:@"RedBagFillInfoTBCell"];
    [self.tableView registerClass:RedBagFillInfoVCodeCell.class forCellReuseIdentifier:@"RedBagFillInfoVCodeCell"];
    [self.tableView registerClass:RedBagFillInfoImageCell.class forCellReuseIdentifier:@"RedBagFillInfoImageCell"];
}

#pragma mark - Target Methods

- (void)submitBtnClick:(UIButton *)btn {
#warning 测试
//    if (self.isCompare) {
//
//        [self faceRecognition];
//    }else{
//
//        [self discloseTheInformationForFaceImageURLs:nil];
//    }
//    return;
    
    if ([self preliminaryValidation]) {
        //验证手机验证码
        [self verifyThePhoneVerificationCode];
    }
}

//初步验证
- (BOOL)preliminaryValidation{
    if ([[self.infoModelArray[0] content] length] == 0) {
        // 姓名
        [Utils toastview:@"请输入姓名"];
        return NO;
    } else if ([[self.infoModelArray[1] content] length] == 0) {
           // 身份证号
           [Utils toastview:@"请输入身份证号码"];
        return NO;
    }else if ([[self.infoModelArray[2] content] length] == 0) {
        // 证件地址
        [Utils toastview:@"请输入证件地址"];
        return NO;
    } else if ([[self.infoModelArray[3] content] length] == 0) {
           // 渠道地址
           [Utils toastview:@"请选择渠道地址"];
        return NO;
    } else if ([[self.infoModelArray[4] content] length] == 0) {
           // 详细地址
           [Utils toastview:@"请输入详细地址"];
        return NO;
    } else if ([[self.infoModelArray[5] content] length] == 0) {
        // 手机号
        [Utils toastview:@"请输入手机号"];
        return NO;
    }else if ([[self.infoModelArray[6] content] length] == 0) {
        // 验证码
        [Utils toastview:@"请输入验证码"];
        return NO;
    }
    
    if (![Utils isMobile:[self.infoModelArray[5] content]]) {
        [Utils toastview:@"请输入正确的手机号格式"];
        return NO;
    }
    
    if (![Utils isIDNumber:[self.infoModelArray[1] content]]) {
        [Utils toastview:@"请输入正确的身份证格式"];
        return NO;
    }
    
    if ([[self.infoModelArray[7] content] length] > 0) {
        // 判断邮箱
        NSString *email = [self.infoModelArray[7] content];
        if (![Utils isEmailAddress:email]) {
            [Utils toastview:@"请输入正确的邮箱格式"];
            return NO;
        }
    }
    return YES;
}

//验证手机验证码
- (void)verifyThePhoneVerificationCode{
    [self showWaitView];
     @WeakObj(self);
    [WebUtils requestCaptchaCheckWithCaptcha:[self.infoModelArray[6] content] andType:5 andTel:[self.infoModelArray[5] content] andCallBack:^(id obj) {
        @StrongObj(self);
            [self hideWaitView];
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];

                if ([code isEqualToString:@"10000"]) {
                    
#pragma mark 如果 isCompare == N 去提交
                    if (self.isCompare) {
                        
                        [self faceRecognition];
                    }else{

                        [self discloseTheInformationForFaceImageURLs:nil];
                    }
                
                }else{
                    [Utils toastview:obj[@"mes"]];
                }
            }
        }];
}


- (void)faceRecognition{
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        FMFileVideoController *viewController = [[FMFileVideoController alloc]init];
        viewController.typeString = @"工号实名制";
        viewController.callBackImageURLs = ^(NSDictionary *imageURLs) {
            @StrongObj(self);
            [self discloseTheInformationForFaceImageURLs:imageURLs];
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

//提交资料
- (void)discloseTheInformationForFaceImageURLs:(NSDictionary *)faceImageDic{
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"contact"] = [self.infoModelArray[0] content];
    params[@"tel"] = [self.infoModelArray[5] content];
    params[@"cardId"] = [self.infoModelArray[1] content];
    params[@"address"] = [self.infoModelArray[2] content];
    params[@"workAddress"] = [[self.infoModelArray[3] content] stringByAppendingFormat:@"%@", [self.infoModelArray[4] content]];
    params[@"provinceCode"] = self.currentProvinceModel.provinceId;
    params[@"cityCode"] = self.currentCityModel.cityId;
    
    if ([self.infoModelArray[7] content] != 0) {
        params[@"email"] = [self.infoModelArray[7] content];
    }
    
    NSArray *keyArray = @[@"photo1",@"photo2",@"photo3"];
    id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    if (![cell isKindOfClass:RedBagFillInfoImageCell.class]) {
        [Utils toastview:@"发生不知名错误"];
        return;
    }
    if (faceImageDic.allKeys.count == 2) {
        for (NSString *faceImageDicKey in faceImageDic.allKeys) {
            params[faceImageDicKey] = faceImageDic[faceImageDicKey];
        }
    }
    RedBagFillInfoImageCell *tmpCell = cell;
    for (int i = 0; i < keyArray.count; i ++) {
        
        UIImageView *imageView = tmpCell.chooseImageView.imageViews[i];
        
        if (imageView.hidden == YES) {
            [Utils toastview:@"请选择图片"];
            return;
        }
        
        NSString *imageString = [Utils imagechange:imageView.image];
        imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [params setObject:imageString forKey:keyArray[i]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        WEAK_SELF
        [self showWaitView];
        [WebUtils agency_dataSupplementWithParams:params andCallback:^(id obj) {
            [self hideWaitView];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
                if ([dic[@"code"] integerValue] == 10000) {
//                if ([dic[@"code"] integerValue] == 10003) {
                    [Utils toastview:@"资料已提交，请等待审核"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                } else {
                    [self showWarningText:dic[@"mes"]];
                    return;
                }
            }
        }];
    });
}


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods

- (NSMutableArray *)infoModelArray {
    if (_infoModelArray == nil) {
        _infoModelArray = [@[
                             [RedBagFillInfoModel modelWithTitle:@"*姓名" placeholder:@"请输入姓名" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*身份证" placeholder:@"请输入身份证号码" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*证件地址" placeholder:@"请输入证件地址" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*渠道地址" placeholder:@"请选择省市" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*渠道详细地址" placeholder:@"请输入详细地址" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*手机号" placeholder:@"请输入手机号" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*验证码" placeholder:@"请输入验证码" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"电子邮箱" placeholder:@"请输入电子邮箱" content:@""],
                             ] mutableCopy];
    }
    return _infoModelArray;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    if (indexPath.row == 8) {
        RedBagFillInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoImageCell"];
        return cell;
    }else if (indexPath.row == 6) {
        RedBagFillInfoVCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoVCodeCell"];
        cell.infoModel = self.infoModelArray[indexPath.row];
        cell.clickVCodeBlock = ^{
            @StrongObj(self);
            if (![Utils isMobile:[self.infoModelArray[5] content]]) {
                [Utils toastview:@"请输入正确的手机号格式"];
                return NO;
            }else{
                [self showWaitView];
                @WeakObj(self);
                
                [WebUtils requestSendCaptchaWithType:5 andTel:[self.infoModelArray[5] content] andCallBack:^(id obj) {
                    @StrongObj(self);
                    [self hideWaitView];
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
                        if ([dic[@"code"] integerValue] == 10000) {
                            
                            [Utils toastview:@"验证短信已发送"];
                            
                        } else {
                            [Utils toastview:dic[@"mes"]];
                            return;
                        }
                    }
                }];
                return YES;
            }
        };
        
        cell.changeTFTextBlock = ^(RedBagFillInfoVCodeCell * _Nonnull cell, NSString * _Nonnull str) {
            @StrongObj(self);
            NSIndexPath *tmpIndexPath = [self.tableView indexPathForCell:cell];
            RedBagFillInfoModel *model = self.infoModelArray[tmpIndexPath.row];
            model.content = str;
        };
        return cell;
    }else{
        RedBagFillInfoTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoTBCell"];
        
        cell.changeTFTextBlock = ^(RedBagFillInfoTBCell *cell, NSString *str) {
            @StrongObj(self);
            if (![cell.infoModel.title isEqualToString:@"*渠道地址"]) {
                NSIndexPath *tmpIndexPath = [self.tableView indexPathForCell:cell];
                RedBagFillInfoModel *model = self.infoModelArray[tmpIndexPath.row];
                model.content = str;
            }
            
        };
        
        cell.infoModel = self.infoModelArray[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        [self chooseAddressAction];
    }
}



- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 8) {
        return (screenWidth - 74)/3.0 + 90;
    }else{
        return 44;
    }
}

- (void)chooseAddressAction{
    [self.view endEditing:YES];
    /*显示背景灰色视图*/
    self.pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.pickerBackView.backgroundColor = [UIColor blackColor];
    self.pickerBackView.alpha = 0.4;
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerBackView];
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAddressPickerAction)];
    [self.pickerBackView addGestureRecognizer:tapBack];
    /*显示地址选择器*/
    self.addressPickerView = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 250, screenWidth, 250)];
    self.addressPickerView.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.addressPickerView];
    /*确定按钮 和 取消按钮*/
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 100, screenHeight - 250, 100, 30)];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[Utils colorRGB:@"#0081eb"] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(pickerClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sureButton];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight - 250, 100, 30)];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[Utils colorRGB:@"#0081eb"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(pickerClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cancelButton];
}

- (void)dismissAddressPickerAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.alpha = 0;
        self.addressPickerView.alpha = 0;
        self.sureButton.alpha = 0;
        self.cancelButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.pickerBackView removeFromSuperview];
        [self.addressPickerView removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        [self.sureButton removeFromSuperview];
    }];
}

- (void)pickerClickedAction:(UIButton *)button{
    if ([button.currentTitle isEqualToString:@"确定"]) {
        self.currentCityModel = self.addressPickerView.currentCityModel;
        self.currentProvinceModel = self.addressPickerView.currentProvinceModel;
        
        RedBagFillInfoModel *provinceCityModel = self.infoModelArray[3];
        if ([self.addressPickerView.currentProvinceModel.provinceName isEqualToString:self.addressPickerView.currentCityModel.cityName]) {
            provinceCityModel.content = self.addressPickerView.currentProvinceModel.provinceName;
        }else{
            provinceCityModel.content = [NSString stringWithFormat:@"%@%@",self.addressPickerView.currentProvinceModel.provinceName,self.addressPickerView.currentCityModel.cityName];
        }
        [self.tableView reloadData];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerBackView.alpha = 0;
        self.addressPickerView.alpha = 0;
        self.sureButton.alpha = 0;
        self.cancelButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.pickerBackView removeFromSuperview];
        [self.addressPickerView removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        [self.sureButton removeFromSuperview];
    }];
}

#pragma mark - MemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
