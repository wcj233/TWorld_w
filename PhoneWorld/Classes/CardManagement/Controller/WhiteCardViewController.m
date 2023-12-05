//
//  WhiteCardViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/19.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "WhiteCardViewController.h"
#import "WhiteCardView.h"
#import "WhitePhoneModel.h"
#import "ReadCardAndChoosePackageViewController.h"
#import "NormalTableViewCell.h"

@interface WhiteCardViewController ()

@property (nonatomic) WhiteCardView *whiteCardView;
@property (nonatomic) NSMutableArray *randomPhoneNumbersArray;

@end

@implementation WhiteCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"号码选择";
    
    self.randomPhoneNumbersArray = [NSMutableArray array];
    
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    self.whiteCardView = [[WhiteCardView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.whiteCardView];
    
    [self requestWhiteNumberPool];
    
    @WeakObj(self);
    [self.whiteCardView setWhiteCardSelectCallBack:^(NSString *numberpool, NSString *numberType) {
        @StrongObj(self);
        [self requestRandomNumbersWithNumberPool:numberpool andNumberType:numberType];
    }];
    
    
    [self.whiteCardView setChangeCallBack:^(id obj) {
        //换一批,就是用同一个方法再请求一遍，后台返回的数据就是随机的数据
        @StrongObj(self);
        [self requestRandomNumbersWithNumberPool:self.whiteCardView.selectView.currentPoolId andNumberType:self.whiteCardView.selectView.currentType];
        
    }];
    
    [self.whiteCardView setNextCallBack:^(id obj) {
        //下一步
        @StrongObj(self);
        ReadCardAndChoosePackageViewController *vc = [[ReadCardAndChoosePackageViewController alloc] init];
        vc.infos = @[self.whiteCardView.currentCell.phoneLB.text];
        vc.currentPoolId = self.whiteCardView.selectView.currentPoolId;
        vc.currentType = self.whiteCardView.selectView.currentType;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

//根据号码池和靓号规则返回随机号码
- (void)requestRandomNumbersWithNumberPool:(NSString *)numberpool andNumberType:(NSString *)numberType{
    
    @WeakObj(self);
    self.randomPhoneNumbersArray = [NSMutableArray array];
    
    [WebUtils requestPhoneNumbersWithNumberPool:[numberpool intValue] andNumberType:numberType andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *codeStr = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([codeStr isEqualToString:@"10000"]) {
                if ([obj[@"data"][@"numbers"] isKindOfClass:[NSNull class]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.whiteCardView.randomPhoneNumbers = @[];
                        [self.whiteCardView.contentView reloadData];
                    });
                    
                }else{
                    NSArray *objArr = obj[@"data"][@"numbers"];
                    if (objArr.count == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.whiteCardView.randomPhoneNumbers = @[];
                            [self.whiteCardView.contentView reloadData];
                        });
                    }else if(objArr.count > 0){
                        for (NSDictionary *dic in objArr) {
                            WhitePhoneModel *pModel = [[WhitePhoneModel alloc] initWithDictionary:dic error:nil];
                            
                            pModel.pool = numberpool;
                            pModel.rules = numberType;
                            
                            [self.randomPhoneNumbersArray addObject:pModel];
                        }
                        self.whiteCardView.randomPhoneNumbers = self.randomPhoneNumbersArray;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.whiteCardView.contentView reloadData];
                        });
                    }
                }
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

//返回号码池以及靓号规则
- (void)requestWhiteNumberPool{
    @WeakObj(self);
    [WebUtils requestWhiteCardPhoneNumbersWithCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            if ([obj[@"code"] isEqualToString:@"10000"]) {
                NSArray *numberPoolArr = obj[@"data"][@"numberpool"];
                self.whiteCardView.selectView.numberPoolArray = numberPoolArr;
                NSArray *numberTypeArr = obj[@"data"][@"numbetrType"];
                self.whiteCardView.selectView.numberTypeArray = numberTypeArr;
                
                NSDictionary *poolDic = numberPoolArr.firstObject;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    /*--查询得到号码池和靓号规则之后用第一个--*/
                    
                    //默认筛选栏中就是第一个号码池和靓号规则
                    for (int i = 0; i < 2; i ++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        NormalTableViewCell *cell = [self.whiteCardView.selectView.filterTableView cellForRowAtIndexPath:indexPath];
                        
                        if (i == 0) {
                            cell.detailLabel.text = [NSString stringWithFormat:@"%@",poolDic[@"name"]];
                        }else{
                            cell.detailLabel.text = [NSString stringWithFormat:@"%@",numberTypeArr.firstObject];
                        }
                    }
                    
                    self.whiteCardView.selectView.currentPoolId = poolDic[@"id"];
                    self.whiteCardView.selectView.currentType = numberTypeArr.firstObject;
                    
                    if (numberTypeArr.count <= 0) {
                        return ;
                    }
                    
                    [self requestRandomNumbersWithNumberPool:poolDic[@"id"] andNumberType:numberTypeArr.firstObject];
                });
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

@end
