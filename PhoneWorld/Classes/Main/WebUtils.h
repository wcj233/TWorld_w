//
//  WebUtils.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/31.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegisterModel.h"

typedef void(^WebUtilsCallBack1)(id obj);

@interface WebUtils : NSObject

@property (nonatomic) void(^WebUtilsCallBack) (id obj);

//点击次数
+ (void)requestWithTouchTimes;

//佣金模块信息
+ (void)requestCommissionCountWithDate:(NSString *)date andCallBack:(WebUtilsCallBack1)callBack;

//开户统计模块
+ (void)requestOpenCountWithDate:(NSString *)date andCallBack:(WebUtilsCallBack1)callBack;

//号码充值（充值手机号）
+ (void)requestTopInfoWithNumber:(NSString *)phoneNumber andMoney:(NSString  *)money andPayPassword:(NSString *)payPassword andCallBack:(WebUtilsCallBack1)callBack;

//工号登记
+ (void)requestSupplementWithUserName:(NSString *)username andTel:(NSString *)tel andEmail:(NSString *)email andCardId:(NSString *)cardId andAddress:(NSString *)address andWebUtilsCallBack:(WebUtilsCallBack1)callBack;

/***工号登记增加图片****/
+ (void)updateAgency_dataSupplementWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

//登陆
+ (void)requestLoginResultWithUserName:(NSString *)username andPassword:(NSString *)password andWebUtilsCallBack:(WebUtilsCallBack1)callBack;
//登出
+ (void)requestLogoutResultWithCallBack:(WebUtilsCallBack1)callBack;
+ (void)requestWithCardModeWithCallBack:(WebUtilsCallBack1)callBack;
//注册
+ (void)requestRegisterResultWithRegisterModel:(RegisterModel *)registerModel andCallBack:(WebUtilsCallBack1)callBack;
//修改登录密码
+ (void)requestAlterPasswordWithOldPassword:(NSString *)oldPassword andNewPassword:(NSString *)newPassword andCallBack:(WebUtilsCallBack1)callBack;
//忘记密码  password相当于修改过后的新密码
+ (void)requestForgetPasswordWithTel:(NSString *)tel andCaptcha:(NSString *)captcha andPassword:(NSString *)password andCallBack:(WebUtilsCallBack1)callBack;
//支付密码创建
+ (void)requestCreatePayPasswordWithPassword:(NSString *)password andCallBack:(WebUtilsCallBack1)callBack;
//支付密码修改
+ (void)requestAlterPayPasswordWithNewPassword:(NSString *)newPassword andOldPassword:(NSString *)oldPassword andCallBack:(WebUtilsCallBack1)callBack;
//返回用户信息
+ (void)requestPersonalInfoWithSessionToken:(NSString *)sessionToken andUserName:(NSString *)username andCallBack:(WebUtilsCallBack1)callBack;
//修改用户信息
+ (void)requestChangePersonalInfoWithParamDic:(NSDictionary *)paramDic andCallBack:(WebUtilsCallBack1)callBack;


//返回轮播图---page31
+ (void)requestHomeScrollPictureWithCallBack:(WebUtilsCallBack1)callBack;

//发送短信验证码
+ (void)requestSendCaptchaWithType:(int)type andTel:(NSString *)tel andCallBack:(WebUtilsCallBack1)callBack;
//短信验证码验证   type 1/2 需要手机号
+ (void)requestCaptchaCheckWithCaptcha:(NSString *)captcha andType:(int)type andTel:(NSString *)tel andCallBack:(WebUtilsCallBack1)callBack;
//验证号段信息 （验证手机号是否为话机世界所拥有的手机号）
+ (void)requestSegmentWithTel:(NSString *)tel andCallBack:(WebUtilsCallBack1)callBack;

//意见反馈
+ (void)requestSuggestWithContent:(NSString *)content andCallBack:(WebUtilsCallBack1)callBack;

//成卡开户---------------------------------------------------
//成卡开户之puk码验证
+ (void)requestFinishedCardWithTel:(NSString *)tel andPUK:(NSString *)puk andCallBack:(WebUtilsCallBack1)callBack;
//成卡开户——根据套餐id的到活动包信息
+ (void)requestPackagesWithID:(NSString *)pid andCallBack:(WebUtilsCallBack1)callBack;
//成卡开户——金额信息
+ (void)requestMoneyInfoWithPrestore:(NSString *)prestore andPromotionId:(NSString *)promotionId andCallBack:(WebUtilsCallBack1)callBack;
//成卡开户
+ (void)requestSetOpenWithDictionary:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack;

//成卡开户--分步上传图片(暂时有人像的情况下)---------------------------------------------------
+ (void)uploadImagesWithDic:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack;
+ (void)uploadVideoImagesWithDic:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack;
+ (void)requestSetOpenWithFourImages:(NSDictionary *)fourImageDic andVideoDic:(NSDictionary *)videoDic andInfoDictionary:(NSDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack;

//白卡开户---------------------------------------------------
//白卡开户返回号码池
+ (void)requestWhiteCardPhoneNumbersWithCallBack:(WebUtilsCallBack1)callBack;
//根据号码池id和靓号规则返回随机号码
+ (void)requestPhoneNumbersWithNumberPool:(int)pool andNumberType:(NSString *)type andCallBack:(WebUtilsCallBack1)callBack;
//白卡开户——号码锁定
+ (void)requestLockNumberWithNumber:(NSString *)number andNumberpoolId:(NSString *)poolId andNumberType:(NSString *)numberType andCallBack:(WebUtilsCallBack1)callBack;
//白卡开户——获取imsi信息
+ (void)requestImsiInfoWithNumber:(NSString *)number andICCID:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack;
//白卡开户——写卡状态（已经与预开户结合，这个不用调用）
+ (void)requestCardResultWithICCID:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack;
//白卡开户——预开户
+ (void)requestPreopenWithNumber:(NSString *)number andICCID:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack;
//白卡开户
+ (void)requestOpenWhiteWithDictionary:(NSDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//白卡申请订单列表
+ (void)requestOpenWhiteOrderListWithPage:(NSString *)page andCallBack:(WebUtilsCallBack1)callBack;
//白卡申请详情
+ (void)requestOpenWhiteApplyDetailWithCardId:(NSNumber *)cardId andCallBack:(WebUtilsCallBack1)callBack;
//白卡申请
+ (void)requestApplyForOpenWhiteWithName:(NSString *)name andTel:(NSString *)tel andAddress:(NSString *)address andNum:(NSNumber *)num andCallBack:(WebUtilsCallBack1)callBack;


//消息推送——消息列表
+ (void)requestMessageListWithLinage:(NSString *)linage andPage:(NSString *)page andCallBack:(WebUtilsCallBack1)callBack;
//消息推送——具体内容
+ (void)requestMessageDetailWithId:(NSString *)messageId andCallBack:(WebUtilsCallBack1)callBack;

//订单查询---------------------------------------------------
//  成卡／白卡开户查询  删除
+ (void)requestInquiryOrderListWithPhoneNumber:(NSString *)number andType:(NSString *)type andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andOrderStatusCode:(NSString *)orderStatusCode andOrderStatusName:(NSString *)orderStatusName andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack;

+ (void)requestCardOrderListWithSelectDictionary:(NSMutableDictionary *)selectDictionary andCallBack:(WebUtilsCallBack1)callBack;

//  过户／补卡查询
+ (void)requestCardTransferListWithNumber:(NSString *)number andType:(NSString *)type andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andStartCode:(NSString *)startCode andStartName:(NSString *)startName andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack;

+ (void)requestTransferAndRepairCardOrderListWithSelectDictionary:(NSMutableDictionary *)selectDictionary andCallBack:(WebUtilsCallBack1)callBack;

//充值查询
+ (void)requestRechargeListWithNumber:(NSString *)number andRechargeType:(NSString *)rechargeType andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack;

//话机世界二期 ------- 话费充值／账户充值订单查询
+ (void)requestTopListWithSelectDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//开户详情  (成卡开户／白卡开户)
+ (void)requestOrderDetailWithOrderNo:(NSString *)orderNo andCallBack:(WebUtilsCallBack1)callBack;
//过户详情
+ (void)requestTransferDetailWithId:(NSString *)orderId andCallBack:(WebUtilsCallBack1)callBack;
//根据订单编号得到----补卡详情
+ (void)requestCardTransferDetailWithId:(NSString *)cardId andCallBack:(WebUtilsCallBack1)callBack;

//账户管理------------------------------
//账户余额查询
+ (void)requestAccountMoneyWithCallBack:(WebUtilsCallBack1)callBack;
//账户充值－预订单（就是需要微信支付或者支付宝支付的）
+ (void)requestReAddRechargeRecordWithNumber:(NSString *)number andMoney:(NSString *)money andRechargeMethod:(NSString *)method andCallBack:(WebUtilsCallBack1)callBack;

//卡片管理-------------------------------
//过户信息提交
+ (void)requestTransferInfoWithDic:(NSDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;
/**新改的过户信息提交--多了个人像**/
+ (void)requestTransferInfoWithDic:(NSDictionary *)dic andVideoDic:(NSDictionary *)videoDic andCallBack:(WebUtilsCallBack1)callBack;

//补卡信息提交
+ (void)requestRepairInfoWithDic:(NSDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//渠道商管理
+ (void)requestChannelListWithPage:(int)page andLinage:(int)linage andCallBack:(WebUtilsCallBack1)callBack;

//订单记录
+ (void)requestOrderListWithOrgCode:(NSString *)orgCode andMonthCount:(NSString *)count andPage:(int)page andLinage:(int)linage andCallBack:(WebUtilsCallBack1)callBack;
    
//话费余额查询
+ (void)requestPhoneNumberMoneyWithNumber:(NSString *)number andCallBack:(WebUtilsCallBack1)callBack;

//接口44  登陆时验证是否是话机世界手机号
+ (void)requestIsHJSJNumberWithNumber:(NSString *)number andCallBack:(WebUtilsCallBack1)callBack;

//关于我们
+ (void)requestAboutUsWithCallBack:(WebUtilsCallBack1)callBack;

//充值优惠
+ (void)requestDiscountInfoWithCallBack:(WebUtilsCallBack1)callBack;

//是否有支付密码
+ (void)requestHasPayPasswordWithCallBack:(WebUtilsCallBack1)callBack;

//话费充值其他金额优惠信息
+ (void)requestOtherRechargeDiscountWithMoney:(NSString *)money andCallBack:(WebUtilsCallBack1)callBack;

+ (void)requestWithChooseScanWithCallBack:(WebUtilsCallBack1)callBack;

+ (void)requestIsLiangWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

//type = 1:过户     type = 2:补卡
+ (void)requestWarningTextWithType:(NSInteger)type andCallBack:(WebUtilsCallBack1)callBack;

/*--------话机世界二期------------------------------------*/
//得到靓号规则
+ (void)requestLiangRuleWithCallBack:(WebUtilsCallBack1)callBack;

//代理商靓号平台
+ (void)requestAgentLiangNumberWithDictionary:(NSMutableDictionary *)dic andCallback:(WebUtilsCallBack1)callBack;

//代理商靓号详情
+ (void)requestAgentLiangDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

//话机世界靓号平台
+ (void)requestHJSJLiangNumberWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//话机世界靓号详情
+ (void)requestHJSJLiangDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

//话机世界靓号获取imsi---写卡、锁定
+ (void)requestLiangImsiWithPhoneNumber:(NSString *)phoneNumber andIccid:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack;

//靓号平台-话机世界靓号写卡成功记录表  不论对错
+ (void)requestAgencyLiangRecordsWithPhoneNumber:(NSString *)phoneNumber andIccid:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack;

//话机世界靓号平台--开户订单提交
+ (void)requestHJSJLiangOpenWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//靓号审核不通过-补登记
+ (void)requestHJSJLiangBUDengjiWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;


//62 
+ (void)requestWhitePrepareOpenNumberDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

//开户
+ (void)requestWhitePrepareOpenFinalWith:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//65 预开户列表
+ (void)requestAgentWhitePrepareOpenNumberListWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//66 预开户列表之后详情
+ (void)requestAgentWhiteRecordDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

/*----------代理商白卡预开户---------------*/
//号码池信息
+ (void)requestPreWhiteNumberPoolWithCallBack:(WebUtilsCallBack1)callBack;

//代理商白卡预开户列表--61
+ (void)requestAgentWhitePrepareOpenFirstStepWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//获取号码详情----接口66
+ (void)requestAgentWhitePrepareOpenNumberDetailWithPhoneNumber:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

//接口63获取imsi信息
+ (void)requestWhitePrepareOpenNumberImsiWithNumber:(NSString *)phoneNumber andIccid:(NSString *)iccid andCallBack:(WebUtilsCallBack1)callBack;

//64.白卡预开户之写白卡预开户表
+ (void)requestAgentWhitePrepareOpenFinalWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//69---渠道商，靓号平台，话机世界靓号平台付款
+ (void)requestPayInfoWithSelectDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

//70、话机靓号-是否已缴纳保证金验证
+ (void)requestIsBondWithCallBack:(WebUtilsCallBack1)callBack;

//71、获取保证金金额
+ (void)requestBondMoneyWithCallBack:(WebUtilsCallBack1)callBack;

//72、提交保证金订单
+ (void)topBondOrderWithOrderNumber:(NSString *)orderNumber andAmount:(NSString *)amount andUsername:(NSString *)username andCallBack:(WebUtilsCallBack1)callBack;

//73、产品订购获取验证码
+ (void)l_getCode:(NSString *)phoneNumber andCallBack:(WebUtilsCallBack1)callBack;

//74、产品订购-获取可订购产品信息
+ (void)l_getProduct:(NSString *)number andVerificationCode:(NSString *)verificationCode andCallBack:(WebUtilsCallBack1)callBack;

//75、订单提交
+ (void)l_orderProductWithNumber:(NSString *)number andVerificationCode:(NSString *)verificationCode andProductId:(NSString *)productId andProductName:(NSString *)productName andProdOfferId:(NSString *)prodOfferId andProdOfferName:(NSString *)prodOfferName andProdOfferDesc:(NSString *)prodOfferDesc andCallBack:(WebUtilsCallBack1)callBack;

//76、产品订购列表查询
+ (void)l_getOrderProductListWithNumber:(NSString *)number andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack;

//开户详情（白卡开户）
+ (void)requestEOrderDetailWithOrderNo:(NSString *)orderNo andCallBack:(WebUtilsCallBack1)callBack;

//78 抽奖有效次数查询

+ (void)requestgetLuckNumbertWithCallBack:(WebUtilsCallBack1)callBack;
//79 中奖记录查询
+ (void)requestgetWinningWithNumber:(NSString *)number andPage:(NSString *)page andLinage:(NSString *)linage andCallBack:(WebUtilsCallBack1)callBack;
//80 抽奖

+ (void)requestluckyDrawWithCallBack:(WebUtilsCallBack1)callBack;



//81 账单查询
+ (void)agency_getBillWithTel:(NSString *)tel accountPeriod:(NSString *)accountPeriod andCallBack:(WebUtilsCallBack1)callBack;
//82 子账户开户列表
+ (void)agency_getSonOrderListWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack;
//83 子账户开户详情
+ (void)agency_getSonOrderWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack;
//84 佣金账期查询
+ (void)agency_getAccountPeriodListWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack;
//85 佣金账期明细查询
+ (void)agency_getAccountPeriodWithParameters:(NSDictionary *)parameters andCallBack:(WebUtilsCallBack1)callBack;
//86 获取开户协议图片地址
+ (void)agency_getAgreementAddressCallBack:(WebUtilsCallBack1)callBack;

// 91 红包抽奖资料补登记
+ (void)agency_dataSupplementWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 93 判断是否为渠道商
+ (void)agencyCheckUserDSCallBack:(WebUtilsCallBack1)callBack;

// 94 预订单生成 - 号码验证
+ (void)agencySelectionCheckWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callBack;

// 95 电商售号 - 二维码内容
+ (void)agencySelectionQrcodeWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 96 预订单列表接口
+ (void)agencySelectionAuditListWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 97 预订单详情接口
+ (void)agencySelectionDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 98 预订单详情接口
+ (void)agencySelectionAuditWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 99 红包补登记资料
+ (void)agency_isNeedToRegisterWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;


#pragma mark - 2019-08
/***人像的--已经上传过图片的 号码激活***/
+ (void)agency_2019setOpenWithFaceWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;
+ (void)requestNormalSetOpenWithDictionary:(NSMutableDictionary *)dic andcallBack:(WebUtilsCallBack1)callBack;

// 100.2019新版白卡预开户-号码池获取
+ (void)agency_2019whiteNumberPoolWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 101.2019新版白卡预开户-随机号码
+ (void)agency_2019preRandomNumberWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 102.2019新版白卡预开户-号码详情
+ (void)agency_2019preNumberDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 103.2019新版白卡预开户-号码锁定（即付款）
+ (void)agency_2019lockNumberWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 104.2019新版白卡预开户-获取IMSI
+ (void)agency_2019GetPreImsiWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 105.2019新版白卡预开户-写卡结果通知
+ (void)agency_2019ResultWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 106.2019新版白卡预开户-号码激活
+ (void)agency_2019setOpenWithWithDictionary:(NSMutableDictionary *)dic andCallBack:(WebUtilsCallBack1)callBack;

// 107.2019新版白卡预开户-预开户列表
+ (void)agency_2019ePreNumberListWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 108.2019新版白卡预开户-预开户订单详情
+ (void)agency_2019preNumberOrderInfoWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

#pragma mark - 2019-12
// 109.2019业务办理-产品列表查询
+ (void)agency_2019QueryProductsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

//110.2019业务办理-产品详情查询
+ (void)agency_2019QueryProductDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

//111.2019业务办理-产品订购/退订
+ (void)agency_2019ServiceProductWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

//112.2019业务办理-订单列表查询
+ (void)agency_2019QueryOrdersWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

//113.2019业务办理-订单详细信息查询
+ (void)agency_2019QueryOrderDetailsWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

//114.    APP校验定位
+ (void)agency_judgeLocation:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

// 115.    2020重新写卡
+ (void)agencyGetPreImsiAgainWithParams:(NSDictionary *)params andCallback:(WebUtilsCallBack1)callback;

@end
