//
//  BaseViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/*显示菊花图*/
- (void)showWaitView;
/*隐藏菊花图*/
- (void)hideWaitView;
/*展示返回的错误信息*/
- (void)showWarningText:(id)text;
/*解析得到的网络数据*/
- (void)analysisWithObj:(id)obj andSuccess:(void(^)(id obj))successCallBack andFailed:(void(^)())failedCallBack;

@end
