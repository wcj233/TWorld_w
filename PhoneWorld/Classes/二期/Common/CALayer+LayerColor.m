//
//  CALayer+LayerColor.m
//  Carpenter
//
//  Created by fym on 2017/6/28.
//  Copyright © 2017年 fym. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color{
    self.borderColor = color.CGColor;
}

-(void)setShadowColorFromUIColor:(UIColor *)color{
    self.shadowColor=color.CGColor;
}
@end
