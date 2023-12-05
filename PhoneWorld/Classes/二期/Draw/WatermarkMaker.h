//
//  WatermarkMaker.h
//  PhoneWorld
//
//  Created by fym on 2018/8/10.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatermarkMaker : NSObject

+(UIImage *)watermarkImageForImage:(UIImage *)image;
+(UIImage *)otherStyleWatermarkImageForImage:(UIImage *)image;

@end
