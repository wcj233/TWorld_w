//
//  WhiteCardOrderListViewController.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WhiteCardOrderListViewController.h"
#import "WWhiteCardOrderListTableView.h"
#import "WWhiteCardOrderDetailViewController.h"
#import "WhiteCardListModel.h"

@interface WhiteCardOrderListViewController ()<WWhiteCardOrderListTableViewDelegate>

@property(nonatomic, strong) WWhiteCardOrderListTableView *tableView;
@property(nonatomic, assign) int page;

@end

@implementation WhiteCardOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"白卡申请订单";
    self.tableView = [[WWhiteCardOrderListTableView alloc]initWithFrame:CGRectZero];
    self.tableView.wWhiteCardOrderListTableViewDelegate = self;
//    self.tableView.lists = @[@"",@"",@""];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
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
}

- (void)requestWithType:(requestType)type{
    if (type == refreshing) {
        self.page = 1;
    }else{
        self.page ++;
    }
    if([[AFNetworkReachabilityManager sharedManager] isReachable] == NO){
        [self endRefeshActionWithType:type];
    }
    
    @WeakObj(self);
    [WebUtils requestOpenWhiteOrderListWithPage:[NSString stringWithFormat:@"%d",self.page] andCallBack:^(id obj) {
        @StrongObj(self);
        [self endRefeshActionWithType:type];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if([code isEqualToString:@"10000"]){
                NSDictionary *data = obj[@"data"];
                NSArray *wcardApply = data[@"wcardApply"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (type == refreshing) {
                        self.tableView.lists = [WhiteCardListModel arrayOfModelsFromDictionaries:wcardApply error:nil];
                    }else{
                        NSMutableArray *arr = [self.tableView.lists mutableCopy];
                        NSArray *updateArr = [WhiteCardListModel arrayOfModelsFromDictionaries:wcardApply error:nil];
                        [arr addObjectsFromArray:updateArr];
                        self.tableView.lists = arr;
                    }
                    
                    [self.tableView reloadData];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
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

-(void)clickTableViewWithIndex:(NSInteger)index{
    WhiteCardListModel *model = self.tableView.lists[index];
    WWhiteCardOrderDetailViewController *vc = [[WWhiteCardOrderDetailViewController alloc]init];
    vc.cardIdNum = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
