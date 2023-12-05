//
//  AgentNumberDetailView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentNumberDetailView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) void(^AgentNumberDetailCallBack) (NSInteger row);

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)array;

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) UIButton *nextButton;

@property (nonatomic) NSMutableArray *dataArray;

@end
