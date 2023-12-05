//
//  BaseWebUtils.m
//  LivePlay
//
//  Created by 刘岑颖 on 16/9/16.
//  Copyright © 2016年 刘岑颖. All rights reserved.
//

#import "BaseWebUtils.h"
#import <AFHTTPSessionManager.h>
#import "Utils.h"
#import "LoginNaviViewController.h"
#import "FailedView.h"

#define app_key @"2370E0E98942B9A1"
#define app_pwd @"205304643532A79F"
#define app_keyMD5 [Utils md5String:app_key]

#import "LoginNewViewController.h"

//睁大狗眼看清楚了，区别在于端口号！！！！！！8080正式！！！！！！！8088测试！！！！！！
//http://121.46.26.224:8088/newagency/AgencyInterface/测试  224:8080正式

@implementation BaseWebUtils

//专为图片
+ (void)postImageRequestWithParamters:(NSDictionary  *)paramtersDic
                 finshedBlock:(WebUtilsCallBack1)block
{
    NSString *path = [NSString stringWithFormat:@"%@/agency_pictureUpload",mainPath];
    NSURL * url = [NSURL URLWithString:path];
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramestr = [[NSMutableString alloc]init];

    if (paramtersDic != nil) {
        [paramestr appendFormat:@"\"app_key\":\"%@\"",[paramtersDic objectForKey:@"app_key"]];
        [paramestr appendFormat:@",\"app_sign\":\"%@\"",[paramtersDic objectForKey:@"app_sign"]];
        [paramestr appendFormat:@",\"version\":\"4.9.3\""];
        
        NSString *string = [Utils MydictionaryToJSON:[paramtersDic objectForKey:@"parameter"]];
        [paramestr appendFormat:@",\"parameter\":%@",string];
        
        NSString *photoString = [Utils MydictionaryToJSON:[paramtersDic objectForKey:@"photo"]];
        [paramestr appendFormat:@",\"photo\":%@",photoString];
    }
    NSString * params = [NSString stringWithFormat:@"{%@}",paramestr];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //6.根据会话对象创建一个Task(发送请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //8.解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict[@"code"]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                if ([code isEqualToString:@"30001"]) {
                    
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:dict[@"mes"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        LoginNaviViewController *naviVC = [[LoginNaviViewController alloc] initWithRootViewController:[[LoginNewViewController alloc] init]];
                        
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:^{
                        }];
                    }];
                    
                    [ac addAction:action1];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
                    
                }else if([code isEqualToString:@"39999"]){
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utils toastview:@"登录信息失效，请重新登录！"];
                    });
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud removeObjectForKey:@"username"];
                    [ud removeObjectForKey:@"password"];
                    [ud removeObjectForKey:@"session_token"];
                    [ud removeObjectForKey:@"grade"];
                    [ud removeObjectForKey:@"hasPayPassword"];
                    [ud synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LoginNaviViewController *naviVC = [[LoginNaviViewController alloc] initWithRootViewController:[[LoginNewViewController alloc] init]];
                        
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:^{
                        }];
                    });
                    
                    
                }else{
                    block(dict);
                }
            }
        }else{
            block(error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils toastview:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            });
        }
    }];
    //7.执行任务
    [dataTask resume];
}

/**
 * 同步请求数据  暂时只在注册中用过
 */
+ (void)postSynRequestWithURL:(NSString *)urlStr
                    paramters:(NSDictionary  *)paramtersDic
                 finshedBlock:(WebUtilsCallBack1)block
{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",mainPath,urlStr];
    
    NSURL * url = [NSURL URLWithString:path];
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramestr = [[NSMutableString alloc]init];
    
    if (paramtersDic != nil) {
        [paramestr appendFormat:@"\"app_key\":\"%@\"",[paramtersDic objectForKey:@"app_key"]];
        [paramestr appendFormat:@",\"app_sign\":\"%@\"",[paramtersDic objectForKey:@"app_sign"]];
        [paramestr appendFormat:@",\"version\":\"4.9.3\""];

        
        NSString *string = [Utils MydictionaryToJSON:[paramtersDic objectForKey:@"parameter"]];
        
        [paramestr appendFormat:@",\"parameter\":%@",string];
        
    }
    NSString * params = [NSString stringWithFormat:@"{%@}",paramestr];
        
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //6.根据会话对象创建一个Task(发送请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //8.解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (dict[@"code"]) {
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                if ([code isEqualToString:@"30001"]) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:dict[@"mes"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LoginNewViewController alloc] init] animated:YES completion:nil];
                    }];
                    
                    [ac addAction:action1];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
                }else if([code isEqualToString:@"39999"]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utils toastview:@"登录信息失效，请重新登录！"];
                    });
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud removeObjectForKey:@"username"];
                    [ud removeObjectForKey:@"password"];
                    [ud removeObjectForKey:@"session_token"];
                    [ud removeObjectForKey:@"grade"];
                    [ud removeObjectForKey:@"hasPayPassword"];
                    [ud synchronize];
                    
                    LoginNaviViewController *naviVC = [[LoginNaviViewController alloc] initWithRootViewController:[[LoginNewViewController alloc] init]];
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:^{
                    }];
                    
                }else{
                    block(dict);
                }
            }
        }else{
            block(error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils toastview:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            });
        }
    }];
    //7.执行任务
    [dataTask resume];
}

+ (void)postRequestWithURL:(NSString *)urlStr paramters:(NSDictionary  *)paramtersDic finshedBlock:(WebUtilsCallBack1)block{
    
    NSString *paramsString = [Utils MydictionaryToJSON:paramtersDic];
    
    NSString *app_sign = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,paramsString,app_pwd]];
    
    NSMutableDictionary *sendParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign,@"version":@"4.9.3",@"parameter":paramtersDic} mutableCopy];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",mainPath,urlStr];
    
    NSURL * url = [NSURL URLWithString:path];
    
    NSLog(@"请求url：%@", path);
    
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSMutableString *paramestr = [[NSMutableString alloc]init];
    
    if (sendParams != nil) {        
        
        [paramestr appendFormat:@"\"app_key\":\"%@\"",[sendParams objectForKey:@"app_key"]];
        [paramestr appendFormat:@",\"app_sign\":\"%@\"",[sendParams objectForKey:@"app_sign"]];
        [paramestr appendFormat:@",\"version\":\"%@\"",[sendParams objectForKey:@"version"]];
        
        NSString *string = [Utils MydictionaryToJSON:[sendParams objectForKey:@"parameter"]];

        [paramestr appendFormat:@",\"parameter\":%@",string];
        
    }
    NSString *params = [NSString stringWithFormat:@"{%@}",paramestr];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //6.根据会话对象创建一个Task(发送请求
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //8.解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"返回数据：%@", dict);
            
            if (dict[@"code"]) {
                NSString *code = [NSString stringWithFormat:@"%@",dict[@"code"]];
                NSString *mes = [NSString stringWithFormat:@"%@", dict[@"mes"]];
                if ([code isEqualToString:@"30001"] && [mes isEqualToString:@"版本号不正确，请下载最新版本！"]) {
                    //版本号不正确
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
                            if ([subView isKindOfClass:[FailedView class]]) {
                                [subView removeFromSuperview];
                            }
                        }
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:dict[@"mes"] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[LoginNewViewController alloc] init] animated:YES completion:nil];
                        }];
                        
                        [ac addAction:action1];
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
                    });
                    NSLog(@"NETWORK ==== ERROR:code: %@, mes:%@ =====", code, mes);
                    
                }else if([code isEqualToString:@"39999"]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
                            if ([subView isKindOfClass:[FailedView class]]) {
                                [subView removeFromSuperview];
                            }
                        }
                        [Utils toastview:@"登录信息失效，请重新登录！"];
                        NSLog(@"NETWORK ==== ERROR:code: %@, mes:%@ =====", code, mes);
                    });
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud removeObjectForKey:@"username"];
                    [ud removeObjectForKey:@"password"];
                    [ud removeObjectForKey:@"session_token"];
                    [ud removeObjectForKey:@"grade"];
                    [ud removeObjectForKey:@"hasPayPassword"];
                    [ud synchronize];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
                        keyWindow.rootViewController = [[LoginNaviViewController alloc] initWithRootViewController:LoginNewViewController.new];
                    });
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(dict);
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(error);
                });
            }
        }else{
            block(error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utils toastview:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            });
        }
    }];
    //7.执行任务
    [dataTask resume];
}

@end
