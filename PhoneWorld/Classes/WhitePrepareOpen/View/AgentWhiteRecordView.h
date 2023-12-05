//
//  AgentWhiteRecordView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentWhiteRecordView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UILabel *selectResultLabel;

@property (nonatomic) void(^AgentWhiteRecordCallBack) (NSInteger row);

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) NSMutableArray *numberArray;//数据


@end
