//
//  BaseViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    self.view.backgroundColor = COLOR_BACKGROUND;
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*显示菊花图*/
-(void)showWaitView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:true];
    });
}

/*隐藏菊花图*/
-(void)hideWaitView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:true];
    });
}
/*展示返回的错误信息*/
- (void)showWarningText:(id)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *mes = [NSString stringWithFormat:@"%@",text];
        [Utils toastview:mes];
    });
}

/*解析得到的网络数据*/
- (void)analysisWithObj:(id)obj andSuccess:(void(^)(id obj))successCallBack andFailed:(void(^)())failedCallBack{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        NSString *code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        if ([code isEqualToString:@"10000"]) {
            successCallBack(obj);
        }else {
            failedCallBack();
            [self showWarningText:obj[@"mes"]];
        }
    }else{
        failedCallBack();
    }
}

- (void)dealloc {
    NSLog(@"=====VC成功被释放=====");
}

@end
