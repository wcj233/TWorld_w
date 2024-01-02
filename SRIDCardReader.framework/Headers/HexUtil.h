//
//  HexUtil.h
//  BTReader
//
//  Created by TZ on 15/10/13.
//  Copyright © 2015年 sunrise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexUtil : NSObject

/**
 功能：将16进制字符串转换成字节数组
 参数：16进制字符串
 结果：结果字节数组生成的NSData
 */
+(NSData*)hexStringToByte:(NSString*)string;


/**
 功能：字节数组转16进制字符串
 参数：字节数组 长度
 结果：16进制字符串
 */
+ (NSString *)bytesToHexString:(uint8_t *)bytes offset:(int)offset length:(int)length;


/**
 功能：十六进制字符串转NSData
 参数：十六进制字符串
 结果：转换结果
 */
+ (NSData *)convertHexStrToData:(NSString *)string;

/**
功能：byte转十六进制字符串
参数：字节数组   长度
结果：转换结果 十六进制字符串
*/
+ (NSString *)hexStringFromByte:(uint8_t*)byte length:(int)length;

@end
