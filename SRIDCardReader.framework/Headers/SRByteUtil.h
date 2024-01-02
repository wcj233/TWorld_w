//
//  ByteUtil.h
//  BTReader
//
//  Created by TZ on 15/10/13.
//  Copyright © 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRByteUtil : NSObject

/**
 功能：将长度为4的字节数组转成整型
 参数：字节数组，是否高位在前
 结果：转换的整型
 */
+(int)bytesToInt:(Byte *)bytes hight:(BOOL)highFirst;

/**
 功能：将整型变量转换成长度为4的自己数组，
 参数：要转换的整型变量，转换结果是否高位在前
 结果：转换结果字节数组
 */
+(void)intToBytes:(int)n highFirst:(BOOL)highFirst respon:(Byte *)b;

@end
