//
//  AgentWriteAndChooseView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/2.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentWriteAndChooseView.h"
#import "NormalShowCell.h"
#import "NormalLeadCell.h"

@interface AgentWriteAndChooseView ()

@property (nonatomic) NSString *typeString;

@end

@implementation AgentWriteAndChooseView

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)array andType:(NSString *)typeString{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.dataArray = [NSMutableArray array];
        self.leftTitlesArray = array;
        self.typeString = typeString;
        self.payWay = 0;
        //界面
        [self contentTableView];
        [self tableFooterView];

        if ([typeString isEqualToString:@"话机世界靓号平台"]) {

            //有支付宝／账号余额支付
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            
            self.cashView = [[PayWayView alloc] init];
            [self.tableFooterView addSubview:self.cashView];
            [self.cashView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.height.mas_equalTo(44);
            }];
            self.cashView.titleLabel.text = @"账号余额支付";
            self.cashView.rightLabel.text = @"当前余额：";
            [self.cashView addGestureRecognizer:tap2];
            
            PayWayView *payView = [[PayWayView alloc] init];
            [self.tableFooterView addSubview:payView];
            [payView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(self.cashView.mas_bottom).mas_equalTo(1);
                make.height.mas_equalTo(44);
            }];
            payView.titleLabel.text = @"支付宝支付";
            payView.hidden=true;
            self.alipayView = payView;
            self.alipayView.leftButton.layer.borderColor = [Utils colorRGB:@"#999999"].CGColor;
            self.alipayView.leftButton.layer.borderWidth = 1.0;
            [self.alipayView addGestureRecognizer:tap1];
        }
        if ([typeString isEqualToString:@"写卡激活"]) {
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            self.cashView = [[PayWayView alloc] init];
            [self.tableFooterView addSubview:self.cashView];
            [self.cashView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(10);
                make.height.mas_equalTo(44);
            }];
            self.cashView.titleLabel.text = @"账号余额支付";
            self.cashView.rightLabel.text = @"当前余额：";
            [self.cashView addGestureRecognizer:tap2];
        }
        
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
        [self.tableFooterView addSubview:_nextButton];
        
        if ([self.typeString isEqualToString:@"话机世界靓号平台"]) {
            [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(170);
                make.top.mas_equalTo(self.alipayView.mas_bottom).mas_equalTo(60);
            }];
        }else{
            [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(170);
                make.top.mas_equalTo(60);
            }];
        }
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

- (UIView *)tableFooterView{
    if (_tableFooterView == nil) {
        if ([self.typeString isEqualToString:@"话机世界靓号平台"]) {
            _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 288)];
        }else{
            _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 140)];
        }
        self.contentTableView.tableFooterView = _tableFooterView;
        _tableFooterView.backgroundColor = [UIColor clearColor];
    }
    return _tableFooterView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleString = self.leftTitlesArray[indexPath.row];
    
    //选择cell
    if ([titleString containsString:@"选择"]) {
        NormalLeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalLeadCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[NormalLeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalLeadCell"];
        }
        
        cell.inputTextField.userInteractionEnabled = NO;
        cell.inputTextField.placeholder = @"请选择";
        cell.leftLabel.text = titleString;
        if (self.dataArray.count == self.leftTitlesArray.count - 1) {
            cell.inputTextField.text = self.dataArray[indexPath.row];
        }
        return cell;
    }
    
    //普通展示cell
    NormalShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalShowCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NormalShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalShowCell"];
    }
    
    cell.leftLabel.text = titleString;
    
    //写卡cell
    if ([titleString isEqualToString:@"ICCID"]) {
        cell.rightLabel.hidden = YES;
        cell.rightLabel.text = self.dataArray.lastObject;
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
    NSString *titleString = self.leftTitlesArray[indexPath.row];
    _AgentWriteAndChooseCallBack(titleString, indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Method ------------

- (void)tapAction:(UITapGestureRecognizer *)tap{
    PayWayView *currentView = (PayWayView *)tap.view;
    if ([currentView.titleLabel.text isEqualToString:@"支付宝支付"]) {
        self.payWay = 1;
        self.alipayView.leftButton.layer.borderColor = [Utils colorRGB:@"#008bd5"].CGColor;
        self.alipayView.leftButton.layer.borderWidth = 6;
        
        self.cashView.leftButton.layer.borderColor = [Utils colorRGB:@"#999999"].CGColor;
        self.cashView.leftButton.layer.borderWidth = 1.0;
    }else{
        self.payWay = 0;
        self.cashView.leftButton.layer.borderColor = [Utils colorRGB:@"#008bd5"].CGColor;
        self.cashView.leftButton.layer.borderWidth = 6;
        
        self.alipayView.leftButton.layer.borderColor = [Utils colorRGB:@"#999999"].CGColor;
        self.alipayView.leftButton.layer.borderWidth = 1.0;
    }
}

@end
