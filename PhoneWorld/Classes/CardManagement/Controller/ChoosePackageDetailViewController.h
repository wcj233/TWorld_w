//
//  ChoosePackageDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/26.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "ChoosePackageDetailView.h"
#import "ChoosePackageTableView.h"

@interface ChoosePackageDetailViewController : BaseViewController

@property (nonatomic) void(^ChoosePackageDetailCallBack) (NSDictionary *currentDic);

@property (nonatomic) ChoosePackageDetailView *detailView;

@property (nonatomic) NSArray *packagesDic;
@property (nonatomic) NSString *currentID;

@end
