//
//  AgentWriteViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentWriteViewController.h"
#import "AgentWriteView.h"
#import "AgentResultViewController.h"
#import "WhitePrepareOpenThreeViewController.h"
#import "BLEGcouple.h"
#import "ICCIDPopView.h"
#import "NormalShowCell.h"
#import "FailedView.h"

//注册蓝牙监听状态的枚举
typedef enum {
    BT_POWEROFF         = 0x0,
    BT_IDLE             = 0x1,
    BT_CONNECTTING      = 0x2,
    BT_DISCONNECTTING   = 0x3,
    BT_CONNECTED        = 0x4,
    
}ListeningState;//枚举名称

@interface AgentWriteViewController ()<UITableViewDelegate ,UITableViewDataSource, BleProtocol>{
    BLEGcouple *ble;
}

@property (nonatomic) AgentWriteView *writeView;
//读卡失败弹窗
@property (nonatomic) FailedView *failedView;

@property (nonatomic) NSString *iccidString;
//蓝牙弹窗
@property (nonatomic) ICCIDPopView *iccidPopView;
//获取imsi信息得到的数据
@property (nonatomic) NSDictionary *imsiDictionary;

@end

@implementation AgentWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"写卡";
    self.imsiDictionary = [NSDictionary dictionary];
    self.writeView = [[AgentWriteView alloc] init];
    [self.view addSubview:self.writeView];
    [self.writeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self.writeView.nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];

    [self.writeView.writeButton addTarget:self action:@selector(writeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self showDataAction];
    
    /*-----蓝牙相关--------------*/
    ble = BLEGcouple.sharedInstance;
    ble.delegate = self;
    
    self.iccidPopView = [[ICCIDPopView alloc] init];
    [self.view addSubview:self.iccidPopView];
    [self.iccidPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.iccidPopView.blueTableView.delegate = self;
    self.iccidPopView.blueTableView.dataSource = self;
    self.iccidPopView.hidden = YES;
}

- (void)nextAction{
    
    if (self.iccidString.length <= 0) {
        [Utils toastview:@"请写卡"];
        return;
    }
    
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        
        self.writeView.nextButton.enabled = NO;
        
        NSMutableDictionary *sendDictionary = [NSMutableDictionary dictionary];
        
        [sendDictionary setObject:self.iccidString forKey:@"iccid"];
        [sendDictionary setObject:self.agentNumberModel[@"num"] forKey:@"number"];
        [sendDictionary setObject:self.detailDictionary[@"packageId"] forKey:@"packageId"];
        [sendDictionary setObject:self.detailDictionary[@"promotionId"] forKey:@"promotionId"];
        [sendDictionary setObject:self.detailDictionary[@"imsi"] forKey:@"imsi"];
        [sendDictionary setObject:self.detailDictionary[@"simId"] forKey:@"simId"];
        
        @WeakObj(self);
        //开户操作
        [WebUtils requestAgentWhitePrepareOpenFinalWithDictionary:sendDictionary andCallBack:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.writeView.nextButton.enabled = YES;
            });
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                
                @StrongObj(self);
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AgentResultViewController *vc = [[AgentResultViewController alloc] init];
                        vc.detailDictionary = self.detailDictionary;
                        vc.agentNumberModel = self.agentNumberModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utils toastview:@"开户失败"];
                    });
                }
            }
        }];
    }else{
        
        //渠道商
        WhitePrepareOpenThreeViewController *vc = [[WhitePrepareOpenThreeViewController alloc] init];
        vc.typeString = self.typeString;
        vc.numberModel = self.numberModel;
        vc.imsiDictionary = self.imsiDictionary;
        vc.iccidString = self.iccidString;
        vc.promotionsDictionary = self.promotionsDictionary;
        vc.packagesDictionary = self.packagesDictionary;
        vc.detailDictionary = self.detailDictionary;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)showDataAction{
    //    @[@"靓号",@"归属地",@"运营商",@"套餐",@"活动包",@"ICCID"];
    
    if ([self.typeString isEqualToString:@"代理商白卡预开户"]) {
        self.writeView.dataArray = [@[self.agentNumberModel[@"num"], self.detailDictionary[@"cityName"], @"假数据", @"假数据", @"假数据"] mutableCopy];
        [self.writeView.contentTableView reloadData];
    }else{
        NSString *address = [Utils getCityWithProvinceId:self.numberModel.provinceCode andCityId:self.numberModel.cityCode];
        
        self.writeView.dataArray = [@[self.numberModel.number, address, self.detailDictionary[@"network"], self.packagesDictionary[@"name"], self.promotionsDictionary[@"name"]] mutableCopy];
        [self.writeView.contentTableView reloadData];
    }
}

//写卡
- (void)writeAction{
    //ICCID是蓝牙读卡器读出来的
    [ble beginScan];
    self.iccidPopView.hidden = NO;
}

- (void)showIccidString:(NSString *)iccidString{
    NormalShowCell *iccidCell = [self.writeView.contentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    iccidCell.rightLabel.hidden = NO;
    iccidCell.rightLabel.text = iccidString;
    self.writeView.writeButton.hidden = YES;
}

- (void)getAndReadActionWithIccidString:(NSString *)iccidString{
    //显示iccidString到界面
        @WeakObj(self);
    
    [WebUtils requestAgencyLiangRecordsWithPhoneNumber:self.numberModel.number andIccid:iccidString andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            //不论对错都接下去，所以不管这个
            @StrongObj(self);
            [self requestLiangWithPhone:self.numberModel.number andICCID:iccidString];
        }
    }];
}

- (void)requestLiangWithPhone:(NSString *)phone andICCID:(NSString *)iccid{
    @WeakObj(self);
    [WebUtils requestLiangImsiWithPhoneNumber:phone andIccid:iccid andCallBack:^(id obj) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            @StrongObj(self);
            
            if ([code isEqualToString:@"10000"]) {
                
                NSDictionary *dictionary = obj[@"data"];
                self.imsiDictionary = dictionary;
                //此时写卡
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
                    NSString *apduImsi = [Utils getRightIMSIWithString:dictionary[@"imsi"]];
                    NSString *responseWrite = [ble transmit:apduImsi];
                    if (![responseWrite isEqualToString:@"9000"]) {
                        [Utils toastview:@"写卡失败"];
                        return;
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Utils toastview:@"写卡失败"];
                            return;
                        });
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showIccidString:iccid];
                    });
                });
            }else{
                [self showSIMFailedAction];
            }
        }
    }];
}

- (void)showSIMFailedAction{
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
    [ble breakScan];
}

- (void)didDisconnect{
    
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
    @WeakObj(self);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        @StrongObj(self);
        NSString *reset = [ble reset];
        NSLog(@"-----%@",reset);
        
        [ble transmit:@"A0A40000023F00"];//到主目录下
        
        [ble transmit:@"A0A40000022FE2"];//到iccid目录下
        
        NSString *responseString = [ble transmit:@"A0B000000A"];//获取iccid
        
        NSLog(@"------%@",responseString);
        
        if (responseString.length >= 20) {
            responseString = [Utils getRightICCIDWithString:responseString];
            
            NSLog(@"------%@",responseString);
            
            if (responseString.length == 20) {
                self.iccidString = responseString;
                [self getAndReadActionWithIccidString:responseString];
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
    [ble connectByName:peri.name];
}

@end
