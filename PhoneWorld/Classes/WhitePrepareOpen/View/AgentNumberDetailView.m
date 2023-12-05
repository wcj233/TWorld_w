//
//  AgentNumberDetailView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentNumberDetailView.h"
#import "NormalShowCell.h"
#import "NormalLeadCell.h"

@interface AgentNumberDetailView ()

@property (nonatomic) NSArray *leftTitlesArray;

@end

@implementation AgentNumberDetailView

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        
        self.dataArray = [NSMutableArray array];
        
        self.leftTitlesArray = array;
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
        [_contentTableView registerClass:[NormalLeadCell class] forCellReuseIdentifier:@"NormalLeadCell"];
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
    
    NSString *titleString = self.leftTitlesArray[indexPath.row];
    if (indexPath.row < 2) {
        NormalLeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalLeadCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NormalLeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalLeadCell"];
        }
        
        cell.inputTextField.userInteractionEnabled = NO;
        cell.leftLabel.text = titleString;
        if (self.dataArray.count == 6) {
            cell.inputTextField.text = self.dataArray[indexPath.row];
        }
        return cell;
    }
    
    NormalShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalShowCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NormalShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalShowCell"];
    }
    
    if (indexPath.row < self.dataArray.count) {
        cell.rightLabel.text = self.dataArray[indexPath.row];
        
    }
    
    cell.leftLabel.text = titleString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 2) {
        _AgentNumberDetailCallBack(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

@end
