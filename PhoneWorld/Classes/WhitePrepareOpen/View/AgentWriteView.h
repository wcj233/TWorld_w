//
//  AgentWriteView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentWriteView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) UIButton *nextButton;

@property (nonatomic) UIButton *writeButton;

@property (nonatomic) NSMutableArray *dataArray;

@end
