//
//  CALayer+LayerColor.h
//  Carpenter
//
//  Created by fym on 2017/6/28.
//  Copyright © 2017年 fym. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (LayerColor)


- (void)setBorderColorFromUIColor:(UIColor *)color;
- (void)setShadowColorFromUIColor:(UIColor *)color;


@end
