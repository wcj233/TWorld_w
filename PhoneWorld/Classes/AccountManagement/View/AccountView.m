//
//  AccountView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/17.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "AccountView.h"
#import "AccountTVCell.h"

@interface AccountView ()

@property (nonatomic) NSArray *imageNames;
@property (nonatomic) NSArray *titles;

@end

@implementation AccountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self accountTableView];
    }
    return self;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountTVCell" forIndexPath:indexPath];
    cell.imageV.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
    cell.titleLB.text = self.titles[indexPath.row];
    if (indexPath.row == self.titles.count-1) {
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _AccountCallBack(indexPath.row);
}


#pragma mark - LazyLoading
- (UITableView *)accountTableView{
    if (_accountTableView == nil) {
        _accountTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 108) style:UITableViewStylePlain];
        [_accountTableView registerClass:[AccountTVCell class]  forCellReuseIdentifier:@"AccountTVCell"];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
        _accountTableView.backgroundColor = COLOR_BACKGROUND;
        [self addSubview:_accountTableView];
        _accountTableView.tableFooterView = [UIView new];
    }
    return _accountTableView;
}

- (NSArray *)imageNames{
    if (_imageNames == nil) {
        _imageNames = @[@"account_icon_accountenquiry"];
    }
    return _imageNames;
}

- (NSArray *)titles{
    if (_titles == nil) {
        _titles = @[@"账户查询与充值"];
    }
    return _titles;
}

@end
