//
//  STopOrderView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "STopOrderView.h"
#import "RechargeListModel.h"
#import "RightsOrderListModel.h"

@implementation STopOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self contentTableView];
        [self tableHeadView];
    }
    return self;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[STopOrderCell class] forCellReuseIdentifier:@"STopOrderCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
}

- (STableHeadView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[STableHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        self.contentTableView.tableHeaderView = _tableHeadView;
    }
    return _tableHeadView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    STopOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STopOrderCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[STopOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STopOrderCell"];
    }
//    cell.separatorInset = UIEdgeInsetsZero;
//    cell.layoutMargins = UIEdgeInsetsZero;
//    cell.preservesSuperviewLayoutMargins = NO;
    
    id tmpeModel = self.dataArray[indexPath.row];
    if ([tmpeModel isKindOfClass:RightsOrderListModel.class]) {
        RightsOrderListModel *model = tmpeModel;
        
        cell.timeLabel.text = model.createDate;
        if ([model.status  isEqual: @"0"]) {
            cell.moneyLabel.text = @"处理中";
        }else if ([model.status  isEqual: @"1"]) {
            cell.moneyLabel.text = @"成功";
        }else if ([model.status  isEqual: @"2"]) {
            cell.moneyLabel.text = @"失败";
        }else if ([model.status  isEqual: @"3"]) {
            cell.moneyLabel.text = @"出错";
        }
        
        cell.rightImageView.hidden = YES;
        cell.rightLab.text = [[NSString alloc]initWithFormat:@"%0.2f", model.orderAmount];;
        cell.phoneLabel.text = model.number;
    }else if ([tmpeModel isKindOfClass:RechargeListModel.class]) {
        RechargeListModel *model = tmpeModel;
        
        cell.timeLabel.text = model.startTime;
        
        cell.moneyLabel.text = [[NSString alloc]initWithFormat:@"%0.2f", [model.payAmount floatValue]];;
        cell.phoneLabel.text = model.number;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _STopOrderCallBack(indexPath.row);
}


@end
