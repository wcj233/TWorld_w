//
//  LiangListView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiangListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *dataArray;

@property (nonatomic) UIView *tableHeaderView;
@property (nonatomic) UILabel *selectResultLabel;

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) void(^NextCallBack) (NSInteger row);

@end
