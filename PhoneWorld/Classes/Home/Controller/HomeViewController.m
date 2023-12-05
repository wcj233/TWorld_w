//
//  HomeViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "HomeJumpViewController.h"

#import "MessageViewController.h"
#import "PersonalHomeViewController.h"
#import "LuckdrawViewController.h"
#import "HomeScrollModel.h"

#import "RightItemView.h"

#import "RedBagFillInfoVC.h"
#import "BaiduMapTool.h"
#import "LoginNaviViewController.h"
#import "LoginNewViewController.h"

@interface HomeViewController ()

@property (nonatomic) NSMutableArray *scrollViewModels;
@property (nonatomic) NSMutableArray *imageUrlGroup;
@property (nonatomic) HomeView *homeView;
//轮播图
@property (nonatomic) SDWebImageManager *imageManager;
@property (nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSTimer *checkLocationPermissionTimer;
/// 检测定位权限
@property (assign, nonatomic) BOOL checkLocationPermissionFlag;
/// 检测定位的时间，分钟数
@property (assign, nonatomic) NSInteger checkLocationMins;

@end

@implementation HomeViewController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGROUND;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.scrollViewModels = [NSMutableArray array];
    self.imageUrlGroup = [NSMutableArray array];
    self.imagesArray = [NSMutableArray array];
    self.checkLocationPermissionFlag = false;
    self.checkLocationMins = 0;
    
    @WeakObj(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"StopCheckLocationNotificationName" object:nil] subscribeNext:^(id x) {
        @StrongObj(self)
        [self.checkLocationPermissionTimer invalidate];
        self.checkLocationPermissionTimer = nil;
    }];
    
    
    //区分用户等级
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *grade = [ud objectForKey:@"grade"];
    if ([grade isEqualToString:@"lev1"] || [grade isEqualToString:@"lev2"]) {
        //代理商 功能少
        [self requestOpenCountByMonthOrYear:@"year"];
        [self requestOpenCountByMonthOrYear:@"month"];
    }
    
    _homeView = [[HomeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44 - 64)];
    [self.view addSubview:self.homeView];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @StrongObj(self);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //请求轮播图
            [self requestHomeScrollView];
        }else{
            
            //如果没网络在本地的拿来
            self.imagesArray = [NSMutableArray array];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSInteger number = [ud integerForKey:@"scrollViewNumber"];
            
            for (int i = 0; i < number; i ++) {
                NSString *appendingString = [NSString stringWithFormat:@"/Documents/homeScrollView%d.arch",i];
                NSString *path = [NSHomeDirectory() stringByAppendingString:appendingString];
                NSData *imageData = [NSData dataWithContentsOfFile:path];
                
                if (imageData) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [self.imagesArray addObject:image];
                }
            }
            self.homeView.imageScrollView.localizationImageNamesGroup = self.imagesArray;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //点击轮播图跳转
    [self.homeView setHomeHeadScrollCallBack:^(NSInteger number) {
        @StrongObj(self);
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus ==  AFNetworkReachabilityStatusReachableViaWWAN  || [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            HomeScrollModel *homeModel = self.scrollViewModels[number];
            NSString *urlString = [NSString stringWithFormat:@"%@",homeModel.jumpUrl];
            if (![urlString isEqualToString:@""]) {
                HomeJumpViewController *jumpVC = [[HomeJumpViewController alloc] init];
                jumpVC.url = homeModel.jumpUrl;
                jumpVC.hidesBottomBarWhenPushed = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:jumpVC animated:YES];
                });
            }
        }
        
    }];
    
    // 首页点击 红包抽奖 的回调，判断资料是否完全
    self.homeView.redBagClickBlock = ^{
        @StrongObj(self);
        [self requestForRedBagInfo];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestFirstPageNews];
//        [self requestForInfoWays];
    });
    
    [self startCheckLocationPermission];
}

- (void)dealloc {
    // 关闭定时器
    [self.checkLocationPermissionTimer invalidate];
    self.checkLocationPermissionTimer = nil;
}

#pragma mark - Method
// 开启检查定位权限的定时器
- (void)startCheckLocationPermission {
    NSInteger interval = 60;
#if DEBUG
    interval = 60;
#else
    interval = 15 * 60;
#endif
    if (self.checkLocationPermissionTimer == nil) {
        self.checkLocationMins = 0;
        @WeakObj(self)
        self.checkLocationPermissionTimer = [NSTimer scheduledTimerWithTimeInterval:interval repeats:true block:^(NSTimer * _Nonnull timer) {
            @StrongObj(self)
            NSLog(@"开始执行定时任务");
            self.checkLocationMins += interval;
            
            if (self.checkLocationMins % interval == 0) {
                // 检测定位权限
                [self checkLocationPermission];
                
                if (self.checkLocationPermissionFlag) {
                    // 检测权限通过
                    if (self.checkLocationMins % (interval * 2) == 0) {
                        // 每30分钟上传定位信息
                        if (self.checkLocationPermissionFlag) {
                            [self uploadLocationInfo];
                        }
                    }
                } else {
                    // 检测权限失败，停止计时。
                    [self.checkLocationPermissionTimer invalidate];
                    self.checkLocationPermissionTimer = nil;
                    
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"未打开位置信息或未开启定位权限，禁止使用" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[BaiduMapTool sharedInstance] logoutAction];
                    }];
                    [alertVC addAction:goAction];
                    [self presentViewController:alertVC animated:true completion:nil];
                }
            }
        }];
    }
}

- (void)checkLocationPermission {
    NSLog(@"检测定位权限");
    
    //定位服务是否可用
    BOOL enable = [CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status = [CLLocationManager authorizationStatus];
    
    if (status == 2) {
        // 没给权限
        self.checkLocationPermissionFlag = false;
    } else if (enable && status >= 3) {
        self.checkLocationPermissionFlag = true;
    } else {
        self.checkLocationPermissionFlag = false;
    }
}

// 上传定位信息
- (void)uploadLocationInfo {
    @WeakObj(self)
    [[BaiduMapTool sharedInstance] uploadLocationInfoWithSuccessBlock:^{
        
    } failBlock:^{
        @StrongObj(self)
        [self.checkLocationPermissionTimer invalidate];
        self.checkLocationPermissionTimer = nil;
    }];
//    @WeakObj(self)
//    [[BaiduMapTool sharedInstance] requestOnceLocationWithSuccessBlock:^(NSString * _Nonnull provinceCode, NSString * _Nonnull cityCode) {
//        @StrongObj(self)
//#if DEBUG
//        provinceCode = @"88";
//        cityCode = @"19";
//#endif
//        @WeakObj(self)
//        [WebUtils agency_judgeLocation:@{@"provinceCode": provinceCode, @"cityCode": cityCode} andCallback:^(id obj) {
//            @StrongObj(self)
//            if ([obj[@"code"] isEqualToString:@"10000"]) {
//                if ([obj[@"data"][@"judgeLocation"] boolValue] == true) {
//
//                } else {
//                    [self.checkLocationPermissionTimer invalidate];
//                    self.checkLocationPermissionTimer = nil;
//
//                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户未在常用地使用" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        // 退出登录
//                        [self logoutAction];
//                    }];
//                    [alertVC addAction:goAction];
//                    [self presentViewController:alertVC animated:true completion:nil];
//                }
//            }
//        }];
//    } withErrorBlock:^(NSError * _Nonnull error) {
//
//    }];
}

- (void)requestForInfoWays{
    __block __weak HomeViewController *weakself = self;
    [WebUtils requestWithCardModeWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                [[NSUserDefaults standardUserDefaults]setObject:obj[@"data"] forKey:@"kaihuMode"];
                [[NSUserDefaults standardUserDefaults]synchronize];
//                weakself.cardOpenMode = [obj[@"data"][@"cardOpenMode"] intValue];
            }
        }
    }];
}

- (void)requestHomeScrollView{
    @WeakObj(self);
    [WebUtils requestHomeScrollPictureWithCallBack:^(id obj) {
        @StrongObj(self);
        if (![obj isKindOfClass:[NSError class]]) {
            self.imageUrlGroup = [NSMutableArray array];
            
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                
                NSArray *models = obj[@"data"][@"carousel_Picture"];
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setInteger:models.count forKey:@"scrollViewNumber"];
                [ud synchronize];
                
                for (int i = 0; i < models.count; i ++) {
                    NSDictionary *dic = models[i];
                    [self.imageUrlGroup addObject:dic[@"url"]];
                    HomeScrollModel *homeModel = [[HomeScrollModel alloc] initWithDictionary:dic error:nil];
                    [self.scrollViewModels addObject:homeModel];
                    
                    
                    //耗时操作  非常耗时
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //做图片缓存
                        NSString *appendingString = [NSString stringWithFormat:@"/Documents/homeScrollView%d.arch",i];
                        NSString *path = [NSHomeDirectory() stringByAppendingString:appendingString];
                        NSData *imageData = [NSData dataWithContentsOfURL:homeModel.url];
                        
                        [imageData writeToFile:path atomically:YES];
                    });
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.homeView.imageScrollView.imageURLStringsGroup = self.imageUrlGroup;
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

//开户量
- (void)requestOpenCountByMonthOrYear:(NSString *)string{

    @WeakObj(self);
    
    [WebUtils requestOpenCountWithDate:string andCallBack:^(id obj) {
        @StrongObj(self);

        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //如果是年
                if ([string isEqualToString:@"year"]) {
                    NSMutableArray *yearCountArray = [NSMutableArray array];
                    NSMutableArray *yearArray = [NSMutableArray array];
                    NSArray *array = obj[@"data"][@"statisticsList"];
                    for (NSDictionary *dic in array) {
                        
                        [yearCountArray addObject:dic[@"record"]];
                        [yearArray addObject:dic[@"time"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        CGFloat max = [obj[@"data"][@"max"] floatValue];
                        
                        CGFloat average = [obj[@"data"][@"average"] floatValue];
                        
                        self.homeView.countView.average2 = average;
                        self.homeView.countView.max2 = max;
                        
                        self.homeView.countView.accountsOpendCountYearArr = yearCountArray;
                        self.homeView.countView.accountsOpenedYearArr = yearArray;
                        [self.homeView.countView setNeedsDisplay];
                    });
                    
                }else{
                    //最多只有6个
                    NSMutableArray *monthCountArray = [NSMutableArray array];
                    NSMutableArray *monthArray = [NSMutableArray array];
                    
                    NSArray *array = obj[@"data"][@"statisticsList"];
                    for (NSDictionary *dic in array) {
                        NSString *monthString = [[NSString stringWithFormat:@"%@",dic[@"time"]] componentsSeparatedByString:@"-"].lastObject;
                        
                        [monthCountArray addObject:dic[@"record"]];
                        [monthArray addObject:monthString];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        CGFloat max = [obj[@"data"][@"max"] floatValue];
                        
                        CGFloat average = [obj[@"data"][@"average"] floatValue];
                        
                        self.homeView.countView.average = average;
                        self.homeView.countView.max = max;
                        
                        [Utils drawChartLineWithLineChart:self.homeView.countView.lineChart andXArray:monthArray andYArray:monthCountArray andMax:max andAverage:average andTitle:@"开户量"];
                        
                        
                        self.homeView.countView.accountsOpenedArr = monthCountArray;
                        self.homeView.countView.accountsOpenedMonthArr = monthArray;
                        [self.homeView.countView setNeedsDisplay];
                    });
                }
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

//请求消息中心数据，对比做小红点显示
- (void)requestFirstPageNews{
    int linage = (screenHeight-64)/40.0;
    NSString *linageString = [NSString stringWithFormat:@"%d",linage];
    [WebUtils requestMessageListWithLinage:linageString andPage:@"1" andCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];

            if([code isEqualToString:@"10000"]){
                
                NSArray *noticeArray = obj[@"data"][@"notice"];
                NSDictionary *newsDic = noticeArray.firstObject;
                
                NSString *latestNewsDateString = [[newsDic  objectForKey:@"updateDate"] componentsSeparatedByString:@"."].firstObject;
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                
                NSString *beforeNewsDateString = [ud objectForKey:@"latestNews"];//先得到之前的再同步
                
                BOOL isClickedNewsCenter = [ud boolForKey:@"isClickedNewsCenter"];
                
                [ud setObject:latestNewsDateString forKey:@"latestNews"];
                [ud synchronize];
                
                if (beforeNewsDateString) {
                    //对比现在得到的和之前保存的新闻日期
                    int result = [Utils compareDateWithNewDate:latestNewsDateString andOldDate:beforeNewsDateString];
                    
                    switch (result) {
                        case 0:
                        case -1:
                        {
                            if (isClickedNewsCenter) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"readNotification" object:nil];
                            }else{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadNotification" object:nil];
                            }
                            //一样
                        }
                            break;
                        case 1:
                        {
                            //new大
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadNotification" object:nil];
                        }
                            break;
                    }
                    
                }else{
                    
                    if (noticeArray.count == 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"readNotification" object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"unreadNotification" object:nil];
                    }
                }
                
                //正确
                int count = [obj[@"data"][@"count"] intValue];
                
                if (count == 0) {
                    
                }else{
                    
                }
            }else{
                
            }
        }
    }];
}

- (void)requestForRedBagInfo {
    @WeakObj(self)
    [self showWaitView];
    [WebUtils agency_isNeedToRegisterWithParams:@{} andCallback:^(id obj) {
        @StrongObj(self)
        NSLog(@"obj = %@", obj);
        [self hideWaitView];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                NSDictionary *dataDic = dic[@"data"];
                if (dataDic[@"registerFlag"] != nil && [dataDic[@"registerFlag"] isEqualToString:@"Y"]) {
                    // 需要补登资料
                    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:@"您的个人资料不完整，请先将资料补充完整" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            RedBagFillInfoVC *vc = [[RedBagFillInfoVC alloc] initWithForType:RedBagFillInfoVCTypeRegistration isCompare:NO];
                            vc.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        });
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    //修改message
                    NSString *alertMsg = @"您的个人资料不完整，请先将资料补充完整";
                    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:alertMsg];
                    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] range:NSMakeRange(0, alertMsg.length)];
                    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, alertMsg.length)];
                    [alertCtrl setValue:alertControllerMessageStr forKey:@"attributedMessage"];
                    // 修改按钮颜色
                    [cancelAction setValue:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forKey:@"titleTextColor"];
                    [sureAction setValue:[UIColor colorWithRed:236/255.0 green:108/255.0 blue:0/255.0 alpha:1.0] forKey:@"titleTextColor"];
                    
                    [alertCtrl addAction:cancelAction];
                    [alertCtrl addAction:sureAction];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alertCtrl animated:YES completion:nil];
                    });
                } else {
                    // 不需要补登，直接进入
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LuckdrawViewController *vc = [[LuckdrawViewController alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
            } else {
                [Utils toastview:dic[@"mes"]];
                return;
            }
        }
    }];
}


@end
