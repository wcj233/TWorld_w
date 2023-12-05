
//
//  BrokerageDetailViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/27.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BrokerageDetailViewController.h"

@interface BrokerageDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain)BrokerageInfo *brokerage;
@property(nonatomic,assign)BOOL isDeduct;
@property(nonatomic,retain)BrokerageDetail *detail;

@property(nonatomic,retain)NSMutableArray<NSMutableArray *> *titleArray;
@property(nonatomic,retain)NSMutableArray<NSMutableArray *> *detailArray;
@end

@implementation BrokerageDetailViewController

-(void)setBrokerage:(BrokerageInfo *)brokerage isDeduct:(BOOL)isDeduct{
    _brokerage=brokerage;
    _isDeduct=isDeduct;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"佣金详情";
    
    _titleArray=[NSMutableArray arrayWithArray:@[
                                                 [NSMutableArray arrayWithObjects:@"号码",@"开户日期",@"号码状态", nil],
                                                 [NSMutableArray array],
                                                 ]];
    _detailArray=[NSMutableArray arrayWithArray:@[
                                                  [NSMutableArray arrayWithObjects:@"",@"",@"", nil],
                                                  [NSMutableArray array],
                                                  ]];
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    [self request];
}

-(void)request{
    [self showWaitView];
    @WeakObj(self);
    
    
    NSMutableDictionary *parameters=[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"id":@(_brokerage.id)
                                                                                    }];
    
    
    [WebUtils agency_getAccountPeriodWithParameters:parameters andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSLog(@"%@",obj[@"data"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.detail=[[BrokerageDetail alloc]initWithDictionary:obj[@"data"]];
                    [self makeDetail];
                    [self.tableView reloadData];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

-(void)makeDetail{
    [_detailArray[0] replaceObjectAtIndex:0 withObject:_detail.tel];
    [_detailArray[0] replaceObjectAtIndex:1 withObject:_detail.openTime];
    [_detailArray[0] replaceObjectAtIndex:2 withObject:_detail.telStart];
    
    
    [_titleArray[1] addObject:_isDeduct?@"扣罚科目":@"佣金科目"];
    [_detailArray[1] addObject:_detail.subject];
    
    [_titleArray[1] addObject:_isDeduct?@"扣罚金额":@"佣金金额"];
    [_detailArray[1] addObject:_detail.amount];
    
    if (_isDeduct) {
        if (!IS_EMPTY(_detail.acceptanceTime)) {
            [_titleArray[1] addObject:@"受理时间"];
            [_detailArray[1] addObject:_detail.acceptanceTime];
        }
    }
    else{
        if (!IS_EMPTY(_detail.year)) {
            [_titleArray[1] addObject:@"佣金年限"];
            [_detailArray[1] addObject:_detail.year];
        }
    }
    
    [_titleArray[1] addObject:_isDeduct?@"扣罚账期":@"账期"];
    [_detailArray[1] addObject:_detail.accountPeriod];
    
    if (!IS_EMPTY(_detail.reason)) {
        [_titleArray[1] addObject:_isDeduct?@"扣罚原因":@"获得原因"];
        [_detailArray[1] addObject:_detail.reason];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray[section].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier;
    UITableViewCell *cell;
    NSUInteger max=_titleArray[indexPath.section].count;
    if (indexPath.row==0&&indexPath.row==max-1) {
        identifier=@"EstablishDetailTableViewCellSingle";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.textLabel.textColor=[UIColor colorWithWhite:0x33/255.0 alpha:1];
            cell.detailTextLabel.font=font16;
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
            line.image=[UIImage imageNamed:@"separator_upsidedown"];
            [cell.contentView addSubview:line];
            
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, screenWidth, 1)];
            line1.image=[UIImage imageNamed:@"separator"];
            [cell.contentView addSubview:line1];
        }
    }
    else if (indexPath.row==0) {
        identifier=@"EstablishDetailTableViewCellFirst";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.textLabel.textColor=[UIColor colorWithWhite:0x33/255.0 alpha:1];
            cell.detailTextLabel.font=font16;
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
            line.image=[UIImage imageNamed:@"separator_upsidedown"];
            [cell.contentView addSubview:line];
        }
    }
    else if (indexPath.row==max-1) {
        identifier=@"EstablishDetailTableViewCellLast";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.textLabel.textColor=[UIColor colorWithWhite:0x33/255.0 alpha:1];
            cell.detailTextLabel.font=font16;
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, screenWidth, 1)];
            line1.image=[UIImage imageNamed:@"separator"];
            [cell.contentView addSubview:line1];
        }
    }
    else {
        identifier=@"EstablishDetailTableViewCell";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.textLabel.textColor=[UIColor colorWithWhite:0x33/255.0 alpha:1];
            cell.detailTextLabel.font=font16;
        }
    }
    
    cell.textLabel.text=[[_titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[[_detailArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
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
