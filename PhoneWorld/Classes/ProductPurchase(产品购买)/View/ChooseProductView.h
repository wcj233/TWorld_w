//
//  ChooseProductView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCell.h"
#import "ChooseProductHeadView.h"
#import "LiangSelectView.h"
#import "LCanBookModel.h"
#import "RightsModel.h"

@interface ChooseProductView : UIView <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) void(^PopCallBack) ();

@property (nonatomic, strong) NSMutableArray *productArray;

@property (nonatomic) void(^ChooseProductCallBack) (NSInteger row);

@property (nonatomic, strong) ChooseProductHeadView *headView;

@property (nonatomic) UITableView *contentTableView;

- (void)showSuccessPopView:(NSString *)imageName title:(NSString *)title;

@end
