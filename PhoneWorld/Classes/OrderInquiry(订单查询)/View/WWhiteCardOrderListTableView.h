//
//  WWhiteCardOrderListTableView.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWhiteCardOrderListTableViewDelegate <NSObject>

-(void)clickTableViewWithIndex:(NSInteger)index;

@end

@interface WWhiteCardOrderListTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) NSArray *lists;
@property(nonatomic, weak) id<WWhiteCardOrderListTableViewDelegate> wWhiteCardOrderListTableViewDelegate;

@end

