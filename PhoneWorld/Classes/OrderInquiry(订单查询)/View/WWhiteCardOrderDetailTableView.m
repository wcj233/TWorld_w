//
//  WWhiteCardOrderDetailTableView.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderDetailTableView.h"
#import "WWhiteCardOrderDetailFirstCell.h"
#import "WWhiteCardOrderDetailSecondCell.h"
#import "WWhiteCardOrderDetailThirdCell.h"

@implementation WWhiteCardOrderDetailTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc]init];
        self.estimatedRowHeight = 60;
        self.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        
        //注册
        [self registerClass:[WWhiteCardOrderDetailFirstCell class] forCellReuseIdentifier:@"WWhiteCardOrderDetailFirstCell"];
        [self registerClass:[WWhiteCardOrderDetailSecondCell class] forCellReuseIdentifier:@"WWhiteCardOrderDetailSecondCell"];
        [self registerClass:[WWhiteCardOrderDetailThirdCell class] forCellReuseIdentifier:@"WWhiteCardOrderDetailThirdCell"];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        WWhiteCardOrderDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWhiteCardOrderDetailFirstCell" forIndexPath:indexPath];
        cell.model = _model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==1){
        WWhiteCardOrderDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWhiteCardOrderDetailSecondCell" forIndexPath:indexPath];
        cell.model = _model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WWhiteCardOrderDetailThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWhiteCardOrderDetailThirdCell" forIndexPath:indexPath];
        cell.model = _model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 117;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

-(void)setModel:(WhiteCardDetailModel *)model{
    _model = model;
    [self reloadData];
}

@end
