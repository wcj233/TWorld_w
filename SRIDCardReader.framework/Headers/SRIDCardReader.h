//
//  Sunrise_BLE_STIDCardReader.h
//  Sunrise_BLE_STIDCardReader
//
//  Created by Chenfan on 8/27/15.
//  Copyright (c) 2015 Sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTReaderDriver.h"


FOUNDATION_EXPORT double SRIDCardReaderVersionNumber;

FOUNDATION_EXPORT const unsigned char SRIDCardReaderVersionString[];

#define READER_STATE_UNKNOWN  -1
#define STATE_READER_NONE 0
#define STATE_READER_START 1
#define STATE_READER_CONNECTING 3
#define STATE_READER_CONNECTED 2

@interface SRMyPeripheral : NSObject
@property(nonatomic,retain) NSString *advName;
@property(nonatomic,retain) NSString *mac;
@end

@interface SRIDReadCardInfo : NSObject
@property(nonatomic) int isWhiteCard;
@property(nonatomic,retain) NSString *ICCID;
@property(nonatomic,retain) NSString *CARDTYPE;
@property(nonatomic) int writeCardResult;
@property(nonatomic) int *messageResult;
@property(nonatomic,retain) NSString *retCode;
@property(nonatomic,retain) NSString *imsi;

@end


//@interface SRDeviceInfo : NSObject
//@property(nonatomic,retain) NSString *Id; //物理 id(设备唯一序列号) 不足 16 字节前补 00H
//@property(nonatomic,retain) NSString *factoryNo; //厂家编码
//@property(nonatomic,retain) NSString *useFlg; //使用接口标识（ 1-蓝牙、 2-NFC、 3-OTG、 4-PC、 5-UART）
////注: Framework 包中每次收发时更新此标识
//@property(nonatomic,retain) NSString *deviceType; //设备型号
//@property(nonatomic,retain) NSString *softVersion; //软件版本
//@property(nonatomic,retain) NSString *hardwareVersion; //硬件版本
//@end

@interface SRDeviceInfo : NSObject
@property(nonatomic,copy)NSString *Id;                 //物理id(设备唯一序列号)不足16字节前补00H
@property(nonatomic,retain)NSString *factoryNo;        //厂家编码
@property(nonatomic,retain)NSString *useFlg;           //使用接口标识（1-蓝牙、2-NFC、3-OTG、4-PC、5-UART）
@property(nonatomic,retain)NSString *deviceType;       //设备型号
@property(nonatomic,retain)NSString *softVersion;      //软件版本
@property(nonatomic,retain)NSString *hardwareVersion;  //硬件版本
@end

@protocol SRIDCardReaderDelegate;
@interface SRIDCardReader : NSObject
@property (assign) id<SRIDCardReaderDelegate> delegate;
@property(nonatomic) NSObject *currentDevice;

+ (id)instance;

+ (id)instanceWithManagerAccount:(NSString *)acc password:(NSString *) pwd key:(NSString *)key;

+ (id)instanceWithManagerIP:(NSString *)ip port:(int)port account:(NSString *)acc password:(NSString *) pwd key:(NSString *)key;

+ (id)instanceWithManager;

/*
 功能：设置管控服务
 参数：服务器地址，端口
 返回值：无
 */
- (void)setUpManagerIP:(NSString *)ip port:(int)port;

/*
 功能：设置用户名密码
 参数：用户名，密码
 返回值：无
 */
- (void)setUpAccount:(NSString *)acc password:(NSString *)pwd;

/*
 功能：设置密钥
 参数：密钥
 返回值：无
 */
- (void)setUpKey:(NSString *)key;

/*
 功能：实例方法，获取sdk版本号。
 参数：无
 返回值：sdk版本号
 */
- (NSString *)getSDKVersion;

/*
 功能：实例方法，设置使用的服务器IP和端口。
 参数：serVerIp 服务器IP地址
 Port    服务器端口号
 返回值：无
 */
- (void)setServerIP:(NSString*)serverIP andPort:(int)port;

/*
 功能：实例方法，设置主备服务器的ip和端口。
 参数：serVerIp 服务器IP地址
 Port    服务器端口号
 返回值：无
 */
- (void)setServerIp:(NSString*)serVerIp andPort:(int)port serVerSndIp:(NSString*)serVerSndIp andPortSnd:(int)Sndport;

/*
 功能：实例方法，设置用于身份证解码的蓝牙设备，必须在子线程调用
 参数：periperalHandle 通过代理方法didUpdatePeripheralList返回的蓝牙设备对象
 返回值：成功返回 YES，失败返回NO
 */
- (BOOL)setLisentPeripheral:(SRMyPeripheral* )periperalHandle;

/*
 功能：实例方法，设置用于身份证解码的蓝牙设备，必须在子线程调用
 参数：
 bt：CBPeripheral对象
 cbmanager：CBCentralManager对象
 返回值：成功返回 YES，失败返回NO
 */
- (BOOL)setLisentPeripheral:(CBPeripheral *)bt withCBManager:(CBCentralManager*)cbmanager;

/*
 功能：扫描等待超时
 参数：无
 返回值：无
 */
- (void)waitingTime;

/*
 功能：实例方法，开始执行读取身份证
 参数：无
 返回值：无
 */
- (void)startScaleCard;

/*
 功能：实例方法，开始执行读取身份证
 参数：超时时间
 返回值：无
 */
- (void)startScaleCard:(int)timeOut;

/*
 功能：实例方法，开始执行读取身份证
 参数：decrypt:是否返回照片 timeOut:超时时间
 返回值：无
 */
- (void)readCardWithoutDecrypt:(BOOL)decrypt timeOut:(int)timeOut;

/*
 功能：实例方法，重新扫描周边的蓝牙设备，并通过代理方法didUpdatePeripheralList返回周边的蓝牙设备对象。
 参数：无
 返回值：无
 */
- (void)refreshDeviceList;

/*
 功能：实例方法，停止扫描周边的蓝牙设备
 参数：无
 返回值：无
 */
//- (void)stopRefreshDeviceList;

/*
 功能：实例方法，读取ICCID
 参数：cardType:卡类型 1代表2G卡，2代表3G卡，3代表4G卡
 返回值：IDReadCardInfo对象
 */
- (SRIDReadCardInfo*)readCardInfo:(NSString *)cardType;

/**
 * 功能:读取卡中IMSI值
 * 参数:是否3G卡
 * 返回值:0 是白卡
 -2 IMSI读取出错
 -1 非白卡
 */
-(NSString *)queryImsi:(BOOL)is3GCard;

/*
 功能：读IMSI号
 参数：无
 返回值：
 -1:读取失败
 0 :白卡
 1 :成卡
 */
- (int)readIMSI;

/*
 功能：写入IMSI号
 参数：IMIS号
 返回值：写入结果代码
 */
- (int)writeIMSI:(NSString *)imsi;

/*
 功能：写入短信中心号和电话号码
 参数：短信中心号
 返回值：写入结果代码
 */
- (int)writeMSGNumber:(NSString *)sms number:(Byte)num;

/*
 功能：总部写卡函数，需要在非主线程中调用
 参数：option：写入短信中心号，iccid：白卡卡号，imsi：写入的imsi号，number：写入的电话号码
 返回值：写卡结果
 */
- (NSString *)insertCard:(NSString *)option iccid:(NSString *)iccid imsi:(NSString *)imsi number:(NSString *)custNum;

/*
 功能：设置读取身份证时传输的业务数据
 参数：JSON字符串
 返回值：设置结果，数据格式错误返回NO，数据格式正确返回YES
 */
-(BOOL)setBusinessData:(NSString *)dataStr;

/*
 功能：蓝牙连接状态查询,返回值:YES 已连接  NO 未连接
 */
-(BOOL)connectStatus;

/*
 功能：刷新解密服务列表
 */
- (int)refreshServerList;

/*
 功能:阅读器名称,该方法必须要非主线程执行
 参数:蓝牙设备对象以及蓝牙管理器
 返回:
    成功:YES
    失败:NO
 */
- (BOOL)openReader:(CBPeripheral *)readerName withCBManager:(CBPeripheralManager *)cbmanager;

/*
 功能:阅读器名称,该方法必须要非主线程执行
 参数:阅读器名称
 返回:
 成功:YES
 失败:NO
 */
- (BOOL)openReader:(NSString *)readerName;

/*
 功能:卡上电操作
 参数:无
 返回:
    成功:YES
    失败:NO
 */
- (BOOL)cardPoweron;

/*
 功能:发送APDU指令
 参数:APDU字符串
 返回:十六进制字符串
 */
- (NSString *)transmitAPDU:(NSString *)apduStr;

/*
 功能:卡下电操作
 参数:无
 返回:无
 */
- (void)cardPoweroff;

/*
 功能:断开阅读器连接
 参数:无
 返回:无
 */
- (void)closeReader;

/*
 功能:读取ICCID,并判断是否白卡
 参数:ICCID指针
 返回:
    -1:读取失败
    0 :白卡
    1 :成卡
 */
-(int)readSimICCID:(NSString *)iccid;

/*
 功能:写白卡
 参数:
    imsi:国际移动用户识别码,15位数字
    smsNo:短信中心号码,11位数字号码
 返回:
 -1:打开阅读器失败
 -2:写IMSI失败
 -3:卡上电失败
 -4:写SMS失败
 -5:卡返回失败
 0:写卡成功
 */
-(int)writeSimCard:(NSString *)imsi withNo:(NSString *)smsNo;

/*
 功能:获取设备信息
 参数:无
 返回值:SRDeviceInfo对象
 */
- (SRDeviceInfo *)getDeviceInfo;

/*
 功能：鉴权接口
 参数：随机字符串
 返回值：密文
 */
- (NSData *)encryptInfo:(NSString *)randomString;

/*
 功能：在指定时间内获取扫描到的设备列表
 参数：超时时间（单位：秒）
 返回：设备列表
 */
- (NSArray *)getDeviceList:(int)timeOut;

/*
 获取设备电量
 返回值：
 0~1的浮点数：设备剩余电量（0为空电量，1为满电量）
 -2：使用的设备无法获取电量
 -1：未连接设备
 */
- (float)getVoltage;

/*
 读取sim卡iccid和imsi号
 返回值：
 -1：读取失败
 0：白卡
 1：成卡
 */
- (int)readSimICCIDIMSI;

/*
 功能：移动读空卡系列号
 参数：无
 返回值：
 -3 卡上电失败
 -4 写入指令失败
 -1 读取失败
 1 系列号
 */
- (int)readMobileCardSN;



/*
 功能：移动读卡片信息
 参数：无
 返回值：
 -3 卡上电失败
 -4 写入指令失败
 -1 读取失败
 1  卡片信息
 */
- (int)readMobileCardInfo;

/*
 功能：移动写卡
 参数：写卡数据
 返回值：
 -3 卡上电失败
 -4 写卡指令错误
 -5 写卡数据错误
 -1 写卡失败
 1  写卡成功信息
 */
- (int)writeMobileCard:(NSString *)parm;

/*
 功能：读取短信中心号
 参数：无
 返回值：
 -3 卡上电失败
 -1 读取失败
 1 返回短信中心号
 */
- (int)readCardMSGNumber;

/*
 功能：读取sim卡号码
 参数：无
 返回值：
 -3 卡上电失败
 -1 读取失败
 1 成卡
 */
- (int)readPhoneNumber;

/*
 功能：指定是否走管控
 参数：YES / NO
 返回值：YES 走管控
        NO 不走管控
 */
- (void)enableAutoServer:(BOOL)enable;

/*
 功能：设置密钥
 参数：密钥
 返回值：设置的密钥
 */
- (void)setAppSecretKey:(NSString *)key;

@end

@protocol SRIDCardReaderDelegate <NSObject>

@required

/*
 功能：代理方法，返回蓝牙设备连接状态
 参数：结果信息
 返回值：无
 */
- (void)readerStateBack:(NSString *)state;

/*
 功能：代理方法，返回蓝牙开关状态
 参数：结果信息
 返回值：无
 */
- (void)centralManagerState:(NSString *)state;

/*
 功能：代理方法，返回读取sim卡号码
 参数：结果信息
 返回值：无
 */
- (void)readPhoneNumberSuccessBack:(NSString *)numberStr withData:(id)data;

/*
 功能：代理方法，返回读取的短信中心号
 参数：结果信息
 返回值：无
 */
- (void)readCardMSGNumberSuccessBack:(NSString *)numberStr withData:(id)data;

/*
 功能：代理方法，返回移动读空卡系列号
 参数：结果信息
 返回值：无
 */
- (void)readMobileCardSNSuccessBack:(NSString *)mobileStr withData:(id)data;



/*
 功能：代理方法，返回移动读卡片信息
 参数：结果信息
 返回值：无
 */
- (void)readMobileCardInfoSuccessBack:(NSString *)mobileStr withData:(id)data;

/*
 功能：代理方法，返回移动写卡结果信息
 参数：结果信息
 返回值：无
 */
- (void)writeMobileCardSuccessBack:(NSString *)mobileStr withData:(id)data;

/*
 功能：代理方法，当扫描到周围的蓝牙设备时，通过该代理获得代表各个蓝牙设备的对象数组。
 参数：peripherals 蓝牙设备对象数组
 返回值: 无
 */
//- (void)SRdidUpdatePeripheralList:(NSArray *)peripherals;
/*
 
 功能：代理方法，读取身份证失败时可以通过这个代理方法获取失败的蓝牙对象和原因。
 参数：peripheral 代表蓝牙设备的对象
 error 描述失败的具体原因
 返回值：无
 */
- (void)SRfailedBack:(CBPeripheral*)peripheral withError:(NSError *)error;
/*
 功能： 代理方法，读取身份证成功时可以通过这个代理方法获取身份证的文本信息和照片信息。
 参数：peripheral代表蓝牙设备的对象
 data 如果data是NSDictionary类型，则里面包含的信息是文本信息，具体获取各字段信息见下表；如果data是NSData类型，则里面包含的是照片的二进制数据流
 返回值：无
 */
- (void)SRsuccessBack:(CBPeripheral*)peripheral withData:(id)data;

/*
 
 功能：代理方法，读取身份证失败时可以通过这个代理方法获取失败的蓝牙对象和原因。
 参数：peripheral 代表蓝牙设备的对象
 error 描述失败的具体原因
 返回值：无
 */
- (void)failedBack:(CBPeripheral*)peripheral withError:(NSError *)error;
/*
 功能： 代理方法，读取身份证成功时可以通过这个代理方法获取身份证的文本信息和照片信息。
 参数：peripheral代表蓝牙设备的对象
 data 如果data是NSDictionary类型，则里面包含的信息是文本信息，具体获取各字段信息见下表；如果data是NSData类型，则里面包含的是照片的二进制数据流
 返回值：无
 */
- (void)successBack:(CBPeripheral*)peripheral withData:(id)data;

/*
 功能:代理方法,读取卡号时通过该方法返回结果
 参数:结果信息
 返回值:无
 */
- (void)ReadICCIDsuccessBack:(SRIDReadCardInfo*)peripheral withData:(id)data;

/*
 功能:代理方法,读取imsi时通过该方法返回结果
 参数:结果信息
 返回值:无
 */
- (void)ReadIMSIsuccessBack:(SRIDReadCardInfo*)peripheral withData:(id)data;

/*
 功能：代理方法，读取iccid和imsi时，同时返回两个值
 参数：结果信息
 返回值：无
 */
- (void)ReadICCIDIMSIsuccessBack:(SRIDReadCardInfo*)peripheral withData:(id)data;

/*
 功能:代理方法,写卡时通过该方法返回结果
 参数:结果信息
 返回值:无
 */
- (void)writeCardResultBack:(SRIDReadCardInfo*)peripheral withData:(id)data;

/*
 功能：返回读取结果的JSON字符串
 参数：JSON字符串
 返回值：无
*/
- (void)idCardInfoJsonStr:(NSString *)jsonStr;

/*
 功能：代理方法，返回身份证密文
 参数：身份证密文
 返回值：无
 */
- (void)idResponSuccessBack:(NSData*)data;

/*
 功能：代理方法，返回连接的解密服务器
 参数：服务器地址
 返回值：无
 */
- (void)connectServerIPPort:(NSString *)str;

@end

