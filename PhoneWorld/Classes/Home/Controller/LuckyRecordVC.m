//
//  LuckyRecordVC.m
//  PhoneWorld
//
//  Created by andy on 2018/4/26.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LuckyRecordVC.h"
#import "LuckyRecordModel.h"
#import "PrizeDetailViewController.h"
@interface LuckyRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger linage;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSMutableArray *messageArray;
@property(nonatomic, assign) NSInteger drawNum;

@end

@implementation LuckyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"抽奖记录";
    
    [self configUI];
    [self prapareData];

}
#pragma mark intviewcontroller
- (void)prapareData{
    @WeakObj(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestWithType:refreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestWithType:loading];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
   
    [self requestWithType:refreshing];

}



- (void)requestWithType:(requestType)type{
    if (type == refreshing) {
        self.page = 1;
        self.messageArray = [NSMutableArray array];
    }else{
        self.page ++;
    }
    
    NSString *linageStr = [NSString stringWithFormat:@"%ld",self.linage];
    NSString *pageStr = [NSString stringWithFormat:@"%ld",self.page];
    
    if([[AFNetworkReachabilityManager sharedManager] isReachable] == NO){
        [self endRefeshActionWithType:type];
    }
    
    if([[AFNetworkReachabilityManager sharedManager] isReachable] == NO){
        [self endRefeshActionWithType:type];
    }
    @WeakObj(self);

    [WebUtils requestgetWinningWithNumber:@"10" andPage:pageStr andLinage:linageStr andCallBack:^(id obj) {

        @StrongObj(self);
        [self endRefeshActionWithType:type];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if([code isEqualToString:@"10000"]){
                
                NSArray *messageArr = obj[@"data"][@"LotteryRecord"];
                
                _drawNum =[obj[@"data"][@"count"] integerValue];

                
                for (NSDictionary *dic in messageArr) {
                    LuckyRecordModel *mm = [[LuckyRecordModel alloc] initWithDictionary:dic error:nil];
                    
                    if (![mm.type isEqualToString:@"谢谢参与"]) {
                        [self.messageArray addObject:mm];
                    }
                }
                self.messageArray = self.messageArray;
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.tableView reloadData];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}





-(void)configUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    [self.tableView   setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];

    
}

#pragma mark buttonAction




#pragma mark --tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count;
//    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LuckyRecordModel *model = _messageArray[indexPath.row];
    
    static NSString *cellid = @"LuckyRecordModel";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
//    HomeModel *model = _tableViewDataArray[indexPath.row];
//    cell.model = model;
    
    cell.textLabel.text =[[NSString alloc]initWithFormat:@"%@:%@",model.type,model.name];
    cell.detailTextLabel.text = model.createDate;
//    cell.detailTextLabel.
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.contentMode =
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LuckyRecordModel *model = _messageArray[indexPath.row];

    PrizeDetailViewController *vc = [[PrizeDetailViewController alloc]init];
    vc.dataModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [Utils colorRGB:@"#FFEFE1"];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    
   UILabel *_TitleLab = [[UILabel alloc]init];
    _TitleLab.font = [UIFont systemFontOfSize:12];
    _TitleLab.textColor = [Utils colorRGB:@"#EC6C00"];
    _TitleLab.text = [[NSString alloc]initWithFormat:@"温馨提示：您已使用过%lu次抽奖机会" ,_drawNum];
    [backView addSubview:_TitleLab];

    _TitleLab.frame = CGRectMake(15, 0, SCREEN_WIDTH, 30);

    return backView;
    
    
    
}
//返回分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//返回分区的脚的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}


- (void)endRefeshActionWithType:(requestType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == refreshing) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    });
}


@end
