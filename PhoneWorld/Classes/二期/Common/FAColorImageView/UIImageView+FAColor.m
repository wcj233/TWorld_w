//
//  UIImageView+FAColor.m
//  WEART
//
//  Created by fym on 2018/4/18.
//  Copyright © 2018年 fym. All rights reserved.
//

#import "UIImageView+FAColor.h"

@implementation UIImageView (FAColor)

-(UIColor *)imageColor{
    return self.tintColor;
}

-(void)setImageColor:(UIColor *)imageColor{
    self.tintColor=nil;
    self.tintColor=imageColor;
}

@end
