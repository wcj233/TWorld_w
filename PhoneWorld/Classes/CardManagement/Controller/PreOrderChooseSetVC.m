//
//  PreOrderChooseSetVC.m
//  PhoneWorld
//
//
// Created by 黄振元 on 2019/4/24.
// Copyright © 2019 xiyoukeji. All rights reserved.
//
// @class PreOrderChooseSetVC
// @abstract 预订单生成VC ，第二步，套餐选择
//

#import "PreOrderChooseSetVC.h"

// Controllers
#import "ChoosePackageDetailViewController.h"
#import "InformationCollectionViewController.h"
#import "CreateQrcodeVC.h"

// Model

// Views
#import "DetailTableViewCell.h"
#import "DisplayTableViewCell.h"


@interface PreOrderChooseSetVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray0;
@property (strong, nonatomic) NSArray *titleArray1;
@property (strong, nonatomic) NSMutableArray *packagesDic;// 所有套餐
@property (strong, nonatomic) NSDictionary *currentDic;//当前选中套餐
@property (strong, nonatomic) NSDictionary *currentPromotionDic;//当前选中活动包

@end


@implementation PreOrderChooseSetVC

#pragma mark - View Controller LifeCyle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"套餐选择";
    self.view.backgroundColor = kSetColor(@"FBFBFB");
    
    self.titleArray0 = @[@"号码", @"归属地", @"运营商", @"预存话费", @"状态"];
    self.titleArray1 = @[@"套餐选择", @"活动包选择"];
    
//    self.packagesDic = @[].mutableCopy;
    self.packagesDic = [NSMutableArray arrayWithArray:self.mobileModel.packages];
    //    [self.mobileModel.packages enumerateObjectsUsingBlock:^(PreOrderMobilePackageModel * _Nonnull subModel, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        NSMutableDictionary *subDic = @{}.mutableCopy;
//        subDic[@"id"] = subModel.packageId;
//        subDic[@"name"] = subModel.name;
//        subDic[@"productDetails"] = subModel.productDetails;
//
//        [self.packagesDic addObject:subDic];
//    }];
    
    [self createMain];
    NSLog(@"detailModel = %@", self.mobileModel);
}


#pragma mark - Override Methods


#pragma mark - Initial Methods


#pragma mark - Privater Methods

- (void)createMain {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, get6W(220))];
    footView.backgroundColor = kSetColor(@"FBFBFB");
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = kSetColor(@"EC6C00");
    nextBtn.layer.cornerRadius = 4;
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footView);
        make.top.mas_equalTo(get6W(90));
        make.size.mas_equalTo(CGSizeMake(get6W(170), get6W(40)));
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - kTopHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = kSetColor(@"FBFBFB");
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    tableView.tableFooterView = footView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.estimatedRowHeight = 100;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma mark - Target Methods

- (void)nextBtnClick:(UIButton *)btn {
    if (!self.currentDic) {
        [Utils toastview:@"请选择套餐"];
        return;
    }
    
    if (!self.currentPromotionDic) {
        [Utils toastview:@"请选择活动包"];
        return;
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"number"] = self.mobileModel.number;
    params[@"packagesId"] = self.currentDic[@"id"];
    params[@"promotionId"] = self.currentPromotionDic[@"id"];
    
    WEAK_SELF
    [self showWaitView];
    [WebUtils agencySelectionQrcodeWithParams:params andCallback:^(id obj) {
        [self hideWaitView];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
            if ([dic[@"code"] integerValue] == 10000) {
                NSString *url = dic[@"data"][@"url"];
                NSLog(@"url = %@", url);
                dispatch_async(dispatch_get_main_queue(), ^{
                    CreateQrcodeVC *vc = [[CreateQrcodeVC alloc] init];
                    vc.qrcodeUrl = url;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                });
            } else {
                [Utils toastview:dic[@"mes"]];
                return;
            }
        }
    }];
}


#pragma mark - Public Methods


#pragma mark - Notification Methods


#pragma mark - KVO Methods


#pragma mark - Getter Setter Methods


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"";
    NSString *placeholder = @"";
    BaseTableViewCell *baseCell;
    
//    switch (indexPath.row) {
//        case 0:{
//            text=_phone.number;
//            break;
//        }
//        case 1:{
//            text=_phone.cityName;
//            break;
//        }
//        case 2:{
//            text=_phone.operatorName;
//            break;
//        }
//        case 3:{
//            text=_phone.prestore;
//            break;
//        }
//        case 4:{
//            text=_phone.numberStatus;
//            break;
//        }
//        case 5:{
//            text=_currentDic[@"name"];
//            placeholder=@"请选择";
//            break;
//        }
//        case 6:{
//            text=_currentPromotionDic[@"name"];
//            placeholder=@"请选择";
//            break;
//        }
//        default:
//            break;
//    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                text = self.mobileModel.number;
                break;
            case 1:
                text = self.mobileModel.cityName;
                break;
            case 2:
                text = self.mobileModel.operatorName;
                break;
            case 3:
                text = self.mobileModel.prestore;
                break;
            case 4:
                text = self.mobileModel.numberStatus;
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                text = self.currentDic[@"name"];
                placeholder = @"请选择";
            }
                break;
            case 1:
            {
                text = self.currentPromotionDic[@"name"];
                placeholder = @"请选择";
            }
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 0) {
        // 基本信息
        DisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DisplayTableViewCell"];
        if (cell == nil) {
            cell=[[DisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DisplayTableViewCell"];
        }

        [cell setContentWithDetail:text];
        [cell setContentWithTitle:[self.titleArray0 objectAtIndex:indexPath.row]];

        return cell;
    } else if (indexPath.section == 1) {
        // 套餐以及活动包选择
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
        if (cell == nil) {
            cell=[[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailTableViewCell"];
        }

        [cell setContentWithDetail:text placeholder:placeholder];
        [cell setContentWithTitle:[self.titleArray1 objectAtIndex:indexPath.row]];

        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 套餐选择
        ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
        vc.title = @"套餐选择";
        vc.packagesDic = self.packagesDic;//所有套餐

        @WeakObj(self)
        [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
            @StrongObj(self)
            self.currentDic = currentDic;
            [self.tableView reloadData];

            NormalTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
            cell.detailLabel.text = @"请选择";
            self.currentPromotionDic = nil;
        }];

        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        if (!self.currentDic[@"id"]) {
            [Utils toastview:@"套餐未选择"];
        } else {
            ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
            vc.title = @"活动包选择";

            @WeakObj(self)
            [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                @StrongObj(self)

                self.currentPromotionDic = currentDic;
                [self.tableView reloadData];
            }];

            vc.currentID = self.currentDic[@"id"];//当前选中套餐ID
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, get6W(22))];
        view.backgroundColor = kSetColor(@"FBFBFB");
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 70;
    }
    return 44;
}


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
