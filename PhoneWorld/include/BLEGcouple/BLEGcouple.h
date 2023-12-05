//
//  BLEGcouple
//  BLEGcouple
//
//  Created by jornason on 2016/11/5.
//  Copyright © 2016年 gcouple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define supportPair NO

typedef void(^BLEBoolCallBack)(BOOL response);


@protocol BleProtocol <NSObject>

@optional
//设备名称白名单策略 return YES 则自动连接
- (BOOL)deviceNameFilter:(NSString * _Nonnull)deviceName;
//设备UUID白名单策略 return YES 则自动连接
- (BOOL)deviceUUIDFilter:(NSString * _Nonnull)UUID;
//设置设备可发现策略，return YES 则可被发现
- (BOOL)didDiscover:(NSString * _Nullable)name rssi:(NSNumber * _Nullable)rssi advertisementData:(NSDictionary * _Nullable)advertisementData;
//获取设备列表的回调
- (void)appendPeripheralFilter:(CBPeripheral * _Nonnull)peripheral RSSI:(NSNumber * _Nonnull)RSSI;
//蓝牙成功连接的回调
- (void)didConnect:(NSString * _Nonnull)name;
//蓝牙断开连接的回调
- (void)didDisconnect;
//蓝牙通信配置完成
- (void)didBleReady;
//蓝牙配对配置完成
- (void)didBlePairReady:(BOOL)State;

//更新RSSI
- (void)didReadRSSI:(NSNumber * _Nonnull)rssi;
//更新蓝牙设备状态
- (void)updateState:(NSInteger)state;


@end

@interface BLEGcouple : NSObject

@property (nonatomic, weak) _Nullable id<BleProtocol> delegate;


+(BLEGcouple* _Nonnull) sharedInstance;

//开始扫描
-(void)beginScan;
//断开扫描
- (void)breakScan;
//获取设备连接状态
- (BOOL)GetConnectState;
//获取设备配对连接状态
- (BOOL)GetConnectPairState;
//设置通信超时时间
- (void)SetDelayInterval:(NSInteger)interval;
//设置断开后是否重连
- (void)setKeepConnect:(BOOL)state;
//获取设备CBPeripheral对象
- (CBPeripheral * _Nullable)getPeripheral;
//断开蓝牙连接
- (CBPeripheral * _Nullable)disConnect;
//通过设备CBPeripheral对象连接蓝牙
- (void)connect:(CBPeripheral * _Nonnull)peripheral;
//通过设备名称连接蓝牙
- (void)connectByName:(NSString * _Nonnull)name;
//通过设备UUID连接蓝牙
- (void)connectByUUID:(NSString * _Nonnull)uuid;
- (NSString * _Nonnull)reset;
- (NSString * _Nonnull)finish;
- (NSString * _Nonnull)sendcmd:(NSString * _Nonnull)cmd;
-(void)writeValue:(NSData* _Nonnull)cmd;
- (NSString * _Nonnull)transmit:(NSString * _Nonnull)apdu;
- (NSData * _Nullable)transmitRaw:(NSData * _Nonnull)apduRaw;
//蓝牙配对
- (void) pairBLE:(BLEBoolCallBack _Nonnull)CallBack authCode:(NSString * _Nonnull)authCode;
//解除蓝牙配对
- (void) unPairBLE:(BLEBoolCallBack _Nonnull)CallBack;

- (void) setCardPPS:(BLEBoolCallBack _Nonnull)CallBack PPS:(NSString * _Nonnull)PPS;
- (NSString* _Nonnull) getDeviceInfo;
- (NSInteger)getChargeRatio;
-(NSInteger) queryDeviceState;
//BT_POWEROFF         = 0x0,
//BT_IDLE             = 0x1,
//BT_CONNECTTING      = 0x2,
//BT_DISCONNECTTING   = 0x3,
//BT_CONNECTED        = 0x4,


@end
