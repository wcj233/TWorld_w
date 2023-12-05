//
//  NewFinishedCardResultViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/31.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "NewFinishedCardResultViewController.h"
#import "FailedView.h"
#import "NewFinishedCardSignViewController.h"

@interface NewFinishedCardResultViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImageView;

@property (nonatomic) FailedView *finishedView;

@property (nonatomic) FailedView *processView;

@property (nonatomic,retain)NSMutableArray *textArray;

@property (nonatomic) NSString *sumMoney;


@property (nonatomic,retain)UIImage *agreementImage;
@end

@implementation NewFinishedCardResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"结算明细";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont14]} forState:UIControlStateNormal];
    
    
    _textArray=[NSMutableArray arrayWithArray:@[
                 [NSString stringWithFormat:@"开户号码：%@",_detailModel.number],
                 [NSString stringWithFormat:@"预存金额：%@",_moneyString],
                 @"套餐金额：",
                 [NSString stringWithFormat:@"活动包：%@",self.currentPromotionDictionary[@"name"]],
                 @"优惠金额：",
                 @"总金额："
                 ]];
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    
    @WeakObj(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @StrongObj(self);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self requestAllMoney];
        }else{
            [Utils toastview:@"无网络"];
        }
    }];
 [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

//得到总金额
- (void)requestAllMoney{
    @WeakObj(self);
    [WebUtils requestMoneyInfoWithPrestore:self.moneyString andPromotionId:self.currentPromotionDictionary[@"id"] andCallBack:^(id obj) {
        @StrongObj(self);
        if (![obj isKindOfClass:[NSError class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                
                
                //得到总金额
                NSString *sumString = [NSString stringWithFormat:@"%@",obj[@"data"][@"sum"]];
              
                
                //套餐金额与总金额一致
             
                
                self.sumMoney = sumString;
                
                //得到优惠金额
                NSInteger money = self.moneyString.integerValue;
                NSInteger sumMoney = sumString.integerValue;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.textArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"套餐金额：%@",sumString]];
                    [self.textArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"优惠金额：%ld",money - sumMoney]];
                    [self.textArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"总金额：%@",sumString]];
                    [self.tableView reloadData];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (void)cancelAction{
    /*
     不保存信息并返回首页
     */
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier=@"NewFinishedCardResultTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font=font16;
        cell.textLabel.textColor=[UIColor colorWithWhite:0.6 alpha:1];
    }
    
    cell.textLabel.text=_textArray[indexPath.row];
    return cell;
}

- (IBAction)submit:(id)sender {
    
    if (!self.agreementImage) {
        [Utils toastview:@"请先同意协议"];
        return;
    }
    
    @WeakObj(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.processView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交" andDetail:@"请耐心等待..." andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:self.processView];
    });
    
    
    NSMutableDictionary *sendDictionary = [self.collectionInfoDictionary mutableCopy];
    
    [sendDictionary setObject:self.detailModel.number forKey:@"number"];
//    NSString *autoString = @"手工";
//    if (self.isAuto) {
//        autoString = @"读取";
//    }
    NSString *autoString = @"App扫描";
    if (self.isFace) {
        autoString = @"App人脸识别";
    }else if (self.cardMode==2) {//识别仪
        autoString = @"App识别仪";
    }
    
    [sendDictionary setObject:autoString forKey:@"authenticationType"];
    NSString *simid = [NSString stringWithFormat:@"%d",self.detailModel.simId];
    [sendDictionary setObject:simid forKey:@"simId"];
    [sendDictionary setObject:self.detailModel.simICCID forKey:@"simICCID"];
    [sendDictionary setObject:self.currentPackageDictionary[@"id"] forKey:@"packageId"];
    [sendDictionary setObject:self.currentPromotionDictionary[@"id"] forKey:@"promotionsId"];
    [sendDictionary setObject:self.sumMoney forKey:@"orderAmount"];
    NSString *orgId = [NSString stringWithFormat:@"%d",self.detailModel.org_number_poolsId];
    [sendDictionary setObject:orgId forKey:@"org_number_poolsId"];
    
    
    [sendDictionary setObject:[Utils imagechange:_agreementImage] forKey:@"photoAgreement"];
    
    if (self.fourImageDic) {
        [WebUtils requestSetOpenWithFourImages:self.fourImageDic andVideoDic:self.videoImageDic andInfoDictionary:sendDictionary andcallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                //提示框删除
                [self.processView removeFromSuperview];
            });
            
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self successAction];
                    });
                    
                    
                }else{
                    NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self popWarningViewWithMes:mes andType:@"成卡"];
                        
                    });
                }
            }
        }];
    }else{//直接上传四张图片和协议
        //提交操作
        [WebUtils requestSetOpenWithDictionary:sendDictionary andcallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                //提示框删除
                [self.processView removeFromSuperview];
            });
            
            if (![obj isKindOfClass:[NSError class]]) {
                
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self successAction];
                    });
                    
                    
                }else{
                    NSString *mes = [NSString stringWithFormat:@"%@",obj[@"mes"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self popWarningViewWithMes:mes andType:@"成卡"];
                        
                    });
                }
            }
        }];
    }
    
}


- (void)popWarningViewWithMes:(NSString *)mes andType:(NSString *)type{
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:mes];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:mes message:@"是否重新提交该订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [[alertControllerStr string] length])];
    [ac setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submit:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [ac addAction:action1];
    [ac addAction:action2];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)successAction{
    NSString *message = @"订单提交成功！";
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:message];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, message.length)];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    if ([ac valueForKey:@"attributedTitle"]) {
        [ac setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    
    [ac addAction:action1];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)agreement:(id)sender {
    
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"NewFinishedCard" bundle:nil];
    NewFinishedCardSignViewController *vc=[story instantiateViewControllerWithIdentifier:@"NewFinishedCardSignViewController"];
    WEAK_SELF
    [vc setSignBlock:^(UIImage *image) {
        weakSelf.agreementImage=image;
        weakSelf.checkmarkImageView.image=[UIImage imageNamed:@"gou.jpg"];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
