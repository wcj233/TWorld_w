//
//  DataPackage.h
//  BTReader
//
//  Created by BlueElf on 15/7/8.
//  Copyright (c) 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataPackage : NSObject{
    NSData *datas;
    uint8_t cmd;
    uint8_t status;
    uint8_t crc;
    int dataslen;
}

@property(nonatomic,retain) NSData *datas;
@property(nonatomic,assign) uint8_t cmd;
@property(nonatomic,assign) uint8_t status;
@property(nonatomic,assign) uint8_t crc;
@property(nonatomic,assign) int dataslen;

-(NSData *)getAllDatas;
-(uint8_t)calCRC;

@end
