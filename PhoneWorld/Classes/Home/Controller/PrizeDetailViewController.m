//
//  PrizeDetailViewController.m
//  PhoneWorld
//
//  Created by andy on 2018/4/28.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "PrizeDetailViewController.h"

@interface PrizeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation PrizeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包详情";
    
    [self prepareData];
    [self configUI];
}
#pragma mark intviewcontroller
-(void)prepareData
{
    
}

-(void)configUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 ,screenWidth, screenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView   setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];

    
}

#pragma mark buttonAction


#pragma mark --tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellid = @"HomeMultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _dataModel.name;

    }else
    {
        cell.textLabel.text =_dataModel.createDate;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *sectionView = [[UIView alloc]init];
    
    sectionView.frame = CGRectMake(0, 0, screenWidth, 40);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 10, 4, 20);
    [sectionView  addSubview:lineView];
    lineView.backgroundColor = MainColor;
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(11, 0, screenWidth, 40);
    [sectionView  addSubview:titleLab];
    titleLab.textColor = MainColor;
    
    if (section == 0) {
        titleLab.text = @"红包内容";
    }else
    {
        titleLab.text = @"领取时间";

    }
    
    return sectionView;
    
}

//返回分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

//返回分区的脚的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


@end
