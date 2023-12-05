//
//  LProductDetailView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalShowCell.h"
#import "LBookedModel.h"
#import "RightsOrderListModel.h"

@interface LProductDetailView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) LBookedModel *bookedModel;

@property (nonatomic, strong) RightsOrderListModel *rightsOrderListModel;

@end
