//
//  BillDetailViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BillDetailViewController.h"

@interface BillDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property(nonatomic,retain)NSArray<NSMutableArray *> *titleArray;
@property(nonatomic,retain)NSArray<NSMutableArray *> *detailArray;

@property(nonatomic,retain)BillInfo *bill;

@end

@implementation BillDetailViewController

-(void)setBill:(BillInfo *)bill{
    _bill=bill;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账单详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    _titleArray=@[
                  [NSMutableArray arrayWithObjects:@"用户号码", nil],
                  [NSMutableArray arrayWithObjects:@"当前账期", nil],
                  [NSMutableArray arrayWithObjects:@"客户名称", nil],
                  [NSMutableArray arrayWithObjects:@"套餐及叠加包月基本费", nil],
                  [NSMutableArray arrayWithObjects:@"套餐及叠加包月基本费费用项目", nil],
                  [NSMutableArray arrayWithObjects:@"套餐及叠加包超出费用", nil]
                  ];
    
    _detailArray=@[
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray arrayWithObjects:@"", nil],
                   [NSMutableArray arrayWithObjects:@"", nil],
                   [NSMutableArray arrayWithObjects:@"", nil]
                   ];
    
    [_detailArray[0] addObject:_bill.accountTel];
    [_detailArray[1] addObject:_bill.billingCycle];
    [_detailArray[2] addObject:_bill.accountName];
    
    [_titleArray[3] addObject:_bill.costItem];
    [_detailArray[3] addObject:[NSString stringWithFormat:@"%@元/月",_bill.meal]];
    
    for (BillItemInfo *basic in _bill.basic) {
        [_titleArray[4] addObject:basic.name];
        [_detailArray[4] addObject:basic.value];
    }
    for (BillItemInfo *others in _bill.others) {
        [_titleArray[5] addObject:others.name];
        [_detailArray[5] addObject:others.value];
    }
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.contentInset=UIEdgeInsetsMake(-13, 0, -8, 0);
    _tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 13)];
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    if (screenHeight==812) {
        _bottomHeight.constant+=34;
    }
    _totalLabel.text=[NSString stringWithFormat:@"%@元",_bill.sum];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section<3) {
        return 0;
    }
    return 13;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section<3) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 13)];
    UIView *white=[[UIView alloc]initWithFrame:CGRectMake(0, 3, screenWidth, 10)];
    white.backgroundColor=[UIColor whiteColor];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 2, screenWidth, 1)];
    line.image=[UIImage imageNamed:@"separator"];
    [view addSubview:white];
    [view addSubview:line];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section<3) {
        return 0;
    }
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section<3) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 8)];
    view.backgroundColor=[UIColor whiteColor];
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 7, screenWidth, 1)];
    line.image=[UIImage imageNamed:@"separator"];
   
    [view addSubview:line];
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray objectAtIndex:section].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<3) {
        return 44;
    }
    else if (indexPath.row==0) {
        return 27;
    }
    return 27;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier;
    UITableViewCell *cell;
    if (indexPath.section<3) {
        identifier=@"BillDetailTableViewCellFirst";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.detailTextLabel.font=font16;
            cell.detailTextLabel.textColor=[UIColor blackColor];
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 43, screenWidth, 1)];
            line.image=[UIImage imageNamed:@"separator"];
            [cell addSubview:line];
        }
    }
    else if (indexPath.row==0) {
        identifier=@"BillDetailTableViewCellTitle";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.detailTextLabel.font=font16;
        }
    }
    else{
        identifier=@"BillDetailTableViewCellDetail";
        cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font=font16;
            cell.textLabel.textColor=[UIColor colorWithWhite:0x99/255.0 alpha:1];
            cell.detailTextLabel.font=font16;
            cell.detailTextLabel.textColor=[UIColor colorWithWhite:0x99/255.0 alpha:1];
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
