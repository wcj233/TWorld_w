//
//  MPosCardReader.h
//  SRIDCardReader
//
//  Created by 侯晓帆 on 2019/9/23.
//  Copyright © 2019 Sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//#define NSLog(...)

@protocol MPosCardReaderDelegate;

@interface MPosCardReader : NSObject
@property (strong, nonatomic) id<MPosCardReaderDelegate> delegate;

/**
 功能：初始化
 参数：appKey 应用接入key   appSecret 签名串加密密钥   password 身份证信息解密密钥
 */
+(id)initDevice;

-(void)setSdkVersion:(NSString *)version;

- (void)setAppKey:(NSString *)appKey;

- (void)setAppSecret:(NSString *)app_secret;

- (void)setPassword:(NSString *)password;

- (void)setBusiSerial:(NSString *)busiSerial;

- (void)setBusiData:(NSDictionary *)busiData;

/*
 功能：注册设备
 参数：peripheral 蓝牙设备对象  manager 蓝牙中心对象  time 连接设备超时时间/秒
 返回值：0 成功  非0 失败
 */
-(int)registerDevice:(CBPeripheral *)peripheral withCBManager:(CBCentralManager *)manager connectTimeout:(int)time;

/*
 功能：与阅读器建立蓝牙连接
 参数：bt 蓝牙设备对象  cbmanager 当前蓝牙管理中心实例  timeout 连接超时，单位秒（不得小于2秒，否则可能导致连接失败）
 返回值：连接结果 0是连接成功 非0是连接失败
 */
- (int)connectPeripheral:(CBPeripheral *)bt withCBManager:(CBCentralManager *)cbmanager withTimeout:(int)timeout;

/**
 功能：读身份证
 参数：timeout 读证超时时间/秒
 返回值：无
 */
-(void)readCert:(int)timeout;

/**
 功能：读身份证
 参数：timeout 读证超时时间/秒
 返回值：无
 */
-(void)readIDCardByJson:(int)timeout;

/**
 功能：断开设备连接
 */
-(void)disConnectDevice;

/**
 功能：读sim卡IMSI号
 参数：imsi出参  卡imsi
 返回值：  1 寻卡失败   0 读取成功   -1 读取失败   -3 卡上电失败
 */
-(int)readSimCardIMSI:(NSString **)imsi;

/**
 功能：读sim卡ICCID
 参数：iccid出参  卡iccid
 返回值：  1 寻卡失败   0 读取成功   -1 读取失败   -3 卡上电失败
 */
-(int)readSimCardICCID:(NSString **)iccid;

/**
 功能：写白卡
 参数：imsi 国际移动用户识别码，15位数字    smsNo 短信中心号码，11位数字
 返回值：  1 寻卡失败   0 写卡成功  -1 打开阅读器失败  -2 写imsi失败  -3 卡上电失败  -4 写sms失败  其他 卡返回失败
 */
-(int)writeSimCardIMSI:(NSString *)imsi withSmsNo:(NSString *)smsNo;

/**
 功能：读移动sim卡序列号
 参数：cardSn 出参   卡序列号
 返回值：  1 寻卡失败   0 读取成功   -1 读取失败  -3 卡上电失败   -4写入指令失败
 */
-(int)readMobileCardSN:(NSString **)cardSn;

/**
 功能：读移动sim卡号
 参数：cardNo 出参  sim卡号
 返回值：  1 寻卡失败   0 读取成功    -1 读取失败    -3 卡上电失败   -4 写入指令失败
 */
-(int)readMobileCardInfo:(NSString **)cardNo;

/**
 功能：写移动sim卡
 参数：param 写卡数据    info 出参  写卡成功信息
 返回值：  1 寻卡失败   0 写卡成功   -1 写卡失败   -3 卡上电失败     -4 写卡指令错误     -5 写卡数据错误
 */
-(int)writeMobileCard:(NSString *)param response:(NSString **)info;

/**
 功能：写湖南移动sim卡
 参数：param 写卡数据    info 出参  写卡成功信息
 返回值：  1 寻卡失败   0 写卡成功   -1 写卡失败   -3 卡上电失败     -4 写卡指令错误     -5 写卡数据错误
 */
-(int)writeMobileCardH_N:(NSString *)param response:(NSString **)info;

/*
 功能：总部写卡函数，需要在非主线程中调用
 参数：option：写入短信中心号，iccid：白卡卡号，imsi：写入的imsi号，number：写入的电话号码
 返回值：写卡结果
 */
- (NSString *)insertCard:(NSString *)option iccid:(NSString *)iccid imsi:(NSString *)imsi number:(NSString *)custNum;

/**
 功能：读sim卡号码
 参数：number 出参  卡号码
 返回值：  1 寻卡失败   0 读取成功   -1 读取失败   -3 卡上电失败
 */
-(int)readPhoneNumber:(NSString **)number;

/**
 功能：读sim卡短信中心号
 参数：number 出参  卡短信中心号
 返回值：  1 寻卡失败   0 读取成功   -1 读取失败    -3 卡上电失败
 */
-(int)readCardMSGNumber:(NSString **)number;

/**
 功能：读取芯片银行卡卡号和有效期，用等号（=）隔开
 参数：number 出参 卡号和有效期
 返回值：  1 寻卡失败   0 读取成功    -1 读取失败   -3 卡上电失败
 */
-(int)readChipBankCardNumber:(NSString **)number;

/**
功能：读取磁条卡卡号和有效期，用等号（=）隔开
参数：number 出参 卡号和有效期
返回值：  1 寻卡失败   0 读取成功    -1 读取失败   -3 卡上电失败
*/
-(int)readMagneticStripCardNumber:(NSString **)number;

/**
 设备卡上电
 type  0 - IC卡   4 - 非接触卡
 */
-(int)cardPowerOn;

/**
 设备卡下电
 type  0 - IC卡   4 - 非接触卡
 */
-(int)cardPowerOff;

/**
 向设备透传apdu指令
 apdu  指令数据
 type  0 - IC卡   4 - CPU卡
 */
-(void)sendApdu:(NSString *)apdu response:(NSString **)param;

/*!
 读取设备序列号
 */
-(NSString *)getDeviceSn;

@end

@protocol MPosCardReaderDelegate <NSObject>

@required

-(void)readCertSuccessBack:(NSString *)certInfo;

-(void)readCertFailureBack:(int)resCode errorMsg:(NSString *)errorMsg;

-(void)parseCertSuccessBack:(NSDictionary *)certInfo;

@end

