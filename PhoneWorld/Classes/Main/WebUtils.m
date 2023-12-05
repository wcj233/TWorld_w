//
//  WebUtils.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/31.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "WebUtils.h"
#import "BaseWebUtils.h"
#import "Utils.h"


#define app_key @"2370E0E98942B9A1"
#define app_pwd @"205304643532A79F"
#define app_keyMD5 [Utils md5String:app_key]

#define topPhoneNumber @"/agency_recharge" //手机号充值
#define homeScrollPicture @"/agency_Carousel" //首页轮播图
#define sendCaptcha @"/agency_sendCaptcha"//发送短信验证码
#define checkCaptcha @"/agency_verifyCaptcha" //验证短信验证码是否正确
#define numberSegment @"/agency_numberSegment" //验证手机号是否为话机世界所拥有的手机号
#define sendSuggest @"/agency_feedback"  //发送意见反馈
#define pukCheck @"/agency_check"  //成卡开户——puk码验证
#define packageGet @"/agency_promotion" //成卡开户——根据套餐id得到活动包
#define whiteNumberPool @"/agency_whiteNumberPool"  //返回白卡开户号码池
#define randomNumbers @"/agency_randomNumber"  //根据号码池id和靓号规则返回随机号码
#define messageList @"/agency_NoticeList"//消息列表
#define messageDetail @"/agency_getNotice"  //消息具体内容
#define orderListInquiry @"/agency_orderList"//成卡开户／白卡开户查询
#define cardTransferList @"/agency_cardTransferList" //过户补卡查询
#define rechargeList @"/agency_rechargeList" //充值列表
#define openOrderInfo @"/agency_openOrderInfo"//开户详情
#define openEOrderInfo @"/agency_openEOrderInfo"//白卡开户详情
#define transferOrderInfo @"/agency_transferOrderInfo"//过户详情
#define remakecardOrderInfo @"/agency_remakecardOrderInfo"  //补卡详情
#define balanceQuery @"/agency_balanceQuery" //账户余额查询
#define transferInfo @"/agency_transfer" //过户信息提交
#define repairInfo @"/agency_repairCard" //补卡信息提交
#define chooseScan @"/agency_cardOpenMode"

@implementation WebUtils

//点击次数
+ (void)requestWithTouchTimes{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int phoneRecharge = (int)[ud integerForKey:@"phoneRecharge"];//话费充值
    int accountRecharge = (int)[ud integerForKey:@"accountRecharge"];//账户充值
    int transform = (int)[ud integerForKey:@"transform"];//过户
    int renewOpen = (int)[ud integerForKey:@"renewOpen"];//成卡开户
    int newOpen = (int)[ud integerForKey:@"newOpen"];//白卡开户
    int replace = (int)[ud integerForKey:@"replace"];//补卡
    int phoneBanlance = (int)[ud integerForKey:@"phoneBanlance"];//话费余额查询
    int accountRecord = (int)[ud integerForKey:@"accountRecord"];//账户充值查询
    int cardQuery = (int)[ud integerForKey:@"cardQuery"];//过户补卡状态查询
    int orderQueryRenew = (int)[ud integerForKey:@"orderQueryRenew"];//订单查询成卡开户
    int orderQueryNew = (int)[ud integerForKey:@"orderQueryNew"];//订单查询白卡开户
    int orderQueryTransform = (int)[ud integerForKey:@"orderQueryTransform"];//订单查询过户
    int orderQueryReplace = (int)[ud integerForKey:@"orderQueryReplace"];//订单查询补卡
    int orderQueryRecharge = (int)[ud integerForKey:@"orderQueryRecharge"];//订单查询话费充值
    int qdsList = (int)[ud integerForKey:@"qdsList"];//渠道商列表
    int qdsOrderList = (int)[ud integerForKey:@"qdsOrderList"];//渠道商订单列表
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (phoneRecharge > 0) {
        [params setObject:@(phoneRecharge) forKey:@"phoneRecharge"];
    }
    if (accountRecharge > 0) {
        [params setObject:@(accountRecharge) forKey:@"accountRecharge"];
    }
    if (transform > 0) {
        [params setObject:@(transform) forKey:@"transform"];
    }
    if (renewOpen > 0) {
        [params setObject:@(renewOpen) forKey:@"renewOpen"];
    }
    if (newOpen > 0) {
        [params setObject:@(newOpen) forKey:@"newOpen"];
    }
    if (replace > 0) {
        [params setObject:@(replace) forKey:@"replace"];
    }
    if (accountRecord > 0) {
        [params setObject:@(accountRecord) forKey:@"accountRecord"];
    }
    if (cardQuery > 0) {
        [params setObject:@(cardQuery) forKey:@"cardQuery"];
    }
    if (phoneBanlance > 0) {
        [params setObject:@(phoneBanlance) forKey:@"phoneBanlance"];
    }
    if (orderQueryRenew > 0) {
        [params setObject:@(orderQueryRenew) forKey:@"orderQueryRenew"];
    }
    if (orderQueryNew > 0) {
        [params setObject:@(orderQueryNew) forKey:@"orderQueryNew"];
    }
    if (orderQueryTransform > 0) {
        [params setObject:@(orderQueryTransform) forKey:@"orderQueryTransform"];
    }
    if (orderQueryReplace > 0) {
        [params setObject:@(orderQueryReplace) forKey:@"orderQueryReplace"];
    }
    if (orderQueryRecharge > 0) {
        [params setObject:@(orderQueryRecharge) forKey:@"orderQueryRecharge"];
    }
    if (qdsList > 0) {
        [params setObject:@(qdsList) forKey:@"qdsList"];
    }
    if (qdsOrderList > 0) {
        [params setObject:@(qdsOrderList) forKey:@"qdsOrderList"];
    }
    
    //一个都没有的话就不传了
    if (params.count > 0) {
        [BaseWebUtils postRequestWithURL:@"/agency_FunctionStatistics" paramters:params finshedBlock:^(id obj) {
        }];
    }
}

//佣金模块信息
+ (void)requestCommissionCountWithDate:(NSString *)date andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"date":date} mutableCopy];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_commissionsQuery" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//开户统计模块
+ (void)requestOpenCountWithDate:(NSString *)date andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"date":date} mutableCopy];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_statistic" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//号码充值（充值手机号）
+ (void)requestTopInfoWithNumber:(NSString *)phoneNumber andMoney:(NSString  *)money andPayPassword:(NSString *)payPassword andCallBack:(WebUtilsCallBack1)callBack{
    NSString *passwordMD5 = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",payPassword]];//得到md5加密过后密码
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"number":phoneNumber,@"money":money,@"pay_password":passwordMD5} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:topPhoneNumber paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//工号登记
+(void)requestSupplementWithUserName:(NSString *)username andTel:(NSString *)tel andEmail:(NSString *)email andCardId:(NSString *)cardId andAddress:(NSString *)address andWebUtilsCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];//得到parameter
    [params setObject:username forKey:@"contact"];
    [params setObject:tel forKey:@"tel"];
    [params setObject:email forKey:@"email"];
    [params setObject:address forKey:@"address"];
    [params setObject:cardId forKey:@"cardId"];
    [BaseWebUtils postRequestWithURL:@"/agency_dataSupplement" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//登录
+ (void)requestLoginResultWithUserName:(NSString *)username andPassword:(NSString *)password andWebUtilsCallBack:(WebUtilsCallBack1)callBack{
    
    NSMutableDictionary *params = [@{@"userName":username,@"password":password} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_login" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}
//登出
+ (void)requestLogoutResultWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_logout" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//注册
+ (void)requestRegisterResultWithRegisterModel:(RegisterModel *)registerModel andCallBack:(WebUtilsCallBack1)callBack{
    
    if (registerModel.photoOne == nil && registerModel.photoTwo == nil) {
        //如果没有图片，直接上传
        NSString *regString = [Utils MydictionaryToJSON:registerModel.regDic];
        
        regString = [regString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *app_sign = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,regString,app_pwd]];
        
        NSMutableDictionary *sendParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign,@"parameter":registerModel.regDic} mutableCopy];
        
        [BaseWebUtils postSynRequestWithURL:@"/agency_register" paramters:sendParams finshedBlock:^(id obj) {
            callBack(obj);
        }];
    }else{
        
        NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
        [imageParamsDic setObject:@"4" forKey:@"type"];
        
        NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
        photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
        
        NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
        
        NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
        
        if (![registerModel.photoOne isEqualToString:@"无"] && ![registerModel.photoTwo isEqualToString:@"无"]) {
            [photoDic setObject:registerModel.photoOne forKey:@"photo1"];
            [photoDic setObject:registerModel.photoTwo forKey:@"photo2"];
        }else if(![registerModel.photoOne isEqualToString:@"无"] && [registerModel.photoTwo isEqualToString:@"无"]){
            [photoDic setObject:registerModel.photoOne forKey:@"photo1"];
        }else if([registerModel.photoOne isEqualToString:@"无"] && ![registerModel.photoTwo isEqualToString:@"无"]){
            [photoDic setObject:registerModel.photoTwo forKey:@"photo1"];
        }
        [imageLoadParams setObject:photoDic forKey:@"photo"];
        
        [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
        
        [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    if (![registerModel.photoOne isEqualToString:@"无"] && ![registerModel.photoTwo isEqualToString:@"无"]) {
                        
                        [registerModel.regDic setObject:obj[@"data"][@"photo1"] forKey:@"photoOne"];
                        [registerModel.regDic setObject:obj[@"data"][@"photo2"] forKey:@"photoTwo"];
                        
                    }else if(![registerModel.photoOne isEqualToString:@"无"] && [registerModel.photoTwo isEqualToString:@"无"]){
                        
                        [registerModel.regDic setObject:obj[@"data"][@"photo1"] forKey:@"photoOne"];
                        
                    }else if([registerModel.photoOne isEqualToString:@"无"] && ![registerModel.photoTwo isEqualToString:@"无"]){
                        
                        [registerModel.regDic setObject:obj[@"data"][@"photo1"] forKey:@"photoTwo"];
                    }
                    
                    NSString *regString = [Utils MydictionaryToJSON:registerModel.regDic];
                    regString = [regString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSString *app_sign = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,regString,app_pwd]];
                    NSMutableDictionary *sendParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign,@"parameter":registerModel.regDic} mutableCopy];
                    [BaseWebUtils postSynRequestWithURL:@"/agency_register" paramters:sendParams finshedBlock:^(id obj) {
                        callBack(obj);
                    }];
                    
                }else{
                    callBack(obj);
                }
                
            }else{
                callBack(obj);
            }
            
        }];
    }
}

//登录密码修改
+ (void)requestAlterPasswordWithOldPassword:(NSString *)oldPassword andNewPassword:(NSString *)newPassword andCallBack:(WebUtilsCallBack1)callBack{
    
    NSString *oldPass = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",oldPassword]];
    NSString *newPass = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",newPassword]];
    
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"old_password":oldPass,@"new_password":newPass} mutableCopy];
    [BaseWebUtils postRequestWithURL:@"/agency_modifyPwd" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}
//忘记密码
+ (void)requestForgetPasswordWithTel:(NSString *)tel andCaptcha:(NSString *)captcha andPassword:(NSString *)password andCallBack:(WebUtilsCallBack1)callBack{
    
    NSString *passwordMD5 = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",password]];
    NSMutableDictionary *params = [@{@"userName":tel,@"captcha":captcha,@"password":passwordMD5} mutableCopy];
    [BaseWebUtils postRequestWithURL:@"/agency_forgetPwd" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//支付密码创建
+ (void)requestCreatePayPasswordWithPassword:(NSString *)password andCallBack:(WebUtilsCallBack1)callBack{
    NSString *passwordMD5 = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",password]];
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"password":passwordMD5} mutableCopy];
    [BaseWebUtils postRequestWithURL:@"/agency_user_pinCreate" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//支付密码修改
+ (void)requestAlterPayPasswordWithNewPassword:(NSString *)newPassword andOldPassword:(NSString *)oldPassword andCallBack:(WebUtilsCallBack1)callBack{
    
    NSString *oldPass = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",oldPassword]];
    NSString *newPass = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",newPassword]];
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"old_password":oldPass,@"new_password":newPass} mutableCopy];
    [BaseWebUtils postRequestWithURL:@"/agency_user_pinmodifyPwd" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//返回个人信息
+ (void)requestPersonalInfoWithSessionToken:(NSString *)sessionToken andUserName:(NSString *)username andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":sessionToken,@"userName":username} mutableCopy];
    [BaseWebUtils postRequestWithURL:@"/agency_information" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

+(void)requestChangePersonalInfoWithParamDic:(NSDictionary *)paramDic andCallBack:(WebUtilsCallBack1)callBack{
    [BaseWebUtils postRequestWithURL:@"/agency_upPersonal" paramters:paramDic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//返回首页轮播图
+ (void)requestHomeScrollPictureWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"parameter":@""} mutableCopy];
    [BaseWebUtils postRequestWithURL:homeScrollPicture paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//发送短信验证  根据不同type
+ (void)requestSendCaptchaWithType:(int)type andTel:(NSString *)tel andCallBack:(WebUtilsCallBack1)callBack{
    
    NSString *typeStr = [NSString stringWithFormat:@"%d",type];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (type == 5 || type == 6) {
        params = [@{@"session_token":[Utils getSessionToken],@"tel":tel} mutableCopy];//得到parameter
    }else{
        if (type == 2 || type == 1) {//注册和忘记号码需要手机号码
            params = [@{@"tel":tel} mutableCopy];//得到parameter
        }else{//3、4不需要手机号
            params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];//得到parameter
        }
    }
    [params setObject:typeStr forKey:@"captcha_type"];
    [BaseWebUtils postRequestWithURL:sendCaptcha paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//短信验证码验证
+ (void)requestCaptchaCheckWithCaptcha:(NSString *)captcha andType:(int)type andTel:(NSString *)tel andCallBack:(WebUtilsCallBack1)callBack{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (type == 5 || type == 6) {
        params = [@{@"session_token":[Utils getSessionToken],@"captcha":captcha,@"tel":tel,} mutableCopy];//得到parameter
    }else{
        if (type == 2 || type == 1) {
            params = [@{@"tel":tel,@"captcha":captcha} mutableCopy];//得到parameter
        }else{
            params = [@{@"session_token":[Utils getSessionToken],@"captcha":captcha} mutableCopy];//得到parameter
        }
    }
    [BaseWebUtils postRequestWithURL:checkCaptcha paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//验证号段信息 （验证手机号是否为话机世界所拥有的手机号）
+ (void)requestSegmentWithTel:(NSString *)tel andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"tel":tel} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:numberSegment paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//意见反馈
+ (void)requestSuggestWithContent:(NSString *)content andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"title":@"suggest",@"content":content} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:sendSuggest paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//成卡开户------------------
//成卡开户之puk码验证
+ (void)requestFinishedCardWithTel:(NSString *)tel andPUK:(NSString *)puk andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"tel":tel,@"puk":puk} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:pukCheck paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//成卡开户——根据套餐id的到活动包信息
+ (void)requestPackagesWithID:(NSString *)pid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"packageId":pid} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:packageGet paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//成卡开户——金额信息
+ (void)requestMoneyInfoWithPrestore:(NSString *)prestore andPromotionId:(NSString *)promotionId andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"prestore":prestore,@"promotionId":promotionId} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_money" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

/***成卡开户--分开传图片--四张照片***/
+ (void)uploadImagesWithDic:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"0" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];

    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"memo11"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo4"];
    
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
       
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
                
                [params setObject:obj[@"data"][@"photo1"] forKey:@"memo4"];
                [params setObject:obj[@"data"][@"photo2"] forKey:@"memo11"];
                [params setObject:obj[@"data"][@"photo3"] forKey:@"photoFront"];
                [params setObject:obj[@"data"][@"photo4"] forKey:@"photoBack"];
                
                callBack(params);
                
            }else{
                callBack(nil);
            }
            
        }else{
            callBack(nil);
        }
    }];
}

/***成卡开户--分开传图片--摄像照片***/
+ (void)uploadVideoImagesWithDic:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"0" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];

    if (dic[@"videoPhotos1"]) {
        [photoDic setObject:[dic objectForKey:@"videoPhotos1"] forKey:@"photo1"];
    }
    if (dic[@"videoPhotos2"]) {
        [photoDic setObject:[dic objectForKey:@"videoPhotos2"] forKey:@"photo2"];
    }
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
                
                [params setObject:obj[@"data"][@"photo1"] forKey:@"videoPhotos1"];
                [params setObject:obj[@"data"][@"photo2"] forKey:@"videoPhotos2"];
                
                callBack(params);
                
            }else{
                callBack(nil);
            }
            
        }else{
            callBack(nil);
        }
    }];
}

/***成卡开户--分开传图片--上传前面的四张图片+人像+协议+开户***/
+ (void)requestSetOpenWithFourImages:(NSDictionary *)fourImageDic andVideoDic:(NSDictionary *)videoDic andInfoDictionary:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack{
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"0" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoAgreement"] forKey:@"photo1"];
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
                [params setObject:[dic objectForKey:@"number"] forKey:@"number"];
                [params setObject:[dic objectForKey:@"authenticationType"] forKey:@"authenticationType"];
                [params setObject:[dic objectForKey:@"customerName"] forKey:@"customerName"];
                [params setObject:[dic objectForKey:@"certificatesType"] forKey:@"certificatesType"];
                [params setObject:[dic objectForKey:@"certificatesNo"] forKey:@"certificatesNo"];
                [params setObject:[dic objectForKey:@"address"] forKey:@"address"];
                if ([dic objectForKey:@"description"]) {
                    [params setObject:[dic objectForKey:@"description"] forKey:@"description"];
                }
                [params setObject:[dic objectForKey:@"cardType"] forKey:@"cardType"];
                [params setObject:[dic objectForKey:@"simId"] forKey:@"simId"];
                [params setObject:[dic objectForKey:@"simICCID"] forKey:@"simICCID"];
                
                [params setObject:[dic objectForKey:@"packageId"] forKey:@"packageId"];
                [params setObject:[dic objectForKey:@"promotionsId"] forKey:@"promotionsId"];
                [params setObject:[dic objectForKey:@"orderAmount"] forKey:@"orderAmount"];
                [params setObject:[dic objectForKey:@"org_number_poolsId"] forKey:@"org_number_poolsId"];
                
                [params setObject:obj[@"data"][@"photo1"] forKey:@"agreementFront"];
                
                [params setObject:videoDic[@"videoPhotos1"] forKey:@"videoPhotos1"];
                [params setObject:videoDic[@"videoPhotos2"] forKey:@"videoPhotos2"];
                
                [params setObject:fourImageDic[@"photoFront"] forKey:@"photoFront"];
                [params setObject:fourImageDic[@"photoBack"] forKey:@"photoBack"];
                [params setObject:fourImageDic[@"memo4"] forKey:@"memo4"];
                [params setObject:fourImageDic[@"memo11"] forKey:@"memo11"];
                
                
                [params setObject:[Utils getSessionToken] forKey:@"session_token"];
                [BaseWebUtils postRequestWithURL:@"/agency_setOpen" paramters:params finshedBlock:^(id obj) {
                    
                    callBack(obj);
                }];
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
    }];
    /*----------图片上传-------------*/
}


/***成卡开户--直接上传四张图片和协议***/
+ (void)requestSetOpenWithDictionary:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack{
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"0" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
//    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo3"];
//    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo2"];
//    [photoDic setObject:[dic objectForKey:@"photoThird"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"memo11"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo4"];
    [photoDic setObject:[dic objectForKey:@"photoAgreement"] forKey:@"photo5"];
//    if (dic[@"videoPhotos1"]) {
//        [photoDic setObject:[dic objectForKey:@"videoPhotos1"] forKey:@"photo5"];
//    }
//    if (dic[@"videoPhotos2"]) {
//        [photoDic setObject:[dic objectForKey:@"videoPhotos2"] forKey:@"photo6"];
//    }
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
                [params setObject:[dic objectForKey:@"number"] forKey:@"number"];
                [params setObject:[dic objectForKey:@"authenticationType"] forKey:@"authenticationType"];
                [params setObject:[dic objectForKey:@"customerName"] forKey:@"customerName"];
                [params setObject:[dic objectForKey:@"certificatesType"] forKey:@"certificatesType"];
                [params setObject:[dic objectForKey:@"certificatesNo"] forKey:@"certificatesNo"];
                [params setObject:[dic objectForKey:@"address"] forKey:@"address"];
                if ([dic objectForKey:@"description"]) {
                    [params setObject:[dic objectForKey:@"description"] forKey:@"description"];
                }
                [params setObject:[dic objectForKey:@"cardType"] forKey:@"cardType"];
                [params setObject:[dic objectForKey:@"simId"] forKey:@"simId"];
                [params setObject:[dic objectForKey:@"simICCID"] forKey:@"simICCID"];
                
                [params setObject:[dic objectForKey:@"packageId"] forKey:@"packageId"];
                [params setObject:[dic objectForKey:@"promotionsId"] forKey:@"promotionsId"];
                [params setObject:[dic objectForKey:@"orderAmount"] forKey:@"orderAmount"];
                [params setObject:[dic objectForKey:@"org_number_poolsId"] forKey:@"org_number_poolsId"];
                
//                [params setObject:obj[@"data"][@"photo1"] forKey:@"photoFront"];
//                [params setObject:obj[@"data"][@"photo2"] forKey:@"photoBack"];
//                [params setObject:obj[@"data"][@"photo3"] forKey:@"memo4"];
                
                [params setObject:obj[@"data"][@"photo1"] forKey:@"memo4"];
                [params setObject:obj[@"data"][@"photo2"] forKey:@"memo11"];
                [params setObject:obj[@"data"][@"photo3"] forKey:@"photoFront"];
                [params setObject:obj[@"data"][@"photo4"] forKey:@"photoBack"];
                
                [params setObject:obj[@"data"][@"photo5"] forKey:@"agreementFront"];
//                if (dic[@"videoPhotos1"]) {
//                    [params setObject:obj[@"data"][@"photo5"] forKey:@"videoPhotos1"];
//                }
//                if (dic[@"videoPhotos2"]) {
//                    [params setObject:obj[@"data"][@"photo6"] forKey:@"videoPhotos2"];
//                }
                
                
                [params setObject:[Utils getSessionToken] forKey:@"session_token"];
                [BaseWebUtils postRequestWithURL:@"/agency_setOpen" paramters:params finshedBlock:^(id obj) {
                    
                    callBack(obj);
                }];
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
    }];
    /*----------图片上传-------------*/
}

//白卡开户------------------
//白卡开户返回号码池
+ (void)requestWhiteCardPhoneNumbersWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:whiteNumberPool paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//根据号码池和靓号规则返回随机号码
+ (void)requestPhoneNumbersWithNumberPool:(int)pool andNumberType:(NSString *)type andCallBack:(WebUtilsCallBack1)callBack{
    NSString *poolStr = [NSString stringWithFormat:@"%d",pool];
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"numberpool":poolStr,@"numberType":type} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:randomNumbers paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//白卡开户——号码锁定
+ (void)requestLockNumberWithNumber:(NSString *)number andNumberpoolId:(NSString *)poolId andNumberType:(NSString *)numberType andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"number":number,@"numberpoolId":poolId,@"numberType":numberType} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_lockNumber" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//白卡开户——获取imsi信息
+ (void)requestImsiInfoWithNumber:(NSString *)number andICCID:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"number":number,@"iccid":iccid} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_imsi" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}
//白卡开户——写卡状态
+ (void)requestCardResultWithICCID:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"iccid":iccid} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_cardResults" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//白卡开户——预开户
+ (void)requestPreopenWithNumber:(NSString *)number andICCID:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"number":number,@"iccid":iccid} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_preopen" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//白卡开户
+ (void)requestOpenWhiteWithDictionary:(NSDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"0" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo2"];
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
                
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
#warning 白卡开户white-----图片字段没有
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
                [params setObject:[dic objectForKey:@"address"] forKey:@"address"];
                [params setObject:[dic objectForKey:@"cardType"] forKey:@"cardType"];
                [params setObject:[dic objectForKey:@"simId"] forKey:@"simId"];
                [params setObject:[dic objectForKey:@"certificatesType"] forKey:@"certificatesType"];
                [params setObject:[dic objectForKey:@"certificatesNo"] forKey:@"certificatesNo"];
                [params setObject:[dic objectForKey:@"iccid"] forKey:@"iccid"];
                [params setObject:[dic objectForKey:@"imsi"] forKey:@"imsi"];
                [params setObject:[dic objectForKey:@"customerName"] forKey:@"customerName"];
                [params setObject:[dic objectForKey:@"orderAmount"] forKey:@"orderAmount"];
                [params setObject:[dic objectForKey:@"number"] forKey:@"number"];
                [params setObject:[dic objectForKey:@"packageId"] forKey:@"packageId"];
                [params setObject:[dic objectForKey:@"promotionsId"] forKey:@"promotionsId"];
                [params setObject:[dic objectForKey:@"payAmount"] forKey:@"payAmount"];
                
                [params setObject:[Utils getSessionToken] forKey:@"session_token"];
                [BaseWebUtils postRequestWithURL:@"/agency_whiteSetOpen" paramters:params finshedBlock:^(id obj) {
                    if([Utils logoutAction:obj[@"code"]] == YES){
                        callBack(obj);
                    }
                    
                }];
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
        
        
    }];
    /*----------图片上传-------------*/
    
}

//白卡申请
+(void)requestApplyForOpenWhiteWithName:(NSString *)name andTel:(NSString *)tel andAddress:(NSString *)address andNum:(NSNumber *)num andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"name":name,@"tel":tel,@"deliveryAddress":address,@"applySum":num} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_getEcard" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//白卡申请订单列表
+(void)
requestOpenWhiteOrderListWithPage:(NSString *)page andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"linage":@"10",@"page":page} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_getEcardList" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

+(void)requestOpenWhiteApplyDetailWithCardId:(NSNumber *)cardId andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"id":cardId} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:@"/agency_getEcardNo" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//消息推送——消息列表
+ (void)requestMessageListWithLinage:(NSString *)linage andPage:(NSString *)page andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"linage":linage,@"page":page,@"type":@"1"} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:messageList paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//消息推送——具体内容
+ (void)requestMessageDetailWithId:(NSString *)messageId andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"id":messageId} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:messageDetail paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//订单查询----------成卡／白卡开户查询--------------
+ (void)requestInquiryOrderListWithPhoneNumber:(NSString *)number andType:(NSString *)type andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andOrderStatusCode:(NSString *)orderStatusCode andOrderStatusName:(NSString *)orderStatusName andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack{
    
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];
    if (![number isEqualToString:@"无"]) {
        [params setObject:number forKey:@"number"];
    }
    if (![type isEqualToString:@""]) {
        [params setObject:type forKey:@"type"];
    }
    if (![startTime isEqualToString:@"无"]) {
        [params setObject:startTime forKey:@"startTime"];
    }
    if (![endTime isEqualToString:@"无"]) {
        [params setObject:endTime forKey:@"endTime"];
    }
    if (![orderStatusCode isEqualToString:@"无"]) {
        [params setObject:orderStatusCode forKey:@"orderStatusCode"];
    }
    
    [params setObject:page forKey:@"page"];
    [params setObject:linage forKey:@"linage"];
    
    [BaseWebUtils postRequestWithURL:orderListInquiry paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界二期------成卡开户列表/白卡开户列表
+ (void)requestCardOrderListWithSelectDictionary:(NSMutableDictionary *)selectDictionary andCallBack:(WebUtilsCallBack1)callBack{
    [selectDictionary setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:orderListInquiry paramters:selectDictionary finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界二期----------过户补卡列表
+ (void)requestTransferAndRepairCardOrderListWithSelectDictionary:(NSMutableDictionary *)selectDictionary andCallBack:(WebUtilsCallBack1)callBack{
    [selectDictionary setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:cardTransferList paramters:selectDictionary finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//  过户／补卡查询
+ (void)requestCardTransferListWithNumber:(NSString *)number andType:(NSString *)type andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andStartCode:(NSString *)startCode andStartName:(NSString *)startName andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack{
    
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];
    if (![number isEqualToString:@"无"]) {
        [params setObject:number forKey:@"number"];
    }
    if (![type isEqualToString:@"无"]) {
        [params setObject:type forKey:@"type"];
    }
    if (![startTime isEqualToString:@"无"]) {
        [params setObject:startTime forKey:@"startTime"];
    }
    if (![endTime isEqualToString:@"无"]) {
        [params setObject:endTime forKey:@"endTime"];
    }
    if (![startCode isEqualToString:@"无"]) {
        [params setObject:startCode forKey:@"startCode"];
    }
    if (![startName isEqualToString:@"无"]) {
        [params setObject:startName forKey:@"startName"];
    }
    [params setObject:page forKey:@"page"];
    [params setObject:linage forKey:@"linage"];
    
    [BaseWebUtils postRequestWithURL:cardTransferList paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//充值查询  删
+ (void)requestRechargeListWithNumber:(NSString *)number andRechargeType:(NSString *)rechargeType andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack{
    
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];
    if (![number isEqualToString:@"无"]) {
        [params setObject:number forKey:@"number"];
    }
    if (![rechargeType isEqualToString:@"无"]) {
        [params setObject:rechargeType forKey:@"rechargeType"];
    }
    if (![startTime isEqualToString:@"无"]) {
        [params setObject:startTime forKey:@"startTime"];
    }
    if (![endTime isEqualToString:@"无"]) {
        [params setObject:endTime forKey:@"endTime"];
    }
    
    [params setObject:page forKey:@"page"];
    [params setObject:linage forKey:@"linage"];
    
    [BaseWebUtils postRequestWithURL:rechargeList paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界二期 -----------------------   话费充值／账户充值订单查询
+ (void)requestTopListWithSelectDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:rechargeList paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//开户详情  (成卡开户)
+ (void)requestOrderDetailWithOrderNo:(NSString *)orderNo andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"orderNo":orderNo} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:openOrderInfo paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}
//开户详情  (白卡开户)
+ (void)requestEOrderDetailWithOrderNo:(NSString *)orderNo andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"orderNo":orderNo} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:openEOrderInfo paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//过户详情
+ (void)requestTransferDetailWithId:(NSString *)orderId andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"id":orderId} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:transferOrderInfo paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//根据订单编号得到----补卡详情
+ (void)requestCardTransferDetailWithId:(NSString *)cardId andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"id":cardId} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:remakecardOrderInfo paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//账户管理------------------------------
//账户余额查询
+ (void)requestAccountMoneyWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken]} mutableCopy];//得到parameter
    [BaseWebUtils postRequestWithURL:balanceQuery paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//账户充值－预订单（就是需要微信支付或者支付宝支付的）
+ (void)requestReAddRechargeRecordWithNumber:(NSString *)number andMoney:(NSString *)money andRechargeMethod:(NSString *)method andCallBack:(WebUtilsCallBack1)callBack{
    
    NSMutableDictionary *params = [@{@"session_token":[Utils getSessionToken],@"money":money,@"rechargeMethod":method} mutableCopy];//得到parameter
    if (![number isEqualToString:@"无"]) {
        [params setObject:number forKey:@"number"];
    }
    [BaseWebUtils postRequestWithURL:@"/agency_reAddRechargeRecord" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//卡片管理-------------------------------
/**新改的过户信息提交--多了个人像**/
+ (void)requestTransferInfoWithDic:(NSDictionary *)dic andVideoDic:(NSDictionary *)videoDic andCallBack:(WebUtilsCallBack1)callBack {
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"2" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoOne"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photoTwo"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"photoThree"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"photoFour"] forKey:@"photo4"];
    [photoDic setObject:[videoDic objectForKey:@"videoPhotos1"] forKey:@"photo5"];
    [photoDic setObject:[videoDic objectForKey:@"videoPhotos2"] forKey:@"photo6"];
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSMutableDictionary *params = [dic mutableCopy];//得到parameter
                [params setObject:obj[@"data"][@"photo1"] forKey:@"photoOne"];
                [params setObject:obj[@"data"][@"photo2"] forKey:@"photoTwo"];
                [params setObject:obj[@"data"][@"photo3"] forKey:@"photoThree"];
                [params setObject:obj[@"data"][@"photo4"] forKey:@"photoFour"];
                //视屏
                [params setObject:obj[@"data"][@"photo5"] forKey:@"memo2"];
                [params setObject:obj[@"data"][@"photo6"] forKey:@"memo3"];
                
                [params setObject:[Utils getSessionToken] forKey:@"session_token"];
                [BaseWebUtils postRequestWithURL:transferInfo paramters:params finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
        }else{
            callBack(obj);
        }
        
        
    }];
    /*----------图片上传-------------*/
}
//过户信息提交
+ (void)requestTransferInfoWithDic:(NSDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"2" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoOne"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photoTwo"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"photoThree"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"photoFour"] forKey:@"photo4"];
    
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSMutableDictionary *params = [dic mutableCopy];//得到parameter
                [params setObject:obj[@"data"][@"photo1"] forKey:@"photoOne"];
                [params setObject:obj[@"data"][@"photo2"] forKey:@"photoTwo"];
                [params setObject:obj[@"data"][@"photo3"] forKey:@"photoThree"];
                [params setObject:obj[@"data"][@"photo4"] forKey:@"photoFour"];
                
                [params setObject:[Utils getSessionToken] forKey:@"session_token"];
                [BaseWebUtils postRequestWithURL:transferInfo paramters:params finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
        }else{
            callBack(obj);
        }
        
        
    }];
    /*----------图片上传-------------*/
}

//补卡信息提交
+ (void)requestRepairInfoWithDic:(NSDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [imageParamsDic setObject:@"3" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photo"] forKey:@"photo1"];
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSMutableDictionary *params = [dic mutableCopy];//得到parameter
                
                [params setObject:obj[@"data"][@"photo1"] forKey:@"photo"];
                
                [params setObject:[Utils getSessionToken] forKey:@"session_token"];
                
                [BaseWebUtils postRequestWithURL:repairInfo paramters:params finshedBlock:^(id obj) {
                    callBack(obj);
                }];
            }else{
                callBack(obj);
            }
        }else{
            callBack(obj);
        }
        
    }];
    /*----------图片上传-------------*/
    
}

//渠道商管理
+ (void)requestChannelListWithPage:(int)page andLinage:(int)linage andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    NSNumber *pageNum = [NSNumber numberWithInt:page];
    NSNumber *linageNum = [NSNumber numberWithInt:linage];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [params setObject:pageNum forKey:@"page"];
    [params setObject:linageNum forKey:@"linage"];
    [BaseWebUtils postRequestWithURL:@"/agency_channelsList" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//订单记录
+ (void)requestOrderListWithOrgCode:(NSString *)orgCode andMonthCount:(NSString *)count andPage:(int)page andLinage:(int)linage andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSNumber *pageNum = [NSNumber numberWithInt:page];
    NSNumber *linageNum = [NSNumber numberWithInt:linage];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [params setObject:pageNum forKey:@"page"];
    [params setObject:linageNum forKey:@"linage"];
    
    if (![orgCode isEqualToString:@"无"]) {
        [params setObject:orgCode forKey:@"orgCode"];
    }
    
    if (![count isEqualToString:@"无"]) {
        [params setObject:count forKey:@"openTime"];
    }
    
    [BaseWebUtils postRequestWithURL:@"/agency_channelsOpenCount" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话费余额查询
+ (void)requestPhoneNumberMoneyWithNumber:(NSString *)number andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:number forKey:@"number"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_queryBalance" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//接口44  登陆时验证是否是话机世界手机号
+ (void)requestIsHJSJNumberWithNumber:(NSString *)number andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:number forKey:@"number"];
    [BaseWebUtils postRequestWithURL:@"/agency_numberCheck" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//关于我们
+ (void)requestAboutUsWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_introduction" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//充值优惠
+ (void)requestDiscountInfoWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_rechargeDiscount" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//是否有支付密码
+ (void)requestHasPayPasswordWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_initialPsdCheck" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话费充值其他金额优惠信息
+ (void)requestOtherRechargeDiscountWithMoney:(NSString *)money andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [params setObject:money forKey:@"actualAmount"];
    [BaseWebUtils postRequestWithURL:@"/agency_otherRechargeDiscount" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

+ (void)requestWithChooseScanWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:chooseScan paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

+ (void)requestWithCardModeWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getOpenPower" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

+ (void)requestIsLiangWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    [params setObject:phoneNumber forKey:@"tel"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_judgeIsLiang" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

+ (void)requestWarningTextWithType:(NSInteger)type andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//得到parameter
    NSNumber *typeNum = [NSNumber numberWithInteger:type];
    [params setObject:typeNum forKey:@"type"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getTips" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

/*--------话机世界二期------------------------------------*/
//得到靓号规则
+ (void)requestLiangRuleWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getLiangRule" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//代理商靓号平台
+ (void)requestAgentLiangNumberWithDictionary:(NSMutableDictionary *)dic andCallback:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getAgentsLiangList" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//代理商靓号详情
+ (void)requestAgentLiangDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"number"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getAgentsLiangNumber" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界靓号平台
+ (void)requestHJSJLiangNumberWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getHjsjLiangList" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界靓号详情
+ (void)requestHJSJLiangDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"number"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getHjsjLiangNumber" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界靓号获取imsi---写卡、锁定
+ (void)requestLiangImsiWithPhoneNumber:(NSString *)phoneNumber andIccid:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"number"];
    [params setObject:iccid forKey:@"iccid"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_liangImsi" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//靓号平台-话机世界靓号写卡成功记录表  不论对错
+ (void)requestAgencyLiangRecordsWithPhoneNumber:(NSString *)phoneNumber andIccid:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"number"];
    [params setObject:iccid forKey:@"iccid"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_liangRecords" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//话机世界靓号平台--开户订单提交
+ (void)requestHJSJLiangOpenWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //话机靓号
    [imageParamsDic setObject:@"5" forKey:@"type"];

    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo3"];
    if (dic[@"videoPhotos1"]) {
        [photoDic setObject:[dic objectForKey:@"videoPhotos1"] forKey:@"photo4"];
    }
    if (dic[@"videoPhotos2"]) {
        [photoDic setObject:[dic objectForKey:@"videoPhotos2"] forKey:@"photo5"];
    }
    
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [dic setObject:obj[@"data"][@"photo1"] forKey:@"photoFront"];
                [dic setObject:obj[@"data"][@"photo2"] forKey:@"photoBack"];
                [dic setObject:obj[@"data"][@"photo3"] forKey:@"memo4"];
                if (dic[@"videoPhotos1"]) {
                    [dic setObject:obj[@"data"][@"photo4"] forKey:@"videoPhotos1"];
                }
                if (dic[@"videoPhotos2"]) {
                    [dic setObject:obj[@"data"][@"photo5"] forKey:@"videoPhotos2"];
                }
                
                [BaseWebUtils postRequestWithURL:@"/agency_liangSetOpen" paramters:dic finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
        
    }];

}

+ (void)requestHJSJLiangBUDengjiWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack
{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //话机靓号
    [imageParamsDic setObject:@"5" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo3"];
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [dic setObject:obj[@"data"][@"photo1"] forKey:@"photoFront"];
                [dic setObject:obj[@"data"][@"photo2"] forKey:@"photoBack"];
                [dic setObject:obj[@"data"][@"photo3"] forKey:@"memo4"];
                
                [BaseWebUtils postRequestWithURL:@"/agency_liangRegistrationOrder" paramters:dic finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
        
    }];
    
}


//62 
+ (void)requestWhitePrepareOpenNumberDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"number"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_preNumberDetails" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//67开户
+ (void)requestWhitePrepareOpenFinalWith:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //话机靓号
    [imageParamsDic setObject:@"1" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
    
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photo1"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photo2"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"photo3"] forKey:@"photo3"];
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [dic setObject:obj[@"data"][@"photo1"] forKey:@"photo1"];
                [dic setObject:obj[@"data"][@"photo2"] forKey:@"photo2"];
                [dic setObject:obj[@"data"][@"photo3"] forKey:@"photo3"];
                                
                [BaseWebUtils postRequestWithURL:@"/agency_openInformation" paramters:dic finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
    }];
}

//65
+ (void)requestAgentWhitePrepareOpenNumberListWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_ePreNumberList" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//66 预开户列表之后详情
+ (void)requestAgentWhiteRecordDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [dic setObject:phoneNumber forKey:@"number"];
    [BaseWebUtils postRequestWithURL:@"/agency_ePreNumber" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}


/*----------代理商白卡预开户---------------*/

//号码池信息
+ (void)requestPreWhiteNumberPoolWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getPreWhiteNumberPool" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//代理商白卡预开户列表--61
+ (void)requestAgentWhitePrepareOpenFirstStepWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_preRandomNumber" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//获取号码详情---66
+ (void)requestAgentWhitePrepareOpenNumberDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNumber forKey:@"number"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_ePreNumber" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//接口63获取imsi信息
+ (void)requestWhitePrepareOpenNumberImsiWithNumber:(NSString *)phoneNumber andIccid:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phoneNumber forKey:@"number"];
    [params setObject:iccid forKey:@"iccid"];
    [params setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getPreImsi" paramters:params finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//64.白卡预开户之写白卡预开户表
+ (void)requestAgentWhitePrepareOpenFinalWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_writePreDetails" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//69---渠道商，靓号平台，话机世界靓号平台付款
+ (void)requestPayInfoWithSelectDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_liangPay" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//70、话机靓号-是否已缴纳保证金验证
+ (void)requestIsBondWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_isBond" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//71、获取保证金金额
+ (void)requestBondMoneyWithCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_bondAmount" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//72、提交保证金订单
+ (void)topBondOrderWithOrderNumber:(NSString *)orderNumber andAmount:(NSString *)amount andUsername:(NSString *)username andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:orderNumber forKey:@"orderNo"];
    [dic setObject:username forKey:@"userName"];
    [dic setObject:amount forKey:@"amount"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_bondOrder" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//73、产品订购获取验证码
+ (void)l_getCode:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:phoneNumber forKey:@"number"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/checkNumber" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//74、产品订购-获取可订购产品信息
+ (void)l_getProduct:(NSString *)number andVerificationCode:(NSString *)verificationCode andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:number forKey:@"number"];
    [dic setObject:verificationCode forKey:@"verificationCode"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/getProduct" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//75、订单提交
+ (void)l_orderProductWithNumber:(NSString *)number andVerificationCode:(NSString *)verificationCode andProductId:(NSString *)productId andProductName:(NSString *)productName andProdOfferId:(NSString *)prodOfferId andProdOfferName:(NSString *)prodOfferName andProdOfferDesc:(NSString *)prodOfferDesc andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:number forKey:@"number"];
    [dic setObject:verificationCode forKey:@"verificationCode"];
    [dic setObject:productId forKey:@"productId"];
    [dic setObject:productName forKey:@"productName"];
    [dic setObject:prodOfferId forKey:@"prodOfferId"];
    [dic setObject:prodOfferName forKey:@"prodOfferName"];
    if (prodOfferDesc) {
        [dic setObject:prodOfferDesc forKey:@"prodOfferDesc"];
    }
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/orderProduct" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//76、产品订购列表查询
+ (void)l_getOrderProductListWithNumber:(NSString *)number andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (number) {
        [dic setObject:number forKey:@"number"];
    }
    [dic setObject:page forKey:@"page"];
    [dic setObject:linage forKey:@"linage"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/getOrderProductList" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}


//78 抽奖有效次数查询

+ (void)requestgetLuckNumbertWithCallBack:(WebUtilsCallBack1)callBack
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getLuckNumbers" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];

    
}
//79 中奖记录查询

+ (void)requestgetWinningWithNumber:(NSString *)number andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (number) {
        [dic setObject:number forKey:@"number"];
    }
    [dic setObject:page forKey:@"page"];
    [dic setObject:@"10" forKey:@"linage"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getWinningOrders" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];

    
}
//80 抽奖

+ (void)requestluckyDrawWithCallBack:(WebUtilsCallBack1)callBack
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_luckyDraw" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//81 账单查询
+ (void)agency_getBillWithTel:(NSString *)tel accountPeriod:(NSString *)accountPeriod andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:tel forKey:@"tel"];
    [dic setObject:accountPeriod forKey:@"accountPeriod"];
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getBill" paramters:dic finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//82 子账户开户列表
+ (void)agency_getSonOrderListWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getSonOrderList" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//83 子账户开户详情
+ (void)agency_getSonOrderWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getSonOrder" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//84 佣金账期查询
+ (void)agency_getAccountPeriodListWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getAccountPeriodList" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//85 佣金账期明细查询
+ (void)agency_getAccountPeriodWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getAccountPeriod" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

//86 获取开户协议图片地址
+ (void)agency_getAgreementAddressCallBack:(WebUtilsCallBack1)callBack{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_getAgreementAddress" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

/***工号登记增加图片****/
+ (void)updateAgency_dataSupplementWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //工号实名
    [imageParamsDic setObject:@"6" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
//    agreementFront
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dict objectForKey:@"photo1"] forKey:@"photo1"];
    [photoDic setObject:[dict objectForKey:@"photo2"] forKey:@"photo2"];
    [photoDic setObject:[dict objectForKey:@"photo3"] forKey:@"photo3"];
    if (dict[@"photo4"]) {
        [photoDic setObject:[dict objectForKey:@"photo4"] forKey:@"photo4"];
    }
    if (dict[@"photo5"]) {
        [photoDic setObject:[dict objectForKey:@"photo5"] forKey:@"photo5"];
    }

    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
            
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    
                    [dict setObject:obj[@"data"][@"photo1"] forKey:@"photo1"];
                    [dict setObject:obj[@"data"][@"photo2"] forKey:@"photo2"];
                    [dict setObject:obj[@"data"][@"photo3"] forKey:@"photo3"];
                    
                    if (obj[@"data"][@"photo4"]) {
                        [dict setObject:obj[@"data"][@"photo4"] forKey:@"photo4"];
                    }
                    if (obj[@"data"][@"photo5"]) {
                        [dict setObject:obj[@"data"][@"photo5"] forKey:@"photo5"];
                    }
                    
                    NSMutableDictionary *photoDic2 = [NSMutableDictionary dictionary];
                    if (dict[@"licensePic"]) {
                        [photoDic2 setObject:[dict objectForKey:@"licensePic"] forKey:@"photo1"];
                    }
                    if (dict[@"branchPic"]) {
                        if (dict[@"licensePic"]) {
                            [photoDic2 setObject:[dict objectForKey:@"branchPic"] forKey:@"photo2"];
                        }else{
                            [photoDic2 setObject:[dict objectForKey:@"branchPic"] forKey:@"photo1"];
                        }
                        
                    }
                    [imageLoadParams setObject:photoDic2 forKey:@"photo"];
                    
                    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
                        //得到的是网点、营业照
                        if (![obj isKindOfClass:[NSError class]]) {
                            
                            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                            if ([code isEqualToString:@"10000"]) {
                            
                                if (dict[@"licensePic"]) {
                                    [dict setObject:obj[@"data"][@"photo1"] forKey:@"licensePic"];
                                }
                                if (dict[@"branchPic"]) {
                                    if (dict[@"licensePic"]) {
                                        [dict setObject:obj[@"data"][@"photo2"] forKey:@"branchPic"];
                                    }else{
                                        [dict setObject:obj[@"data"][@"photo1"] forKey:@"branchPic"];
                                    }
                                    
                                }
                                
                                //上传
                                [BaseWebUtils postRequestWithURL:@"/agency_dataSupplement" paramters:dict finshedBlock:^(id obj) {
                                    callback(obj);
                                }];
                                
                            }else{
                                callback(obj);
                            }
                        }else{
                            callback(obj);
                        }
                        
                    }];
                    
                }else{
                    callback(obj);
                }
                
            }else{
                callback(obj);
            }
            
        }];
    
    
}

// 91 红包抽奖资料补登记
+ (void)agency_dataSupplementWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //工号实名
    [imageParamsDic setObject:@"6" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
//    agreementFront
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dict objectForKey:@"photo1"] forKey:@"photo1"];
    [photoDic setObject:[dict objectForKey:@"photo2"] forKey:@"photo2"];
    [photoDic setObject:[dict objectForKey:@"photo3"] forKey:@"photo3"];
    if (dict[@"photo4"]) {
        [photoDic setObject:[dict objectForKey:@"photo4"] forKey:@"photo4"];
    }
    if (dict[@"photo5"]) {
        [photoDic setObject:[dict objectForKey:@"photo5"] forKey:@"photo5"];
    }
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
            
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    
                    [dict setObject:obj[@"data"][@"photo1"] forKey:@"photo1"];
                    [dict setObject:obj[@"data"][@"photo2"] forKey:@"photo2"];
                    [dict setObject:obj[@"data"][@"photo3"] forKey:@"photo3"];
                    
                    if (obj[@"data"][@"photo4"]) {
                        [dict setObject:obj[@"data"][@"photo4"] forKey:@"photo4"];
                    }
                    if (obj[@"data"][@"photo5"]) {
                        [dict setObject:obj[@"data"][@"photo5"] forKey:@"photo5"];
                    }
                    
                    
                    [BaseWebUtils postRequestWithURL:@"/agency_dataSupplement" paramters:dict finshedBlock:^(id obj) {
                        callback(obj);
                    }];
                    
                }else{
                    callback(obj);
                }
                
            }else{
                callback(obj);
            }
            
        }];
    
    
}

// 93 判断是否为渠道商
+ (void)agencyCheckUserDSCallBack:(WebUtilsCallBack1)callBack {
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_checkUserDS" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

// 94 预订单生成 - 号码验证
+ (void)agencySelectionCheckWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callBack {
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_selection_check" paramters:dict finshedBlock:^(id obj) {
        callBack(obj);
    }];
}

// 95 电商售号 - 二维码内容
+ (void)agencySelectionQrcodeWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_selection_qrcode" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 96 预订单列表接口
+ (void)agencySelectionAuditListWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_selection_auditList" paramters:dict finshedBlock:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(obj);
        });
    }];
}

// 97 预订单详情接口
+ (void)agencySelectionDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_selection_details" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 98 预订单详情接口
+ (void)agencySelectionAuditWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_selection_audit" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 99 红包补登记资料
+ (void)agency_isNeedToRegisterWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_isNeedToRegister" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 100.2019新版白卡预开户-号码池获取
+ (void)agency_2019whiteNumberPoolWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019whiteNumberPool" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 101.2019新版白卡预开户-随机号码
+ (void)agency_2019preRandomNumberWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019preRandomNumber" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 102.2019新版白卡预开户-号码详情
+ (void)agency_2019preNumberDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019preNumberDetails" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 103.2019新版白卡预开户-号码锁定（即付款）
+ (void)agency_2019lockNumberWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019lockNumber" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 104.2019新版白卡预开户-获取IMSI
+ (void)agency_2019GetPreImsiWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019GetPreImsi" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 105.2019新版白卡预开户-写卡结果通知
+ (void)agency_2019ResultWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019Result" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

/***人像的--已经上传过图片的 号码激活***/
+ (void)agency_2019setOpenWithFaceWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack
{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //话机靓号
    [imageParamsDic setObject:@"5" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
//    agreementFront
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
//    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo1"];
//    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo2"];
//    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"agreementFront"] forKey:@"photo1"];
    
//#pragma mark - 人脸识别
//    if ([dic objectForKey:@"videoPhotos1"]) {
//        [photoDic setObject:[dic objectForKey:@"videoPhotos1"] forKey:@"photo5"];
//    }
//    if ([dic objectForKey:@"videoPhotos2"]) {
//        [photoDic setObject:[dic objectForKey:@"videoPhotos2"] forKey:@"photo6"];
//    }
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [dic setObject:obj[@"data"][@"photo1"] forKey:@"agreementFront"];
                
                
                [BaseWebUtils postRequestWithURL:@"/agency_2019setOpen" paramters:dic finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
        
    }];
    
}

//成卡激活一次性上传
+ (void)requestNormalSetOpenWithDictionary:(NSMutableDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //话机靓号
    [imageParamsDic setObject:@"5" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
//    agreementFront
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    
    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"memo11"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo4"];
    [photoDic setObject:[dic objectForKey:@"agreementFront"] forKey:@"photo5"];
//    }
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [dic setObject:obj[@"data"][@"photo1"] forKey:@"memo4"];
                [dic setObject:obj[@"data"][@"photo2"] forKey:@"memo11"];
                [dic setObject:obj[@"data"][@"photo3"] forKey:@"photoFront"];
                [dic setObject:obj[@"data"][@"photo4"] forKey:@"photoBack"];
                
                [dic setObject:obj[@"data"][@"photo5"] forKey:@"agreementFront"];
                
                [BaseWebUtils postRequestWithURL:@"/agency_2019setOpen" paramters:dic finshedBlock:^(id obj) {
                    
                    callBack(obj);
                }];
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
    }];
    /*----------图片上传-------------*/
}


// 106.2019新版白卡预开户-号码激活
+ (void)agency_2019setOpenWithWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack
{
    [dic setObject:[Utils getSessionToken] forKey:@"session_token"];
    
    /*----------图片上传-------------*/
    NSMutableDictionary *imageParamsDic = [NSMutableDictionary dictionary];//得到parameter
    [imageParamsDic setObject:[Utils getSessionToken] forKey:@"session_token"];
    //话机靓号
    [imageParamsDic setObject:@"5" forKey:@"type"];
    
    NSString *photoString = [Utils MydictionaryToJSON:imageParamsDic];
    photoString = [photoString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *app_sign_photo = [Utils md5String:[NSString stringWithFormat:@"%@%@%@",app_pwd,photoString,app_pwd]];
    
    NSMutableDictionary *imageLoadParams = [@{@"app_key":app_keyMD5,@"app_sign":app_sign_photo} mutableCopy];
//    agreementFront
    NSMutableDictionary *photoDic = [NSMutableDictionary dictionary];
    [photoDic setObject:[dic objectForKey:@"photoFront"] forKey:@"photo1"];
    [photoDic setObject:[dic objectForKey:@"photoBack"] forKey:@"photo2"];
    [photoDic setObject:[dic objectForKey:@"memo4"] forKey:@"photo3"];
    [photoDic setObject:[dic objectForKey:@"agreementFront"] forKey:@"photo4"];
    
#pragma mark - 人脸识别
    if ([dic objectForKey:@"videoPhotos1"]) {
        [photoDic setObject:[dic objectForKey:@"videoPhotos1"] forKey:@"photo5"];
    }
    if ([dic objectForKey:@"videoPhotos2"]) {
        [photoDic setObject:[dic objectForKey:@"videoPhotos2"] forKey:@"photo6"];
    }
    
    [imageLoadParams setObject:photoDic forKey:@"photo"];
    
    [imageLoadParams setObject:imageParamsDic forKey:@"parameter"];
    
    
    [BaseWebUtils postImageRequestWithParamters:imageLoadParams finshedBlock:^(id obj) {
        
        if (![obj isKindOfClass:[NSError class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                [dic setObject:obj[@"data"][@"photo1"] forKey:@"photoFront"];
                [dic setObject:obj[@"data"][@"photo2"] forKey:@"photoBack"];
                [dic setObject:obj[@"data"][@"photo3"] forKey:@"memo4"];
                [dic setObject:obj[@"data"][@"photo4"] forKey:@"agreementFront"];
                
#pragma mark - 人脸识别
                if (obj[@"data"][@"photo5"]) {
                    [dic setObject:obj[@"data"][@"photo5"] forKey:@"videoPhotos1"];
                }
                if (obj[@"data"][@"photo6"]) {
                    [dic setObject:obj[@"data"][@"photo6"] forKey:@"videoPhotos2"];
                }
                
                [BaseWebUtils postRequestWithURL:@"/agency_2019setOpen" paramters:dic finshedBlock:^(id obj) {
                    callBack(obj);
                }];
                
            }else{
                callBack(obj);
            }
            
        }else{
            callBack(obj);
        }
        
    }];
    
}


// 107.2019新版白卡预开户-预开户列表
+ (void)agency_2019ePreNumberListWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019ePreNumberList" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

+ (void)agency_2019preNumberOrderInfoWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019preNumberOrderInfo" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 109.2019业务办理-产品列表查询
+ (void)agency_2019QueryProductsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019QueryProducts" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

//110.2019业务办理-产品详情查询
+ (void)agency_2019QueryProductDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019QueryProductDetails" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

//111.2019业务办理-产品订购/退订
+ (void)agency_2019ServiceProductWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
       [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
       [BaseWebUtils postRequestWithURL:@"/agency_2019ServiceProduct" paramters:dict finshedBlock:^(id obj) {
           callback(obj);
       }];
}

//112.2019业务办理-订单列表查询
+ (void)agency_2019QueryOrdersWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019QueryProductOrders" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

//113.2019业务办理-订单详细信息查询
+ (void)agency_2019QueryOrderDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_2019QueryOrderDetails" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

//114.    APP校验定位
+ (void)agency_judgeLocation:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agency_judgeLocation" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}

// 115.    2020重新写卡
+ (void)agencyGetPreImsiAgainWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setObject:[Utils getSessionToken] forKey:@"session_token"];
    [BaseWebUtils postRequestWithURL:@"/agencyGetPreImsiAgain" paramters:dict finshedBlock:^(id obj) {
        callback(obj);
    }];
}


@end
