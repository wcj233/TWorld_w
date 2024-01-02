//
//  BTReader.h
//  BTReader
//
//  Created by BlueElf on 15/7/7.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SRIDCardReader/btreader.h>

#define CMD_OPENID  0x90
#define CMD_INT_AUTHID  0xa4
#define CMD_EXT_AUTHID  0xa5
#define CMD_ID_RESPON   0xf2
#define CMD_ID_TELECOM_RESPON   0Xf3
#define CMD_ID_MOBILE_RESPON   0xf4
#define CMD_ID_MSG_RESPON  0xf5

#define READER_STATE_UNKNOWN  -1
#define STATE_READER_NONE 0
#define STATE_READER_START 1
#define STATE_READER_CONNECTING 3
#define STATE_READER_CONNECTED 2

#define ERR_BLUETOOTH_CONNECT_FAIL      -11101
#define ERR_READER_OPEN_IDCARD_TIMEOUT         -11104
#define ERR_READER_OPEN_IDCARD_CMD_ERROR       -11105
#define ERR_READER_OPEN_IDCARD_STATUS_ERROR    -11106
#define ERR_INIT_PARAM_ERROR            -11401
#define ERR_INIT_PARAM_EMPTY            -11402
#define ERR_NOT_INIT                    -11403
#define ERR_AUTH_DATA_PARSING_ERROR     -11006
#define ERR_AUTH_RETURN_NULL            -11007
#define ERR_SERVER_LIST_NULL            -11010
#define ERR_MANAGER_SERVER_CONNECT_FAIL -11008
#define ERR_MANAGER_SERVER_AUTH_FAIL    -11009
#define ERR_SAM_90_CMD_ERROR            -11310
#define ERR_SAM_90_STATUS_ERROR         -11311
#define ERR_SAM_90_RETURN_NULL          -11012
#define ERR_READER_A4_RETURN_NULL       -11113
#define ERR_READER_A4_CMD_ERROR         -11114
#define ERR_READER_A4_STATUS_ERROR      -11115
#define ERR_SAM_A4_CMD_ERROR            -11316
#define ERR_SAM_A4_STATUS_ERROR         -11317
#define ERR_SAM_A4_RETURN_NULL          -11018
#define ERR_READER_A5_RETURN_NULL       -11119
#define ERR_READER_A5_CMD_ERROR         -11120
#define ERR_READER_A5_STATUS_ERROR      -11121
#define ERR_SAM_A5_CMD_ERROR            -11322
#define ERR_SAM_A5_STATUS_ERROR         -11323
#define ERR_SAM_A5_RETURN_NULL          -11024
#define ERR_READER_93_RETURN_NULL       -11131
#define ERR_READER_93_CMD_ERROR         -11132
#define ERR_READER_93_STATUS_ERROR      -11133
#define ERR_READ_IDCARD_TIMEOUT         -10501
#define ERR_SAM_DELAY_100_MS            -11128
#define ERR_DECRYPT_DATA_ERROR          -11331

@protocol btReaderDriverDelegate;


@interface BTReaderDriver : NSObject<btreaderDelegate>
@property (strong, nonatomic) id<btReaderDriverDelegate> delegate;
-(id)initWithServer:(NSString*)server port:(int)port account:(NSString *)account password:(NSString *)password;
-(int)openReader:(CBPeripheral *)curdevice;
-(int)openReader:(CBPeripheral *)curdevice withManager:(CBCentralManager*)cbManager;
-(void)closeReader;
-(int)readid:(NSString *)ip port:(int)port token:(NSString *)tokenStr sn:(NSString *)sn body:(NSDictionary *)body auth:(NSDictionary *)authParam;
-(int)getSerialNum:(uint8_t*)serialNum length:(int*)serlen;
-(int)cardPoweron:(uint8_t*)atr length:(int*)atrlen;
-(int)cardTransmit:(uint8_t*)apdu apdulen:(int)apdulen response:(uint8_t*)response reslen:(int*)reslen;
-(int)getVersion:(uint8_t*)ver length:(int*)verlen;
-(int)getSamService;
-(void)startScanReader;
-(void)stopScanReader;
-(int)uploadLog:(NSString *)dateStr;
-(NSArray *)getServerList;
-(long)getServiceDelay:(NSString *)ip port:(int)port;
-(BOOL)setBusinessData:(NSString *)dataStr;
-(BOOL)isReaderConnected;
-(void)setPassword:(NSData *)password;
- (NSString *)getSn;
- (NSString *)getVer;
- (NSString *)getFactory;
//- (NSString *)getModel;
- (NSString *)getProductDate;
- (float)getVoltage;
- (NSString *)readerStatus;
- (NSString *)getCertInfo:(NSData **)info dn:(NSString **)dn;
- (int)readSAMCert:(NSString *)sn dn:(NSString **)dn certInfo:(NSString **)certInfo photo:(NSData **)photo;
- (int)checkIdCard;
-(void)setDesKey:(NSString *)key;
-(void)setSdkVersion:(NSString *)version;
/*
 设置和读头通信的协议
 */
-(void)setReaderMode:(BOOL)isSunriseReader;
/*
 获取通过管控检测到的延迟最低的服务器
 */
- (NSString *)getFastestSamServer;
- (void)enableAutoServer:(BOOL)enable;
- (NSString *)getReaderCode;

-(void)setDesKey:(NSString *)key;

@end

@protocol btReaderDriverDelegate <NSObject>

@required

//-(void)readerConnected;
//-(void)readerDisConnected;
//-(void)updateReaderName:(NSString*)name;
-(void)idInfo:(NSString*)idStr;
-(void)idPhoto:(NSData*)image;
-(void)idRespon:(NSData*)data;
-(void)readerState:(int)state;
-(void)didGetDeviceList:(NSArray *)devices;
-(void)samDelay:(long)delay;
-(void)idXML3DesStr:(NSString *)str;
-(void)idMobileJsonStr:(NSString *)str;
-(void)idMSGJsonStr:(NSString *)str;
-(void)BTBluetoothBack:(NSString *)time;
-(void)BTNetworkBack:(NSString *)time;
-(void)idoriginal:(NSData *)data;
-(void)idInfoSrcData:(uint8_t *)data dataLen:(uint16_t)dataLen;
@end
