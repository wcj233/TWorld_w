//
//  CardManageView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "CardManageView.h"
#import "AccountTVCell.h"

@interface CardManageView ()

@property (nonatomic) NSArray *imageNames;
@property (nonatomic) NSArray *titles;

@end

@implementation CardManageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //区分用户等级
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *grade = [ud objectForKey:@"grade"];
        if ([grade isEqualToString:@"lev1"] || [grade isEqualToString:@"lev2"]) {
            self.imageNames = @[@"home_icon_preparerecord_big",@"business_icon_purchase_small"];
            self.titles = @[@"预开户记录",@"子账户开户记录"];
            
        }else if([grade isEqualToString:@"lev3"]){
            self.imageNames = @[@[@"Business_icon",@"home_icon_ownership_big",@"card_2"],@[@"home_icon_fill_big"],@[@"business_icon_bremaining",@"bill",@"number", @"order_icon_ownership_small-1",@"2020order_icon_ownership_last"]];
            self.titles = @[@[@"业务办理",@"过户",@"成卡开户"],@[@"补卡"],@[@"话费余额查询",@"账单查询",@"靓号", @"预订单生成", @"白卡申请"]];
        }else{
            self.imageNames = @[@"home_icon_establish_big",@"home_icon_ownership_big",@"home_icon_fill_big",@"Business_icon",@"business_icon_bremaining",@"business_icon_purchase_small"];
            self.titles = @[@"成卡开户",@"过户",@"补卡",@"业务办理",@"话费余额查询",@"账单查询"];
        }

        [self cardTableView];
    }
    return self;
}

- (UITableView *)cardTableView{
    if (_cardTableView == nil) {
        _cardTableView = [[UITableView alloc] init];
        [self addSubview:_cardTableView];
        [_cardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        _cardTableView.backgroundColor = COLOR_BACKGROUND;
        _cardTableView.tableFooterView = [UIView new];
        _cardTableView.delegate = self;
        _cardTableView.dataSource = self;
        [_cardTableView registerClass:[AccountTVCell class] forCellReuseIdentifier:@"acell"];
        if (@available(iOS 11.0, *)) {
            _cardTableView.estimatedSectionHeaderHeight = 0;
            _cardTableView.estimatedSectionFooterHeight = 0;
            _cardTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _cardTableView;
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *grade = [ud objectForKey:@"grade"];
    if ([grade isEqualToString:@"lev3"]) {
        return 3;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *grade = [ud objectForKey:@"grade"];
    if ([grade isEqualToString:@"lev3"]) {
        NSArray *arr = self.imageNames[section];
        return arr.count;
    }
    return self.imageNames.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"acell" forIndexPath:indexPath];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *grade = [ud objectForKey:@"grade"];
    if ([grade isEqualToString:@"lev3"]) {
        NSArray *images = self.imageNames[indexPath.section];
        NSArray *titles = self.titles[indexPath.section];
        cell.imageV.image = [UIImage imageNamed:images[indexPath.row]];
        cell.titleLB.text = titles[indexPath.row];
        
        if (indexPath.row == 2&&indexPath.section == 2) {
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
    }else{
        cell.imageV.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
        cell.titleLB.text = self.titles[indexPath.row];
        
        if (indexPath.row == self.titles.count-1) {
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
        }
    }
    
    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.myCallBack) {
        AccountTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.myCallBack(cell.titleLB.text);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *grade = [ud objectForKey:@"grade"];
    if ([grade isEqualToString:@"lev3"]) {
        return 5;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

@end
