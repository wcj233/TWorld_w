//
//  MemberSystemVC.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/12.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "MemberSystemVC.h"
#import "MemberSystemListCell.h"
#import "RightsModel.h"
#import "CreatePayPasswordViewController.h"

#import "PayView.h"
#import "FailedView.h"
#import "TopResultViewController.h"

@interface MemberSystemVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Prods *selectedProds;

@property (nonatomic, strong) NSString *memberAccount;

//余额
@property (nonatomic, assign) CGFloat myMoney;
//支付密码相关
@property (nonatomic) PayView *payView;//6位密码输入框
@property (nonatomic) UIView *grayView;//6位密码输入框后面的灰色半透明背景
@property (nonatomic) FailedView *processView;//支付过程提示框

@end


@implementation MemberSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self loadData];
}

- (instancetype )initWithBusinessList:(NSArray *)listArray andPhone:(NSString *)phone{
    if (self = [super init]) {
        _listArray = [listArray mutableCopy];
        _phone = phone;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //TODO: 页面appear 禁用
   [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //TODO: 页面Disappear 启用
   [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)setUI{
    UIView *topBgView = UIView.new;
    topBgView.userInteractionEnabled = YES;
//    UIGestureRecognizer
    [topBgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEditPhone)]];
    topBgView.backgroundColor = rgba(226, 226, 226, 1);
    topBgView.layer.borderColor = rgba(249, 249, 249, 1).CGColor;
    topBgView.layer.borderWidth = 1;
    [self.view addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *title = UILabel.new;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"您当前订购产品的手机号为"attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName: rgba(153, 153, 153, 1)}];
    [string appendAttributedString:[[NSMutableAttributedString alloc] initWithString:self.phone attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],NSForegroundColorAttributeName: rgba(236, 108, 0, 1)}]];
    title.attributedText = string;
    [topBgView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.centerY.mas_equalTo(topBgView);
    }];
    
    UIImageView *rIcon = [UIImageView.alloc initWithImage:kSetImage(@"order_icon_next")];
    [topBgView addSubview:rIcon];
    [rIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-15);
        make.centerY.mas_equalTo(topBgView);
    }];
    
    UILabel *editTitle = [UILabel labelWithTitle:@"更改" color:rgba(236, 108, 0, 1) fontSize:12];
    [topBgView addSubview:editTitle];
    [editTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(rIcon.mas_leading).mas_equalTo(-2);
        make.centerY.mas_equalTo(topBgView);
    }];
    
    self.tableView = UITableView.new;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.bottom.leading.trailing.mas_equalTo(self.view);
       make.top.mas_equalTo(topBgView.mas_bottom).mas_equalTo(1);
    }];
    [self.tableView registerClass:MemberSystemListCell.class forCellReuseIdentifier:@"MemberSystemListCell"];
}

- (void)loadData{
    [self.tableView reloadData];
    
//    [self requestAccountMoney];
}

#pragma mark - Action

- (void)clickEditPhone{
    [self.navigationController popViewControllerAnimated:YES];
}

//订购逻辑
- (void)showPromptConfirmationBoxForProds:(Prods *)model{
    self.memberAccount = @"";
    @WeakObj(self);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:model.name message:model.productDetails preferredStyle:UIAlertControllerStyleAlert];
    
    UIView *subView1 = ac.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
    //设置内容的对齐方式
    UILabel *mes= subView5.subviews[2];
    mes.textAlignment = NSTextAlignmentLeft;
    
    UIAlertAction *exitAa = [UIAlertAction actionWithTitle:@"退订" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        [self showUnsubscribeBoxForProds:model];
    }];
    UIAlertAction *cancelAa = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *indentAa = [UIAlertAction actionWithTitle:@"订购" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        
        if (model.memo1.intValue == 1) {
            UITextField *envirnmentNameTextField = ac.textFields.firstObject;
            
            if (envirnmentNameTextField.text.length > 0) {
                self.memberAccount = envirnmentNameTextField.text;
                [self showIndentBoxForProds:model];
            }else{
                [Utils toastview:@"请输入会员账号"];
                [self presentViewController:ac animated:YES completion:nil];
            }
        }else{
            [self showIndentBoxForProds:model];
        }
    }];
    if (model.isCancleFlag) {
        [ac addAction:exitAa];
    }else {
        [ac addAction:cancelAa];
    }
    
    if (model.memo1.intValue == 1) {
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入会员账号";
        }];
    }
    
    [ac addAction:indentAa];
    [self presentViewController:ac animated:YES completion:^{
        [ac alertTapDismiss];
    }];
}

//确认退订
- (void)showUnsubscribeBoxForProds:(Prods *)model{
    @WeakObj(self);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认退订该产品？\n%@", model.name] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAa = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *exitAa = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
//        [self getPayPasswordForProds:model andOperateType:0];
        [self orderOrUnorderForProds:model andOperateType:0];
    }];
    [ac addAction:cancelAa];
    [ac addAction:exitAa];
    [self presentViewController:ac animated:YES completion:^{
        [ac alertTapDismiss];
    }];
}

//确定订购

- (void)showIndentBoxForProds:(Prods *)model{
    NSString *attributedMessageStr = [NSString stringWithFormat:@"注：%@费用将从用户话费中扣除", model.type == 2 ? @"流量包" : @"会员"];
    
    @WeakObj(self);
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"订购信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIView *subView1 = ac.view.subviews[0];
    UIView *subView2 = subView1.subviews[0];
    UIView *subView3 = subView2.subviews[0];
    UIView *subView4 = subView3.subviews[0];
    UIView *subView5 = subView4.subviews[0];
    //设置内容的对齐方式
    UILabel *mes= subView5.subviews[2];
    mes.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", model.name] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgba(102, 102, 102, 1)}];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"价格：%0.2f元\n", model.orderAmount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgba(102, 102, 102, 1)}]];
    
    if (model.memo1.intValue == 1) {
        [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"会员账户：%@\n", self.memberAccount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgba(102, 102, 102, 1)}]];
    }
    
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:attributedMessageStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:rgba(255, 0, 31, 1)}]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str.string length])];
    
    [ac setValue:str forKey:@"attributedMessage"];
    UIAlertAction *cancelAa = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *indentAa = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @StrongObj(self);
        [self orderOrUnorderForProds:model andOperateType:1];
    }];
    [ac addAction:cancelAa];
    [ac addAction:indentAa];
    [self presentViewController:ac animated:YES completion:^{
        [ac alertTapDismiss];
    }];
}

#pragma mark - 支付密码
//isOperateType 1 订购 0 退订
- (void)getPayPasswordForProds:(Prods *)model andOperateType:(NSUInteger )isOperateType{
    @WeakObj(self);
    if (isOperateType == 1) {
        //待支付金额
        CGFloat payAmount = model.orderAmount;
        if (payAmount > self.myMoney) {
            [Utils toastview:@"余额不足"];
            return;
        }
    }
    /*
     判断用户是否有支付密码，如果没有支付密码则跳转到创建用户支付密码
     */
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL hasPayPass = [ud boolForKey:@"hasPayPassword"];
    if (hasPayPass != YES || !hasPayPass) {
        [WebUtils requestHasPayPasswordWithCallBack:^(id obj) {
            @StrongObj(self);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    //如果有支付密码
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setBool:YES forKey:@"hasPayPassword"];
                    [ud synchronize];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self payActionForProds:model andOperateType:isOperateType];
                    });
                }else{
                    //如果没有支付密码
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"该用户未创建支付密码" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"创建密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            CreatePayPasswordViewController *vc = [[CreatePayPasswordViewController alloc] init];
                            vc.type = 1;
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [ac addAction:action1];
                        [ac addAction:action2];
                        [self presentViewController:ac animated:YES completion:nil];
                    });
                }
            }
        }];
    }else{
        [self payActionForProds:model andOperateType:isOperateType];
    }
        
}

- (void)payActionForProds:(Prods *)model andOperateType:(NSUInteger )isOperateType{
    @WeakObj(self);

    /*---------支付操作----------*/
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.grayView.backgroundColor = [UIColor blackColor];
    self.grayView.alpha = 0;
    [self.view addSubview:self.grayView];
    self.payView = [[PayView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, 500)];
    [self.view addSubview:self.payView];
    
    
    [self.payView.textField becomeFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        @StrongObj(self);
        CGRect frame = self.payView.frame;
        frame.origin.y = screenHeight - 500;
        self.payView.frame = frame;
        self.grayView.alpha = 0.4;
    }];
    
    
    [self.payView setPayCallBack:^(NSString *password) {
        @StrongObj(self);
        /*
         输入完毕，支付操作
         */
        
        //弹窗显示
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在支付" andDetail:@"请稍候..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
        [self.view endEditing:YES];
        
        
        //判断网络
        if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
            [Utils toastview:@"网络不好"];
            [self.processView removeFromSuperview];
        }
        
        
        //去订购、取消逻辑
//        [self orderOrUnorderForProds:model andOperateType:isOperateType andPayPassword:password];
    }];
    
    
    //支付界面英藏
    [self.payView setClosePayCallBack:^(id obj) {
        @StrongObj(self);
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.payView.frame;
            frame.origin.y = screenHeight;
            self.payView.frame = frame;
            self.grayView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.grayView removeFromSuperview];
        }];
    }];
}

#pragma mark - Api
//- (void)orderOrUnorderForProds:(Prods *)model andOperateType:(NSUInteger )isOperateType andPayPassword:(NSString *)payPassword{
- (void)orderOrUnorderForProds:(Prods *)model andOperateType:(NSUInteger )isOperateType{
    @WeakObj(self);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"type"] = @(model.type);
    params[@"productId"] = @(model.productId);
    params[@"number"] = self.phone;
    params[@"operateType"] = @(isOperateType);
    params[@"productAmount"] = @(model.productAmount);
    params[@"orderAmount"] = @(model.orderAmount);
    if (self.memberAccount.length > 0) {
        params[@"memberAccount"] = self.memberAccount;
    }
//    params[@"payPassword"] = [Utils md5String:[NSString stringWithFormat:@"HJSJ%@2015GK#S",payPassword]];
    [WebUtils agency_2019ServiceProductWithParams:params andCallback:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.processView removeFromSuperview];
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    //支付成功
//                    [Utils toastview:obj[@"订购成功"]];
                    [self.view makeToast:obj[@"mes"] duration:2.5 position:CSToastPositionCenter title:nil image:nil style:nil completion:^(BOOL didTap) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
//                    NSString *numbers = [NSString stringWithFormat:@"%@",obj[@"data"][@"orderNo"]];
//                    dispatch_async(dispatch_get_main_queue(), ^{
    //                            self.topCallMoneyCallBack(topMoney, phoneView.textField.text,numbers, @"支付成功");
//                        [self payResultsForProds:model andisSuccessful:YES andNumbers:numbers andStatus:@""];
//                    });

                }else{
                    if (![code isEqualToString:@"39999"]) {
                        [Utils toastview:obj[@"mes"]];
//                        //支付有问题
//                        NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//    //                                self.topCallMoneyCallBack(topMoney, phoneView.textField.text, @"无", mes);
//                            [self payResultsForProds:model andisSuccessful:NO andNumbers:@"" andStatus:mes];
//                        });
                    }
                }
            }
        });
    }];
}

//返回账户当前余额
- (void)requestAccountMoney{
    @WeakObj(self);
    [WebUtils requestAccountMoneyWithCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    float money = [[NSString stringWithFormat:@"%@",obj[@"data"][@"balance"]] floatValue];
                    self.myMoney = money;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utils toastview:@"账户余额查询失败"];
                });
            }
        }
    }];
}

- (void)payResultsForProds:(Prods *)model andisSuccessful:(BOOL)isSuccessful andNumbers:(NSString *)numbers andStatus:(NSString *)status{
    NSMutableArray *allResults = [NSMutableArray array];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *locationString=[dateformatter stringFromDate:currentDate];
    
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",model.orderAmount];
    [allResults addObjectsFromArray:@[numbers,locationString,@"话费充值",moneyStr,self.phone,status]];
    
    TopResultViewController *resultView = [TopResultViewController new];
    resultView.isSucceed = NO;
    resultView.allResults = allResults;
    if (isSuccessful) {
        resultView.isSucceed = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.payView.frame;
            frame.origin.y = screenHeight;
            self.payView.frame = frame;
            self.grayView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.grayView removeFromSuperview];
            [self.navigationController pushViewController:resultView animated:YES];
        }];
    });
}

#pragma mark - UITableViewDelegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberSystemListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberSystemListCell"];
    cell.model = self.listArray[indexPath.row];
    @WeakObj(self);
    cell.selectedModelBlock = ^(Prods * _Nonnull model) {
        @StrongObj(self);
        
        [self showPromptConfirmationBoxForProds:model];
        
    };
    return cell;
}

@end
