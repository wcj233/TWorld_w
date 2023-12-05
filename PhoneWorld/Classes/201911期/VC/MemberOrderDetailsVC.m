//
//  MemberOrderDetailsVC.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/17.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "MemberOrderDetailsVC.h"

#import "RightsOrderDetailsModel.h"

@interface MemberOrderDetailsVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *orderNo;

@property (nonatomic, strong) RightsOrderDetailsModel *detailsModel;

@end

@implementation MemberOrderDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self loadData];
}

- (instancetype )initWithOrderNo:(NSString *)orderNo{
    if (self = [super init]) {
        _orderNo = orderNo;
    }
    return self;
}

- (void)setUI{
    self.navigationItem.title = @"订单详情";
    
    self.tableView = UITableView.new;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.leading.trailing.mas_equalTo(self.view);
    }];
}

- (void)loadData{
    @WeakObj(self)
    [WebUtils agency_2019QueryOrderDetailsWithParams:@{@"orderNo":self.orderNo} andCallback:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideWaitView];
            [self.tableView.mj_header endRefreshing];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    
                    self.detailsModel = [RightsOrderDetailsModel yy_modelWithJSON:obj[@"data"][@"order"]];
                    
                    [self.tableView reloadData];
                    
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }else{
                [self showWarningText:@"请求出错"];
            }
        });
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = kSetColor(@"333333");
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.detailsModel.orderNo;
    }else if (indexPath.row == 1) {
        cell.detailTextLabel.text = self.detailsModel.productName;
    }else if (indexPath.row == 2) {
        cell.detailTextLabel.text = self.detailsModel.number;
    }else if (indexPath.row == 3) {
        cell.detailTextLabel.text = self.detailsModel.createDate;
    }else if (indexPath.row == 4) {
        if ([self.detailsModel.status isEqualToString:@"0"]) {
            cell.detailTextLabel.text = @"处理中";
        }else if ([self.detailsModel.status isEqualToString:@"1"]) {
            cell.detailTextLabel.text = @"成功";
        }else if ([self.detailsModel.status isEqualToString:@"2"]) {
            cell.detailTextLabel.text = @"失败";
        }else if ([self.detailsModel.status isEqualToString:@"3"]) {
            cell.detailTextLabel.text = @"出错";
        }
        cell.detailTextLabel.textColor = rgba(236, 108, 0, 1);
    }
    return cell;
}

- (NSArray *)titlesArray{
    return @[@"订单编号",@"产品名称",@"手机号",@"操作时间",@"订单状态"];
}

@end
