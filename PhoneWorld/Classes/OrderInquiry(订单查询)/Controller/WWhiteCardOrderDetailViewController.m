//
//  WWhiteCardOrderDetailViewController.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardOrderDetailViewController.h"
#import "WWhiteCardOrderDetailTableView.h"
#import "WhiteCardDetailModel.h"

@interface WWhiteCardOrderDetailViewController ()

@property(nonatomic, strong) WWhiteCardOrderDetailTableView *tableView;

@end

@implementation WWhiteCardOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"白卡申请详情";
    self.tableView = [[WWhiteCardOrderDetailTableView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self requestData];
}

-(void)requestData{
    @WeakObj(self);
    [WebUtils requestOpenWhiteApplyDetailWithCardId:self.cardIdNum andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if([code isEqualToString:@"10000"]){
                NSDictionary *data = obj[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableView.model = [[WhiteCardDetailModel alloc]initWithDictionary:data error:nil];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

@end
