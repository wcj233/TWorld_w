//
//  STReadWriteCardTool.m
//  PhoneWorld
//
//  Created by sheshe on 2024/1/23.
//  Copyright © 2024 xiyoukeji. All rights reserved.
//

#import "STReadWriteCardTool.h"

@implementation STReadWriteCardTool

- (void)initSTReader {
    //代理
    [[STIDCardReader instance] setDelegate:self];
    [[BlueManager instance] setDeleagte:self];
}

- (void)deinitSTReader {
    [[STIDCardReader instance] setDelegate:nil];
    [[BlueManager instance] setDeleagte:nil];
}

///读卡
- (void)STConnectedDevicesForPeripheral:(STMyPeripheral *)peri {
    
    self.stPeri = peri;
    
    BlueManager *bmanager = [BlueManager instance];
    bmanager.deleagte = self;
    [bmanager startScan];
}

///写卡
- (void)STWriteCardWithSimCard:(NSString *)sim andSMSNO:(NSString *)no {
    [[STIDCardReader instance] writeSimCard:sim SMSNO:no];
}

/*展示返回的错误信息*/
- (void)showWarningText:(id)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *mes = [NSString stringWithFormat:@"%@",text];
        [Utils toastview:mes];
    });
}

#pragma mark -============= ST山东信通 代理 ================

// 读ICCID，IMSI及发送APDU指令代理方法 - 返回信息的获取参照DEMO实例
- (void)ReadICCIDsuccessBack:(STIDReadCardInfo *)peripheral withData:(id)data {
    [self.stReadWriteCardToolDelegate STReadICCIDsuccessBack:peripheral withData:data];
}

- (void)writeCardResultBack:(STIDReadCardInfo*)peripheral withData:(id)data{
    [self.stReadWriteCardToolDelegate STWriteCardResultBack:peripheral withData:data];
}

- (void)failedBack:(STMyPeripheral *)peripheral withError:(NSError *)error{
    [self.stReadWriteCardToolDelegate STFailedBack:peripheral withError:error];
}

#pragma mark - BlueManagerDelegate

- (void)didFindNewPeripheral:(STMyPeripheral *)periperal {
    if(/*[periperal.mac isEqualToString:@""] ||*/ periperal.advName == nil) {
        
        return;
    }
    if([periperal.advName isEqualToString:self.stPeri.advName] && [periperal.mac isEqualToString:self.stPeri.mac]) {
        
        BlueManager *bmanager = [BlueManager instance];
        [bmanager stopScan];
        STMyPeripheral *myPeripheral = bmanager.linkedPeripheral;
        [bmanager disConnectPeripher:myPeripheral];
        NSLog(@"点选设备,开始连接蓝牙设备");
        //先建立连接，连接上以后 传给SDK
        //bmanager.linkedPeripheral = peripheral;
        [bmanager connectPeripher:periperal];
    }
}

- (void)connectperipher:(STMyPeripheral *)peripheral withError:(NSError *)error {
    NSLog(@"已连接上 %@",peripheral.advName);
    [[STIDCardReader instance] setLisentPeripheral:peripheral];
    [[STIDCardReader instance] readSimICCID];
}

@end
