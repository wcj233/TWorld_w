//
//  SCardOrderView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableHeadView.h"
#import "OrderListModel.h"
#import "CardTransferListModel.h"

@interface SCardOrderView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) void(^SCardOrderCallBack) (NSInteger row);

@property (nonatomic) UITableView *contentTableView;
@property (nonatomic) STableHeadView *tableHeadView;

@property (nonatomic) NSMutableArray *dataArray;

@end
