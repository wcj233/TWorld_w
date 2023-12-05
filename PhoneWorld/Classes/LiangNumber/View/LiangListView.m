//
//  LiangListView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LiangListView.h"
#import "LiangCell.h"
#import "LiangNumberModel.h"

@implementation LiangListView

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
            make.top.mas_equalTo(30);
        }];
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
            make.height.mas_equalTo(30);
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
            make.top.bottom.mas_equalTo(0);
        }];
        _selectResultLabel.textColor = [Utils colorRGB:@"#999999"];
        _selectResultLabel.text = @"共0条";
        _selectResultLabel.font = [UIFont systemFontOfSize:textfont14];
        _selectResultLabel.numberOfLines = 0;
    }
    return _selectResultLabel;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LiangCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LiangCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LiangCell"];
    }
    
    LiangNumberModel *currentModel = self.dataArray[indexPath.row];
    
    cell.phoneNumberLabel.text = [NSString stringWithFormat:@"手机号：%@",currentModel.number];
    
    NSString *address = [Utils getCityWithProvinceId:currentModel.provinceCode andCityId:currentModel.cityCode];
    
    cell.placeLabel.text = [NSString stringWithFormat:@"归属地：%@",address];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _NextCallBack(indexPath.row);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}


@end
