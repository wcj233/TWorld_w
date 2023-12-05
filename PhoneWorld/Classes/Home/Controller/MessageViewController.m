//
//  MessageViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/11.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageView.h"
#import "MessageModel.h"

@interface MessageViewController ()

@property (nonatomic) NSInteger linage;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSMutableArray *messageArray;
@property (nonatomic) MessageView *messageView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    self.linage = (screenHeight-64)/40;
    self.page = 1;
    
    self.messageView = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.messageView];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readNotification" object:nil];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"isClickedNewsCenter"];
    [ud synchronize];
    
    @WeakObj(self);
    self.messageView.messageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestWithType:refreshing];
    }];
    
    self.messageView.messageTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @StrongObj(self);
        [self requestWithType:loading];
    }];
    
    [self.messageView.messageTableView.mj_header beginRefreshing];
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
    
    @WeakObj(self);
    [WebUtils requestMessageListWithLinage:linageStr andPage:pageStr andCallBack:^(id obj) {
        @StrongObj(self);
        [self endRefeshActionWithType:type];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            
            if([code isEqualToString:@"10000"]){
                
                NSArray *messageArr = obj[@"data"][@"notice"];
                for (NSDictionary *dic in messageArr) {
                    MessageModel *mm = [[MessageModel alloc] initWithDictionary:dic error:nil];
                    [self.messageArray addObject:mm];
                }
                self.messageView.messagesArray = self.messageArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.messageView.messageTableView reloadData];
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
            [self.messageView.messageTableView.mj_header endRefreshing];
        }else{
            [self.messageView.messageTableView.mj_footer endRefreshing];
        }
    });
}

@end
