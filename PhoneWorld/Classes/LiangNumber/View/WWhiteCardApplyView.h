//
//  WWhiteCardApplyTableView.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWhiteCardApplyView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *submitButton;

@end

NS_ASSUME_NONNULL_END
