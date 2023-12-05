//
//  SCardOrderView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SCardOrderView.h"
#import "SOrderCell.h"
#import "WhitePrepareOpenFourViewController.h"
#import "SCardOrderViewController.h"
#import "WriteCardModel.h"
#import "AgentWriteAndChooseViewController.h"
#import "BaiduMapTool.h"

@implementation SCardOrderView

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
        [_contentTableView registerClass:[SOrderCell class] forCellReuseIdentifier:@"SOrderCell"];
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
    
    SOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SOrderCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SOrderCell"];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    if ([self.dataArray[indexPath.row] isKindOfClass:[OrderListModel class]]) {
        OrderListModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.startTime;
        cell.stateLabel.text = model.orderStatusName;
        cell.nameLabel.text = model.customerName;
        cell.phoneLabel.text = model.number;
        
        if ( [model.orderStatusName isEqualToString:@"已取消"]) {
            
            
            
            cell.resubmitbtn.hidden = NO;
            cell.resubmitbtn.tag = indexPath.row;
            [cell.resubmitbtn addTarget:self action:@selector(resubmitLabAction:) forControlEvents:UIControlEventTouchUpInside];
//            UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resubmitLabAction)];
//            [cell.resubmitLab addGestureRecognizer:tag];
//            cell.resubmitLab .backgroundColor = [UIColor redColor];
//            [self viewController].navigationController pushViewController: animated:<#(BOOL)#>
        }else
        {
            cell.resubmitbtn.hidden = YES;

        }
        SCardOrderViewController * vc =   (SCardOrderViewController *)self.viewController;
        if (vc.type  != BaiKa) {
            cell.resubmitbtn.hidden = YES;

        }

        
    }else if([self.dataArray[indexPath.row] isKindOfClass:[WriteCardModel class]]){
        WriteCardModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.createdate;
        cell.stateLabel.text = model.state?model.state:@"待开户";
        cell.nameLabel.text = model.ePreNo;
        cell.phoneLabel.text = model.number;
        
        // 202011月份新需求，重写功能
        if ([@"已锁定" isEqualToString:model.state]) {
            cell.reWriteBtn.hidden = false;
            cell.reWriteBtn.tag = indexPath.row;

            @WeakObj(self)
            [[[cell.reWriteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @StrongObj(self)
                AgentWriteAndChooseViewController *vc = [[AgentWriteAndChooseViewController alloc] init];
                vc.leftTitlesArray = @[@"号码",@"归属地",@"运营商",@"预存话费",@"选号费",@"保底",@"订单金额"];
                vc.typeString = @"写卡激活";
                vc.phoneNumber = model.number;
                vc.stateIsLock = true;
                vc.orderNo = model.ePreNo;
                [[[BaiduMapTool getCurrentVC] navigationController] pushViewController:vc animated:true];
            }];
        } else {
            cell.reWriteBtn.hidden = true;
        }
    }else{
        CardTransferListModel *model = self.dataArray[indexPath.row];
        cell.timeLabel.text = model.startTime;
        cell.stateLabel.text = model.startName;
        cell.nameLabel.text = model.name;
        cell.phoneLabel.text = model.number;
    }
    
    return cell;
}


-(void)resubmitLabAction:(UIButton *)btn
{
    
    OrderListModel *model = self.dataArray[btn.tag];

    
    WhitePrepareOpenFourViewController *vc = [[WhitePrepareOpenFourViewController alloc] init];
//    if (tag == 0) {
//        //识别仪开户
//        vc.openWay = @"识别仪开户";
//    }else{
        //扫描开户
        vc.openWay = @"扫描开户";
////    }
//    vc.numberModel = self.numberModel;
    vc.orderNo = model.orderNo;
//    vc.payMethod = self.payMethod;
//    vc.detailDictionary = self.detailDictionary;
//    vc.packagesDictionary = self.packagesDictionary;
    vc.typeString = @"重新加载资料";
//    vc.iccidString = self.iccidString;
//    vc.imsiDictionary = self.imsiDictionary;
//    vc.promotionDictionary = self.promotionsDictionary;
    [self.viewController.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _SCardOrderCallBack(indexPath.row);
}

@end
