//
//  WhitePrepareOpenTwoView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenTwoView.h"

@interface WhitePrepareOpenTwoView ()

@property (nonatomic) NSArray *leftTitlesArray;

@end

@implementation WhitePrepareOpenTwoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.leftTitlesArray = @[@"号码",@"归属地",@"运营商",@"套餐",@"活动包"];
        [self contentTableView];
        [self nextButton];
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
        [_contentTableView registerClass:[NormalShowCell class] forCellReuseIdentifier:@"NormalShowCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
}

- (UIButton *)nextButton{
    if (_nextButton == nil) {
        _nextButton = [Utils returnNextTwoButtonWithTitle:@"下一步"];
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-90);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(170);
        }];
    }
    return _nextButton;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalShowCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NormalShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalShowCell"];
    }
    cell.leftLabel.text = self.leftTitlesArray[indexPath.row];
    
    if (self.showDataArray.count == self.leftTitlesArray.count) {
        cell.rightLabel.text = self.showDataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==3||indexPath.row==4) {
        return 70;
    }
    return 44;
}

@end
