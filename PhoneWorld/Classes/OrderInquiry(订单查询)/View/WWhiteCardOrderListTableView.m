//
//  WWhiteCardOrderListTableView.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderListTableView.h"
#import "WWhiteCardOrderListCell.h"

@implementation WWhiteCardOrderListTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        //注册
        [self registerClass:[WWhiteCardOrderListCell class] forCellReuseIdentifier:@"WWhiteCardOrderListCell"];
        self.estimatedRowHeight = 60;
        self.tableFooterView = [[UIView alloc]init];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lists.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWhiteCardOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWhiteCardOrderListCell" forIndexPath:indexPath];
    cell.model = self.lists[indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.wWhiteCardOrderListTableViewDelegate clickTableViewWithIndex:indexPath.row];
}

@end
