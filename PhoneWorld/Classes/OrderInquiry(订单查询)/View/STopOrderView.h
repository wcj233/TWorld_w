//
//  STopOrderView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableHeadView.h"
#import "STopOrderCell.h"

@interface STopOrderView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) void(^STopOrderCallBack) (NSInteger row);

@property (nonatomic) UITableView *contentTableView;
@property (nonatomic) STableHeadView *tableHeadView;

@property (nonatomic) NSMutableArray *dataArray;

@end
