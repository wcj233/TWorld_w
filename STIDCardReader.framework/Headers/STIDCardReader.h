//
//  STIDCardReader.h
//
//  Created by tungkong on 15/8/7.
//  Copyright (c) 2015年 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "STMyPeripheral.h"


@protocol STIDCardReaderDelegate;
@interface STIDCardReader : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>{
    
}

@property(nonatomic,assign) id delegate;
@property (nonatomic,retain)NSString *checkCode,*uuid,*timeTag,*signStr,*strDN;

+(id)instance;

// ----------------------------------参数配置----------------------------------------
// 设置服务器 地址 和端口 - 必须
- (void)setServerIp:(NSString *)serVerIp andPort:(int)port;

// 设置需要监听的蓝牙设备 - 必须
- (BOOL)setLisentPeripheral:(STMyPeripheral *)periperalHandle;

// set appcode - 非必须[专用]
- (void)setAppCode:(int)code;

// 设置sdk key - 非必须[专用]
- (void)setKey:(NSString *)key;

// 设置透传参数 - 非必须[专用]
- (void)setPassthroughParam:(NSString *)passthroughParam;

// set log server address - 暂未启用
- (void)setLogServerAddr:(NSString*)logServerAddr;

// 预留接口 - 暂未启用
- (void)setReserved:(NSInteger)reserved;


// -----------------------------------设备信息----------------------------------------
// 获取设备的编号
- (NSString *)getSerialNumber;

// 获取设备信息 - 设备型号,设备唯一标识及状态
- (NSDictionary *)getDevInfo;

// 获取固件版本号
- (NSString *)getFirmwareVer;

// 获取SDK版本号
- (NSString *)getSDKVer;

// 获取SIM卡插入状态 1：插入 0：未插入 -1:获取失败
- (int)getSimCardStatus;

// 获取设备电量信息-0：电量不足 100：满电量 -1：获取失败
- (int)getDevVoltage;


// -----------------------------------身份证读取---------------------------------------
// 读取身份证 - 分体一体通用
- (void)readIDCard;

// 带指纹读取身份证 - 分体一体通用
- (void)readIDCardWithFP;

// nfc带指纹读取身份证 -
- (void)nfcReadIDCardWithFP;

// 扫描卡片 - 一体式设备 - [弃用，更新SDK时，建议使用一体分体通用接口]
- (void)readCert;

// 带指纹扫描卡片 - 一体式设备 - [弃用，更新SDK时，建议使用一体分体通用接口]
- (void)readCertWithFP;

///开始扫描卡片 - 分体式设备 - [弃用，更新SDK时，建议使用一体分体通用接口]
- (void)startScaleCard;

// 带指纹扫描卡片 - 分体式设备 - [弃用，更新SDK时，建议使用一体分体通用接口]
- (void)startScaleCardWithFP;


// ----------------------------------SIM卡通用--------------------------------------
// 发送APDU指令
- (void)sendApduCommand:(NSString*)apdu;

// sim卡上电操作，成功为YES，失败为NO - 选用
-(BOOL)cardPowerOn;

// sim卡下电操作, 成功为YES，失败为NO - 选用
-(BOOL)cardPowerOff;


// ---------------------------------联通SIM卡---------------------------------------
/* 读取 ICCID,并判断是否是成白卡
 *  @return 返回SIM 信息   "iccid":"23333333","stype":"0"
 *  key为iccid 的value值为ICCID  key为stype的 value值为0（白卡）或 1（成卡）*/
-(void)readSimICCID;

// 读取sim卡的imsi的方法
-(void)readIMSINumber;

// 写白卡 - @param imsi  国际移动用户识别码；@param smsNo 短信中心号码
-(void)writeSimCard:(NSString*)imsi SMSNO:(NSString*) smsNo;

// 写5G白卡 @param imsi  国际移动用户识别码；@param ri    RI值
-(void)write5GSimCard:(NSString *)imsi SMSNO:(NSString *)smsNo withRi:(NSString *)ri;

// 发送卡操作的字符指令 *apdu: 字符指令 - 处理成功返回0；处理失败返回-1
-(void)transmitCard:(NSString *)apdu;


// ---------------------------------移动SIM卡----------------------------------------
// 读取空卡序列号
- (void)getCardSN;

// 读取卡片信息
- (void)getCardInfo;

// 最新的获取卡信息的接口
- (void)getNewCardInfo;

// 实时写卡数据写入
- (void)writeCardWithIssueData:(NSString*)issueData;

// 实时写超级SIM卡
- (void)wirteSuperCardWithIsueData:(NSString*)issueData;

// 京东便利店添加的实时写卡方法 江西
- (void)writeCardWithIssueData2:(NSString *)issueData;

// 获取sdk版本信息
- (NSString*)getOPSVersion;


// ---------------------------------电信SIM卡----------------------------------------
// 获取读卡器信息
- (NSString *)getReaderInfo;

// 读取SIM卡信息
- (void)readSimCardInfo;


// ----------------------------读取门禁卡ICCID[专用]-----------------------------------
// read door card iccid
- (void)getICCID;


@end


//// STIDCardReader Delegate
@protocol STIDCardReaderDelegate

@optional

// -------------------------读身份证及SIM卡操作所有蓝牙通信代理方法--------------------------
// 蓝牙相关 - 和蓝牙相关的操作失败代理方法[身份证和SIM卡]；通过此代理方法获取相关错误信息
- (void)failedBack:(STMyPeripheral *)peripheral withError:(NSError *)error;

// 读证成功代理方法 - 如果是文本信息，Data 是NSDictionary  图片则返回NSData
- (void)successBack:(STMyPeripheral *)peripheral withData:(id)data;

// 程序获取到checkCode 或者SignStr 后自动调用
- (void)getDataBack:(NSString *)checkCode SignStr:(NSString *)signStr;


// -------------------------sendApduCommand代理方法[SIM卡通用]----------------------------
// 发送SIM卡指令代理方法 - 通过peripheral.USERAUTOCMD获取发送指令后的返回信息
- (void)transmitCardBack:(STIDReadCardInfo *)peripheral withData:(id)data;


// --------------------------------联通读写SIM卡代理方法------------------------------------
/*  @param peripheral <#peripheral description#>
 *  @param data       ICCID
 stype   -1失败 0白卡 1 成卡 */
// 读ICCID，IMSI及发送APDU指令代理方法 - 返回信息的获取参照DEMO实例
- (void)ReadICCIDsuccessBack:(STIDReadCardInfo *)peripheral withData:(id)data;

// 写卡Delegate - 通过peripheral.writeCardResult判断是否写卡成功
- (void)writeCardResultBack:(STIDReadCardInfo*)peripheral withData:(id)data;


// --------------------------------移动读写SIM卡代理方法------------------------------------
// 读取SN代理方法 - 通过peripheral.sn获取返回信息
- (void)getCardSNBack:(STIDReadCardInfo*)peripheral withData:(id)data;

// 读取cardInfo代理方法 - 通过peripheral.iccid, peripheral.sn获取返回信息
- (void)getCardInfoBack:(STIDReadCardInfo*)peripheral withData:(id)data;

// 写卡代理方法 - 通过peripheral.writeCardResult判断是否写卡成功
- (void)writeCardBack:(STIDReadCardInfo *)peripheral withData:(id)data;


// -------------------------------电信读写SIM卡代理方法-------------------------------------
- (void)readSimCardInfoBack:(STIDReadCardInfo *)peripheral withData:(id)data;


// ------------------------------------读门禁卡ICCID---------------------------------------
// door card delegate
- (void)getICCIDBack:(STIDReadCardInfo *)peripheral withData:(id)data;


@end

