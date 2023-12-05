//
//  BrokerageListViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/21.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BrokerageListViewController.h"
#import "BrokerageTableViewCell.h"
#import "BrokerageDetailViewController.h"

@interface BrokerageListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain)NSMutableArray<BrokerageInfo *> *brokerageArray;

@property(nonatomic,assign)int type;//1奖励佣金2发展佣金3扣罚佣金

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int linage;
@end

@implementation BrokerageListViewController

-(void)setType:(int)type{
    _type=type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView registerClass:[BrokerageTableViewCell class] forCellReuseIdentifier:@"BrokerageTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"BrokerageTableViewCell" bundle:nil] forCellReuseIdentifier:@"BrokerageTableViewCell"];
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    _page=1;
    if (screenHeight==812) {
        _linage=12;
    }
    else{
        _linage=10;
    }
    
    WEAK_SELF
    _tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestWithRefresh:YES];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestWithRefresh:NO];
    }];
}

-(void)refresh{
    [_tableView.mj_header beginRefreshing];
}

-(void)requestWithRefresh:(BOOL)isRefresh{
    [self showWaitView];
    @WeakObj(self);
    
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:@{
                                        @"page":isRefresh?@"1":[NSString stringWithFormat:@"%d",_page],
                                        @"linage":[NSString stringWithFormat:@"%d",_linage],
                                        @"type":_type==1?@"1":(_type==2?@"0":@"2")
                                        }];
    
    if (!IS_EMPTY(_periodString)) {
        [parameters setObject:_periodString forKey:@"accountPeriod"];
    }
    
    [WebUtils agency_getAccountPeriodListWithParameters:parameters andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
            if (isRefresh) {
                [self.tableView.mj_header endRefreshing];
            }
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSLog(@"%@",obj[@"data"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *array=[BrokerageInfo arrayFromData:obj[@"data"][@"accountPeriod"]];
                    if (isRefresh) {
                        self.brokerageArray=[NSMutableArray arrayWithArray:array];
                        self.page=2;
                    }
                    else{
                        [self.brokerageArray addObjectsFromArray:array];
                        self.page++;
                    }
                    if (array.count<self.linage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    else{
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                    
                    [self.tableView reloadData];
                    
                    self.total=obj[@"data"][@"amountSUM"];
                    [self.parentVC setTotalBrokerage:obj[@"data"][@"amountSUM"] index:self.type-1];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _brokerageArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier=@"BrokerageTableViewCell";
    BrokerageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[BrokerageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [cell setContentWithBrokerage:_brokerageArray[indexPath.row] mark:_type==3?@"-":@"+"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Brokerage" bundle:nil];
    BrokerageDetailViewController *vc=[story instantiateViewControllerWithIdentifier:@"BrokerageDetailViewController"];
    [vc setBrokerage:_brokerageArray[indexPath.row] isDeduct:_type==3];
    [self.parentVC.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
