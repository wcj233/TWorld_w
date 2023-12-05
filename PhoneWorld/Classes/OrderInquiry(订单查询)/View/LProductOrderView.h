//
//  LProductOrderView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/16.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableHeadView.h"
#import "LBookedModel.h"
#import "LProductOrderCell.h"

@interface LProductOrderView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) void(^LProductOrderCallBack) (NSInteger row);

@property (nonatomic) UITableView *contentTableView;
@property (nonatomic) STableHeadView *tableHeadView;

@property (nonatomic) NSMutableArray<LBookedModel *> *dataArray;

@end
