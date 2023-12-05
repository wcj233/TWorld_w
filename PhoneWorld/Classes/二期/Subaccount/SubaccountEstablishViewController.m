//
//  SubaccountEstablishViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "SubaccountEstablishViewController.h"
#import "EstablishTableViewCell.h"
#import "EstablishFilterViewController.h"
#import "TimeUtil.h"
#import "EstablishDetailViewController.h"

@interface SubaccountEstablishViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) EstablishFilterViewController *filterVC;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTop;
@property (weak, nonatomic) IBOutlet UIView *filterBackView;

@property(nonatomic,assign)BOOL isAnimating;
@property(nonatomic,assign)BOOL isOpen;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int linage;

@property(nonatomic,retain)NSMutableArray<ChildOrderInfo *> *orderArray;

@property(nonatomic,retain)OrderFilterInfo *orderFilter;

@end

@implementation SubaccountEstablishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"子账户开户列表";
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(right)];
    right.tintColor=[Utils colorRGB:@"#008BD5"];
    self.navigationItem.rightBarButtonItem=right;
    
    [_tableView registerClass:[EstablishTableViewCell class] forCellReuseIdentifier:@"EstablishTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"EstablishTableViewCell" bundle:nil] forCellReuseIdentifier:@"EstablishTableViewCell"];
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    _isOpen=NO;
    _isAnimating=NO;
    
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
    
    [self refresh];
}

-(void)refresh{
    [_tableView.mj_header beginRefreshing];
//    [self requestWithRefresh:YES];
}

-(void)requestWithRefresh:(BOOL)isRefresh{
    [self showWaitView];
    @WeakObj(self);
    

    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:@{                               @"page":isRefresh?@"1":[NSString stringWithFormat:@"%d",_page],
                               @"linage":[NSString stringWithFormat:@"%d",_linage]
                               }];
    
    if (!IS_EMPTY(_orderFilter.way)) {
        [parameters setObject:_orderFilter.way forKey:@"username"];
    }
    if (!IS_EMPTY(_orderFilter.mobile)) {
        [parameters setObject:_orderFilter.mobile forKey:@"number"];
    }
    if (_orderFilter.startTime>0) {
        [parameters setObject:[[TimeUtil getInstance] dateStringFromSecondYMR:_orderFilter.startTime separator:@"-"] forKey:@"startTime"];
    }
    if (_orderFilter.endTime>0) {
        [parameters setObject:[[TimeUtil getInstance] dateStringFromSecondYMR:_orderFilter.endTime separator:@"-"] forKey:@"endTime"];
    }
    
    if (_orderFilter.status==1) {
        [parameters setObject:@"PENDING" forKey:@"orderStatusCode"];
    }
    else if (_orderFilter.status==2) {
        [parameters setObject:@"SUCCESS" forKey:@"orderStatusCode"];
    }
    
    [WebUtils agency_getSonOrderListWithParameters:parameters andCallBack:^(id obj) {
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
                    NSArray *array=[ChildOrderInfo arrayFromData:obj[@"data"][@"order"]];
                    if (isRefresh) {
                        self.orderArray=[NSMutableArray arrayWithArray:array];
                        self.page=2;
                    }
                    else{
                        [self.orderArray addObjectsFromArray:array];
                        self.page++;
                    }
                    if (array.count<self.linage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    else{
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                
                    [self.tableView reloadData];
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
    return _orderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier=@"EstablishTableViewCell";
    EstablishTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[EstablishTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [cell setContentWithChildOrder:_orderArray[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Subaccount" bundle:nil];
    EstablishDetailViewController *vc=[story instantiateViewControllerWithIdentifier:@"EstablishDetailViewController"];
    [vc setOrder:_orderArray[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)right{
    if (_isAnimating) {
        return;
    }
    WEAK_SELF
    _isAnimating=YES;
    if (!_isOpen) {
        
        [_filterVC setOrderFilter:_orderFilter];
        
        _filterBackView.userInteractionEnabled=YES;
        [UIView animateWithDuration:0.3 animations:^{
            _filterBackView.alpha=1;
            weakSelf.filterTop.constant=0;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.isOpen=YES;
            weakSelf.isAnimating=NO;
        }];
    }
    else{
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            _filterBackView.alpha=0;
            weakSelf.filterTop.constant=-298;
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            weakSelf.filterBackView.userInteractionEnabled=NO;
            weakSelf.isOpen=NO;
            weakSelf.isAnimating=NO;
        }];
    }
}
- (IBAction)filterBackTap:(id)sender {
    if (_isAnimating) {
        return;
    }
    [self right];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Filter"]) {
        _filterVC=segue.destinationViewController;
        _filterVC.parentVC=self;
        WEAK_SELF
        [_filterVC setFilterBlock:^(id object) {
            if ([object isKindOfClass:[OrderFilterInfo class]]) {
                weakSelf.orderFilter=object;
                [weakSelf right];
                [weakSelf refresh];
            }
        }];
    }
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
