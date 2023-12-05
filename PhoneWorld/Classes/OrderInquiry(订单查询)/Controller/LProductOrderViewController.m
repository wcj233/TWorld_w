//
//  LProductOrderViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/16.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LProductOrderViewController.h"
#import "LProductOrderView.h"
#import "LProductDetailViewController.h"
#import "LBookedModel.h"
#import "LiangSelectView.h"
#import "NormalInputCell.h"

@interface LProductOrderViewController ()

@property (nonatomic, strong) LProductOrderView *orderView;

@property (nonatomic, strong) NSMutableArray<LBookedModel *> *bookedModelArray;

@property (nonatomic) LiangSelectView *selectView;
@property (nonatomic) NSMutableDictionary *selectDictionary;

@property (nonatomic) int page;
@property (nonatomic) int linage;

@end

@implementation LProductOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流量包订单";
    self.orderView = [[LProductOrderView alloc] init];
    [self.view addSubview:self.orderView];
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont16],NSForegroundColorAttributeName:[Utils colorRGB:@"#008bd5"]} forState:UIControlStateNormal];
    
    
    self.page = 1;
    self.linage = 10;
    self.bookedModelArray = [NSMutableArray array];
    self.selectDictionary = [NSMutableDictionary dictionary];
    
    @WeakObj(self);
    [self.orderView setLProductOrderCallBack:^(NSInteger row) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            LProductDetailViewController *vc = [[LProductDetailViewController alloc] init];
            vc.bookedModel = self.bookedModelArray[row];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
    
    //筛选框查询事件
    [self.selectView setSelectInquiryCallBack:^(id obj){
        @StrongObj(self);
        self.selectView.hidden = YES;
        [self showSelectDetailAction];
        [self.orderView.contentTableView.mj_header beginRefreshing];
    }];
    
    //筛选框重置事件
    [self.selectView setSelectResetCallBack:^(id obj){
        @StrongObj(self);
        self.selectDictionary = [NSMutableDictionary dictionary];
        self.orderView.tableHeadView.centerLabel.text = @"";
        self.orderView.tableHeadView.rightLabel.text = @"";
    }];
    
    //添加刷新
    self.orderView.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestOrderListWithType:refreshing];
    }];
    
    self.orderView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestOrderListWithType:loading];
    }];
    
    [self.orderView.contentTableView.mj_header beginRefreshing];
}

- (void)requestOrderListWithType:(requestType)requestType{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.orderView.userInteractionEnabled = NO;
    });
    
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        if (requestType == refreshing) {
            [self.orderView.contentTableView.mj_header endRefreshing];
        }else{
            [self.orderView.contentTableView.mj_footer endRefreshing];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.orderView.userInteractionEnabled = YES;
        });
        return;
    }
    
    if (requestType == refreshing) {
        self.page = 1;
        self.bookedModelArray = [NSMutableArray array];
        
    }else if(requestType == loading){
        self.page ++;
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%d",self.page];
    NSString *linageStr = [NSString stringWithFormat:@"%d",self.linage];
    @WeakObj(self);
    
    NSString *numberString = nil;
    if (self.selectDictionary.count > 0) {
        numberString = [self.selectDictionary objectForKey:@"number"];
    }
    
    [WebUtils l_getOrderProductListWithNumber:numberString andPage:pageStr andLinage:linageStr andCallBack:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.orderView.userInteractionEnabled = YES;
        });
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            @StrongObj(self);
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSArray *arr = obj[@"data"][@"orderProductList"];
                for (NSDictionary *dic in arr) {
                    LBookedModel *om = [[LBookedModel alloc] initWithDictionary:dic error:nil];
                    [self.bookedModelArray addObject:om];
                }
                
                
                
            }else{
                [self showWarningText:obj[@"mes"]];
            }
            self.orderView.dataArray = self.bookedModelArray;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showCountAndReloadTableViewAction];
                [self.orderView.contentTableView reloadData];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshingWithType:requestType];
        });
        
    }];
}

- (void)showCountAndReloadTableViewAction{
    NSString *countString = [NSString stringWithFormat:@"共%ld条",self.bookedModelArray.count];
    self.orderView.tableHeadView.countLabel.attributedText = [Utils setTextColor:countString FontNumber:[UIFont systemFontOfSize:12] AndRange:NSMakeRange(1, countString.length - 2) AndColor:MainColor];
    
    [self.orderView.contentTableView reloadData];
}

- (void)endRefreshingWithType:(requestType)requestType{
    if (requestType == refreshing) {
        [self.orderView.contentTableView.mj_header endRefreshing];
    }else{
        [self.orderView.contentTableView.mj_footer endRefreshing];
    }
}

//筛选操作
- (void)selectAction{
    self.selectView.hidden = NO;
}

//展示筛选条件
- (void)showSelectDetailAction{
    //number
    NormalInputCell *phoneCell = [self.selectView.selectTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (phoneCell.inputTextField.text.length > 0) {
        [self.selectDictionary setObject:phoneCell.inputTextField.text forKey:@"number"];
    }else{
        [self.selectDictionary removeObjectForKey:@"number"];
    }
    
    self.orderView.tableHeadView.centerLabel.text = [NSString stringWithFormat:@"%@", phoneCell.inputTextField.text];
}


#pragma mark - LazyLoading -----

- (LiangSelectView *)selectView{
    if (_selectView == nil) {
        _selectView = [[LiangSelectView alloc] initWithFrame:CGRectZero andLeftTitlesArray:@[@"手机号码"] andDataDictionary:@{@"手机号码":@"phoneNumber"}];
        [self.view addSubview:_selectView];
        _selectView.hidden = YES;
        [_selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _selectView;
}

@end
