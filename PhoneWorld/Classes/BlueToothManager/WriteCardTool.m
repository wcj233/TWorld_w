//
//  WriteCardTool.m
//  PhoneWorld
//
//  Created by 黄振元 on 2020/11/20.
//  Copyright © 2020 xiyoukeji. All rights reserved.
//

#import "WriteCardTool.h"
// 白色读卡器
#import "BLEGcouple.h"

@implementation WriteCardTool

//+ (void)writeCardActionWithBle:(BLEGcouple *)ble apduImsi:(NSString *)apduImsi smscent:(NSString *)smscent {
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^(){
//        // [ble transmit] 一定要在子线程中执行，才不会超时
//        NSString *responseWrite = [ble transmit:apduImsi];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (![responseWrite isEqualToString:@"9000"]) {
//                [self hideWaitView];
//                [Utils toastview:@"写卡失败"];
//                return;
//            }
//
//            //短信中心号写进去
//            smscent = [Utils getSwapSmscent:smscent];
//
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^(){
//                NSString *response1 = [ble transmit:@"002000010831323334FFFFFFFF"];
//                NSString *response2 = [ble transmit:@"A0A40000023F00"];
//                NSString *response3 = [ble transmit:@"A0A40000027FF0"];
//                NSString *response4 = [ble transmit:@"A0A40000026F42"];
//
//                NSLog(@"本地打印response:\n%@\n%@\n%@\n%@",response1,response2,response3,response4);
//
//                smscent = [NSString stringWithFormat:@"A0DC010428FFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFFFFF%@FFFFFFFFFFFF",smscent];
//                NSString *response5 = [ble transmit:smscent];
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (![response5 isEqualToString:@"9000"]) {
//                        [self resultWriteCardResultsForResult:@"1" imsi:imsi iccid:blockIccid];
//                    }else{
//                        [self resultWriteCardResultsForResult:@"0" imsi:imsi iccid:blockIccid];
//                    }
//                });
//
//            });
//        });
//    });
//}

@end
