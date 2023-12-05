//
//  btreader.h
//  btreader
//
//  Created by Chenfan on 3/21/16.
//  Copyright © 2016 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol btReaderDelegate;
@interface btreader : NSObject ;
@property (assign) id<btReaderDelegate> delegate;


- (BOOL)connectBt:(CBPeripheral*)bt usingCBManager:(CBCentralManager*)cbmanager;
- (BOOL)disconnectBt;
- (int)cardPoweron:(uint8_t *)atr length:(int *)atrlen;
- (int)cardTransmit:(uint8_t *)apdu apdulen:(int)apdulen response:(uint8_t *)response reslen:(int *)reslen;
- (int)openid:(uint8_t *)res response_len:(uint16_t *)reslen;
- (int)closeid:(uint8_t *)res response_len:(uint16_t *)reslen;
- (int)authid:(uint8_t *)cmd_para para_len:(uint16_t)para_len response:(uint8_t *)res response_len:(uint16_t *)reslen;
- (int)readinfo:(uint8_t *)cmdpara  para_len:(uint16_t)paralen response:(uint8_t *)res response_len:(uint16_t *)reslen;
- (int)getSerialNum:(uint8_t *)serialNum length:(int*)serlen;
- (void)refreshDeviceList:(int)times;
- (int)getVersion:(uint8_t*)ver length:(int*)verlen;
-(void)disconnectBt:(CBPeripheral*)bt;

//20160926新增电信协议相关接口
typedef struct __devinfo{
    char mfrs[5];
    char hVer[8];
    char model[7];
    char sn[25];
    char Product_date[9];
    char auth_str[24];
}devInfo;

-(int) read_cmcc0:(devInfo*) info;
-(int) read_cmcc0:(devInfo*) info response:(uint8_t*) response reslen:(uint16_t*)response_len;
-(int) read_cmcc1:(uint8_t*) sendbuf len:(uint16_t*) sendlen;
-(int)read_cmcc2:(uint8_t*)inbuf inlen:(uint16_t) inlen outbuf:(uint8_t*) outbuf outlen:(uint16_t*)outlen;
-(int) read_cmcc3:(uint8_t*) inbuf inlen:(uint16_t) inlen outbuf:(uint8_t*) outbuf outlen:(uint16_t*)outlen;
-(int)send_cmd_to_reader:(uint8_t*)para para_len:(uint16_t)len response:(uint8_t*)res response_len:(uint16_t*)reslen;
-(int) close_cmcc_reader;
-(void)setKaier:(bool) flag;
-(int) setKey:(uint8_t*)inbuf;
-(void)setBeep;

@end

@protocol btreaderDelegate <NSObject>

@required
- (void)didUpdatePeripheralList:(NSArray *)peripherals;
- (void)didConnected;

@end
