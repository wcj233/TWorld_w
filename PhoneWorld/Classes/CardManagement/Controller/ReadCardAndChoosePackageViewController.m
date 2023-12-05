//
//  ReadCardAndChoosePackageViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/19.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "ReadCardAndChoosePackageViewController.h"
#import "ReadCardAndChoosePackageView.h"
#import "IMSIModel.h"
#import "ChoosePackageTableView.h"
#import "BLEGcouple.h"
#import "ICCIDPopView.h"

//注册蓝牙监听状态的枚举
typedef enum {
    BT_POWEROFF         = 0x0,
    BT_IDLE             = 0x1,
    BT_CONNECTTING      = 0x2,
    BT_DISCONNECTTING   = 0x3,
    BT_CONNECTED        = 0x4,
    
}ListeningState;//枚举名称

@interface ReadCardAndChoosePackageViewController ()<UITableViewDelegate ,UITableViewDataSource, BleProtocol>{
    BLEGcouple *ble;
}

@property (nonatomic) ReadCardAndChoosePackageView *readView;

@property (nonatomic) NSUserDefaults *defaults;

@property (nonatomic) NSString *iccidString;

@property (nonatomic) ICCIDPopView *iccidPopView;

@end

@implementation ReadCardAndChoosePackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写卡与套餐选择";
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];

    self.readView = [[ReadCardAndChoosePackageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64) andInfo:self.infos];
    [self.view addSubview:self.readView];
    
    @WeakObj(self);
    ble = BLEGcouple.sharedInstance;
    ble.delegate = self;
    [ble beginScan];
    
    self.iccidPopView = [[ICCIDPopView alloc] init];
    [self.view addSubview:self.iccidPopView];
    [self.iccidPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.iccidPopView.blueTableView.delegate = self;
    self.iccidPopView.blueTableView.dataSource = self;
    self.iccidPopView.hidden = YES;
    
    //ICCID是蓝牙读卡器读出来的
    [self.readView setBlueToothCallBack:^(id obj) {
        @StrongObj(self);
        self.iccidPopView.hidden = NO;
    }];
}

- (void)removeGrayView{
    self.readView.hidden = YES;
}

- (void)getAndReadActionWithIccidString:(NSString *)iccidString{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *labelText = [NSString stringWithFormat:@"ICCID：%@",iccidString];
        NSRange range = [labelText rangeOfString:@"ICCID："];
        self.readView.iccidStringLabel.attributedText = [Utils setTextColor:labelText FontNumber:[UIFont systemFontOfSize:textfont14] AndRange:range AndColor:[Utils colorRGB:@"#999999"]];
        
        NSString *phoneNumber = self.infos.firstObject;
        
        [self lockNumber:phoneNumber andICCID:iccidString];
    });
}

//号码锁定
- (void)lockNumber:(NSString *)phoneNumber andICCID:(NSString *)iccidString{
    @WeakObj(self);
    [WebUtils requestLockNumberWithNumber:phoneNumber andNumberpoolId:self.currentPoolId andNumberType:self.currentType andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                [self getImsiActionWithPhone:phoneNumber andICCID:iccidString];
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)getImsiActionWithPhone:(NSString *)phoneNumber andICCID:(NSString *)iccidString{
    @WeakObj(self);
    [WebUtils requestImsiInfoWithNumber:phoneNumber andICCID:iccidString andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                IMSIModel *imsiModel = [[IMSIModel alloc] initWithDictionary:obj[@"data"] error:nil];
                
                //此时写卡
                NSString *apduImsi = [Utils getRightIMSIWithString:imsiModel.imsi];
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                    NSString *responseWrite = [ble transmit:apduImsi];
                    if (![responseWrite isEqualToString:@"9000"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:@"写卡失败"];
                            return;
                        });
                    }
                    
                    //短信中心号写进去
                    NSString *smscent = imsiModel.smscent;
                    smscent = [Utils getSwapSmscent:smscent];
                    NSString *response1 = [ble transmit:@"002000010831323334FFFFFFFF"];
                    NSString *response2 = [ble transmit:@"A0A40000023F00"];
                    NSString *response3 = [ble transmit:@"A0A40000027FF0"];
                    NSString *response4 = [ble transmit:@"A0A40000026F42"];
                    
                    NSLog(@"response:\n%@\n%@\n%@\n%@",response1,response2,response3,response4);
                    
                    smscent = [NSString stringWithFormat:@"A0DC010428FFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF%@FFFFFFFFFFFF",smscent];
                    NSString *response5 = [ble transmit:smscent];
                    if (![response5 isEqualToString:@"9000"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:@"写卡失败"];
                            return;
                        });
                    }
                    
                    //imsi
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //读卡成功
                        if (self.readView.chooseTableView == nil) {
                            self.readView.chooseTableView = [[ChoosePackageTableView alloc] initWithFrame:CGRectMake(0, 85, screenWidth, 119) style:UITableViewStylePlain];
                            self.readView.chooseTableView.packagesDic = imsiModel.packages;
                            self.readView.chooseTableView.imsiModel = imsiModel;
                            [self.readView addSubview:self.readView.chooseTableView];
                        }
                        
                        [self.readView.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
                        [self.readView.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(self.readView.chooseTableView.mas_bottom).mas_equalTo(40);
                            make.centerX.mas_equalTo(0);
                            make.height.mas_equalTo(40);
                            make.width.mas_equalTo(171);
                        }];
                    });
                    
                    [self preOpenActionWithPhone:phoneNumber andICCID:iccidString];
                });
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //读卡失败
                    self.readView.failedView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"读卡失败" andDetail:@"SIM卡状态不正确" andImageName:@"icon_cry" andTextColorHex:@"#0081eb"];
                    [[UIApplication sharedApplication].keyWindow addSubview:self.readView.failedView];
                    
                    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(removeGrayView) userInfo:nil repeats:NO];
                });
                
            }
        }
    }];
}

- (void)preOpenActionWithPhone:(NSString *)phoneNumber andICCID:(NSString *)iccidString{
    [WebUtils requestPreopenWithNumber:phoneNumber andICCID:iccidString andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.readView.iccidString = iccidString;
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
    
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
    [ble connectByName:peri.name];
}

#pragma mark - BLEProtocal Delegate

-(void)appendPeripheralFilter:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    if(self.iccidPopView.deviceListArray == nil){
        self.iccidPopView.deviceListArray = [[NSMutableArray alloc] init];
    }
    if ([self.iccidPopView.deviceListArray containsObject:peripheral] == NO) {
        [self.iccidPopView.deviceListArray addObject:peripheral];
        [self.iccidPopView.blueTableView reloadData];
    }
}

- (void)didConnect:(NSString *)name{
    [Utils toastview:[NSString stringWithFormat:@"已连接上%@设备的蓝牙",name]];
    self.iccidPopView.hidden = YES;
    [ble breakScan];
}

- (void)didDisconnect{
    [Utils toastview:@"蓝牙已断开连接"];
}

- (void)didBleReady{
    //当蓝牙准备好的时候运行方法，这里延迟一秒，不知道人家蓝牙里面怎么写的，不延迟一秒左右的时间就不行，应该是里面的分线程中的没准备好
    [self performSelector:@selector(resetAction) withObject:nil afterDelay:1.0];
}

- (void)updateState:(NSInteger)state{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case BT_POWEROFF:
                NSLog(@"BLUETOOTH-----POWEROFF");
                break;
            case BT_IDLE:
                NSLog(@"BLUETOOTH-----IDLE");
                break;
                
            case BT_CONNECTTING:
                NSLog(@"BLUETOOTH-----CONNECTTING");
                break;
                
            case BT_DISCONNECTTING:
                NSLog(@"BLUETOOTH-----DISCONNECTIONG");
                break;
                
            case BT_CONNECTED:
                NSLog(@"BLUETOOTH-----CONNECTED");
                break;
                
            default:
                break;
        }
        
    });
}

//重置蓝牙
- (void)resetAction{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSString *reset = [ble reset];
        NSLog(@"-----%@",reset);
        [ble transmit:@"A0A40000023F00"];//到主目录下
        [ble transmit:@"A0A40000022FE2"];//到iccid目录下
        NSString *responseString = [ble transmit:@"A0B000000A"];//获取iccid
        if (responseString.length >= 20) {
            responseString = [Utils getRightICCIDWithString:responseString];
            if (responseString.length == 20) {
                [self getAndReadActionWithIccidString:responseString];
            }
        }
    });
}

@end
