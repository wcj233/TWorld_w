//
//  InformationCollectionViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "InformationCollectionViewController.h"
#import "InformationCollectionView.h"
#import "SettlementDetailViewController.h"
#import "FMFileVideoController.h"

#import <STIDCardReader/STIDCardReader.h>//蓝牙读身份证
//#define ERROR
#define UDValue(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SETUDValue(value,key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]

#define SERVER @"SERVERIP"  //@"192.168.1.10"//@"222.134.70.138" //
#define PORT @"SERVERPORT" //10002//8088 //

#import "PopView.h"
#import "PersonCardModel.h"

#import "FailedView.h"

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
#import <AipOcrSdk/AipOcrSdk.h>

#endif


#import "NewFinishedCardResultViewController.h"
#import "WatermarkMaker.h"


//3代
#import "SRIDCardReader/SRIDCardReader.h"
#import "SRIDCardReader/sm4.h"
#import "SRIDCardReader/ByteUtil.h"
#import "SRIDCardReader/HexUtil.h"
#import <dlfcn.h>
#import "ZSYPopoverListView.h"
static NSString *const kCharacteristicUUID = @"CCE62C0F-1098-4CD0-ADFA-C8FC7EA2EE90";
static NSString *const kServiceUUID = @"50BD367B-6B17-4E81-B6E9-F62016F26E7B";

@interface InformationCollectionViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, InformationCollectionViewDelegate,
//3代
SRIDCardReaderDelegate,
ZSYPopoverListDatasource,
ZSYPopoverListDelegate,
CBCentralManagerDelegate>{
    NSString *_imagePath;
    NSString *_cropImagePath;//裁切完成图片的路径
    int _currentOpenMode;
    
    //3代蓝牙连接设备Manage
    SRIDCardReader* idManager;
    CBCentralManager *manager;
    ZSYPopoverListView *listView;
    int rowCount;
    NSMutableArray *deviceList;
    NSObject *currentDevice;
    
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

@property (nonatomic) InformationCollectionView *informationCollectionView;
@property (nonatomic) BOOL isAuto;

@property (nonatomic) PopView *popView;//点击读取信息的时候弹出框显示所有搜索到的蓝牙
@property (nonatomic) PersonCardModel *personModel;//读出来的身份证信息

//扫描识别
@property (assign, nonatomic) int cardType;

@property (assign, nonatomic) int resultCount;

@property (strong, nonatomic) NSString *typeName;

@property (nonatomic) FailedView *processView;

//3代蓝牙视图
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end

@implementation InformationCollectionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllInfosAction:) name:@"ChooseImageViewRemoveImageAction" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息采集";
    
    //初始化3代蓝牙Manage
    [self SRInit];
    
    self.isAuto = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_tabbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    if (self.informationCollectionView) {
        self.informationCollectionView.frame = CGRectMake(0, 0, screenWidth, screenHeight-kTopHeight);
    }
    
    [self configCallback];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//清除
- (void)clearAllInfosAction:(NSNotification *)noti{
    for (InputView *iv in self.informationCollectionView.inputViews) {
        iv.textField.text = @"";
    }
    
    self.informationCollectionView.addressView.addressTextView.text = @"";
    self.informationCollectionView.addressView.addressPlaceholderLabel.hidden = NO;
}


//根据上一个界面传过来的值判断当前事识别仪还是扫描获取身份证信息
/// cardOpenModes:扫描/识别仪/全部(1/2/3))
- (void)setCardOpenMode:(int)cardOpenMode{
    _cardOpenMode = cardOpenMode;
    _currentOpenMode = cardOpenMode;
    if (cardOpenMode == 2) {
        //识别仪
        UIImage *orignalImage = [UIImage imageNamed:@"font1"];
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction:)];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"识别仪" style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction)];
//        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont14]} forState:UIControlStateNormal];
    }else{
        //3 都可以 1 扫描 （默认进来都是扫描用户）
        UIImage *orignalImage = [UIImage imageNamed:@"font2"];
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanForInformationAction) name:@"scanForInformation" object:nil];
    }
    [self startAction];
    
}


//页面布局
- (void)startAction{
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.informationCollectionView = [[InformationCollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andIsFinished:self.isFinished andIsFaceCheck:self.isFaceCheck];
    self.informationCollectionView.typeString = self.typeString;
    [self.view addSubview:self.informationCollectionView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeModel:)];
    [self.informationCollectionView.chooseImageView.titleLB addGestureRecognizer:tap];
    if (self.cardOpenMode==3) {//全部的话
        if (_currentOpenMode==3) {
            _currentOpenMode=1;//默认扫描
        }
//        [self changeTipStyle];
    }else if (self.cardOpenMode==1){//扫描
        self.informationCollectionView.informationCollectionViewDelegate = self;
    }else{
//        self.informationCollectionView.informationCollectionViewDelegate = nil;
        self.informationCollectionView.informationCollectionViewDelegate = self;
    }
    
    [self changeTipStyle];
    
//    }
    __block __weak InformationCollectionViewController *weakself = self;
    
    [self.informationCollectionView setNextCallBack:^(NSDictionary *dic) {
        
        if (weakself.informationCollectionView.isFinished == YES&&weakself.isFaceCheck==NO) {
            UIStoryboard* story = [UIStoryboard storyboardWithName:@"NewFinishedCard" bundle:nil];
            NewFinishedCardResultViewController *viewController=[story instantiateViewControllerWithIdentifier:@"NewFinishedCardResultViewController"];
            viewController.cardMode = _currentOpenMode;//开户方式
            viewController.isFace = NO;//开户方式
            viewController.detailModel = weakself.detailModel;
//            viewController.isFinished = YES;
            
            if (weakself.infosArray && weakself.infosArray.count > 0) {
                viewController.infosArray = weakself.infosArray;
            }
            viewController.currentPackageDictionary = weakself.currentPackageDictionary;
            viewController.currentPromotionDictionary = weakself.currentPromotionDictionary;
            viewController.collectionInfoDictionary = dic;
            viewController.moneyString = weakself.moneyString;
            viewController.isAuto = weakself.isAuto;
            
            
            [weakself.navigationController pushViewController:viewController animated:YES];
            return ;
        }else if (self.isFaceCheck){
            if ([self.typeString isEqualToString:@"靓号"]) {
                //人脸识别
                FMFileVideoController *viewController = [[FMFileVideoController alloc]init];
                
                viewController.detailModel = weakself.detailModel;
                //            viewController.isFinished = YES;
                
                if (weakself.infosArray && weakself.infosArray.count > 0) {
                    viewController.infosArray = weakself.infosArray;
                }
                viewController.currentPackageDictionary = weakself.currentPackageDictionary;
                viewController.currentPromotionDictionary = weakself.currentPromotionDictionary;
                viewController.collectionInfoDictionary = dic;
                viewController.moneyString = weakself.moneyString;
                viewController.isAuto = weakself.isAuto;
                
                //靓号相关
                viewController.typeString = self.typeString;
    //            viewController.isFinished = self.isFinished;
                viewController.payMethod = self.payMethod;
                viewController.orderNo = self.orderNo;
                viewController.numberModel = self.numberModel;
                viewController.imsiDictionary = self.imsiDictionary;
                viewController.iccidString = self.iccidString;
                viewController.detailDictionary = self.detailDictionary;
                
                
                [weakself.navigationController pushViewController:viewController animated:YES];
            }else{
                /******后台说要一张一张上传图片 因为这里有视频 所以先上传一波图片******/
                [WebUtils uploadImagesWithDic:dic andcallBack:^(id obj) {
                    if (obj) {
                        NSDictionary *fourImagesDic = obj;
                        //人脸识别
                        dispatch_async(dispatch_get_main_queue(), ^{
                        FMFileVideoController *viewController = [[FMFileVideoController alloc]init];
                        
                        viewController.detailModel = weakself.detailModel;
                        //            viewController.isFinished = YES;
                        
                        if (weakself.infosArray && weakself.infosArray.count > 0) {
                            viewController.infosArray = weakself.infosArray;
                        }
                        viewController.fourImageDic = fourImagesDic;
                        viewController.currentPackageDictionary = weakself.currentPackageDictionary;
                        viewController.currentPromotionDictionary = weakself.currentPromotionDictionary;
                        viewController.collectionInfoDictionary = dic;
                        viewController.moneyString = weakself.moneyString;
                        viewController.isAuto = weakself.isAuto;
                        
                        //靓号相关
                        viewController.typeString = self.typeString;
            //            viewController.isFinished = self.isFinished;
                        viewController.payMethod = self.payMethod;
                        viewController.orderNo = self.orderNo;
                        viewController.numberModel = self.numberModel;
                        viewController.imsiDictionary = self.imsiDictionary;
                        viewController.iccidString = self.iccidString;
                        viewController.detailDictionary = self.detailDictionary;
                        
                        
                            [weakself.navigationController pushViewController:viewController animated:YES];
                        });
                    }
                }];
            }
            
            
            
            
            
            return ;
        }else if([self.typeString isEqualToString:@"靓号"]&&self.isFaceCheck==NO){
            self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在开户中" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
            [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
            //靓号
            NSMutableDictionary *sendDictionary = [dic mutableCopy];
            NSString *autoString = @"App扫描";
            if (self.isFaceCheck) {
                autoString = @"App人脸识别";
            }else if (_currentOpenMode==2) {//识别仪
                autoString = @"App识别仪";
            }
            
            [sendDictionary setObject:autoString forKey:@"authenticationType"];
            [sendDictionary setObject:self.orderNo forKey:@"orderNo"];
            
            [sendDictionary setObject:self.imsiDictionary[@"simId"] forKey:@"simId"];
            
            [sendDictionary setObject:self.imsiDictionary[@"imsi"] forKey:@"imsi"];
            [sendDictionary setObject:self.iccidString forKey:@"iccid"];
            
            [sendDictionary setObject:self.currentPackageDictionary[@"id"] forKey:@"packageId"];
            [sendDictionary setObject:self.currentPromotionDictionary[@"id"] forKey:@"promotionsId"];
            
            [sendDictionary setObject:self.numberModel.prestore forKey:@"orderAmount"];
            [sendDictionary setObject:self.numberModel.prestore forKey:@"payAmount"];
            [sendDictionary setObject:self.numberModel.number forKey:@"number"];
            [sendDictionary setObject:[NSString stringWithFormat:@"%d",self.payMethod] forKey:@"payMethod"];
            @WeakObj(self);
            [WebUtils requestHJSJLiangOpenWithDictionary:sendDictionary andCallBack:^(id obj) {
                @StrongObj(self);
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
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                }];
                                
                                [ac addAction:action1];
                                [self presentViewController:ac animated:YES completion:nil];
                            });
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                                [Utils toastview:mes];
                            });
                        }
                    }
            }];
            return;
        }
       
        
        SettlementDetailViewController *viewController = [[SettlementDetailViewController alloc] init];
        
        if (weakself.informationCollectionView.isFinished == YES) {
            //成卡
            viewController.detailModel = weakself.detailModel;
            viewController.isFinished = YES;
        }else{
            //白卡
            viewController.isFinished = NO;
            viewController.imsiModel = weakself.imsiModel;
            viewController.iccidString = weakself.iccidString;
        }

        if (weakself.infosArray && weakself.infosArray.count > 0) {
            viewController.infosArray = weakself.infosArray;
        }
        viewController.currentPackageDictionary = weakself.currentPackageDictionary;
        viewController.currentPromotionDictionary = weakself.currentPromotionDictionary;
        viewController.collectionInfoDictionary = dic;
        viewController.moneyString = weakself.moneyString;
        viewController.isAuto = weakself.isAuto;
        [weakself.navigationController pushViewController:viewController animated:YES];
    }];
    
    //默认身份证
    self.cardType = 2;
    self.resultCount = 7;
    self.typeName = NSLocalizedString(@"二代身份证", nil) ;
}

/*--这TMD干啥用的？？？--*/
- (void)requestForInfoWays{
    __block __weak InformationCollectionViewController *weakself = self;

    [WebUtils requestWithChooseScanWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                self.cardOpenMode = [obj[@"data"][@"cardOpenMode"] intValue];
                [weakself startAction];
            }else{
                NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils toastview:mes];
                });
            }
        }
    }];
}

//扫描操作，接收通知进入
- (void)scanForInformationAction{
    
    self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在扫描" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
    [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
    
    UIImageView *imageV = (UIImageView *)self.informationCollectionView.chooseImageView.imageViews.firstObject;
    
    [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:imageV.image];
    
    imageV.image=[WatermarkMaker watermarkImageForImage:imageV.image];
    
}

//识别仪操作
- (void)readInfoAction:(UIBarButtonItem *)item{
    deviceList = nil;
    rowCount = 0;
    manager.delegate = self;
    [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
    [listView show];
}

#pragma mark - 2019
- (void)oldIdentifyMachine{
    //0209
    
    __block __weak InformationCollectionViewController *weakself = self;
    
    //读卡+写卡（imsi+smscent）操作
    /*
     self.imsiModel.imsi
     self.imsiModel.smscent
     */
    self.isAuto = YES;
    
    [[STIDCardReader instance] setDelegate:self];
    
    self.popView = [[PopView alloc] init];
    [self.view addSubview:self.popView];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    [self.popView setPopCallBack:^(id obj) {
        //点击popView黑色背景隐藏popView
        dispatch_async(dispatch_get_main_queue(), ^{
            [[BlueManager instance] stopScan];
            [weakself startScareCard];
            weakself.popView.hidden = YES;
        });
    }];
}

#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机

//扫描回调
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
                InputView *nameIV = weakSelf.informationCollectionView.inputViews[0];
                nameIV.textField.text = name;
                
                InputView *numberIV = weakSelf.informationCollectionView.inputViews[1];
                numberIV.textField.text = idNO;
                
                weakSelf.informationCollectionView.addressView.addressTextView.text = address;
                weakSelf.informationCollectionView.addressView.addressPlaceholderLabel.hidden = YES;
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
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSelectorInBackground:@selector(didFinishedSelect:) withObject:image];
}

#pragma mark - method

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

#pragma mark - 蓝牙读取身份证信息 -------bluetooth------------

-(void)startScareCard{
    
    BlueManager *bmanager = [BlueManager instance];
    bmanager.deleagte = (id)self;
    if(bmanager.linkedPeripheral == nil){
        [Utils toastview:@"请先选中要连接的蓝牙设备!"];
    }else{
        if(bmanager.linkedPeripheral.peripheral.state != CBPeripheralStateConnected){
//            NSLog(@"蓝牙处于未连接状态,先连接蓝牙!");
            [[BlueManager instance] connectPeripher:bmanager.linkedPeripheral];
        }else{
//            NSLog(@"蓝牙处在连接状态,直接进行读卡的操作!");
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
-(void) disconnectCurrentPeripher:(STMyPeripheral *)peripheral{
//    NSLog(@"MainView进入断开蓝牙的操作!");
    if(peripheral.peripheral.state == CBPeripheralStateConnected){
//        NSLog(@"蓝牙处于连接状态,需要关闭!");
        BlueManager *bmanager = [BlueManager instance];
        bmanager.deleagte = (id)self;
        [bmanager disConnectPeripher:peripheral];
    }
}

#pragma ScaleDelegate ---------------------

- (void)failedBack:(STMyPeripheral *)peripheral withError:(NSError *)error{
    
    if(error){
        
        //----出现错误之后,发送断开蓝牙的指令，如果想要保持长连接，可以不用关闭----
        //[self disconnectCurrentPeripher:peripheral];
        
        //--循环测试的方法,10秒之后循环读卡---
        [self performSelector:@selector(startScareCard) withObject:nil afterDelay:5.0f];
    }
}

- (void)successBack:(STMyPeripheral *)peripheral withData:(id)data{
    
    if(data && [data isKindOfClass:[NSDictionary class]]) {
        
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
        
        for (int i = 0; i < self.informationCollectionView.inputViews.count; i ++) {
            InputView *inputView = self.informationCollectionView.inputViews[i];
            switch (i) {
                case 0:
                {
                    NSString *nameString = allName;
                    inputView.textField.text = nameString;
                }
                    break;
                case 1:
                {
                    NSString *cardNoString = cardNo;
                    inputView.textField.text = cardNoString;
                }
                    break;
                
                default:
                    break;
            }
        }
        
        NSString *addressString = address;
        self.informationCollectionView.addressView.addressTextView.text = addressString;
        self.informationCollectionView.addressView.addressPlaceholderLabel.hidden = YES;
        
        self.personModel = [[PersonCardModel alloc] initWithDictionary:data error:nil];
        
    }else if (data &&[data isKindOfClass:[NSData class]]){
     /*把识别出来的照片不显示*/
//        UIImage *img = [UIImage imageWithData:data];
//
//        UIImageView *lastImageView = self.informationCollectionView.chooseImageView.imageViews.firstObject;
//        lastImageView.hidden = NO;
//        lastImageView.image = img;
//
//        UIButton *removeButton = self.informationCollectionView.chooseImageView.removeButtons.firstObject;
//        removeButton.hidden = NO;
//
//        UIButton *addImageButton = self.informationCollectionView.chooseImageView.imageButtons.firstObject;
//        addImageButton.userInteractionEnabled = NO;

//        ----照片解析出来之后，发送断开蓝牙的指令，如果想要保持长连接，可以不关闭蓝牙连接----
        [self disconnectCurrentPeripher:peripheral];
//        --循环测试的方法,10秒之后循环读卡---
//        [self performSelector:@selector(startAll) withObject:nil afterDelay:4.3f];
    }
}

-(void)changeTipStyle{
    for (int i = 0; i<self.informationCollectionView.chooseImageView.imageViews.count; i++) {
        UIImageView *imageV = self.informationCollectionView.chooseImageView.imageViews[i];
        UIButton *button = self.informationCollectionView.chooseImageView.removeButtons[i];
        imageV.hidden = YES;
        button.hidden = YES;
        UIButton *addImageButton = self.informationCollectionView.chooseImageView.imageButtons[i];
        addImageButton.userInteractionEnabled = YES;
        if (i==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseImageViewRemoveImageAction" object:button];
        }
    }

    
    
    NSString *title = @"识别仪开户";
    if (_currentOpenMode==2) {//识别仪用户
        title = @"扫描开户";
        UIImage *orignalImage = [UIImage imageNamed:@"font1"]; // 亮色字体
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:@selector(readInfoAction:)];
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"scanForInformation" object:nil];
        self.informationCollectionView.informationCollectionViewDelegate = nil;
    }else{
        UIImage *orignalImage = [UIImage imageNamed:@"font2"]; // 暗色字体
        orignalImage = [orignalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:orignalImage style:UIBarButtonItemStylePlain target:self action:nil];
        self.informationCollectionView.informationCollectionViewDelegate = self;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanForInformationAction) name:@"scanForInformation" object:nil];
    }
    if (_cardOpenMode==3) {//全部
        NSMutableAttributedString *s1 = [[NSMutableAttributedString alloc]initWithString:@"图片（点击图片可放大）" attributes:@{NSForegroundColorAttributeName:[Utils colorRGB:@"#333333"],NSFontAttributeName:font14}];
        NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSForegroundColorAttributeName:[Utils colorRGB:@"#008BD5"],NSFontAttributeName:font16}];
        [s1 appendAttributedString:s2];
        self.informationCollectionView.chooseImageView.titleLB.attributedText = s1;
        self.informationCollectionView.chooseImageView.titleLB.userInteractionEnabled = YES;
    }
    
}

-(void)changeModel:(UITapGestureRecognizer *)gesture{
    if (_currentOpenMode == 1) {
        _currentOpenMode = 2;
    }else{
        _currentOpenMode = 1;
    }
    [self changeTipStyle];
}

-(void)scanForInformation{
    [self scanForInformationAction];
}


#pragma mark -============= 3代蓝牙 事件 ================
- (void)SRInit{
    [idManager setUpAccount:@"test03" password:@"12315aA..1"];
    idManager = [SRIDCardReader instanceWithManager];
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
        [Utils toastview:@"阅读器监听失败"];
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
        [Utils toastview:@"请稍候！"];
    }else{
        [Utils toastview:@"无法连接此设备！"];
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
            [Utils toastview:@"尚未打开蓝牙，请在设置中打开"];
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
            [Utils toastview:@"请点击读二代证按钮"];
            
            break;
        case -7:
            [Utils toastview:@"读取超时"];
            break;
        case -4:
            [Utils toastview:@"检测不到二代证"];
            break;
        case -9:
            [Utils toastview:@"连接后台失败"];
            break;
        case -6:
            [Utils toastview:@"读头数据异常"];
            break;
        case -5:
            [Utils toastview:@"网络传输超时"];
            break;
        case -3:
            [Utils toastview:@"后台通信出错"];
            break;
        case -2:
            [Utils toastview:@"无后台服务"];
            break;
        case -1:
            [Utils toastview:@"连接读头失败"];
            break;
        case -10:
            [Utils toastview:@"未设置IP"];
            break;
        case -13:
            [Utils toastview:@"阅读器繁忙"];
            break;
        default:
            [Utils toastview:@"未知错误"];
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
//                //得到结果之后
//                NSArray *array = [allResult componentsSeparatedByString:@"\n"];
                InputView *nameIV = self.informationCollectionView.inputViews[0];
//                NSString *nameString = [array.firstObject componentsSeparatedByString:@":"].lastObject;
                nameIV.textField.text = [[NSString stringWithFormat:@"%@",idInfo[@"Name"]] componentsSeparatedByString:@" "].firstObject;
                
                InputView *numberIV = self.informationCollectionView.inputViews[1];
//                NSString *numberString = [array[5] componentsSeparatedByString:@":"].lastObject;
                numberIV.textField.text = [[NSString stringWithFormat:@"%@",idInfo[@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
                
//                NSString *placeString = [array[4] componentsSeparatedByString:@":"].lastObject;
                self.informationCollectionView.addressView.addressTextView.text = [[NSString stringWithFormat:@"%@",idInfo[@"Address"]] componentsSeparatedByString:@" "].firstObject;
                self.informationCollectionView.addressView.addressPlaceholderLabel.hidden = YES;
                
                
//                NSString *nameString = [[NSString stringWithFormat:@"%@",idInfo[@"Name"]] componentsSeparatedByString:@" "].firstObject;
//                NSString *cardNoString = [[NSString stringWithFormat:@"%@",idInfo[@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
//                NSString *addressString = [[NSString stringWithFormat:@"%@",idInfo[@"Address"]] componentsSeparatedByString:@" "].firstObject;
//                self.fourView.infoArray = [NSMutableArray array];
//                [self.fourView.infoArray addObjectsFromArray:@[nameString, cardNoString, addressString]];
//                [self.fourView.contentTableView reloadData];
            }else{
                //得到结果之后
                //                NSArray *array = [allResult componentsSeparatedByString:@"\n"];
                InputView *nameIV = self.informationCollectionView.inputViews[0];
                //                NSString *nameString = [array.firstObject componentsSeparatedByString:@":"].lastObject;
                nameIV.textField.text = [[NSString stringWithFormat:@"%@",idInfo[@"Name"]] componentsSeparatedByString:@" "].firstObject;
                
                InputView *numberIV = self.informationCollectionView.inputViews[1];
                //                NSString *numberString = [array[5] componentsSeparatedByString:@":"].lastObject;
                numberIV.textField.text = [[NSString stringWithFormat:@"%@",idInfo[@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
                
                //                NSString *placeString = [array[4] componentsSeparatedByString:@":"].lastObject;
                self.informationCollectionView.addressView.addressTextView.text = [[NSString stringWithFormat:@"%@",idInfo[@"Address"]] componentsSeparatedByString:@" "].firstObject;
                self.informationCollectionView.addressView.addressPlaceholderLabel.hidden = YES;
                
//                NSString *nameString = [[NSString stringWithFormat:@"%@",idInfo[@"Name"]] componentsSeparatedByString:@" "].firstObject;
//                NSString *cardNoString = [[NSString stringWithFormat:@"%@",idInfo[@"CardNo"]] componentsSeparatedByString:@" "].firstObject;
//                NSString *addressString = [[NSString stringWithFormat:@"%@",idInfo[@"Address"]] componentsSeparatedByString:@" "].firstObject;
//                self.fourView.infoArray = [NSMutableArray array];
//                [self.fourView.infoArray addObjectsFromArray:@[nameString, cardNoString, addressString]];
//                [self.fourView.contentTableView reloadData];
            }
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
//    [self showWaitView];
    [Utils toastview:@"请稍后"];
    [[STIDCardReader instance] setDelegate:self];
    self.popView = [[PopView alloc] init];
    CBPeripheral *peripheral = (CBPeripheral *)currentDevice;
    [self.popView searchEquipmentForName:peripheral.name];
    
    @WeakObj(self);
    [self.popView setPopCallBack:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @StrongObj(self);
            [[BlueManager instance] stopScan];
            [self startScareCard];
        });
    }];
}

@end
