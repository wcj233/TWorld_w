//
//  STMyPeripheral.h
//  BLETR
//
//  Created by D500 user on 13/5/30.
//  Copyright (c) 2013年 ISSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSInteger, DeviceMode) {
    DeviceModeBluetooth,//蓝牙方式
    DeviceModeNFC,//NFC方式
};

@interface STMyPeripheral:NSObject

// 蓝牙设备名称
@property(nonatomic,retain) NSString *advName;
// 蓝牙设备MAC
@property (nonatomic,retain)NSString *mac;
// CBPeripheral - 在搜索蓝牙设备时获取
@property (nonatomic,retain) CBPeripheral *peripheral;
// Proprietary写特征值 - 在连接蓝牙设备时设置
@property(nonatomic,retain) CBCharacteristic *transparentDataWriteChar;
// Proprietary写特征值 - 在连接蓝牙设备时设备
@property(nonatomic,retain) CBCharacteristic *transparentDataReadChar;

// 初始化STMyPeripheral对象
- (id)initWithCBPeripheral:(CBPeripheral *)peripheral;

@property (nonatomic,assign)DeviceMode mDeviceMode;

@end


// 用于代理方法的信息返回
@interface STIDReadCardInfo : NSObject

@property (retain) STMyPeripheral *currentPeripheral;       // 连接蓝牙的句柄
@property (nonatomic) int *isWhiteCard;                     // -1:读卡失败; 0:是白卡; 1:是成卡
@property (nonatomic,retain) NSString *ICCID;               // iccid号码成功 失败＝nil
@property (nonatomic,retain) NSString *IMSI;                // imsi号码成功  失败= nil
@property (nonatomic,retain) NSString *USERAUTOCMD;         // 用户自己发送APDU操作指令时，返回的返回值
@property (nonatomic,retain) NSString *CARDTYPE;            // 暂未使用
@property (nonatomic) int *messageResult;                   // 0:写短信中心号码成功; 1:失败
@property (nonatomic) int *writeCardResult;                 // [联通 0:写卡成功 1:写卡失败] [移动：0：写卡成功，其他：写卡失败]
@property (nonatomic, retain) NSString *sn;                 // 移动SIM卡SN
@property (nonatomic, retain) NSString *iccid;              // 移动SIM卡ICCID及门禁卡ICCID
@property (nonatomic, retain) NSString *writeCardReturn;    // 联通移动写SIM卡
@property (nonatomic, retain) NSString *strTelecomCardInfo; // 电信SIM卡信息

@end


