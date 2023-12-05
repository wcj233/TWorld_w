//
//  LProductOrderView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/16.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LProductOrderView.h"

@implementation LProductOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self contentTableView];
        [self tableHeadView];
    }
    return self;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[LProductOrderCell class] forCellReuseIdentifier:@"LProductOrderCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
}

- (STableHeadView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[STableHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        self.contentTableView.tableHeaderView = _tableHeadView;
    }
    return _tableHeadView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LProductOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LProductOrderCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LProductOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LProductOrderCell"];
    }
    cell.bookedModel = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _LProductOrderCallBack(indexPath.section);
}


@end
