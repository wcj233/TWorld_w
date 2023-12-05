//
//  AgentWriteView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentWriteView.h"
#import "NormalShowCell.h"

@interface AgentWriteView ()

@property (nonatomic) NSArray *leftTitlesArray;

@end

@implementation AgentWriteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.leftTitlesArray = @[@"靓号",@"归属地",@"运营商",@"套餐",@"活动包",@"ICCID"];
        self.dataArray = [NSMutableArray array];
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
        _nextButton = [Utils returnNextTwoButtonWithTitle:@"提交"];
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

- (UIButton *)writeButton{
    if (_writeButton == nil) {
        _writeButton = [[UIButton alloc] init];
        [_writeButton setTitle:@"写卡" forState:UIControlStateNormal];
        [_writeButton setTitleColor:[Utils colorRGB:@"#008bd5"] forState:UIControlStateNormal];
        _writeButton.layer.cornerRadius = 4;
        _writeButton.layer.borderColor = [Utils colorRGB:@"#008bd5"].CGColor;
        _writeButton.layer.borderWidth = 1.0;
        _writeButton.backgroundColor = [UIColor clearColor];
        _writeButton.titleLabel.font = [UIFont systemFontOfSize:textfont14];
    }
    return _writeButton;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleString = self.leftTitlesArray[indexPath.row];
    
    NormalShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalShowCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NormalShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalShowCell"];
    }
    
    cell.leftLabel.text = titleString;
    
    if (indexPath.row == self.leftTitlesArray.count - 1) {
        //最后一行
        cell.rightLabel.hidden = YES;
        [cell.contentView addSubview:self.writeButton];
        [self.writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(28);
            make.centerY.mas_equalTo(0);
        }];
    }else{
        if (indexPath.row < self.dataArray.count) {
            cell.rightLabel.text = self.dataArray[indexPath.row];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end
