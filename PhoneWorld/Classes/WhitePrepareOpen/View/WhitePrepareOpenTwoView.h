//
//  WhitePrepareOpenTwoView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalShowCell.h"

@interface WhitePrepareOpenTwoView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) UIButton *nextButton;

@property (nonatomic) NSArray *showDataArray;

@end
