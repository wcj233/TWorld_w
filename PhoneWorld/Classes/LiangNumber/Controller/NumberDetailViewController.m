//
//  NumberDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/12.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "NumberDetailViewController.h"
#import "NormalShowCell.h"

@interface NumberDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) NSMutableArray *dataArray;

@property (nonatomic) NSDictionary *detailDictionary;

@end

@implementation NumberDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    [self contentTableView];
    
    [self getLiangDetailAction];
    
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _contentTableView.userInteractionEnabled = NO;
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
    
    cell.leftLabel.text = titleString;
    
    if (indexPath.row < self.dataArray.count) {
        cell.rightLabel.text = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma mark - Method ------------------------------
- (void)getLiangDetailAction{
    [self showWaitView];
    @WeakObj(self);
    [WebUtils requestAgentLiangDetailWithPhoneNumber:self.numberModel.number andCallBack:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        //@[@"靓号",@"归属地",@"预存话费",@"保底消费",@"代理商",@"联系方式"];
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                self.detailDictionary = obj[@"data"];
                
                NSString *address = [Utils getCityWithProvinceId:self.detailDictionary[@"provinceCode"] andCityId:self.detailDictionary[@"cityCode"]];
                
                if ([self.title isEqualToString:@"号码详情"]) {
                    [self.dataArray addObjectsFromArray:@[self.detailDictionary[@"number"],address,[NSString stringWithFormat:@"%@元",self.detailDictionary[@"prestore"]],[NSString stringWithFormat:@"%@元",self.detailDictionary[@"minConsumption"]],self.detailDictionary[@"userName"],self.detailDictionary[@"userTel"]]];
                }else if([self.title isEqualToString:@"靓号详情"]){
                    
                    NSString *statusString = @"";
                    
                    NSString *liangStatus = [NSString stringWithFormat:@"%@",self.detailDictionary[@"liangStatus"]];
                    
                    if ([liangStatus isEqualToString:@"0"]) {
                        statusString = @"未分配";
                    }else if([liangStatus isEqualToString:@"1"]){
                        statusString = @"已激活";
                    }else if([liangStatus isEqualToString:@"2"]){
                        statusString = @"已使用";
                    }else if([liangStatus isEqualToString:@"3"]){
                        statusString = @"锁定";
                    }else{
                        statusString = @"开户中";
                    }
                    
                    NSString *updateString = [self.detailDictionary[@"updateDate"] componentsSeparatedByString:@"."].firstObject;
                    
                    [self.dataArray addObjectsFromArray:@[self.detailDictionary[@"number"],address,statusString,[NSString stringWithFormat:@"%@元",self.detailDictionary[@"prestore"]],[NSString stringWithFormat:@"%@元",self.detailDictionary[@"minConsumption"]],updateString]];
                }
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.contentTableView reloadData];
                });
            }else {
                [self showWarningText:obj[@"mes"]];
            }
            
        }
        
    }];
}

@end
