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

#import "WCJWorkSignViewController.h"

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
#import "RedBagFillInfoCell.h"
#import "BaiduMapTool.h"
#import "SearchLocationViewController.h"
#import <Photos/Photos.h>
#import "CameraViewController.h"
#import "FailedView.h"
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
#import "CameraViewController.h"
#import "WintoneCardOCR.h"
#import <AipOcrSdk/AipOcrSdk.h>

#endif

@interface WCJWorkSignViewController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,RedBagFillInfoImageCellDelegate>{
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

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

@property (nonatomic, strong) NSString *dingweiCity;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *prince;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIAlertAction *readAction;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) FailedView *processView;
@property (nonatomic, strong) NSString *imagePath;

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机

@property (strong, nonatomic) WintoneCardOCR *cardRecog;

#endif
@property (assign, nonatomic) int cardType;
@property (assign, nonatomic) int resultCount;
@property (nonatomic, strong) NSString *cropImagePath;

@end


@implementation WCJWorkSignViewController

#pragma mark - View Controller LifeCyle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"工号实名制";
    [self configNav];
    
    [self createMain];
    [self showAlertView];
    self.index = 0;
    
    self.cardType = 2;//身份证
    self.resultCount = 7;
    [self initRecog];
    
    @WeakObj(self);
    [[BaiduMapTool sharedInstance]workSignRequestOnceLocationWithSuccessBlock:^(CLPlacemark *placemark) {
        @StrongObj(self);
        NSArray *infos = self.infoModelArray[1];
        RedBagFillInfoModel *addressModel = infos[0];
        RedBagFillInfoModel *detailModel = infos[1];
        addressModel.content = [NSString stringWithFormat:@"%@%@%@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
        detailModel.content = placemark.thoroughfare;
        [self.tableView reloadData];
        self.city = placemark.locality;
        self.dingweiCity = placemark.locality;
        self.prince = placemark.administrativeArea;
    } withErrorBlock:^(NSError * _Nonnull error) {
        
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeAlert) userInfo:nil repeats:YES];
    
    [self configCallback];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllInfosAction:) name:@"ChooseImageViewRemoveImageAction" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//清除
- (void)clearAllInfosAction:(NSNotification *)noti{
    //清除相关的信息扫描出来的结果--但是老用户不需要清除
    NSDictionary *dataDic = self.loginInfoDic[@"data"];
    NSString *cardId = dataDic[@"cardId"];
    
    //判断是哪张图被清除了
    RedBagFillInfoImageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    UIImageView *iv = cell.chooseImageView.imageViews.firstObject;
    if (iv.hidden == YES) {
        if (cardId == nil || [cardId isEqualToString:@""]) {
            //新用户
            NSArray *infos = self.infoModelArray[0];
            RedBagFillInfoModel *nameM = infos[0];
            nameM.content = @"";
            RedBagFillInfoModel *cardM = infos[1];
            cardM.content = @"";
            RedBagFillInfoModel *addressM = infos[2];
            addressM.content = @"";
            [self.tableView reloadData];
        }
    }
    
}


-(void)changeAlert{
    self.index ++;
    if (self.index == 5) {
        self.readAction.enabled = YES;
//        [self.readAction setValue:MainColor forKey:@"_titleTextColor"];
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)showAlertView{
    NSString *message = @"尊敬的用户，您好！\n        根据工信部文件要求，所有渠道工号必须实名认证。未实名认证工号无法使用，请完善相关资料。\n        为防止工号和设备被滥用，开户工号需在网点使用。完善信息时，请保证渠道信息准确。渠道地址和渠道详细地址指的是网点地址。使用App时请打开定位功能。";
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"已阅读" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:a1];
    
    [a1 setValue:MainColor forKey:@"_titleTextColor"];
    a1.enabled = NO;
    
    self.readAction = a1;
    
    UIView *subView1 = alertVC.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
    //    取title和message：
        UILabel *messageLabel = subView5.subviews[1];
    //    然后设置message内容居左：
    messageLabel.textAlignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:kSetColor(@"666666") range:NSMakeRange(0, message.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, message.length)];
    [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(172, 42));
    }];
    
    self.tableView = UITableView.new;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.estimatedRowHeight = 60;
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
//    self.tableView.tableFooterView = footerView;
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
    [self.tableView registerClass:RedBagFillInfoCell.class forCellReuseIdentifier:@"RedBagFillInfoCell"];
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
    NSArray *firstInfos = self.infoModelArray[0];
    NSArray *lastInfos = self.infoModelArray[1];
    if ([[firstInfos[0] content] length] == 0) {
        // 姓名
        [Utils toastview:@"请输入姓名"];
        return NO;
    } else if ([[firstInfos[1] content] length] == 0) {
           // 身份证号
           [Utils toastview:@"请输入身份证号码"];
        return NO;
    }else if ([[firstInfos[2] content] length] == 0) {
        // 证件地址
        [Utils toastview:@"请输入证件地址"];
        return NO;
    }else if ([[firstInfos[3] content] length] == 0) {
        // 手机号
        [Utils toastview:@"请输入手机号"];
        return NO;
    }else if ([[firstInfos[4] content] length] == 0) {
        // 验证码
        [Utils toastview:@"请输入验证码"];
        return NO;
    }else if ([[lastInfos[0] content] length] == 0) {
           // 渠道地址
           [Utils toastview:@"请选择渠道地址"];
        return NO;
    } else if ([[lastInfos[1] content] length] == 0) {
           // 详细地址
           [Utils toastview:@"请输入详细地址"];
        return NO;
    }else if ([[lastInfos[2] content] length] == 0) {
        // 详细地址
        [Utils toastview:@"请输入网点名称"];
     return NO;
    }
    
    id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];

    RedBagFillInfoImageCell *tmpCell = cell;
    /******上传身份证图片*****/
    UIImageView *frontIV = tmpCell.chooseImageView.imageViews[0];
    if (frontIV.hidden == YES) {
        [Utils toastview:@"请上传身份证正面照"];
        return NO;
    }
    
    UIImageView *backIV = tmpCell.chooseImageView.imageViews[1];
    if (backIV.hidden == YES) {
        [Utils toastview:@"请上传身份证反面照"];
        return NO;
    }
    
    UIImageView *handVC = tmpCell.chooseImageView.imageViews[2];
    if (handVC.hidden == YES) {
        [Utils toastview:@"请上传手持身份证照"];
        return NO;
    }
    
    
    //判断网点照片
    RedBagFillInfoCell *secondImageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    
    UIImageView *firstImageView = secondImageCell.chooseImageView.imageViews[0];
    UIImageView *secondImageView = secondImageCell.chooseImageView.imageViews[1];
    if (firstImageView.hidden == YES && secondImageView.hidden == YES) {
        [Utils toastview:@"营业执照或网点照片至少上传1张"];
        return NO;
    }
    
    
    if (![Utils isMobile:[firstInfos[3] content]]) {
        [Utils toastview:@"请输入正确的手机号格式"];
        return NO;
    }
    
    if (![Utils isIDNumber:[firstInfos[1] content]]) {
        [Utils toastview:@"请输入正确的身份证格式"];
        return NO;
    }
    
    if ([[firstInfos[5] content] length] > 0) {
        // 判断邮箱
        NSString *email = [firstInfos[5] content];
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
    NSArray *infos = self.infoModelArray[0];
    [WebUtils requestCaptchaCheckWithCaptcha:[infos[4] content] andType:5 andTel:[infos[3] content] andCallBack:^(id obj) {
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
    
    NSArray *firstInfos = self.infoModelArray.firstObject;
    NSArray *lastInfos = self.infoModelArray.lastObject;
    
    params[@"contact"] = [firstInfos[0] content];
    params[@"tel"] = [firstInfos[3] content];
    params[@"cardId"] = [firstInfos[1] content];
    params[@"address"] = [firstInfos[2] content];
//    params[@"workAddress"] = [[self.infoModelArray[3] content] stringByAppendingFormat:@"%@", [self.infoModelArray[4] content]];
    params[@"workAddress"] = [lastInfos[1] content];
//    params[@"provinceCode"] = self.currentProvinceModel.provinceId;
//    params[@"cityCode"] = self.currentCityModel.cityId;
    if ([self.city isEqualToString:self.prince]) {//直辖市
        params[@"provinceCode"] = [self.city componentsSeparatedByString:@"市"].firstObject;
        params[@"cityCode"] = [self.city componentsSeparatedByString:@"市"].firstObject;
    }else{//不是直辖市--要去掉省--除了自治区
        NSString *province = [[lastInfos[0] content] componentsSeparatedByString:self.city].firstObject;
        if ([province containsString:@"省"]) {
            params[@"provinceCode"] = [province componentsSeparatedByString:@"省"].firstObject;
        }else{
            params[@"provinceCode"] = province;
        }
        
        params[@"cityCode"] = [self.city componentsSeparatedByString:@"市"].firstObject;
    }
    
    
    params[@"districtCode"] = [[lastInfos[0] content] componentsSeparatedByString:self.city].lastObject;
    
    params[@"branchName"] = [lastInfos[2] content];
    
    if ([firstInfos[5] content] != 0) {
        params[@"email"] = [firstInfos[5] content];
    }
    
    NSArray *keyArray = @[@"photo1",@"photo2",@"photo3"];
    id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
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
    /******上传身份证图片*****/
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
    
    /******上传网点/营业图片*****/
    RedBagFillInfoCell *secondImageCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    
    UIImageView *firstImageView = secondImageCell.chooseImageView.imageViews[0];
    UIImageView *secondImageView = secondImageCell.chooseImageView.imageViews[1];
    if (firstImageView.hidden == YES && secondImageView.hidden == YES) {
        [Utils toastview:@"营业执照或网点照片至少上传1张"];
        return;
    }
    
    NSArray *keys = @[@"licensePic",@"branchPic"];
    for (int i = 0; i < secondImageCell.chooseImageView.imageViews.count; i ++) {
        
        UIImageView *imageView = secondImageCell.chooseImageView.imageViews[i];
        
        if (imageView.hidden == YES) {
            continue;
        }
        
        NSString *imageString = [Utils imagechange:imageView.image];
        imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [params setObject:imageString forKey:keys[i]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        WEAK_SELF
        [self showWaitView];
        [WebUtils updateAgency_dataSupplementWithParams:params andCallback:^(id obj) {
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
    NSDictionary *dataDic = self.loginInfoDic[@"data"];
    NSString *cardId = dataDic[@"cardId"];
    
    NSString *name = @"";
    NSString *idCard = @"";
    NSString *address = @"";
    NSString *phone = @"";
    NSString *email = @"";
    if (cardId == nil || [cardId isEqualToString:@""]) {//新用户
        
    }else{//老用户
        name = dataDic[@"name"];
        idCard = dataDic[@"cardId"];
        if ([dataDic[@"address"] isKindOfClass:[NSNull class]] || dataDic[@"address"] == nil) {
            address = @"";
        }else{
            address = dataDic[@"address"];
        }
        phone = dataDic[@"tel"] == nil ? @"" : dataDic[@"tel"];
        if ([dataDic[@"email"] isKindOfClass:[NSNull class]] || dataDic[@"email"] == nil) {
            email = @"";
        }else{
            email = dataDic[@"email"];
        }
    }
    
    if (_infoModelArray == nil) {
        _infoModelArray = [@[
                             @[[RedBagFillInfoModel modelWithTitle:@"*姓名" placeholder:@"由证件扫描获取" content:name],
                             [RedBagFillInfoModel modelWithTitle:@"*身份证" placeholder:@"由证件扫描获取" content:idCard],
                             [RedBagFillInfoModel modelWithTitle:@"*证件地址" placeholder:@"由证件扫描获取" content:address],
//                             [RedBagFillInfoModel modelWithTitle:@"*渠道地址" placeholder:@"请选择省市" content:@""],
//                             [RedBagFillInfoModel modelWithTitle:@"*渠道详细地址" placeholder:@"请输入详细地址" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"*手机号" placeholder:@"请输入手机号" content:phone],
                             [RedBagFillInfoModel modelWithTitle:@"*验证码" placeholder:@"请输入验证码" content:@""],
                             [RedBagFillInfoModel modelWithTitle:@"电子邮箱" placeholder:@"请输入电子邮箱" content:email],
                             ],
                             @[[RedBagFillInfoModel modelWithTitle:@"*渠道地址" placeholder:@"请输入省市区" content:@""],
                               [RedBagFillInfoModel modelWithTitle:@"*渠道详细地址" placeholder:@"请输入详细地址" content:@""],
                               [RedBagFillInfoModel modelWithTitle:@"*网点名称" placeholder:@"请输入网点名称" content:@""]]] mutableCopy];
    }
    return _infoModelArray;
}


#pragma mark - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = MainColor;
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"用户信息";
    }
    return @"渠道信息";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);
    if (indexPath.section == 0) {
        if (indexPath.row == 6) {
            RedBagFillInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoImageCell"];
            cell.userInteractionEnabled = YES;
            cell.redBagFillInfoImageCellDelegate = self;
            return cell;
        }else if (indexPath.row == 4) {//验证码
            
            RedBagFillInfoVCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoVCodeCell"];
            NSArray *singleTitles =  self.infoModelArray[indexPath.section];
            cell.infoModel = singleTitles[indexPath.row];
            cell.clickVCodeBlock = ^{
                @StrongObj(self);
                if (![Utils isMobile:[singleTitles[3] content]]) {
                    [Utils toastview:@"请输入正确的手机号格式"];
                    return NO;
                }else{
                    [self showWaitView];
                    @WeakObj(self);
                    
                    [WebUtils requestSendCaptchaWithType:5 andTel:[singleTitles[3] content] andCallBack:^(id obj) {
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
//            cell.tf.userInteractionEnabled = YES;
            cell.userInteractionEnabled = YES;
            cell.changeTFTextBlock = ^(RedBagFillInfoVCodeCell * _Nonnull cell, NSString * _Nonnull str) {
                @StrongObj(self);
                NSIndexPath *tmpIndexPath = [self.tableView indexPathForCell:cell];
                RedBagFillInfoModel *model = singleTitles[tmpIndexPath.row];
                model.content = str;
            };
            return cell;
            
        }else{
            RedBagFillInfoTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoTBCell"];
            NSArray *singleTitles = self.infoModelArray[indexPath.section];
            cell.infoModel = singleTitles[indexPath.row];
            NSDictionary *dataDic = self.loginInfoDic[@"data"];
            NSString *cardId = dataDic[@"cardId"];
            if (cardId == nil || [cardId isEqualToString:@""]) {//新用户
                if (indexPath.row == 3||indexPath.row == 5) {
                    cell.userInteractionEnabled = YES;
                }else{
                    cell.userInteractionEnabled = NO;
                }
            }else{
                if (indexPath.row == 5) {
                    cell.userInteractionEnabled = YES;
                }else{
                    cell.userInteractionEnabled = NO;
                }
            }
            if (indexPath.row == 2) {//证件地址
                if (cell.tf.text.length>0) {
                    cell.tf.hidden = YES;
                    cell.addressLabel.text = cell.tf.text;
                }else{
                    cell.tf.hidden = NO;
                    cell.addressLabel.text = @"";
                }
            }else{
                cell.tf.hidden = NO;
                cell.addressLabel.text = @"";
            }
            
            cell.changeTFTextBlock = ^(RedBagFillInfoTBCell *cell, NSString *str) {
                @StrongObj(self);
                if (![cell.infoModel.title isEqualToString:@"*渠道地址"]) {
                    NSIndexPath *tmpIndexPath = [self.tableView indexPathForCell:cell];
                    NSArray *singleTitles = self.infoModelArray[tmpIndexPath.section];
                    RedBagFillInfoModel *model = singleTitles[tmpIndexPath.row];
                    model.content = str;
                }
                
            };
            
            
            
            return cell;
        }
    }else{
        if (indexPath.row == 3) {
            RedBagFillInfoCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoCell" forIndexPath:indexPath];
            return imageCell;
        }else{
            NSArray *singleTitles = self.infoModelArray[indexPath.section];
//            RedBagFillInfoModel *model = singleTitles[indexPath.row];
            RedBagFillInfoTBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RedBagFillInfoTBCell"];
            cell.userInteractionEnabled = YES;
            if (indexPath.row == 0) {
                cell.tf.userInteractionEnabled = NO;
            }else if (indexPath.row == 1){
                cell.tf.userInteractionEnabled = YES;
            }else{
                cell.tf.userInteractionEnabled = YES;
            }
            cell.changeTFTextBlock = ^(RedBagFillInfoTBCell *cell, NSString *str) {
                @StrongObj(self);
                if (![cell.infoModel.title isEqualToString:@"*渠道地址"]) {
                    NSIndexPath *tmpIndexPath = [self.tableView indexPathForCell:cell];
                    NSArray *singleTitles = self.infoModelArray[tmpIndexPath.section];
                    RedBagFillInfoModel *model = singleTitles[tmpIndexPath.row];
                    model.content = str;
                }
                
            };
            
            
            cell.infoModel = singleTitles[indexPath.row];
            
            return cell;
        }
        
    }
    
}

-(NSString *)hidePartWithStr:(NSString *)Str holderSingleStr:(NSString *)holderSingleStr location:(NSInteger)location length:(NSInteger)length
{
    NSString *hideNumStr = Str;
    NSString *placeHolderStr=[NSString string];
    if ( Str != nil)//判断非空
    {
        for (int i=0; i<length; i++)
        {
            placeHolderStr = [placeHolderStr stringByAppendingString:holderSingleStr];
        }
        hideNumStr =[Str stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:placeHolderStr];
    }
    return hideNumStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section == 1) {
//        [self chooseAddressAction];
        SearchLocationViewController *vc = [[SearchLocationViewController alloc]init];
        vc.city = self.dingweiCity;
        vc.prince = self.prince;
        @WeakObj(self);
        vc.mycallBack = ^(BMKPoiInfo * _Nonnull location) {
            @StrongObj(self);
            //地区
            NSArray *areaInfos = self.infoModelArray[1];
            RedBagFillInfoModel *provinceCityModel = areaInfos[0];
            if ([location.province isEqualToString:location.city]) {
                provinceCityModel.content = [NSString stringWithFormat:@"%@%@",location.city,location.area];
                self.city = location.city;
                self.prince = location.province;
            }else{
                provinceCityModel.content = [NSString stringWithFormat:@"%@%@%@",location.province,location.city,location.area];
                self.city = location.city;
                self.prince = location.province;
            }
            
            //详细地址
            NSArray *detailInfos = self.infoModelArray[1];
            RedBagFillInfoModel *detailModel = detailInfos[1];
            detailModel.content = [NSString stringWithFormat:@"%@%@",location.address,location.name];
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)scanIdentify{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    @WeakObj(self);
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
            dispatch_async(dispatch_get_main_queue(), ^{
                @StrongObj(self);
                if (granted) {
                    NSLog(@"Authorized");
                    
                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                    imagePicker.delegate = self;
                    
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                }else{
                    NSLog(@"Denied or Restricted");
                    [self showWarningAction];
                }
            });
        }];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker2 animated:YES completion:nil];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [ac addAction:action2];

    [ac addAction:action3];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showWarningAction{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中授权使用相册和相机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [self presentViewController:ac animated:YES completion:nil];
}



- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 2) {//证件地址
        return UITableViewAutomaticDimension;
    }
    if ((indexPath.section == 0 && indexPath.row == 6)||(indexPath.section == 1 && indexPath.row == 3)) {
        return (screenWidth - 74)/3.0 + 90;
    }else{
        return 44;
    }
//    if (indexPath.row == 8) {
//        return (screenWidth - 74)/3.0 + 90;
//    }else{
//        return 44;
//    }
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

#pragma mark - UIImagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark RedBagFillInfoImageCellDelegate
-(void)scanForInformation{
    NSDictionary *dataDic = self.loginInfoDic[@"data"];
    NSString *cardId = dataDic[@"cardId"];
    if (cardId == nil || [cardId isEqualToString:@""]) {//新用户
        RedBagFillInfoImageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在扫描" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
        
        UIImageView *imageV = (UIImageView *)cell.chooseImageView.imageViews.firstObject;
        
        [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:imageV.image];
    }
    //老用户换了证件也不需要扫描替换信息
    
    
//    imageV.image = [WatermarkMaker watermarkImageForImage:imageV.image];
}

//存储照片
-(void)didFinishedSelect:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    UIImage *saveImage = image;
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"HjsjIDCardFree.jpg"];
    
    
    //存储图片
    [UIImageJPEGRepresentation(saveImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
    NSLog(@"%.2f",UIImageJPEGRepresentation(saveImage, 1).length/1024.0);
    
    _imagePath = imageFilePath;
    [self performSelectorInBackground:@selector(recog:) withObject:image];
}

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
//初始化核心
- (void) initRecog
{
    NSDate *before = [NSDate date];
    self.cardRecog = [[WintoneCardOCR alloc] init];
    /*提示：该开发码和项目中的授权仅为演示用，客户开发时请替换该开发码及项目中Copy Bundle Resources 中的.lsc授权文件*/
    
    //6KAD5PY65LIW55W   话机世界的
    
    int intRecog = [self.cardRecog InitIDCardWithDevcode:@"6KAD5PY65LIW55W" recogLanguage:0];
    NSLog(@"intRecog = %d",intRecog);
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:before];
    NSLog(@"%f", time);
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result) {
        NSLog(@"%@", result);
                
        __block NSString *name = @"";
        __block NSString *idNO = @"";
        __block NSString *address = @"";
        
        if (result[@"words_result"]) {
            if ([result[@"words_result"] isKindOfClass:[NSDictionary class]]) {
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSString *content = @"";
                    
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        content = obj[@"words"];
                    } else {
                        content = obj;
                    }
                    
                    if ([key isEqualToString:@"姓名"]) {
                        name = content;
                    }
                    
                    if ([key isEqualToString:@"公民身份号码"]) {
                        idNO = content;
                    }
                    
                    if ([key isEqualToString:@"住址"]) {
                        address = content;
                    }
                }];
            } else if ([result[@"words_result"] isKindOfClass:[NSArray class]]) {
                NSArray *results = result[@"words_result"];
                for(int i = 0; i < results.count; i ++) {
                    id obj = results[i];
                    NSString *content = @"";
                    if ([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        content = obj[@"words"];
                    } else {
                        content = obj;
                    }
                    
                    if (i == 0) {
                        name = content;
                    }
                    
                    if (i == 2) {
                        idNO = content;
                    }
                    
                    if (i == results.count - 1) {
                        address = content;
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.processView removeFromSuperview];
                
                NSArray *infos = weakSelf.infoModelArray[0];
                
                RedBagFillInfoModel *nameModel = infos[0];
                nameModel.content = name;
                
                RedBagFillInfoModel *verIdModel = infos[1];
                verIdModel.content = idNO;
                
                RedBagFillInfoModel *addressModel = infos[2];
                addressModel.content = address;
                
                [weakSelf.tableView reloadData];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.processView removeFromSuperview];
                [Utils toastview:@"身份证照片读取失败！"];
            });
        }
    };
    
    _failHandler = ^(NSError *error) {
        NSLog(@"%@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.processView removeFromSuperview];
            [Utils toastview:@"身份证照片读取失败！"];
        });
    };
}

- (void)recog:(UIImage *)image
{
    [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];
    
    return;
    
    //设置导入识别模式和证件类型
    [self.cardRecog setParameterWithMode:0 CardType:self.cardType];
    //图片预处理 7－裁切+倾斜校正+旋转
    [self.cardRecog processImageWithProcessType:7 setType:1];
    
    //导入图片数据
    int loadImage = [self.cardRecog LoadImageToMemoryWithFileName:_imagePath Type:0];
    
    NSLog(@"loadImage = %d", loadImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = paths[0];
    NSString *imagepath = [caches stringByAppendingPathComponent:@"image.jpg"];
    NSString *headImagePath = [caches stringByAppendingPathComponent:@"head.jpg"];
    
    if (self.cardType != 3000) {//***注意：机读码需要自己重新设置类型来识别
        if (self.cardType == 2) {
            
            //自动分辨二代证正反面
            [self.cardRecog autoRecogChineseID];
        }else{
            //其他证件
            [self.cardRecog recogIDCardWithMainID:self.cardType];
        }
        //非机读码，保存头像
        [self.cardRecog saveHeaderImage:headImagePath];
        
        //获取识别结果
        NSString *allResult = @"";
        [self.cardRecog saveImage:imagepath];
        _cropImagePath = imagepath;
        
        for (int i = 1; i < self.resultCount; i++) {
            
            //获取字段值
            NSString *field = [self.cardRecog GetFieldNameWithIndex:i];
            //获取字段结果
            NSString *result = [self.cardRecog GetRecogResultWithIndex:i];
            NSLog(@"%@:%@\n",field, result);
            if(field != NULL){
                allResult = [allResult stringByAppendingString:[NSString stringWithFormat:@"%@:%@\n", field, result]];
            }
        }
        if (![allResult isEqualToString:@""] && [allResult containsString:@"公民身份号码"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.processView removeFromSuperview];
                
                //得到结果之后
                NSArray *array = [allResult componentsSeparatedByString:@"\n"];
                NSArray *infos = self.infoModelArray[0];
                
                RedBagFillInfoModel *nameModel = infos[0];
                NSString *nameString = [array.firstObject componentsSeparatedByString:@":"].lastObject;
                nameModel.content = nameString;
                
                RedBagFillInfoModel *verIdModel = infos[1];
                NSString *idString = [array[5] componentsSeparatedByString:@":"].lastObject;
                verIdModel.content = idString;
                
                RedBagFillInfoModel *addressModel = infos[2];
                NSString *addressString = [array[4] componentsSeparatedByString:@":"].lastObject;
                addressModel.content = addressString;
                
                [self.tableView reloadData];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.processView removeFromSuperview];
                [Utils toastview:@"身份证照片读取失败！"];
            });
        }
    }
}
#endif


@end
