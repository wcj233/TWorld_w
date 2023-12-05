//
//  SignBoxViewController.h
//  SignDemo
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SignBoxCallBackBlock)(UIImage *image);

@interface SignBoxViewController : UIViewController

-(void)setCompletionBlock:(SignBoxCallBackBlock)completionBlock;

@end
