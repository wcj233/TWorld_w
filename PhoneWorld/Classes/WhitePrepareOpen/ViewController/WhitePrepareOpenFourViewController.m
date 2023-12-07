//
//  WhitePrepareOpenFourViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenFourViewController.h"
#import "WhitePrepareOpenFourView.h"
#import "FailedView.h"
#import "PopView.h"//蓝牙列表弹出框
#import <STIDCardReader/STIDCardReader.h>//蓝牙读身份证
#import "NormalInputCell.h"
#import "PersonCardModel.h"
#import "AppDelegate.h"
#import "AddressCell.h"
#import "WhitePrepareOpenOneViewController.h"
#import "LiangListViewController.h"
#import "NewFinishedCardSignViewController.h"
#import "ChooseIDTypeAlertV.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
#import <AipOcrSdk/AipOcrSdk.h>
#endif

#import "WatermarkMaker.h"

//弹出框
#import <YBPopupMenu.h>
//3代
#import "SRIDCardReader/SRIDCardReader.h"
#import "SRIDCardReader/sm4.h"
#import "SRIDCardReader/ByteUtil.h"
#import "SRIDCardReader/HexUtil.h"
#import <dlfcn.h>
#import "ZSYPopoverListView.h"
//人脸识别
#import "FMFileVideoController.h"
static NSString *const kCharacteristicUUID = @"CCE62C0F-1098-4CD0-ADFA-C8FC7EA2EE90";
static NSString *const kServiceUUID = @"50BD367B-6B17-4E81-B6E9-F62016F26E7B";

@interface WhitePrepareOpenFourViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,WhitePrepareOpenFourViewDelegate, ChooseImageViewDelegate,YBPopupMenuDelegate,
//3代
SRIDCardReaderDelegate,
ZSYPopoverListDatasource,
ZSYPopoverListDelegate,
CBCentralManagerDelegate> {
    NSString *_imagePath;
    NSString *_cropImagePath;//裁切完成图片的路径
    //3代蓝牙连接设备Manage
    SRIDCardReader* idManager;
    CBCentralManager *manager;
    ZSYPopoverListView *listView;
    int rowCount;
    NSMutableArray *deviceList;
    NSObject *currentDevice;
    NSString *isExistOpenMode;
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

@property (nonatomic) WhitePrepareOpenFourView *fourView;

@property (nonatomic) FailedView *processView;

/**
 1 最终识别仪开户，2 最终扫描开户
 */
@property (assign, nonatomic) NSInteger scanType;

@property (nonatomic) BOOL isAuto;//是否自动还是手动
@property (nonatomic) PopView *popView;//点击读取信息的时候弹出框显示所有搜索到的蓝牙
@property (nonatomic) PersonCardModel *personModel;//读出来的身份证信息

//扫描识别
@property (assign, nonatomic) int cardType; //身份类型 居民身份证 1 外国人永久居留身份证 2
@property (assign, nonatomic) int resultCount;//
@property (strong, nonatomic) NSString *typeName;

//3代蓝牙视图
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end

@implementation WhitePrepareOpenFourViewController
@synthesize selectedIndexPath = _selectedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"信息采集";
    
    self.fourView = [[WhitePrepareOpenFourView alloc] initWithFrame:CGRectZero andType:self.typeString isFaceVerify:self.isFaceVerify];
    [self.view addSubview:self.fourView];
    if ([self.typeString isEqualToString:@"写卡激活"]) {
        [self.fourView.openButton setTitle:@"下一步" forState:UIControlStateNormal];
        
    }
    [self.fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    //初始化3代蓝牙Manage
    [self SRInit];
    
    [self.fourView.openButton addTarget:self action:@selector(openAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //初始化
    self.resultCount = 7;
    //默认身份证
    self.cardType = 1;
    self.isAuto = NO;//是否自动
    
    /*****写卡激活添加识别仪、扫描判断--其他的不确定--所以先把写卡激活分出来*****/
    if (![self.typeString isEqualToString:@"写卡激活"]) {
        // 标题添加点击手势，用于修改扫描方式
        self.fourView.chooseImageView.titleLB.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScanType)];
        [self.fourView.chooseImageView.titleLB addGestureRecognizer:tap];
        // 默认 1 扫描开户
        self.scanType = 1;
        [self openWayAction:self.openWay];
        
        // 第一次设置扫描方式
        [self changeScanType];
    }else{
        // 标题添加点击手势，用于修改扫描方式
        self.fourView.chooseImageView.titleLB.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeModel:)];
        [self.fourView.chooseImageView.titleLB addGestureRecognizer:tap];
        [self initCardOpenMode];
    }
    
    
    //清除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllInfosAction:) name:@"ChooseImageViewRemoveImageAction" object:nil];
    
    [self configCallback];
    
    [self showChooseCardTypeAction];
}

- (void)showChooseCardTypeAction {
    
    ChooseIDTypeAlertV *v = [[ChooseIDTypeAlertV alloc] init];
    [[UIApplication sharedApplication].delegate.window addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [v showAnimation];
    @WeakObj(self);
    v.OkBlock = ^(NSInteger tag) {
        @StrongObj(self);
        self.cardType = tag;
        if (tag == 2) {
            if (![self.typeString isEqualToString:@"写卡激活"]) {
                [self changeScanType];
            }else{
                [self changeTipStyle];
            }
        }
        
        self.fourView.cardType = tag;
    };
}

//根据上一个界面传过来的值判断当前事识别仪还是扫描获取身份证信息
/// cardOpenModes:扫描/识别仪/全部(1/2/3))
- (void)setCardOpenMode:(int)cardOpenMode{
    _cardOpenMode = cardOpenMode;
    isExistOpenMode = @"YES";
    _scanType = cardOpenMode;
}

-(void)initCardOpenMode{
    if ([self.typeString isEqualToString:@"写卡激活"]) {
        
        if (self.cardOpenMode == 2) {
            //识别仪
            UIImage *orignalImage = [UIImage imageNamed:@"font1"];
            orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction:)];
        }else{
            //3 都可以 1 扫描 （默认进来都是扫描用户）
            UIImage *orignalImage = [UIImage imageNamed:@"font2"];
            orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:nil];
            //扫描
            [self performSelectorInBackground:@selector(initRecog) withObject:nil];
        }
        
        if (self.cardOpenMode==3) {//全部的话
            if (_scanType==3) {
                _scanType=1;//默认扫描
            }
        }else if (self.cardOpenMode==1){//扫描
            self.fourView.whitePrepareOpenFourViewDelegate = self;
        }else{
            self.fourView.whitePrepareOpenFourViewDelegate = self;
        }
        
        [self changeTipStyle];
    }
}

-(void)changeModel:(UITapGestureRecognizer *)gesture{
    if (self.scanType == 1) {
        self.scanType = 2;
    } else if (self.scanType == 2) {
        self.scanType = 1;
    }
    
    [self changeTipStyle];
}

-(void)changeTipStyle{
    // 切换
    
    for (int i = 0; i<self.fourView.chooseImageView.imageViews.count; i++) {
        UIImageView *imageV = self.fourView.chooseImageView.imageViews[i];
        UIButton *button = self.fourView.chooseImageView.removeButtons[i];
        imageV.hidden = YES;
        button.hidden = YES;
        UIButton *addImageButton = self.fourView.chooseImageView.imageButtons[i];
        addImageButton.userInteractionEnabled = YES;
        if (i==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseImageViewRemoveImageAction" object:button];
        }
    }
    
    self.fourView.isIDCardEnable = NO;
    self.fourView.infoArray = [NSMutableArray array];
    
    NSString *title = @"识别仪开户";
    if (_scanType==2) {//识别仪用户
        title = @"扫描开户";
        UIImage *orignalImage = [UIImage imageNamed:@"font1"]; // 亮色字体
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction:)];
        //        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"scanForInformation" object:nil];
        self.fourView.whitePrepareOpenFourViewDelegate = nil;
    }else{
        UIImage *orignalImage = [UIImage imageNamed:@"font2"]; // 暗色字体
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:nil];
        self.fourView.whitePrepareOpenFourViewDelegate = self;
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanForInformationAction) name:@"scanForInformation" object:nil];
        
        if (self.cardType == 2) {
            //外国人
            self.fourView.isIDCardEnable = YES;
        }
    }
    if (_cardOpenMode==3) {//全部
        NSMutableAttributedString *s1 = [[NSMutableAttributedString alloc]initWithString:@"证件上传（点击图片可放大）" attributes:@{NSForegroundColorAttributeName:[Utils colorRGB:@"#333333"],NSFontAttributeName:font14}];
        NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[Utils colorRGB:@"#008BD5"],NSFontAttributeName:font16}];
        [s1 appendAttributedString:s2];
        self.fourView.chooseImageView.titleLB.attributedText = s1;
        self.fourView.chooseImageView.titleLB.userInteractionEnabled = YES;
    }else{
        self.fourView.chooseImageView.titleLB.userInteractionEnabled = NO;
    }
    
}

// 修改扫描方式
- (void)changeScanType {
    // 切换
    if (self.scanType == 1) {
        self.scanType = 2;
    } else if (self.scanType == 2) {
        self.scanType = 1;
    }
    
    NSString *title = @"";
    
    self.fourView.isIDCardEnable = NO;
    self.fourView.infoArray = [NSMutableArray array];
    
    
    if (self.scanType == 1) {
        // 1 可切换到扫描开户，当前是识别仪开户
        title = @"扫描开户";
        UIImage *orignalImage = [UIImage imageNamed:@"font1"];
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction:)];
        //        self.fourView.chooseImageView.chooseImageViewDelegate = nil;
        self.fourView.whitePrepareOpenFourViewDelegate = nil;
    } else if (self.scanType == 2) {
        // 2 可切换到识别仪开户，当前是扫描开户
        title = @"识别仪开户";
        UIImage *orignalImage = [UIImage imageNamed:@"font2"];
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:nil];
        //        self.fourView.chooseImageView.chooseImageViewDelegate = self;
        self.fourView.whitePrepareOpenFourViewDelegate = self;
        
        if (self.cardType == 2) {
            //外国人
            self.fourView.isIDCardEnable = YES;
        }
    }
    
    NSMutableAttributedString *s1 = [[NSMutableAttributedString alloc]initWithString:@"证件上传（点击图片可放大）" attributes:@{NSForegroundColorAttributeName:[Utils colorRGB:@"#333333"],NSFontAttributeName:font14}];
    NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[Utils colorRGB:@"#008BD5"],NSFontAttributeName:font16}];
    [s1 appendAttributedString:s2];
    self.fourView.chooseImageView.titleLB.attributedText = s1;
    //    self.informationCollectionView.chooseImageView.titleLB.userInteractionEnabled = YES;
    
    for (int i = 0; i<self.fourView.chooseImageView.imageViews.count; i++) {
        UIImageView *imageV = self.fourView.chooseImageView.imageViews[i];
        UIButton *button = self.fourView.chooseImageView.removeButtons[i];
        imageV.hidden = YES;
        button.hidden = YES;
        UIButton *addImageButton = self.fourView.chooseImageView.imageButtons[i];
        addImageButton.userInteractionEnabled = YES;
        if (i==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseImageViewRemoveImageAction" object:button];
        }
    }
}

#pragma mark - Method ------------------------
//删除扫描照片的时候清除扫描得到的信息
- (void)clearAllInfosAction:(NSNotification *)noti{
    
    self.fourView.infoArray = [NSMutableArray array];
    
    if (self.cardType == 2) {
        //扫描下的外国人
        if (![self.typeString isEqualToString:@"写卡激活"]) {
            if (self.scanType == 2) {
                self.fourView.infoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"中华人民共和国国家移民管理局"]];
            }
        } else {
            if (self.scanType == 1) {
                self.fourView.infoArray = [NSMutableArray arrayWithArray:@[@"", @"", @"中华人民共和国国家移民管理局"]];
            }
        }
    }
    [self.fourView.contentTableView reloadData];
}

//开户
- (void)openAction:(UIButton *)button{
    [self.view endEditing:YES];
    
    __block NSMutableDictionary *sendDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.fourView.infoArray.count == 3 && ![self.fourView.infoArray containsObject:@""]) {
        [sendDictionary setObject:self.fourView.infoArray[0] forKey:@"customerName"];
        [sendDictionary setObject:self.fourView.infoArray[1] forKey:@"certificatesNo"];
        [sendDictionary setObject:self.fourView.infoArray[2] forKey:@"address"];
    }else{
        [Utils toastview:@"请获取开户人信息"];
        return;
    }
    
    if (self.cardType == 2) {
        if (!([self.fourView.infoArray[1] hasPrefix:@"9"] || [Utils JudgeString:self.fourView.infoArray[1]])) {
            [Utils toastview:@"请检查您输入的证件号是否正确"];
            
            return;
        }
    }
    
    //固定的
    [sendDictionary setObject:@"Idcode" forKey:@"certificatesType"];
    [sendDictionary setObject:@"ESIM" forKey:@"cardType"];
    
    @WeakObj(self);
    
    //话机世界靓号平台的开户------------------------
    if ([self.typeString isEqualToString:@"话机世界靓号平台"]) {
        
        [sendDictionary setObject:self.orderNo forKey:@"orderNo"];
        
        [sendDictionary setObject:self.imsiDictionary[@"simId"] forKey:@"simId"];
        
        [sendDictionary setObject:self.imsiDictionary[@"imsi"] forKey:@"imsi"];
        [sendDictionary setObject:self.iccidString forKey:@"iccid"];
        
        [sendDictionary setObject:self.packagesDictionary[@"id"] forKey:@"packageId"];
        [sendDictionary setObject:self.promotionDictionary[@"id"] forKey:@"promotionsId"];
        
        [sendDictionary setObject:self.numberModel.prestore forKey:@"orderAmount"];
        [sendDictionary setObject:self.numberModel.prestore forKey:@"payAmount"];
        [sendDictionary setObject:self.numberModel.number forKey:@"number"];
        
        NSString *autoString = @"手工";
        if (self.isAuto) {
            autoString = @"读取";
        }
        
        [sendDictionary setObject:[NSString stringWithFormat:@"%d",self.payMethod] forKey:@"payMethod"];
        
        [sendDictionary setObject:autoString forKey:@"authenticationType"];
        
        NSArray *keyArray = @[@"memo4",@"photoFront",@"photoBack"];
        
        for (int i = 0; i < keyArray.count; i ++) {
            UIImageView *imageView = self.fourView.chooseImageView.imageViews[i];
            
            if (imageView.hidden == YES) {
                [Utils toastview:@"请选择图片"];
                return;
            }
            
            NSString *imageString = [Utils imagechange:imageView.image];
            imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [sendDictionary setObject:imageString forKey:keyArray[i]];
        }
        
        [Utils toastview:@"正在开户中，请稍候"];
        
        [WebUtils requestHJSJLiangOpenWithDictionary:sendDictionary andCallBack:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                
                @StrongObj(self);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.processView removeFromSuperview];
                });
                
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"购买成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            //跳转到特定界面
                            NSArray *temArray = self.navigationController.viewControllers;
                            for(UIViewController *temVC in temArray){
                                if ([temVC isKindOfClass:[LiangListViewController class]]){
                                    [self.navigationController popToViewController:temVC animated:YES];
                                }
                            }
                        }];
                        
                        [ac addAction:action1];
                        [self presentViewController:ac animated:YES completion:nil];
                    });
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
        
    }else if([self.typeString isEqualToString:@"渠道商白卡预开户"]){
        //渠道商白卡预开户开户------------------
        
        [sendDictionary setObject:self.detailDictionary[@"simId"] forKey:@"simId"];
        
        [sendDictionary setObject:self.detailDictionary[@"imsi"] forKey:@"imsi"];
        [sendDictionary setObject:self.detailDictionary[@"iccid"] forKey:@"iccid"];
        
        [sendDictionary setObject:self.detailDictionary[@"packageId"] forKey:@"packageId"];
        [sendDictionary setObject:self.detailDictionary[@"promotionId"] forKey:@"promotionId"];
        
        [sendDictionary setObject:self.detailDictionary[@"amount"] forKey:@"orderAmount"];
        [sendDictionary setObject:self.detailDictionary[@"amount"] forKey:@"payAmount"];
        
        [sendDictionary setObject:self.detailDictionary[@"number"] forKey:@"number"];
        
        //图片
        NSArray *keyArray = @[@"photo1",@"photo2",@"photo3"];
        
        for (int i = 0; i < keyArray.count; i ++) {
            UIImageView *imageView = self.fourView.chooseImageView.imageViews[i];
            
            if (imageView.hidden == YES) {
                [Utils toastview:@"请选择图片"];
                return;
            }
            
            NSString *imageString = [Utils imagechange:imageView.image];
            imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [sendDictionary setObject:imageString forKey:keyArray[i]];
        }
        
        [Utils toastview:@"正在开户中，请稍候"];
        
        [WebUtils requestWhitePrepareOpenFinalWith:sendDictionary andCallBack:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *titleString = @"开户成功！";
                        [Utils showOpenSucceedViewWithTitle:titleString];
                        
                        [NSTimer scheduledTimerWithTimeInterval:1.2 repeats:NO block:^(NSTimer * _Nonnull timer) {
                            //跳转到特定界面
                            NSArray *temArray = self.navigationController.viewControllers;
                            for(UIViewController *temVC in temArray){
                                if ([temVC isKindOfClass:[WhitePrepareOpenOneViewController class]]){
                                    [self.navigationController popToViewController:temVC animated:YES];
                                }
                            }
                        }];
                    });
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }else if([self.typeString isEqualToString:@"重新加载资料"]){
        
        [sendDictionary setObject:self.orderNo forKey:@"orderNo"];
        NSString *autoString = @"手工";
        if (self.scanType == 1) {
            // 识别仪开户
            autoString = @"App识别仪";
        } else if (self.scanType == 2) {
            // 扫描开户
            autoString = @"App扫描";
        }
        
        [sendDictionary setObject:[NSString stringWithFormat:@"%d",self.payMethod] forKey:@"payMethod"];
        
        [sendDictionary setObject:autoString forKey:@"authenticationType"];
        
        NSArray *keyArray = @[@"memo4",@"photoFront",@"photoBack"];
        
        for (int i = 0; i < keyArray.count; i ++) {
            UIImageView *imageView = self.fourView.chooseImageView.imageViews[i];
            
            if (imageView.hidden == YES) {
                [Utils toastview:@"请选择图片"];
                return;
            }
            
            NSString *imageString = [Utils imagechange:imageView.image];
            imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [sendDictionary setObject:imageString forKey:keyArray[i]];
        }
        
        [Utils toastview:@"正在提交中，请稍候"];
        
        [WebUtils requestHJSJLiangBUDengjiWithDictionary:sendDictionary andCallBack:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                
                @StrongObj(self);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.processView removeFromSuperview];
                });
                
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }];
                        
                        [ac addAction:action1];
                        [self presentViewController:ac animated:YES completion:nil];
                    });
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
        
    }else if ([self.typeString isEqualToString:@"写卡激活"]){
        /*******人脸识别的话 分开传********/
        if (self.isFaceVerify) {
            //人脸识别
            [self goFaceRecognitionForSendDictionary:sendDictionary];
        }else{
            //跳转开户协议
            [self goAccountAgreementForSendDictionary:sendDictionary andIsFace:NO];
        }
        
    }
}

/****人像的写卡激活****/
- (void)setOpenNetWithFaceForSendDictionary:(NSDictionary *)sendDictionary{
    [Utils toastview:@"正在提交中，请稍候"];
    __block NSDictionary *sendDictionary_standby = [sendDictionary mutableCopy];
    @WeakObj(self);
    [WebUtils agency_2019setOpenWithFaceWithDictionary:[NSMutableDictionary dictionaryWithDictionary:sendDictionary] andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                [Utils toastview:@"开户成功"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"订单提交失败，是否重新提交？" preferredStyle:UIAlertControllerStyleAlert];
                    @WeakObj(self);
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self setOpenNetWithFaceForSendDictionary:sendDictionary_standby];
                    }];
                    [ac addAction:action1];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                    }];
                    [ac addAction:cancel];
                    [self presentViewController:ac animated:YES completion:nil];
                });
            }
        }
    }];
}
//普通激活
- (void)setOpenNetWithNormalForSendDictionary:(NSDictionary *)sendDictionary{
    [Utils toastview:@"正在提交中，请稍候"];
    __block NSDictionary *sendDictionary_standby = [sendDictionary mutableCopy];
    @WeakObj(self);
    [WebUtils requestNormalSetOpenWithDictionary:[NSMutableDictionary dictionaryWithDictionary:sendDictionary] andcallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                [Utils toastview:@"开户成功"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"订单提交失败，是否重新提交？" preferredStyle:UIAlertControllerStyleAlert];
                    @WeakObj(self);
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self setOpenNetWithFaceForSendDictionary:sendDictionary_standby];
                    }];
                    [ac addAction:action1];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                    }];
                    [ac addAction:cancel];
                    [self presentViewController:ac animated:YES completion:nil];
                });
            }
        }
    }];
    
}

//写卡激活
- (void)setOpenNetForSendDictionary:(NSDictionary *)sendDictionary{
    [Utils toastview:@"正在提交中，请稍候"];
    __block NSDictionary *sendDictionary_standby = [sendDictionary mutableCopy];
    @WeakObj(self);
    [WebUtils agency_2019setOpenWithWithDictionary:[NSMutableDictionary dictionaryWithDictionary:sendDictionary] andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                [Utils toastview:@"开户成功"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"订单提交失败，是否重新提交？" preferredStyle:UIAlertControllerStyleAlert];
                    @WeakObj(self);
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self setOpenNetForSendDictionary:sendDictionary_standby];
                    }];
                    [ac addAction:action1];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                    }];
                    [ac addAction:cancel];
                    [self presentViewController:ac animated:YES completion:nil];
                });
            }
        }
    }];
}

//根据上一个界面传过来的值判断当前事识别仪还是扫描获取身份证信息
- (void)openWayAction:(NSString *)openWay{
    
    if ([self.openWay isEqualToString:@"扫描开户"]) {
        [self performSelectorInBackground:@selector(initRecog) withObject:nil];
        self.fourView.whitePrepareOpenFourViewDelegate = self;
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanForInformationAction) name:@"scanForInformation" object:nil];
    }else{
        self.fourView.whitePrepareOpenFourViewDelegate = nil;
        //识别仪开户 收不到通知所以不会进扫描的方法
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"读取信息" style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction:)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont14]} forState:UIControlStateNormal];
    }
}

/*-----识别仪开户--------------------*/

//识别仪操作
- (void)readInfoAction:(UIBarButtonItem *)item{
    //    [YBPopupMenu showAtPoint:CGPointMake(screenWidth - 50, kStatusBarHeight + kNavigationBarHeight) titles:@[@"山东信通",@"森锐"] icons:nil menuWidth:110 otherSettings:^(YBPopupMenu *popupMenu) {
    //        popupMenu.dismissOnSelected = YES;
    //        popupMenu.isShowShadow = YES;
    //        popupMenu.delegate = self;
    //        popupMenu.type = YBPopupMenuTypeDefault;
    //        popupMenu.cornerRadius = 1;
    //        popupMenu.rectCorner = UIRectCornerBottomLeft| UIRectCornerBottomRight;
    //        popupMenu.tag = 100;
    //        //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
    //        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //        popupMenu.textColor = kSetColor(@"666666");
    //    }];
    
    //    if (index == 0) {//老的识别仪
    //        [self oldIdentifyMachine];
    //    }else{
    deviceList = nil;
    rowCount = 0;
    manager.delegate = self;
    [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    [listView show];
    //    }
    
}

#pragma mark - 2019
- (void)oldIdentifyMachine{
    //读卡+写卡（imsi+smscent）操作
    @WeakObj(self);
    self.isAuto = YES;
    
    [[STIDCardReader instance] setDelegate:self];
    
    self.popView = [[PopView alloc] init];
    [self.view addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    [self.popView setPopCallBack:^(id obj) {
        @StrongObj(self);
        //点击popView黑色背景隐藏popView
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BlueManager instance] stopScan];
            [self startScareCard];
            self.popView.hidden = YES;
        });
    }];
}

#pragma mark - 蓝牙读取身份证信息 -------bluetooth------------

-(void)startScareCard{
    
    BlueManager *bmanager = [BlueManager instance];
    bmanager.deleagte = (id)self;
    if(bmanager.linkedPeripheral == nil){
        [Utils toastview:@"请先选中要连接的蓝牙设备!"];
    }else{
        if(bmanager.linkedPeripheral.peripheral.state != CBPeripheralStateConnected){
            NSLog(@"蓝牙处于未连接状态,先连接蓝牙!");
            [[BlueManager instance] connectPeripher:bmanager.linkedPeripheral];
        }else{
            NSLog(@"蓝牙处在连接状态,直接进行读卡的操作!");
            [[STIDCardReader instance] setDelegate:(id)self];
            [[STIDCardReader instance] startScaleCard];
        }
    }
    
}

//--MainVewi中断开蓝牙的连接，在读卡成功或者失败的时候都要执行断开的操作
/**
 * 关闭蓝牙连接的方法
 * 在调用该方法后，会关闭在蓝牙设备列表中选中的蓝牙设备的连接，但不会清除该对象！
 * 如果是连续读卡的环境或者想要更快的读卡速度，建议不要调用此方法，使蓝牙设备保持长连接。
 * 如果读卡业务不繁忙，可以在读完卡之后调用该方法，关闭蓝牙连接。
 */
-(void)disconnectCurrentPeripher:(STMyPeripheral *)peripheral{
    //    NSLog(@"MainView进入断开蓝牙的操作!");
    if(peripheral.peripheral.state == CBPeripheralStateConnected){
        //        NSLog(@"蓝牙处于连接状态,需要关闭!");
        BlueManager *bmanager = [BlueManager instance];
        bmanager.deleagte = (id)self;
        [bmanager disConnectPeripher:peripheral];
    }
}

- (void)failedBack:(STMyPeripheral *)peripheral withError:(NSError *)error{
    
    if(error){
        //----出现错误之后,发送断开蓝牙的指令，如果想要保持长连接，可以不用关闭----
        //[self disconnectCurrentPeripher:peripheral];
        
        //--循环测试的方法,10秒之后循环读卡---
        [self performSelector:@selector(startScareCard) withObject:nil afterDelay:5.0f];
    }
}

- (void)successBack:(STMyPeripheral *)peripheral withData:(id)data{
    
    if(data && [data isKindOfClass:[NSDictionary class]]){
        
        NSString *allName = @"";
        NSString *cardNo = @"";
        NSString *address = @"";
        
        //--通过flag区分证件类型； 49:外国人永久居住身份证; 4A:港澳台居民居住证; 59:新版外国人永久居住身份证 其他：中国居民身份证；
        if([[data objectForKey:@"flag"]  isEqual: @"49"] || [[data objectForKey:@"flag"]  isEqual: @"59"]){
            //-----外国人永久居留身份证----
            
            NSString *englishName = [data objectForKey:@"EnglishName"];
            NSString *englishNameBack = [data objectForKey:@"EnglishNameBack"];
            
            //去除右边的空格、换行符、tab符
            //1. 去除收尾空格
            englishName = [englishName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            englishNameBack = [englishNameBack stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //2. 去除换行
            englishName = [englishName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            englishNameBack = [englishNameBack stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            if ([[data objectForKey:@"flag"]  isEqual: @"59"]) {
                allName = [NSString stringWithFormat:@"%@%@",englishName, englishNameBack];
            }
            else {
                allName = [NSString stringWithFormat:@"%@", englishName];
            }
            cardNo = [data objectForKey:@"CardNo"];
            address = @"中华人民共和国国家移民管理局";
        }
        else {
            //-----中国居民身份证以及港澳台----
            allName = [[NSString stringWithFormat:@"%@", [data objectForKey:@"Name"]] componentsSeparatedByString:@" "].firstObject;
            cardNo = [[NSString stringWithFormat:@"%@", [data objectForKey:@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
            address = [[NSString stringWithFormat:@"%@", [data objectForKey:@"Address"]] componentsSeparatedByString:@" "].firstObject;
        }
        
        NSString *nameString = allName;
        NSString *cardNoString = cardNo;
        NSString *addressString = address;
        self.fourView.infoArray = [NSMutableArray array];
        [self.fourView.infoArray addObjectsFromArray:@[nameString, cardNoString, addressString]];
        [self.fourView.contentTableView reloadData];
        
        self.personModel = [[PersonCardModel alloc] initWithDictionary:data error:nil];
        
    }else if (data &&[data isKindOfClass:[NSData class]]){
        /*把识别出来的照片不显示*/
        //        UIImage *img = [UIImage imageWithData:data];
        //
        //        UIImageView *lastImageView = self.fourView.chooseImageView.imageViews.firstObject;
        //        lastImageView.hidden = NO;
        //        lastImageView.image = img;
        //
        //        UIButton *removeButton = self.fourView.chooseImageView.removeButtons.firstObject;
        //        removeButton.hidden = NO;
        //
        //        UIButton *addImageButton = self.fourView.chooseImageView.imageButtons.firstObject;
        //        addImageButton.userInteractionEnabled = NO;
        
        //----照片解析出来之后，发送断开蓝牙的指令，如果想要保持长连接，可以不关闭蓝牙连接----
        [self disconnectCurrentPeripher:peripheral];
        //--循环测试的方法,10秒之后循环读卡---
        //[self performSelector:@selector(startAll) withObject:nil afterDelay:4.3f];
    }
}

/*-----识别仪开户--------------------*/


/*------扫描开户-------------------------*/

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机

//扫描操作，接收通知进入
- (void)scanForInformationAction {
    
    UIImageView *imageV = (UIImageView *)self.fourView.chooseImageView.imageViews.firstObject;
    imageV.image=[WatermarkMaker watermarkImageForImage:imageV.image];
    
    if (self.cardType == 2) {
        //扫描+外国人
        
        if (![self.typeString isEqualToString:@"写卡激活"]) {
            if (self.scanType == 2) {
                [Utils toastview:@"识别证件信息失败，请手动录入"];
                
                return;
            }
        } else {
            if (self.scanType == 1) {
                [Utils toastview:@"识别证件信息失败，请手动录入"];
                
                return;
            }
        }
    }
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在扫描" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
                
        [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:imageV.image];
}

//存储照片
-(void)didFinishedSelect:(UIImage *)image{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    UIImage *saveImage = image;
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"HjsjIDCardFree.jpg"];
    //
    //    //存储图片
    [UIImageJPEGRepresentation(saveImage, 1.0f) writeToFile:imageFilePath atomically:YES];
    
    //    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HjsjIDCardFree.jpg"];
    //    [UIImageJPEGRepresentation(image,1.0) writeToFile:jpgPath atomically:YES];
    
    _imagePath = imageFilePath;
    [self performSelectorInBackground:@selector(recog:) withObject:image];
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
                
                //得到结果之后
                weakSelf.fourView.infoArray = [NSMutableArray array];
                [weakSelf.fourView.infoArray addObjectsFromArray:@[name, idNO, address]];
                [weakSelf.fourView.contentTableView reloadData];
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
    
}

#endif

#pragma mark - UIImagePickerController Delegate -------------

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [Utils toastview:@"正在识别，请稍候！"];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:image];
}

-(void)scanForInformation{
    //    [self scanForInformationAction];
    [self performSelector:@selector(scanForInformationAction) withObject:nil];
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if (index == 0) {//老的识别仪
        [self oldIdentifyMachine];
    }else{
        deviceList = nil;
        rowCount = 0;
        manager.delegate = self;
        [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
        [listView show];
    }
}

#pragma mark -============= 3代蓝牙 事件 ================
- (void)SRInit{
//    [idManager setUpAccount:@"test03" password:@"12315aA..1"];
    idManager = [SRIDCardReader instanceWithManagerAccount:@"test03" password:@"12315aA..1" key:@""];
    idManager.delegate=self;
    [idManager setServerIP:@"59.41.39.51" andPort:6000];
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    listView.titleName.text = @"蓝牙设备列表";
    listView.datasource = self;
    listView.delegate = self;
    rowCount=0;
}

//连接设备
- (void)SRConnectedDevicesForPeripheral:(CBPeripheral *)peri{
    if([idManager setLisentPeripheral:peri withCBManager:manager]){
        //清除
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseImageViewRemoveImageAction" object:nil];
        //获取
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [idManager startScaleCard:15];
        });
    }else{
        [self showWarningText:@"阅读器监听失败"];
    }
}

#pragma mark -============ ZSYPopoverListView ===========
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rowCount;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
    @try {
        cell.textLabel.text = ((CBPeripheral *)[deviceList objectAtIndex:indexPath.row]).name;
    } @catch (NSException *exception) {
        cell.textLabel.text = ((SRMyPeripheral *)[deviceList objectAtIndex:indexPath.row]).advName;
    } @finally {
        
    }
    
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    NSLog(@"deselect:%d", (int)indexPath.row);
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    NSLog(@"select:%d", (int)indexPath.row);
    currentDevice=[deviceList objectAtIndex:indexPath.row];
    
    CBPeripheral *device = (CBPeripheral *)currentDevice;
#pragma mark - 判断设备
    if ([device.name hasPrefix:@"ST"]) {//ST
        [self STsearch];
    }else if([device.name hasPrefix:@"SR"]){//3代SR)
        [self SRConnectedDevicesForPeripheral:currentDevice];
        [self showWaitView];
        
    }else{
        [self showWarningText:@"无法连接此设备！"];
    }
    [self performSelectorOnMainThread:@selector(listDismiss) withObject:nil waitUntilDone:NO];
}

-(void)listDismiss{
    [listView dismiss];
}

#pragma  mark --======= CBCentralManagerDelegate =======
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
            //判断状态开始扫瞄周围设备 第一个参数为空则会扫瞄所有的可连接设备  你可以
            //指定一个CBUUID对象 从而只扫瞄注册用指定服务的设备
            //scanForPeripheralsWithServices方法调用完后会调用代理CBCentralManagerDelegate的
            //- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI方法
        case CBCentralManagerStatePoweredOn:
            [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
            
            break;
        case CBCentralManagerStatePoweredOff:
            //            [self showMessage:@"尚未打开蓝牙，请在设置中打开"];
            //            [self showIccidString:@"尚未打开蓝牙，请在设置中打开"];
            [self showWarningText:@"尚未打开蓝牙，请在设置中打开"];
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheraln advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if(deviceList==nil){
        deviceList=[NSMutableArray array];
    }
    if([deviceList containsObject:peripheraln] || peripheraln.name.length == 0){
        return;
    }
    [deviceList addObject:peripheraln];
    rowCount = [deviceList count];
    [listView.mainPopoverListView reloadData];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"has connected");
    //    [self.mutableData setLength:0];
    //    self.peripheral.delegate = self;
    //此时设备已经连接上了  你要做的就是找到该设备上的指定服务 调用完该方法后会调用代理CBPeripheralDelegate（现在开始调用另一个代理的方法了）的
    //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    //    [self.peripheral discoverServices:@[[CBUUID UUIDWithString:kServiceUUID]]];
    
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //此时连接发生错误
    NSLog(@"connected periphheral failed");
}


#pragma mark -- CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error==nil) {
        //在这个方法中我们要查找到我们需要的服务  然后调用discoverCharacteristics方法查找我们需要的特性
        //该discoverCharacteristics方法调用完后会调用代理CBPeripheralDelegate的
        //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        for (CBService *service in peripheral.services) {
            if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
                [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:kCharacteristicUUID]] forService:service];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error==nil) {
        //在这个方法中我们要找到我们所需的服务的特性 然后调用setNotifyValue方法告知我们要监测这个服务特性的状态变化
        //当setNotifyValue方法调用后调用代理CBPeripheralDelegate的- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error==nil) {
        //调用下面的方法后 会调用到代理的- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
        [peripheral readValueForCharacteristic:characteristic];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
}

#pragma mark -============= 3代蓝牙 代理 ================

/*
 功能：代理方法，读取身份证失败时可以通过这个代理方法获取失败的蓝牙对象和原因。
 参数：peripheral 代表蓝牙设备的对象
 error 描述失败的具体原因
 返回值：无
 */
- (void)SRfailedBack:(CBPeripheral *)peripheral withError:(NSError *)error
{
    switch(error.code)
    {
        case 0:
            [self showWarningText:@"请点击读二代证按钮"];
            break;
        case -7:
            [self showWarningText:@"读取超时"];
            break;
        case -4:
            [self showWarningText:@"检测不到二代证"];
            break;
        case -9:
            [self showWarningText:@"连接后台失败"];
            break;
        case -6:
            [self showWarningText:@"读头数据异常"];
            break;
        case -5:
            [self showWarningText:@"网络传输超时"];
            break;
        case -3:
            [self showWarningText:@"后台通信出错"];
            break;
        case -2:
            [self showWarningText:@"无后台服务"];
            break;
        case -1:
            [self showWarningText:@"连接读头失败"];
            break;
        case -10:
            [self showWarningText:@"未设置IP"];
            break;
        case -13:
            [self showWarningText:@"阅读器繁忙"];
            break;
        default:
            [self showWarningText:@"未知错误"];
            break;
            
    }
    [idManager closeReader];
}
/*
 功能： 代理方法，读取身份证成功时可以通过这个代理方法获取身份证的文本信息和照片信息。
 参数：peripheral代表蓝牙设备的对象
 data 如果data是NSDictionary类型，则里面包含的信息是文本信息，具体获取各字段信息见下表；如果data是NSData类型，则里面包含的是照片的二进制数据流
 返回值：无
 */
- (void)SRsuccessBack:(SRMyPeripheral *)peripheral withData:(id)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([data isKindOfClass:[NSDictionary class]]){
            NSDictionary *idInfo=(NSDictionary *)data;
            //姓名 身份证号码 身份证地址
            if ([[idInfo objectForKey:@"idType"] isEqualToString:@"I"]) {
                NSString *nameString = [[NSString stringWithFormat:@"%@",idInfo[@"Name"]] componentsSeparatedByString:@" "].firstObject;
                NSString *cardNoString = [[NSString stringWithFormat:@"%@",idInfo[@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
                NSString *addressString = [[NSString stringWithFormat:@"%@",idInfo[@"Address"]] componentsSeparatedByString:@" "].firstObject;
                self.fourView.infoArray = [NSMutableArray array];
                [self.fourView.infoArray addObjectsFromArray:@[nameString, cardNoString, addressString]];
                [self.fourView.contentTableView reloadData];
            }else{
                NSString *nameString = [[NSString stringWithFormat:@"%@",idInfo[@"Name"]] componentsSeparatedByString:@" "].firstObject;
                NSString *cardNoString = [[NSString stringWithFormat:@"%@",idInfo[@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
                NSString *addressString = [[NSString stringWithFormat:@"%@",idInfo[@"Address"]] componentsSeparatedByString:@" "].firstObject;
                self.fourView.infoArray = [NSMutableArray array];
                [self.fourView.infoArray addObjectsFromArray:@[nameString, cardNoString, addressString]];
                [self.fourView.contentTableView reloadData];
            }
            [self hideWaitView];
        }else{
            //        NSLog(@"%lu",(unsigned long)[data length]);
            //        [photoData appendData:data];
            //        UIImage* image=[UIImage imageWithData:photoData scale:1.0];
            //        NSLog(@"size:%f %f",image.size.width,image.size.height);
            //        ((UIImageView*)photoImageView).image=image;
            //        [photoImageView setNeedsDisplay];
            //        readerState.text=@"读取成功！";
            //        [self updateFinishUI];
            //        sleep(2);
            //        [idManager startScaleCard:30];
        }
        [idManager closeReader];
    });
    
}
#pragma mark - 3代蓝牙
- (void)STsearch{
    [self showWaitView];
    [[STIDCardReader instance] setDelegate:self];
    self.popView = [[PopView alloc] init];
    CBPeripheral *peripheral = (CBPeripheral *)currentDevice;
    [self.popView searchEquipmentForName:peripheral.name];
    
    @WeakObj(self);
    [self.popView setPopCallBack:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @StrongObj(self);
            [self hideWaitView];
            [[BlueManager instance] stopScan];
            [self startScareCard];
        });
    }];
}

#pragma mark - 人脸识别
- (void)goFaceRecognitionForSendDictionary:(NSMutableDictionary *)sendDictionary{
    
    @WeakObj(self);
    __block NSMutableDictionary *sendDic = [sendDictionary mutableCopy];
    NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
    
    //判断信息是否齐全
    NSArray *keyArray = @[@"memo4",@"memo11",@"photoFront",@"photoBack"];
    
    for (int i = 0; i < keyArray.count; i ++) {
        UIImageView *imageView = self.fourView.chooseImageView.imageViews[i];
        
        if (imageView.hidden == YES) {
            [Utils toastview:@"请选择图片"];
            return;
        }
        
        NSString *imageString = [Utils imagechange:imageView.image];
        imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [imageDic setObject:imageString forKey:keyArray[i]];
    }
    
    
    /***先传一波四张图片***/
    [WebUtils uploadImagesWithDic:imageDic andcallBack:^(id obj) {
        if (obj) {
            NSDictionary *fourImagesDic = obj;
            for (NSString *imageKey in fourImagesDic.allKeys) {
                [sendDic setObject:fourImagesDic[imageKey] forKey:imageKey];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //人脸识别
                FMFileVideoController *viewController = [[FMFileVideoController alloc]init];
                viewController.fourImageDic = fourImagesDic;
                viewController.typeString = self.typeString;
                viewController.callBackImageURLs = ^(NSDictionary *imageURLs) {
                    @StrongObj(self);
                    //返回的是已经上传了的图片地址
                    for (NSString *dicKey in imageURLs.allKeys) {
                        [sendDic setObject:imageURLs[dicKey] forKey:dicKey];
                    }
                    
                    [self goAccountAgreementForSendDictionary:sendDic andIsFace:YES];
                };
                [self.navigationController pushViewController:viewController animated:YES];
            });
        }
    }];
    
    
}

#pragma mark - 跳转开户协议
- (void)goAccountAgreementForSendDictionary:(NSMutableDictionary *)sendDictionary andIsFace:(BOOL)isFace{
    @WeakObj(self);
    
    //私有
    [sendDictionary setObject:self.phoneNumber forKey:@"number"];
    
    NSString *autoString = @"手工";
    if (self.isFaceVerify) {
        autoString = @"App人脸识别";
    }else{
        if (self.scanType == 2) {
            // 识别仪开户
            autoString = @"App识别仪";
        } else{
            // 扫描开户
            autoString = @"App扫描";
        }
    }
    
    [sendDictionary setObject:[NSString stringWithFormat:@"%d",self.payMethod] forKey:@"payMethod"];
    
    [sendDictionary setObject:autoString forKey:@"authenticationType"];
    /*****sendDictionary已经包含上传的四张图片地址了以及人像********/
    if (isFace == NO) {
        //判断信息是否齐全
        NSArray *keyArray = @[@"memo4",@"memo11",@"photoFront",@"photoBack"];
        
        for (int i = 0; i < keyArray.count; i ++) {
            UIImageView *imageView = self.fourView.chooseImageView.imageViews[i];
            
            if (imageView.hidden == YES) {
                [Utils toastview:@"请选择图片"];
                return;
            }
            
            NSString *imageString = [Utils imagechange:imageView.image];
            imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [sendDictionary setObject:imageString forKey:keyArray[i]];
        }
        
    }
    
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"NewFinishedCard" bundle:nil];
    NewFinishedCardSignViewController *vc = [story instantiateViewControllerWithIdentifier:@"NewFinishedCardSignViewController"];
    vc.isNonreturn = YES;
    [vc setSignBlock:^(UIImage *image) {
        NSString *imageString = [Utils imagechange:image];
        imageString = [imageString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [sendDictionary setObject:imageString forKey:@"agreementFront"];
        @StrongObj(self);
        if (isFace) {
            [self setOpenNetWithFaceForSendDictionary:sendDictionary];
        }else{
            [self setOpenNetWithNormalForSendDictionary:sendDictionary];
        }
        
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        @StrongObj(self);
        [self.navigationController pushViewController:vc animated:YES];
    });
}


@end
