//
//  AgentWriteAndChooseViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2015/6/2.
//  Copyright © 2015年 xiyoukeji. All rights reserved.
//

#import "AgentWriteAndChooseViewController.h"
#import "AgentWriteAndChooseView.h"
#import "BLEGcouple.h"
#import "ICCIDPopView.h"
#import "NormalShowCell.h"
#import "NormalLeadCell.h"
#import "FailedView.h"
#import "ChoosePackageDetailViewController.h"
#import "WhitePrepareOpenThreeViewController.h"
#import "AgentResultViewController.h"
#import "AppDelegate.h"
#import "ChooseWayViewController.h"
//3代
#import "SRIDCardReader/SRIDCardReader.h"
#import "SRIDCardReader/srSm4.h"
#import "SRIDCardReader/SRByteUtil.h"
#import "SRIDCardReader/HexUtil.h"
#import <dlfcn.h>
#import "ZSYPopoverListView.h"

//山东通信
#import "STReadWriteCardTool.h"
#import "BlueManager.h"

// 白色读卡器
#import "BLEGcouple.h"

static NSString *const kCharacteristicUUID = @"CCE62C0F-1098-4CD0-ADFA-C8FC7EA2EE90";
static NSString *const kServiceUUID = @"50BD367B-6B17-4E81-B6E9-F62016F26E7B";

//注册蓝牙监听状态的枚举
typedef enum {
    BT_POWEROFF         = 0x0,
    BT_IDLE             = 0x1,
    BT_CONNECTTING      = 0x2,
    BT_DISCONNECTTING   = 0x3,
    BT_CONNECTED        = 0x4,
    
}ListeningState;//枚举名称


@interface AgentWriteAndChooseViewController ()<UITableViewDelegate ,UITableViewDataSource, UINavigationBarDelegate, UIGestureRecognizerDelegate,
//3代
SRIDCardReaderDelegate,
ZSYPopoverListDatasource,
ZSYPopoverListDelegate,
CBCentralManagerDelegate,
//小读卡器
BleProtocol,
STReadWriteCardToolDelegate
>{
    //1代
    BLEGcouple *ble;
    //3代蓝牙连接设备Manage
    
    SRIDCardReader* idManager;
    CBCentralManager *manager;
    ZSYPopoverListView *listView;
    int rowCount;
    NSMutableArray *deviceList;
    NSMutableArray *stDeviceList;
    NSObject *currentDevice;
    
    NSString *SRImsi;
    NSString *SRICCID;
    
    STReadWriteCardTool *STReaderTool;
}

@property (nonatomic) AgentWriteAndChooseView *writeView;
//请求到的详细数据
@property (nonatomic) NSDictionary *detailDictionary;
//活动包
@property (nonatomic) NSDictionary *packagesDic;
//套餐包
@property (nonatomic) NSDictionary *promotionsDic;

//读卡失败弹窗
@property (nonatomic) FailedView *failedView;

@property (nonatomic) NSString *iccidString;
//蓝牙弹窗
@property (nonatomic) ICCIDPopView *iccidPopView;
//获取imsi信息得到的数据
@property (nonatomic) NSDictionary *imsiDictionary;

@property (nonatomic) CGFloat currentMoney;
//判断写卡是否完成，是否可以下一步，写卡完成才能进行下一步
@property (nonatomic) BOOL canNext;

//3代蓝牙视图
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@end

@implementation AgentWriteAndChooseViewController
@synthesize selectedIndexPath = _selectedIndexPath;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    manager.delegate = nil;
    idManager.delegate = nil;
    [STReaderTool deinitSTReader];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    manager.delegate = self;
    idManager.delegate = self;
    [STReaderTool initSTReader];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"号码详情";
    
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"order_tabbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    //    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(backAction:)];
    //    fixedButton.width = -8;
    self.navigationItem.leftBarButtonItem=leftButon;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.writeView = [[AgentWriteAndChooseView alloc] initWithFrame:CGRectZero andLeftTitlesArray:self.leftTitlesArray andType:self.typeString];
    [self.view addSubview:self.writeView];
    [self.writeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.writeView.nextButton setTitle:@"购买" forState:UIControlStateNormal];
    
    self.canNext = NO;
    
    //初始化3代蓝牙Manage
    [self SRInit];
    //山东通信
    STReaderTool = [[STReadWriteCardTool alloc] init];
    STReaderTool.stReadWriteCardToolDelegate = self;
    [STReaderTool initSTReader];
    
    //初始化1代蓝牙
//    ble = BLEGcouple.sharedInstance;
//    ble.delegate = self;
    
    //下一步操作--------------------
    [self.writeView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    //写卡操作--------------------
    [self.writeView.writeButton addTarget:self action:@selector(writeAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.stateIsLock) {
        self.writeView.nextButton.hidden = true;
    }
    
    //选择套餐包和活动包--------------------
    @WeakObj(self);
    [self.writeView setAgentWriteAndChooseCallBack:^(NSString *titleString, NSInteger row){
        @StrongObj(self);
        if ([titleString isEqualToString:@"套餐选择"]) {
            //套餐选择
            ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
            vc.title = @"套餐选择";
            [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                self.packagesDic = currentDic;
                self.promotionsDic = nil;
                NormalLeadCell *cell = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                [self.writeView.dataArray replaceObjectAtIndex:row withObject:currentDic[@"name"]];
                [self.writeView.dataArray replaceObjectAtIndex:row + 1 withObject:@""];
                
                cell.inputTextField.text = self.packagesDic[@"name"];
                //套餐包更改之后活动包清空
                NormalLeadCell *promotionCell = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row + 1 inSection:0]];
                promotionCell.inputTextField.text = @"";
            }];
            vc.packagesDic = self.detailDictionary[@"packages"];//所有套餐
            [self.navigationController pushViewController:vc animated:YES];
        }else if([titleString isEqualToString:@"活动包选择"]){
            //活动包选择
            if (!self.packagesDic[@"id"]) {
                [Utils toastview:@"套餐未选择"];
                return;
            }
            
            ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
            vc.title = @"活动包选择";
            [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                self.promotionsDic = currentDic;
                NormalLeadCell *cell = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                cell.inputTextField.text = self.promotionsDic[@"name"];
                [self.writeView.dataArray replaceObjectAtIndex:row withObject:currentDic[@"name"]];
            }];
            vc.currentID = self.packagesDic[@"id"];//当前选中套餐ID
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    //请求数据----------------------
    if ([self.typeString isEqualToString:@"话机世界靓号平台"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestHJSJNumberDetailAction];
            [self requestAccountMoney];
        });
    }
    
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestAgentWhitePrepareOpenDetailAction];
        });
    }
    
    if ([self.typeString isEqualToString:@"写卡激活"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.stateIsLock) {
                [self showWriteAction];
            }
            
            [self requestWriteCardActivation];
            [self requestAccountMoney];
        });
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //选择蓝牙弹出框--------------------
        self.iccidPopView = [[ICCIDPopView alloc] init];
        [self.view addSubview:self.iccidPopView];
        [self.iccidPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        self.iccidPopView.blueTableView.delegate = self;
        self.iccidPopView.blueTableView.dataSource = self;
        self.iccidPopView.hidden = YES;
    });
}

- (void)backAction:(id)sender{
    //这里响应你想要的效果
    if ([self.typeString isEqualToString:@"话机世界靓号平台"] && self.writeView.alipayView.hidden == YES) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"若返回上一页，将不对已支付金额进行返还，请确认是否返回？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)nextAction{
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        if (self.iccidString.length <= 0) {
            [Utils toastview:@"请先写卡"];
            return;
        }
        if (self.canNext == NO) {
            [Utils toastview:@"请先写卡"];
            return;
        }
        
        [self DLWhiteCardPrepareOpenAction];
        
    }else if([self.typeString isEqualToString:@"话机世界靓号平台"]){
        //支付前判断套餐和活动包
        if (!self.packagesDic || !self.promotionsDic) {
            [Utils toastview:@"请先选择套餐包和活动包！"];
            return;
        }
        //跳转
        if (self.writeView.cashView.hidden == YES) {
            
            if (self.canNext == NO) {
                [Utils toastview:@"请先写卡"];
                return;
            }
            [self QDJumpAction];
        }else{
            //先支付
            if (self.writeView.payWay == 0) {
                CGFloat paiedMoney = [NSString stringWithFormat:@"%@",self.detailDictionary[@"prestore"]].floatValue;
                if (paiedMoney > self.currentMoney) {
                    [Utils toastview:@"余额不足"];
                    return;
                }
            }
            [self QDPayAction];
        }
    }else if ([self.typeString isEqualToString:@"写卡激活"]){
        //支付前判断套餐和活动包
        if (self.stateIsLock == false) {
            if (!self.packagesDic || !self.promotionsDic) {
                [Utils toastview:@"请先选择套餐包和活动包！"];
                return;
            }
        }
        //跳转
        if (self.writeView.cashView.hidden == YES) {
            if (self.canNext == NO) {
                [Utils toastview:@"请先写卡"];
                return;
            }
            [self XK2019PayAction];
        }else{
            //先支付
            if (self.writeView.payWay == 0) {
                CGFloat paiedMoney = [NSString stringWithFormat:@"%@",self.detailDictionary[@"prestore"]].floatValue;
                if (paiedMoney > self.currentMoney) {
                    [Utils toastview:@"余额不足"];
                    return;
                }
            }
            [self XK2019PayAction];
        }
    }
}

- (void)DLWhiteCardPrepareOpenAction{
    @WeakObj(self);
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    [sendDictionary setObject:self.iccidString forKey:@"iccid"];
    [sendDictionary setObject:self.agentNumberModel[@"num"] forKey:@"number"];
    [sendDictionary setObject:self.packagesDic[@"id"] forKey:@"packageId"];
    [sendDictionary setObject:self.promotionsDic[@"id"] forKey:@"promotionId"];
    [sendDictionary setObject:self.imsiDictionary[@"imsi"] forKey:@"imsi"];
    [sendDictionary setObject:self.imsiDictionary[@"simId"] forKey:@"simId"];
    
    //开户操作
    [WebUtils requestAgentWhitePrepareOpenFinalWithDictionary:sendDictionary andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            @StrongObj(self);
            if ([code isEqualToString:@"10000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AgentResultViewController *vc = [[AgentResultViewController alloc] init];
                    vc.detailDictionary = self.detailDictionary;
                    vc.agentNumberModel = self.agentNumberModel;
                    vc.packageDictionary = self.packagesDic;
                    vc.promotionDictionary = self.promotionsDic;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)QDPayAction{
    @WeakObj(self);
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    [sendDictionary setObject:self.numberModel.number forKey:@"number"];
    [sendDictionary setObject:[NSString stringWithFormat:@"%@",self.detailDictionary[@"prestore"]] forKey:@"orderAmount"];
    [sendDictionary setObject:[NSString stringWithFormat:@"%@",self.detailDictionary[@"prestore"]] forKey:@"payAmount"];
    [sendDictionary setObject:[NSString stringWithFormat:@"%d",self.writeView.payWay] forKey:@"payMethod"];
    
    [WebUtils requestPayInfoWithSelectDictionary:sendDictionary andCallBack:^(id obj) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //支付成功套餐和活动包不得修改
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if ([code isEqualToString:@"10000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.orderNo = obj[@"data"][@"orderNo"];
//                    if (self.writeView.payWay == 1) {
//                        //支付宝支付
//                        NSString *orderString = [NSString stringWithFormat:@"%@",obj[@"data"][@"request"]];
//                        [self alipayActionWithOrderString:orderString];
//                    }else{
                        [self showWriteAction];
//                    }
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)QDJumpAction{
    @WeakObj(self);
    [WebUtils requestAgencyLiangRecordsWithPhoneNumber:self.numberModel.number andIccid:self.iccidString andCallBack:^(id obj) {
        @StrongObj(self);
        [WebUtils requestWithCardModeWithCallBack:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"code"] isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSUserDefaults standardUserDefaults]setObject:obj[@"data"] forKey:@"kaihuMode"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        ChooseWayViewController *vc = [[ChooseWayViewController alloc] init];
                        vc.typeString = @"靓号";
                        vc.isFinished = NO;
                        vc.currentPackageDictionary = self.packagesDic;
                        vc.currentPromotionDictionary = self.promotionsDic;
                        vc.payMethod = self.writeView.payWay;
                        vc.orderNo = self.orderNo;
                        vc.numberModel = self.numberModel;
                        vc.imsiDictionary = self.imsiDictionary;
                        vc.iccidString = self.iccidString;
                        vc.detailDictionary = self.detailDictionary;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
            }
        }];
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //渠道商
        //            WhitePrepareOpenThreeViewController *vc = [[WhitePrepareOpenThreeViewController alloc] init];
        //            vc.payMethod = self.writeView.payWay;
        //            vc.orderNo = self.orderNo;
        //            vc.typeString = self.typeString;
        //            vc.numberModel = self.numberModel;
        //            vc.imsiDictionary = self.imsiDictionary;
        //            vc.iccidString = self.iccidString;
        //            vc.promotionsDictionary = self.promotionsDic;
        //            vc.packagesDictionary = self.packagesDic;
        //            vc.detailDictionary = self.detailDictionary;
        //            [self.navigationController pushViewController:vc animated:YES];
        //        });
        
    }];
}

///2019写卡支付
- (void)XK2019PayAction{
    @WeakObj(self);
    NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
    
    [sendDictionary setObject:self.phoneNumber forKey:@"number"];
    [sendDictionary setValue:self.detailDictionary[@"poolname"] forKey:@"poolname"];
    [sendDictionary setValue:self.detailDictionary[@"crmCode"] forKey:@"crmCode"];
    [sendDictionary setValue:self.detailDictionary[@"crmUserName"] forKey:@"crmUserName"];
    [sendDictionary setValue:self.detailDictionary[@"liangType"] forKey:@"liangType"];
    [sendDictionary setValue:self.detailDictionary[@"isLiang"] forKey:@"isLiang"];
    [sendDictionary setValue:self.detailDictionary[@"prestore"] forKey:@"prestore"];
    [sendDictionary setValue:self.detailDictionary[@"regFee"] forKey:@"regFee"];
//    [sendDictionary setValue:self.detailDictionary[@"cityName"] forKey:@"cityName"];
//    [sendDictionary setValue:self.detailDictionary[@"province"] forKey:@"province"];
//    [sendDictionary setValue:self.detailDictionary[@"operatorname"] forKey:@"operatorname"];
    [sendDictionary setValue:self.packagesDic[@"id"] forKey:@"packageId"];
    [sendDictionary setValue:self.packagesDic[@"name"] forKey:@"packageName"];
    [sendDictionary setValue:self.promotionsDic[@"id"] forKey:@"promotionId"];
    [sendDictionary setValue:self.promotionsDic[@"name"] forKey:@"promotionName"];
    [sendDictionary setValue:self.detailDictionary[@"prestore"] forKey:@"payAmount"];
    
    
    
    [WebUtils agency_2019lockNumberWithParams:sendDictionary andCallback:^(id obj) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //支付成功套餐和活动包不得修改
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if ([code isEqualToString:@"10000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.orderNo = obj[@"data"][@"orderNo"];
                    //                    if (self.writeView.payWay == 1) {
                    //                        //支付宝支付
                    //                        NSString *orderString = [NSString stringWithFormat:@"%@",obj[@"data"][@"request"]];
                    //                        [self alipayActionWithOrderString:orderString];
                    //                    }else{
                    [self showWriteAction];
                    //                    }
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)writeAction{
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        //写卡前判断套餐和活动包
        if (!self.packagesDic || !self.promotionsDic) {
            [Utils toastview:@"请先选择套餐包和活动包！"];
            return;
        }
    }else if ([self.typeString isEqualToString:@"写卡激活"]){
        deviceList = nil;
        rowCount = 0;
        manager.delegate = self;
        [manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
        [listView show];
    }else{
        //    [self showWaitView];
        /*-----蓝牙相关--------------*/
        ble = BLEGcouple.sharedInstance;
        ble.delegate = self;
        [ble SetDelayInterval:100];
        [ble beginScan];
        self.iccidPopView.hidden = NO;
    }
}

//支付宝支付
- (void)alipayActionWithOrderString:(NSString *)orderString{
    @WeakObj(self);
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setAppCallBack:^(BOOL result) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result == YES) {
                NSString *titleString = @"购买成功！";
                [Utils showOpenSucceedViewWithTitle:titleString];
                
                [self showWriteAction];
                
            }else{
                NSString *titleString = @"购买失败！";
                [Utils showOpenSucceedViewWithTitle:titleString];
            }
        });
    }];
}

//支付完成展示写卡
- (void)showWriteAction{
    //支付完显示写卡
    if ([self.typeString isEqualToString:@"写卡激活"]) {
        if (self.stateIsLock) {
            self.leftTitlesArray = @[@"号码",@"归属地",@"运营商",@"预存话费", @"选号费", @"保底",@"订单金额",@"ICCID"];
            self.writeView.leftTitlesArray = @[@"号码",@"归属地",@"运营商",@"预存话费", @"选号费", @"保底",@"订单金额",@"ICCID"];
        } else {
            self.leftTitlesArray = @[@"号码",@"归属地",@"状态",@"运营商",@"预存话费",@"保底",@"套餐选择",@"活动包选择",@"订单金额",@"ICCID"];
            self.writeView.leftTitlesArray = @[@"号码",@"归属地",@"状态",@"运营商",@"预存话费",@"保底",@"套餐选择",@"活动包选择",@"订单金额",@"ICCID"];
        }
    }else{
        self.leftTitlesArray = @[@"靓号",@"归属地",@"状态",@"运营商",@"预存话费",@"保底消费",@"套餐选择",@"活动包选择",@"订单金额",@"ICCID"];
        self.writeView.leftTitlesArray = @[@"靓号",@"归属地",@"状态",@"运营商",@"预存话费",@"保底消费",@"套餐选择",@"活动包选择",@"订单金额",@"ICCID"];
    }
    [self.writeView.contentTableView reloadData];
    
    //读卡成功后界面修改
    self.writeView.alipayView.hidden = YES;
    self.writeView.cashView.hidden = YES;
    [self.writeView.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(170);
        make.top.mas_equalTo(60);
    }];
    
    [self.writeView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    if (self.stateIsLock == false) {
        NormalLeadCell *cell6 = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        NormalLeadCell *cell7 = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
        cell6.userInteractionEnabled = NO;
        cell7.userInteractionEnabled = NO;
    }
}

//请求数据-----------------------------------------

//请求当前余额
- (void)requestAccountMoney{
    @WeakObj(self);
    [WebUtils requestAccountMoneyWithCallBack:^(id obj) {
        @StrongObj(self);
        if (![obj isKindOfClass:[NSError class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat money = [[NSString stringWithFormat:@"%@",obj[@"data"][@"balance"]] floatValue];
                self.currentMoney = money;
                self.writeView.cashView.rightLabel.text = [NSString stringWithFormat:@"当前余额：%.2f元",money];
            });
        }
    }];
}

- (void)requestHJSJNumberDetailAction{
    @WeakObj(self);
    [self showWaitView];
    [WebUtils requestHJSJLiangDetailWithPhoneNumber:self.numberModel.number andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                self.detailDictionary = obj[@"data"];
                
                NSString *address = [Utils getCityWithProvinceId:self.detailDictionary[@"provinceCode"] andCityId:self.detailDictionary[@"cityCode"]];
                
                NSString *minCost = [NSString stringWithFormat:@"%@元",self.detailDictionary[@"minConsumption"]];
                
                NSString *liangStatus = [NSString stringWithFormat:@"%@",self.detailDictionary[@"liangStatus"]];
                
                NSString *statusString = [self getStatusWithCode:liangStatus];
                
                NSString *moneyString = [NSString stringWithFormat:@"%@元",self.detailDictionary[@"prestore"]];
                
                [self.writeView.dataArray addObjectsFromArray:@[self.numberModel.number, address, statusString, self.detailDictionary[@"network"], moneyString, minCost,@"",@"",moneyString]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.writeView.contentTableView reloadData];
                });
                
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)requestAgentWhitePrepareOpenDetailAction{
    @WeakObj(self);
    [self showWaitView];
    [WebUtils requestWhitePrepareOpenNumberDetailWithPhoneNumber:self.agentNumberModel[@"num"] andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //    @[@"靓号",@"归属地",@"说明",@"运营商",@"套餐选择",@"活动包选择",@"ICCID"]
                self.detailDictionary = obj[@"data"];
                
                NSString *placeString = [NSString stringWithFormat:@"%@%@",self.detailDictionary[@"province"] ,self.detailDictionary[@"cityName"]];
                
                [self.writeView.dataArray addObjectsFromArray:@[self.detailDictionary[@"number"], placeString, self.agentNumberModel[@"infos"], self.detailDictionary[@"operatorname"],@"",@""]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.writeView.contentTableView reloadData];
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)requestWriteCardActivation{
    @WeakObj(self);
    [self showWaitView];
    [WebUtils agency_2019preNumberDetailsWithParams:@{@"number":self.phoneNumber} andCallback:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //                @[@"号码",@"归属地",@"运营商",@"预存话费",@"选号费",@"保底消费",@"套餐选择",@"活动包选择",@"订单金额"];
                self.detailDictionary = obj[@"data"];
                
                if (self.stateIsLock) {
                    [self.writeView.dataArray addObjectsFromArray:@[self.detailDictionary[@"number"],
                                                                    self.detailDictionary[@"cityName"],
                                                                    self.detailDictionary[@"operatorname"],
                                                                    self.detailDictionary[@"prestore"],
                                                                    self.detailDictionary[@"regFee"],
                                                                    self.detailDictionary[@"cycle"],//保底周期
                                                                    self.detailDictionary[@"orderPrice"]]];
                } else {
                    [self.writeView.dataArray addObjectsFromArray:@[self.detailDictionary[@"number"],
                                                                    self.detailDictionary[@"cityName"],
                                                                    self.detailDictionary[@"operatorname"],
                                                                    self.detailDictionary[@"prestore"],
                                                                    self.detailDictionary[@"regFee"],
                                                                    self.detailDictionary[@"cycle"],//保底周期
                                                                    @"套餐选择",
                                                                    @"活动包选择",
                                                                    self.detailDictionary[@"orderPrice"]]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.writeView.contentTableView reloadData];
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (NSString *)getStatusWithCode:(NSString *)statusCode{
    
    if ([statusCode isEqualToString:@"0"]) {
        return @"未分配";
    }
    if ([statusCode isEqualToString:@"1"]) {
        return @"已激活";
    }
    if ([statusCode isEqualToString:@"2"]) {
        return @"已使用";
    }
    if ([statusCode isEqualToString:@"3"]) {
        return @"锁定";
    }
    if ([statusCode isEqualToString:@"4"]) {
        return @"开户中";
    }
    return @"";
}

#pragma mark - BlueTooth -------------------------

- (void)showIccidString:(NSString *)iccidString{
    NormalShowCell *iccidCell = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.writeView.leftTitlesArray.count - 1 inSection:0]];
    iccidCell.rightLabel.hidden = NO;
    iccidCell.rightLabel.text = iccidString;
    [self.writeView.dataArray addObject:iccidString];
    self.writeView.writeButton.hidden = YES;
}

//话机世界靓号平台
- (void)HJSJLiangNumberWithIccidString:(NSString *)iccidString{
    @WeakObj(self);
    
    [WebUtils requestLiangImsiWithPhoneNumber:self.numberModel.number andIccid:iccidString andCallBack:^(id obj) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            @StrongObj(self);
            
            if ([code isEqualToString:@"10000"]) {
                
                NSDictionary *dictionary = obj[@"data"];
                self.imsiDictionary = dictionary;
                //此时写卡
                NSString *apduImsi = [Utils getRightIMSIWithString:dictionary[@"imsi"]];
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                    NSString *responseWrite = [ble transmit:apduImsi];
                    if (![responseWrite isEqualToString:@"9000"]) {
                        [Utils toastview:@"写卡失败"];
                        return ;
                    }
                    
                    //短信中心号写进去
                    NSString *smscent = dictionary[@"smscent"];
                    smscent = [Utils getSwapSmscent:smscent];
                    NSString *response1 = [ble transmit:@"002000010831323334FFFFFFFF"];
                    NSString *response2 = [ble transmit:@"A0A40000023F00"];
                    NSString *response3 = [ble transmit:@"A0A40000027FF0"];
                    NSString *response4 = [ble transmit:@"A0A40000026F42"];
                    
                    NSLog(@"response:\n%@\n%@\n%@\n%@",response1,response2,response3,response4);
                    
                    smscent = [NSString stringWithFormat:@"A0DC010428FFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF%@FFFFFFFFFFFF",smscent];
                    NSString *response5 = [ble transmit:smscent];
                    if (![response5 isEqualToString:@"9000"]) {
                        [Utils toastview:@"写卡失败"];
                        return ;
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.canNext = YES;
                        [self showWarningText:iccidString];
                    });
                });
            }else{
                [self showFailedViewAction];
            }
        }
    }];
}

//代理商白卡预开户
- (void)getAndReadActionWithIccidString:(NSString *)iccidString{
    //显示iccidString到界面
    @WeakObj(self);
    //代理商白卡预开户号码锁定
    
    [WebUtils requestLockNumberWithNumber:self.agentNumberModel[@"num"] andNumberpoolId:self.detailDictionary[@"org_number_poolsId"] andNumberType:self.detailDictionary[@"liangType"] andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [WebUtils requestWhitePrepareOpenNumberImsiWithNumber:self.agentNumberModel[@"num"] andIccid:iccidString andCallBack:^(id obj) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                        
                        @StrongObj(self);
                        
                        if ([code isEqualToString:@"10000"]) {
                            
                            NSDictionary *dictionary = obj[@"data"];
                            self.imsiDictionary = dictionary;
                            //此时写卡
                            NSString *apduImsi = [Utils getRightIMSIWithString:dictionary[@"imsi"]];
                            
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                                NSString *responseWrite = [ble transmit:apduImsi];
                                if (![responseWrite isEqualToString:@"9000"]) {
                                    [Utils toastview:@"写卡失败"];
                                    return ;
                                }
                                
                                //短信中心号写进去
                                NSString *smscent = dictionary[@"smscent"];
                                smscent = [Utils getSwapSmscent:smscent];
                                NSString *response1 = [ble transmit:@"002000010831323334FFFFFFFF"];
                                NSString *response2 = [ble transmit:@"A0A40000023F00"];
                                NSString *response3 = [ble transmit:@"A0A40000027FF0"];
                                NSString *response4 = [ble transmit:@"A0A40000026F42"];
                                
                                NSLog(@"response:\n%@\n%@\n%@\n%@",response1,response2,response3,response4);
                                
                                smscent = [NSString stringWithFormat:@"A0DC010428FFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF%@FFFFFFFFFFFF",smscent];
                                NSString *response5 = [ble transmit:smscent];
                                if (![response5 isEqualToString:@"9000"]) {
                                    [Utils toastview:@"写卡失败"];
                                    return ;
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.canNext = YES;
                                    [self showIccidString:iccidString];
                                });
                            });
                        }else{
                            [self showFailedViewAction];
                        }
                    }
                }];
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)showFailedViewAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        //读卡失败
        self.failedView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"读卡失败" andDetail:@"SIM卡状态不正确" andImageName:@"icon_cry" andTextColorHex:@"#0081eb"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.failedView];
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeGrayView) userInfo:nil repeats:NO];
    });
}

- (void)removeGrayView{
    [UIView animateWithDuration:0.5 animations:^{
        self.failedView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.failedView removeFromSuperview];
    }];
}

#pragma mark - BLEProtocal Delegate ------------------

-(void)appendPeripheralFilter:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    if ([self.typeString isEqualToString:@"写卡激活"]) {
        if ([currentDevice isKindOfClass:[CBPeripheral class]]) {
            CBPeripheral *cb = (CBPeripheral *)currentDevice;
            if ([cb.name isEqualToString:peripheral.name]) {
                [ble connect:peripheral];
                [ble breakScan];
            }
        }
        return;
    }
    
    if(self.iccidPopView.deviceListArray == nil){
        self.iccidPopView.deviceListArray = [[NSMutableArray alloc] init];
    }
    if ([self.iccidPopView.deviceListArray containsObject:peripheral] == NO) {
        [self.iccidPopView.deviceListArray addObject:peripheral];
        [self.iccidPopView.blueTableView reloadData];
    }
}

- (void)didConnect:(NSString *)name{
    [Utils toastview:[NSString stringWithFormat:@"已连接上%@设备的蓝牙，正在读卡中，请稍候！",name]];
    self.iccidPopView.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showWaitView];
    });
    [ble breakScan];
}

- (void)didDisconnect{
    [Utils toastview:@"蓝牙断开连接"];
    NSLog(@"蓝牙断开连接");
}

- (void)didBleReady{
    //当蓝牙准备好的时候运行方法，这里延迟一秒，不知道人家蓝牙里面怎么写的，不延迟一秒左右的时间就不行，应该是里面的分线程中的没准备好
    [self performSelector:@selector(resetAction) withObject:nil afterDelay:1.0];
}

- (void)didBlePairReady:(BOOL)State{
    NSLog(@"didBlePairReady%d", State);
}

- (void)didReadRSSI:(NSNumber *)rssi{
    NSLog(@"rssi%@", rssi);
}

- (void)updateState:(NSInteger)state{
    NSLog(@"state:%ld", (long)state);
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case BT_POWEROFF:
                NSLog(@"BLUETOOTH-----定时关机");
                break;
            case BT_IDLE:
                NSLog(@"BLUETOOTH-----闲置");
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideWaitView];
                });
            }
                break;
                
            case BT_CONNECTTING:
                NSLog(@"BLUETOOTH-----连接");
                break;
                
            case BT_DISCONNECTTING:{
                NSLog(@"BLUETOOTH-----断开连接");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideWaitView];
                });
            }
                NSLog(@"BLUETOOTH-----断开");
                break;
                
            case BT_CONNECTED:
                NSLog(@"BLUETOOTH-----连接");
                break;
                
            default:
                break;
        }
    });
}

//重置蓝牙
- (void)resetAction{
    @WeakObj(self);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        @StrongObj(self);
        NSString *reset = [ble reset];
        NSLog(@"---reset--%@",reset);
        
        [ble transmit:@"A0A40000023F00"];//到主目录下
        [ble transmit:@"A0A40000022FE2"];//到iccid目录下
        
        NSString *responseString = [ble transmit:@"A0B000000A"];//获取iccid
        
        NSLog(@"---responseString---%@",responseString);
        
        if (responseString.length >= 20) {
            responseString = [Utils getRightICCIDWithString:responseString];
            
            NSLog(@"------%@",responseString);
            
            if (responseString.length == 20) {
                self.iccidString = responseString;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideWaitView];
                });
                
                if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
                    [self getAndReadActionWithIccidString:responseString];
                }else if([self.typeString isEqualToString:@"话机世界靓号平台"]){
                    [self HJSJLiangNumberWithIccidString:responseString];
                }else{
                    [self getPreImsiForICCID:responseString forBluetoothDevices:YES andISST:NO];
                }
            }
        }
    });
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.iccidPopView.deviceListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CBPeripheral *peri = self.iccidPopView.deviceListArray[indexPath.row];
    cell.textLabel.text = peri.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"发现设备列表:";
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CBPeripheral *peri = self.iccidPopView.deviceListArray[indexPath.row];
    if ([peri.name hasPrefix:@"ST"]) {//2代ST
        //结束扫描
//        [ble breakScan];
//        [self STConnectedDevicesForPeripheral:peri];
        [Utils toastview:@"此设备无法连接"];
    }else if([peri.name hasPrefix:@"SR"]){//3代SR
        //结束扫描
        [ble breakScan];
    }else{//1代
        [ble connectByName:peri.name];
    }
}

#pragma mark -============= 3代蓝牙 事件 ================
- (void)SRInit{
//    [idManager setUpAccount:@"test03" password:@"12315aA..1"];
    idManager = [SRIDCardReader initDevice];
    idManager.delegate=self;
    
    //传入鉴权信息
    [idManager setAppKey:SR_APP_KEY];
    [idManager setAppSecret:SR_APP_SECRET];
    [idManager setPassword:SR_APP_PASSWORD];
    
    [idManager setServerIP:@"59.41.39.51" andPort:6000];
//    manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)];
    listView = [[ZSYPopoverListView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    listView.titleName.text = @"蓝牙设备列表";
    listView.datasource = self;
    listView.delegate = self;
    rowCount=0;
}
//连接设备
- (void)SRConnectedDevicesForPeripheral:(CBPeripheral *)peri{
    if([idManager setLisentPeripheral:peri withCBManager:manager]){
//        if ([idManager cardPoweron]) {
            //获取卡IMSI
        [idManager cardPoweron];
            if([idManager readSimICCIDIMSI] == 0){
                NSLog(@"白卡");
            }else{
                NSLog(@"成卡");
            }
//        }else{
//            [self showWarningText:@"上电失败"];
//        }
    }else{
        [self showWarningText:@"阅读器监听失败"];
    }
}

//调用接口imsi 是否是老设备 isST--是否是山东通信
- (void)getPreImsiForICCID:(NSString *)iccid forBluetoothDevices:(BOOL)isOld andISST:(BOOL)isST {
    if (iccid == nil || iccid.length <= 0) {
        [self hideWaitView];
        [self showWarningText:@"ICCID获取异常"];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showIccidString:iccid];
    });
    
    __block NSString *blockIccid = iccid;
    
    @WeakObj(self);
    if (self.stateIsLock) {
        // 已锁定状态
        [WebUtils agencyGetPreImsiAgainWithParams:@{@"iccid":iccid,@"number":self.phoneNumber} andCallback:^(id obj) {
            @StrongObj(self);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    NSDictionary *data = obj[@"data"];
                    //获取imsi、smscent 和 号码
                    NSString *imsi = data[@"imsi"];
                    NSString *smscent = data[@"smscent"];
                    NSString *simId = data[@"simId"];
                    SRImsi = imsi;
                    SRICCID = iccid;
                    if (isST) {
                        //山东通信
                        [STReaderTool STWriteCardWithSimCard:imsi andSMSNO:smscent];
                    } else {
                        if (!isOld) { //3代
                            if ([smscent containsString:@"+86"]) {
                                smscent = [smscent substringFromIndex:3];
                            }
                            if([idManager cardPoweron]){
                                [idManager writeSimCard:imsi withNo:smscent];
                            }else{
                                [self hideWaitView];
                                [self showWarningText:@"卡上电失败"];
                            }
                        }else{ //1代
                            //此时写卡
                            [self asyncWriteCardActionWithApduImsi:imsi smscent:smscent blockIccid:blockIccid];
                        }
                    }
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    } else {
        [WebUtils agency_2019GetPreImsiWithParams:@{@"iccid":iccid,@"number":self.phoneNumber} andCallback:^(id obj) {
            @StrongObj(self);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    NSDictionary *data = obj[@"data"];
                    //获取imsi、smscent 和 号码
                    NSString *imsi = data[@"imsi"];
                    __block NSString *smscent = data[@"smscent"];
                    NSString *simId = data[@"simId"];
                    SRImsi = imsi;
                    SRICCID = iccid;
                    if (isST) {
                        //山东通信
                        [STReaderTool STWriteCardWithSimCard:imsi andSMSNO:smscent];
                    } else {
                        if (!isOld) { //3代
                            if ([smscent containsString:@"+86"]) {
                                smscent = [smscent substringFromIndex:3];
                            }
                            if([idManager cardPoweron]){
                                [idManager writeSimCard:imsi withNo:smscent];
                            }else{
                                [self hideWaitView];
                                [self showWarningText:@"卡上电失败"];
                            }
                        }else{ //1代
                            //此时写卡
                            [self asyncWriteCardActionWithApduImsi:imsi smscent:smscent blockIccid:iccid];
                        }
                    }
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }
}

/// 1代，也就是白色写卡器的写卡操作，一定得是异步
- (void)asyncWriteCardActionWithApduImsi:(NSString *)imsi smscent:(NSString *)tmpSmscent blockIccid:(NSString *)blockIccid {
    NSString *apduImsi = [Utils getRightIMSIWithString:imsi];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^(){
        // [ble transmit] 一定要在子线程中执行，才不会超时
        NSString *responseWrite = [ble transmit:apduImsi];
        
        if (![responseWrite isEqualToString:@"9000"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideWaitView];
                [Utils toastview:@"写卡失败"];
                return;
            });
        }
        
        //短信中心号写进去
        NSString *smscent = [Utils getSwapSmscent:tmpSmscent];
        
        NSString *response1 = [ble transmit:@"002000010831323334FFFFFFFF"];
        NSString *response2 = [ble transmit:@"A0A40000023F00"];
        NSString *response3 = [ble transmit:@"A0A40000027FF0"];
        NSString *response4 = [ble transmit:@"A0A40000026F42"];
        
        NSLog(@"本地打印response:\n%@\n%@\n%@\n%@",response1,response2,response3,response4);
        
        smscent = [NSString stringWithFormat:@"A0DC010428FFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF%@FFFFFFFFFFFF",smscent];
        NSString *response5 = [ble transmit:smscent];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![response5 isEqualToString:@"9000"]) {
                [self resultWriteCardResultsForResult:@"1" imsi:imsi iccid:blockIccid];
            }else{
                [self resultWriteCardResultsForResult:@"0" imsi:imsi iccid:blockIccid];
            }
        });
    });
}

//写卡结果通知
- (void)resultWriteCardResultsForResult:(NSString *)result imsi:(NSString *)imsi iccid:(NSString *)iccid{
    @WeakObj(self);
    [WebUtils agency_2019ResultWithParams:@{@"orderNo":self.orderNo,
                                            @"result":result,
                                            @"imsi":imsi,
                                            @"iccid":iccid,
                                            @"number":self.phoneNumber} andCallback:^(id obj) {
        @StrongObj(self);
        [self hideWaitView];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"30000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:@"写卡成功" preferredStyle:UIAlertControllerStyleAlert];
                    @WeakObj(self);
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"当场激活" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //跳转认证激活
                            [self jumpWayToOpenAnAccount];
                        });
                    }];
                    [ac addAction:action1];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"退出激活" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        @StrongObj(self);
                        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
                    }];
                    [ac addAction:cancel];
                    [self presentViewController:ac animated:YES completion:nil];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

//跳转开户方式-》信息采集
- (void)jumpWayToOpenAnAccount{
    [manager stopScan];
    if (currentDevice) {
        [manager cancelPeripheralConnection:(CBPeripheral *)currentDevice];
    }//1代
    [ble disConnect];
    [idManager closeReader];
    [idManager cardPoweroff];
    
    ChooseWayViewController *vc = [[ChooseWayViewController alloc]init];
    vc.typeString = self.typeString;
    vc.phoneNumber = self.phoneNumber;
    [self.navigationController pushViewController:vc animated:YES];
    
//    //渠道商
//    WhitePrepareOpenThreeViewController *vc = [[WhitePrepareOpenThreeViewController alloc] init];
//    vc.typeString = self.typeString;
//    vc.phoneNumber = self.phoneNumber;
//    [self.navigationController pushViewController:vc animated:YES];
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
    currentDevice = [deviceList objectAtIndex:indexPath.row];
    
    [self showWaitView];
    if ([currentDevice isKindOfClass:[CBPeripheral class]]) {
        CBPeripheral *peripheralDevice = (CBPeripheral *)currentDevice;
        if ([[peripheralDevice.name substringToIndex:2] isEqualToString:@"SR"]) {
            [self SRConnectedDevicesForPeripheral:peripheralDevice];
        } else if ([[peripheralDevice.name substringToIndex:2] isEqualToString:@"ST"]) {//ST
            [STReaderTool STConnectedDevicesForPeripheral:[stDeviceList objectAtIndex:indexPath.row]];
        } else if([[peripheralDevice.name substringToIndex:2] isEqualToString:@"ZR"]) {
            [self ultramanConnectedDevices:peripheralDevice];
        } else {
            [self hideWaitView];
            [self showWarningText:@"选择的设备无法识别"];
        }
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
            [self showWarningText:@"尚未打开蓝牙，请在设置中打开"];
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheraln advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if(deviceList==nil){
        deviceList=[NSMutableArray array];
        stDeviceList = [NSMutableArray array];
    }
    if([deviceList containsObject:peripheraln] || peripheraln.name.length == 0){
        return;
    }
    [deviceList addObject:peripheraln];
    
    //st的设置
    STMyPeripheral *newMyPerip = [[STMyPeripheral alloc] initWithCBPeripheral:peripheraln];
    NSString *mac = [[BlueManager instance] macTrans:[advertisementData objectForKey:@"kCBAdvDataManufacturerData"]];
    newMyPerip.advName = peripheraln.name;
    newMyPerip.mac = mac;
    
    [stDeviceList addObject:newMyPerip];
    
    rowCount = [deviceList count];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [listView.mainPopoverListView reloadData];
    });
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

#pragma mark -============= ST山东信通 代理 ================

// 读ICCID，IMSI及发送APDU指令代理方法 - 返回信息的获取参照DEMO实例
- (void)STReadICCIDsuccessBack:(STIDReadCardInfo *)peripheral withData:(id)data {
    [self hideWaitView];
    
    [self showWaitView];
    //调用接口imsi
    [self getPreImsiForICCID:peripheral.ICCID forBluetoothDevices:NO andISST:YES];
}

- (void)STWriteCardResultBack:(STIDReadCardInfo *)peripheral withData:(id)data {

    if (peripheral.writeCardResult ==0 && peripheral.messageResult==0) {
        [self resultWriteCardResultsForResult:@"0" imsi:SRImsi iccid:SRICCID];
    } else {
        //@"写卡失败";
        [self resultWriteCardResultsForResult:@"1" imsi:SRImsi iccid:SRICCID];
    }
}

- (void)STFailedBack:(STMyPeripheral *)peripheral withError:(NSError *)error {
    
    [self hideWaitView];
    [self showWarningText:@"ICCID获取异常"];
}

#pragma mark -============= 3代蓝牙 代理 ================
/*
 功能：代理方法，返回读取sim卡号码
 参数：结果信息
 返回值：无
 */
- (void)readPhoneNumberSuccessBack:(NSString *)numberStr withData:(id)data{
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,numberStr] waitUntilDone:NO];
    
}

/*
 功能:代理方法,读取imsi时通过该方法返回结果
 参数:结果信息
 返回值:无
 */
- (void)ReadIMSIsuccessBack:(SRIDReadCardInfo*)peripheral withData:(id)data{
    NSLog(@"%d",[((NSNumber *)data) intValue]);
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,peripheral.imsi] waitUntilDone:NO];
    
}
/*
 功能：代理方法，读取iccid和imsi时，同时返回两个值
 参数：结果信息
 返回值：无
 */
- (void)ReadICCIDIMSIsuccessBack:(SRIDReadCardInfo*)peripheral withData:(id)data{
    [self hideWaitView];
    
    [self showWaitView];
    //调用接口imsi
    [self getPreImsiForICCID:peripheral.ICCID forBluetoothDevices:NO andISST:NO];
    [idManager cardPoweroff];
}

/*
 功能:代理方法,写卡时通过该方法返回结果
 参数:结果信息
 返回值:无
 */
- (void)writeCardResultBack:(SRIDReadCardInfo*)peripheral withData:(id)data {
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,peripheral.writeCardResult==0?@"成功":@"失败"] waitUntilDone:NO];
    if (peripheral.writeCardResult == 0) {//成功
        [self resultWriteCardResultsForResult:@"0" imsi:SRImsi iccid:SRICCID];
    }else{//失败
        [self resultWriteCardResultsForResult:@"1" imsi:SRImsi iccid:SRICCID];
    }
    [idManager cardPoweroff];
}

/*
 功能：代理方法，返回读取的短信中心号
 参数：结果信息
 返回值：无
 */
- (void)readCardMSGNumberSuccessBack:(NSString *)numberStr withData:(id)data{
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,numberStr] waitUntilDone:NO];
    
}

/*
 功能：代理方法，返回移动读空卡系列号
 参数：结果信息
 返回值：无
 */
- (void)readMobileCardSNSuccessBack:(NSString *)mobileStr withData:(id)data{
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,mobileStr] waitUntilDone:NO];
}



/*
 功能：代理方法，返回移动读卡片信息
 参数：结果信息
 返回值：无
 */
- (void)readMobileCardInfoSuccessBack:(NSString *)mobileStr withData:(id)data{
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,mobileStr] waitUntilDone:NO];
    
    
}

/*
 功能：代理方法，返回移动写卡结果信息
 参数：结果信息
 返回值：无
 */
- (void)writeMobileCardSuccessBack:(NSString *)mobileStr withData:(id)data{
//    [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"%@:%@",data,mobileStr] waitUntilDone:NO];
    
}

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
            NSLog(@"请点击读二代证按钮");
            break;
        case -7:
            NSLog(@"读取超时");
            break;
        case -4:
            NSLog(@"检测不到二代证");
            break;
        case -9:
            NSLog(@"连接后台失败");
            break;
        case -6:
            NSLog(@"读头数据异常");
            break;
        case -5:
            NSLog(@"网络传输超时");
            break;
        case -3:
            NSLog(@"后台通信出错");
            break;
        case -2:
            NSLog(@"无后台服务");
            break;
        case -1:
            NSLog(@"连接读头失败");
            break;
        case -10:
            NSLog(@"未设置IP");
            break;
        case -13:
            NSLog(@"阅读器繁忙");
            break;
        default:
            NSLog(@"未知错误");
            break;
            
    }
    
}

- (void)SRsuccessBack:(CBPeripheral *)peripheral withData:(id)data { 
    
}


- (void)centralManagerState:(NSString *)state {
    
}


- (void)connectServerIPPort:(NSString *)str {
    
}


- (void)idCardInfoJsonStr:(NSString *)jsonStr {
    
}


- (void)idResponSuccessBack:(NSData *)data {
    
}


- (void)readerStateBack:(NSString *)state {
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (void)updateFocusIfNeeded {
    
}

#pragma mark -============= 1代蓝牙 方法 ================
- (void)ultramanConnectedDevices:(CBPeripheral *)peripheral{
    ble = BLEGcouple.sharedInstance;
    ble.delegate = self;
    [ble SetDelayInterval:100];
    [ble beginScan];
}
@end
