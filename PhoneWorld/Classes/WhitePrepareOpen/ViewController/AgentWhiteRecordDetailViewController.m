//
//  AgentWhiteRecordDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "AgentWhiteRecordDetailViewController.h"
#import "NormalShowCell.h"

@interface AgentWhiteRecordDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *contentTableView;
@property (nonatomic) NSArray *leftTitlesArray;
@property (nonatomic) NSMutableArray *rightDetailArray;

@end

@implementation AgentWhiteRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    
    self.leftTitlesArray = @[@"靓号",@"归属地",@"运营商",@"套餐",@"活动包",@"状态"];
    
    [self contentTableView];
    [self getDetailAction];
}

- (void)getDetailAction{
    @WeakObj(self);
    [self showWaitView];
    [WebUtils requestAgentWhiteRecordDetailWithPhoneNumber:self.receivedDictionary[@"number"] andCallBack:^(id obj) {
        @StrongObj(self);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            @StrongObj(self);
            if ([code isEqualToString:@"10000"]) {
                NSDictionary *dataDic = obj[@"data"];
                self.rightDetailArray = [NSMutableArray array];
                
                NSString *stateString = @"待开户";
                if ([dataDic[@"preState"] isEqualToString:@"1"]) {
                    stateString = @"已开户";
                }
                
                [self.rightDetailArray addObjectsFromArray:@[dataDic[@"number"], dataDic[@"cityName"], dataDic[@"operator"], dataDic[@"packageName"], dataDic[@"promotionName"], stateString]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contentTableView reloadData];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _contentTableView.bounces = YES;
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[NormalShowCell class] forCellReuseIdentifier:@"NormalShowCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
    }
    return _contentTableView;
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
    
    if (indexPath.row < self.rightDetailArray.count) {
        cell.rightLabel.text = self.rightDetailArray[indexPath.row];
    }
    
    cell.leftLabel.text = titleString;
    
    if (indexPath.row == self.leftTitlesArray.count - 1) {
        cell.rightLabel.textColor = MainColor;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
