//
//  STReadWriteCardTool.h
//  PhoneWorld
//
//  Created by sheshe on 2024/1/23.
//  Copyright © 2024 xiyoukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIDCardReader/STIDCardReader.h"
#import "BlueManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol STReadWriteCardToolDelegate <NSObject>

// 读ICCID，IMSI及发送APDU指令代理方法 - 返回信息的获取参照DEMO实例
- (void)STReadICCIDsuccessBack:(STIDReadCardInfo *)peripheral withData:(id)data;

- (void)STWriteCardResultBack:(STIDReadCardInfo*)peripheral withData:(id)data;

- (void)STFailedBack:(STMyPeripheral *)peripheral withError:(NSError *)error;

@end

@interface STReadWriteCardTool : NSObject<STIDCardReaderDelegate, BlueManagerDelegate>

@property (nonatomic, weak) id<STReadWriteCardToolDelegate> stReadWriteCardToolDelegate;

@property (nonatomic, strong) STMyPeripheral * stPeri;

- (void)initSTReader;
- (void)deinitSTReader;
- (void)STConnectedDevicesForPeripheral:(STMyPeripheral *)peri;
///写卡
- (void)STWriteCardWithSimCard:(NSString *)sim andSMSNO:(NSString *)no;

@end

NS_ASSUME_NONNULL_END
