//
//  BTReader.h
//  BTReader
//
//  Created by BlueElf on 15/7/7.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "btreader.h"

#define ERR_NO_READER -1
#define ERR_READER_BUSY -2
#define ERR_NET_ERROR -3
#define ERR_NO_ID -4
#define ERR_SAM_ERROR -5
#define ERR_READER_ERROR -6
#define ERR_AGAIN -7
#define ERR_READER_OPENID -8
#define ERR_NET_CONNECT -9
#define ERR_NET_NOSERVER -10
#define ERR_NET_AUTHFAIL -11
#define ERR_READER_INVALIDSN -12

#define SUCCESS_MANAGER 0
#define ERR_MANAGER_CONNECT -1
#define ERR_MANAGER_AUTH -2
#define ERR_MANAGER_NOSERVICE -3
#define ERR_MANAGER_SN -4

#define CMD_OPENID  0x90
#define CMD_INT_AUTHID  0xa4
#define CMD_EXT_AUTHID  0xa5
#define CMD_ID_RESPON   0xf2
#define CMD_ID_TELECOM_RESPON   0Xf3
#define CMD_ID_MOBILE_RESPON   0xf4

#define READER_STATE_UNKNOWN  -1
#define STATE_READER_NONE 0
#define STATE_READER_START 1
#define STATE_READER_CONNECTING 3
#define STATE_READER_CONNECTED 2

#define DRIVER_VERSION 3.8

@protocol btReaderDriverDelegate;


@interface BTReaderDriver : NSObject<btreaderDelegate>
@property (strong, nonatomic) id<btReaderDriverDelegate> delegate;
-(id)initWithServer:(NSString*)server port:(int)port account:(NSString *)account password:(NSString *)password key:(NSData *)key;
-(int)openReader:(CBPeripheral *)curdevice;
-(int)openReader:(CBPeripheral *)curdevice withManager:(CBCentralManager*)cbManager;
-(void)closeReader;
-(int)readid;
-(int)readid:(NSString *)ip port:(int)port retry:(int)retry_count sn:(NSString *)sn;
-(int)readid:(NSString *)ip port:(int)port token:(NSString *)token redisServer:(NSString *)redisServer sn:(NSString *)sn crmSn:(NSString *)crmSn;
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
- (NSString *)getSn;
- (NSString *)getVer;
- (NSString *)getFactory;
- (NSString *)getModel;
- (NSString *)getProductDate;
- (float)getVoltage;
/*
 设置和读头通信的协议
 */
-(void)setReaderMode:(BOOL)isSunriseReader;
/*
 获取通过管控检测到的延迟最低的服务器
 */
- (NSDictionary *)getFastestSamServer;
- (void)enableAutoServer:(BOOL)enable;
- (void)isDecrypt:(BOOL)decrypt;
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
-(void)connectServer:(NSString *)str;
@end
