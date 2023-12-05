//
//  AgentNumberListView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentNumberListView.h"
#import "LiangCell.h"
#import "AgentNumberModel.h"
#import "LiangNumberModel.h"

@implementation AgentNumberListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        [self tableHeaderView];
        [self selectResultLabel];
        [self contentTableView];
    }
    return self;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.tableHeaderView.mas_bottom).mas_equalTo(0);
        }];
        _contentTableView.bounces = YES;
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[LiangCell class] forCellReuseIdentifier:@"LiangCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
}

- (UIView *)tableHeaderView{
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc] init];
        [self addSubview:_tableHeaderView];
        [_tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
//            make.height.mas_equalTo(30);
        }];
        _tableHeaderView.backgroundColor = COLOR_BACKGROUND;
    }
    return _tableHeaderView;
}

- (UILabel *)selectResultLabel{
    if (_selectResultLabel == nil) {
        _selectResultLabel = [[UILabel alloc] init];
        [self.tableHeaderView addSubview:_selectResultLabel];
        [_selectResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
        }];
        _selectResultLabel.textColor = [Utils colorRGB:@"#999999"];
        _selectResultLabel.font = [UIFont systemFontOfSize:textfont14];
        _selectResultLabel.numberOfLines = 0;
    }
    return _selectResultLabel;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiangCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LiangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LiangCell"];
    }
    
    NSString *placeString = @"状态：";
    
    if ([self.numberArray[indexPath.row] isKindOfClass:[LiangNumberModel class]]) {
        LiangNumberModel *model = self.numberArray[indexPath.row];
        cell.phoneNumberLabel.text = [NSString stringWithFormat:@"手机号：%@",model.number];
        if ([model.liangStatus isEqualToString:@"0"]) {
            placeString = [placeString stringByAppendingString:@"未分配"];
        }else if([model.liangStatus isEqualToString:@"1"]){
            placeString = [placeString stringByAppendingString:@"已激活"];
        }else if([model.liangStatus isEqualToString:@"2"]){
            placeString = [placeString stringByAppendingString:@"已使用"];
        }else if([model.liangStatus isEqualToString:@"3"]){
            placeString = [placeString stringByAppendingString:@"锁定"];
        }else{
            placeString = [placeString stringByAppendingString:@"开户中"];
        }
    }else{
        NSDictionary *dic = self.numberArray[indexPath.row];
        cell.phoneNumberLabel.text = [NSString stringWithFormat:@"手机号：%@",dic[@"num"]];
        placeString = [NSString stringWithFormat:@"说明：%@",dic[@"infos"]];
    }
    
    cell.placeLabel.attributedText = [Utils setTextColor:placeString FontNumber:font14 AndRange:NSMakeRange(2, placeString.length - 2) AndColor:MainColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _AgentNumberCallBack(indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

@end
