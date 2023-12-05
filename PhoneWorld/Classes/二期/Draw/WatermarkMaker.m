//
//  WatermarkMaker.m
//  PhoneWorld
//
//  Created by fym on 2018/8/10.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WatermarkMaker.h"
#import "TimeUtil.h"

@implementation WatermarkMaker

+(UIImage *)watermarkImageForImage:(UIImage *)image{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode=NSLineBreakByCharWrapping;
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius=5;
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"话机实名认证专用\n%@\n%@",[[TimeUtil getInstance] dateStringFromSecondFull:[[TimeUtil getInstance] currentSecond] separator:@"-"],[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.4],NSShadowAttributeName:shadow}];
    CGSize textSize= [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    
    UIGraphicsBeginImageContext(CGSizeMake(textSize.width, textSize.height));
    
    
    [str drawInRect:CGRectMake(0, 0, textSize.width, textSize.height)];
    
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize size=image.size;
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    
    float width=image.size.width;
    if (size.width>size.height) {
        width=image.size.height;
    }
    
    float ratio=2.8;
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM (context,0,width/ratio*sqrtf(3.0));
    CGContextRotateCTM (context, M_PI_2/3*10);
    //    CGContextTranslateCTM (context,size.width*(1-sqrtf(2.0))/2,size.height*(1-sqrtf(2.0))/2);
    
    [textImage drawInRect:CGRectMake(0, 0, width/(ratio/2), width*textSize.height/textSize.width/(ratio/2))];
    //    [textImage drawInRect:CGRectMake((image.size.width-width)/2, (image.size.height-width*textSize.height/textSize.width)/2, width, width*textSize.height/textSize.width)];
    
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkImage;
}


+(UIImage *)otherStyleWatermarkImageForImage:(UIImage *)image{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"话机实名认证专用\n%@\n%@",[[TimeUtil getInstance] dateStringFromSecondFull:[[TimeUtil getInstance] currentSecond] separator:@"-"],[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.4]/*,NSShadowAttributeName:shadow*/}];
    CGSize textSize= [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;


    UIGraphicsBeginImageContext(CGSizeMake(textSize.width, textSize.height));

    CGSize size=image.size;
    float width=image.size.width;
    if (size.width>size.height) {
        width=image.size.height;
    }

    [str drawInRect:CGRectMake(0, 0, textSize.width, textSize.height)];
    float ratio=3.8;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM (context,0,width/ratio*sqrtf(3.0));

    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [textImage drawInRect:CGRectMake((image.size.width-(width/(ratio/2)))/2, image.size.height-width*textSize.height/textSize.width, width/(ratio/2), width*textSize.height/textSize.width/(ratio/2))];


    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkImage;

}

@end
