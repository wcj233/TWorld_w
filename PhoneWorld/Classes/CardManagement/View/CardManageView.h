//
//  CardManageView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardManageView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,copy) void(^myCallBack)(NSString *titleStr);
@property (nonatomic) UITableView *cardTableView;
@end
