//
//  HomeView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/12.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "HomeView.h"
#import "HomeCell.h"
#import "TopCallMoneyViewController.h"  //话费充值
#import "CheckAndTopViewController.h"  //余额查询与充值
#import "TransferCardViewController.h"//过户
#import "FinishCardViewController.h"//成卡开户
#import "WhiteCardViewController.h"//白卡开户
#import "CardRepairViewController.h"//补卡
#import "ChooseEntryViewController.h"//靓号平台
#import "WhitePrepareOpenOneViewController.h"//白卡预开户-渠道商
#import "AgentNumberListViewController.h"//白卡预开户-代理商
#import "AgentWhiteRecordViewController.h"//代理商预开户记录
#import "LIdentifyPhoneNumberViewController.h"//产品购买
#import "LuckdrawViewController.h"//红包抽奖
#import "BillInquiryViewController.h"//账单查询
#import "ChooseWayViewController.h"
#import "ChooseCardListVC.h" //写卡开户
#import "NewFinishedCardSignViewController.h"

#pragma mark -201911期
#import "BusinessPagingVC.h"

#define sc 195/375.0  //首页轮播图 高／宽
#define cv 260/375.0  //collectionView  高／宽

#define hw 312.0/375.0//开户量高／宽


@interface HomeView ()

@property (nonatomic) NSArray *imageNames;
@property (nonatomic) NSArray *titleNames;

@end

@implementation HomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageScrollView];//轮播图
        
        
        /*--------靓号隐藏--------*/
//        //区分用户等级
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSString *grade = [ud objectForKey:@"grade"];
//        if ([grade isEqualToString:@"lev1"] || [grade isEqualToString:@"lev2"]) {
//            //代理商 功能少
//
//            self.imageNames = @[@"business_icon_preparerecord_big",@"home_icon_whiteprepare_big"];
//            self.titleNames = @[@"预开户记录",@"白卡预开户"];
//            [self fastCollectionView];
//            [self countView];
//
//        }else if([grade isEqualToString:@"lev3"]){
//            //渠道商  功能多  lev0
//            self.imageNames = @[@"home_icon_telephoneexpenses_big",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_whiteestablish_big",@"home_icon_fill_big",@"business_icon_purchase",@"home_icon_whiteprepare_big"];
//            self.titleNames = @[@"话费充值",@"账户充值",@"过户",@"成卡开户",@"白卡开户",@"补卡",@"产品购买",@"白卡预开户"];
//            [self fastCollectionView];
//        }else{
//            //lev0 总 话机最高帐号
//            self.imageNames = @[@"home_icon_telephoneexpenses_big",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_whiteestablish_big",@"home_icon_fill_big",@"business_icon_purchase",@"home_icon_whiteprepare_big"];
//            self.titleNames = @[@"话费充值",@"账户充值",@"过户",@"成卡开户",@"白卡开户",@"补卡",@"产品购买",@"白卡预开户"];
//            [self fastCollectionView];
//        }
        
        /*--------靓号不隐藏--------*/
        //区分用户等级
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *grade = [ud objectForKey:@"grade"];
        if ([grade isEqualToString:@"lev1"] || [grade isEqualToString:@"lev2"]) {
            //代理商 功能少
            
            //self.imageNames = @[@"home_icon_platform_big",@"business_icon_preparerecord_big",@"home_icon_whiteprepare_big"];
//            self.imageNames=@[@"business_icon_preparerecord_big",@"home_icon_whiteprepare_big"];
            self.imageNames=@[@"business_icon_preparerecord_big",@"home_icon_whiteprepare_big",@"home_icon_bill"];
            //self.titleNames = @[@"靓号",@"预开户记录",@"白卡预开户"];
//            self.titleNames=@[@"预开户记录",@"白卡预开户"];
            self.titleNames=@[@"预开户记录",@"白卡预开户",@"子账户开户记录"];
            [self fastCollectionView];
            [self countView];
            
        }else if([grade isEqualToString:@"lev3"]){
            //渠道商  功能多  lev0
//            self.imageNames=@[@"home_icon_telephoneexpenses_big",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_fill_big",@"home_icon_platform_big",@"business_icon_purchase",@"home_icon_whiteredbg_big",@"home_icon_bill",@"xkjh_icon_establish"];
//            self.titleNames=@[@"话费充值",@"账户充值",@"过户",@"成卡开户",@"补卡",@"靓号",@"流量包",@"红包抽奖",@"账单查询",@"写卡激活"];
            self.imageNames=@[@"Business_icon",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_fill_big",@"home_icon_platform_big",@"home_icon_whiteredbg_big",@"home_icon_bill",@"xkjh_icon_establish"];

            self.titleNames=@[@"业务办理",@"账户充值",@"过户",@"成卡开户",@"补卡",@"靓号",@"红包抽奖",@"账单查询",@"写卡激活"];
            

            [self fastCollectionView];
        }else{
            //lev0 总 话机最高帐号
            //self.imageNames = @[@"home_icon_telephoneexpenses_big",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_whiteestablish_big",@"home_icon_fill_big",@"home_icon_platform_big",@"business_icon_purchase",@"home_icon_whiteprepare_big"];
            //self.titleNames = @[@"话费充值",@"账户充值",@"过户",@"成卡开户",@"白卡开户",@"补卡",@"靓号",@"流量包",@"白卡预开户"];
//            self.imageNames=@[@"home_icon_telephoneexpenses_big",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_whiteestablish_big",@"home_icon_fill_big",@"business_icon_purchase",@"home_icon_whiteprepare_big"];
//            self.titleNames=@[@"话费充值",@"账户充值",@"过户",@"成卡开户",@"白卡开户",@"补卡",@"流量包",@"白卡预开户"];
            
//            self.imageNames=@[@"home_icon_telephoneexpenses_big",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_fill_big",@"business_icon_purchase",@"home_icon_whiteprepare_big"];
            self.imageNames=@[@"Business_icon",@"home_icon_recharge_big",@"home_icon_ownership_big",@"home_icon_establish_big",@"home_icon_whiteestablish_big",@"home_icon_fill_big",@"home_icon_whiteprepare_big",@"home_icon_bill",@"xkjh_icon_establish"];
//            self.titleNames=@[@"话费充值",@"账户充值",@"过户",@"成卡开户",@"补卡",@"流量包",@"红包抽奖"];
            self.titleNames=@[@"业务办理",@"账户充值",@"过户",@"成卡开户",@"白卡开户",@"补卡",@"白卡预开户",@"账单查询",@"写卡激活"];

            [self fastCollectionView];
        }
    }
    return self;
}

- (CountView *)countView{
    if (_countView == nil) {
        _countView = [[[CountView alloc] init]initWithFrame:CGRectZero andTitle:@"开户量"];
        [self addSubview:_countView];
        [_countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fastCollectionView.mas_bottom).mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenWidth * hw + 20);
            make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(0);
        }];
    }
    return _countView;
}


#pragma mark - LazyLoading
- (SDCycleScrollView *)imageScrollView{
    if (_imageScrollView == nil) {        
        _imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
        _imageScrollView.contentMode = UIViewContentModeScaleAspectFit;
        _imageScrollView.backgroundColor = COLOR_BACKGROUND;
        [self addSubview:_imageScrollView];
        _imageScrollView.autoScrollTimeInterval = 5.0;
        _imageScrollView.currentPageDotColor = MainColor;
        [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenWidth*sc);
        }];
    }
    return _imageScrollView;
}

- (UICollectionView *)fastCollectionView{
    if (_fastCollectionView == nil) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat height = (screenWidth / 376.0) * 112.0;
        int rowNumber = 1;
        if (self.imageNames.count > 6) {
#warning 超过9个Icon 改成 >3的数
            rowNumber = 3;
        }
        
        NSLog(@"collectionViewHeight = %f",height);
        
        
        _fastCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        
        _fastCollectionView.backgroundColor = COLOR_BACKGROUND;
        _fastCollectionView.delegate = self;
        _fastCollectionView.dataSource = self;
        [_fastCollectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_fastCollectionView];
        
        if (rowNumber == 1) {
            [_fastCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.imageScrollView.mas_bottom).mas_equalTo(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(height * rowNumber);
                make.width.mas_equalTo(screenWidth);
            }];
        }else{
            [_fastCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.imageScrollView.mas_bottom).mas_equalTo(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(height * rowNumber);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(screenWidth);
            }];
        }        
    }
    return _fastCollectionView;
}

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    _HomeHeadScrollCallBack(index);
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
    cell.titleLb.text = self.titleNames[indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (screenWidth - 4)/3.0;
    CGFloat height = (screenWidth / 376.0) * 112.0 - 1;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    UIViewController *viewCon = [self viewController];
    
    #pragma mark - 数量别忘记了
    if (self.imageNames.count == 3) {
        switch (indexPath.row) {
//            case 0:
//            {
////                [Utils toastview:@"该功能待开发，敬请期待！"];
//
//                AgentNumberListViewController *vc = [[AgentNumberListViewController alloc] init];
//                vc.typeString = @"代理商靓号平台";
//                vc.title = @"靓号平台";
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
//            }
//                break;
            case 0:
            {
//                [Utils toastview:@"该功能待开发，敬请期待！"];

                AgentWhiteRecordViewController *vc = [AgentWhiteRecordViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
                [Utils toastview:@"该功能待开发，敬请期待！"];

//                AgentNumberListViewController *vc = [[AgentNumberListViewController alloc] init];
//                vc.title = @"号码列表";
//                vc.typeString = @"代理商白卡预开户";
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //子账户开户记录
                UIStoryboard* story = [UIStoryboard storyboardWithName:@"Subaccount" bundle:nil];
                UIViewController *vc=[story instantiateViewControllerWithIdentifier:@"SubaccountEstablishViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
            {
//话费充值
//                NSInteger i0 = [ud integerForKey:@"phoneRecharge"];
//                i0 = i0 + 1;
//                [ud setInteger:i0 forKey:@"phoneRecharge"];
//                [ud synchronize];
//                TopCallMoneyViewController *vc = [TopCallMoneyViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
                
//业务办理
                BusinessPagingVC *vc = [BusinessPagingVC new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {
//账户充值
                NSInteger i1 = [ud integerForKey:@"accountRecharge"];
                i1 = i1 + 1;
                [ud setInteger:i1 forKey:@"accountRecharge"];
                [ud synchronize];
                CheckAndTopViewController *vc = [CheckAndTopViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
//@"过户"
                NSInteger i2 = [ud integerForKey:@"transform"];
                i2 = i2 + 1;
                [ud setInteger:i2 forKey:@"transform"];
                [ud synchronize];
                TransferCardViewController *vc = [TransferCardViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
//@"成卡开户"
                NSInteger i3 = [ud integerForKey:@"renewOpen"];
                i3 = i3 + 1;
                [ud setInteger:i3 forKey:@"renewOpen"];
                [ud synchronize];
//                FinishCardViewController *vc = [FinishCardViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
                ChooseWayViewController *vc = [[ChooseWayViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
//            case 4:
//            {
//
////                [Utils toastview:@"该功能待开发，敬请期待！"];
//
////                白卡开户
//                NSInteger i4 = [ud integerForKey:@"replace"];
//                i4 = i4 + 1;
//                [ud setInteger:i4 forKey:@"replace"];
//                [ud synchronize];
//                WhiteCardViewController *vc = [WhiteCardViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
//
//            }
//                break;
            case 4:
            {
                
                //                补卡
                CardRepairViewController *vc = [CardRepairViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 5:
            {
//                [Utils toastview:@"该功能待开发，敬请期待！"];
                //渠道商靓号平台
                ChooseEntryViewController *vc = [[ChooseEntryViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
//            case 6:
//            {
//
////流量包
////                [Utils toastview:@"该功能待开发，敬请期待！"];
//
//                LIdentifyPhoneNumberViewController *vc = [LIdentifyPhoneNumberViewController new];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 7:
//            {
//
////白卡预开户
////                [Utils toastview:@"该功能待开发，敬请期待！"];
//
//                //渠道商白卡预开户
//                WhitePrepareOpenOneViewController *vc = [[WhitePrepareOpenOneViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
//            }
//                break;
            case 6:
            {

                //红包抽奖
//                [Utils toastview:@"该功能待开发，敬请期待！"];
                
                if (self.redBagClickBlock) {
                    self.redBagClickBlock();
                }

//                LuckdrawViewController *vc = [[LuckdrawViewController alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            case 7:
            {
                //账单查询
                UIStoryboard* story = [UIStoryboard storyboardWithName:@"Bill" bundle:nil];
                UIViewController *vc=[story instantiateViewControllerWithIdentifier:@"BillInquiryViewController"];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 8:{
                // 写卡激活
                ChooseCardListVC *vc = ChooseCardListVC.new;
//                UIStoryboard* story = [UIStoryboard storyboardWithName:@"NewFinishedCard" bundle:nil];
//                NewFinishedCardSignViewController *vc=[story instantiateViewControllerWithIdentifier:@"NewFinishedCardSignViewController"];
//                WEAK_SELF
//                [vc setSignBlock:^(UIImage *image) {
////                    weakSelf.agreementImage=image;
////                    weakSelf.checkmarkImageView.image=[UIImage imageNamed:@"gou.jpg"];
//                }];
                vc.hidesBottomBarWhenPushed = YES;
                [viewCon.navigationController pushViewController:vc animated:YES];
            }

        }
    }
}

@end
