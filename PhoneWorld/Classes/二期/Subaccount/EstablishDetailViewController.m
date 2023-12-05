//
//  EstablishDetailViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/24.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "EstablishDetailViewController.h"

@interface EstablishDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain)ChildOrderInfo *order;
@property(nonatomic,retain)ChildOrderDetail *detail;

@property(nonatomic,retain)NSMutableArray<NSMutableArray *> *titleArray;
@property(nonatomic,retain)NSMutableArray<NSMutableArray *> *detailArray;
@end

@implementation EstablishDetailViewController

-(void)setOrder:(ChildOrderInfo *)order{
    _order=order;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"子账户开户详情";
    
    _titleArray=[NSMutableArray arrayWithArray:@[
                  [NSMutableArray arrayWithObjects:@"用户号码", nil],
                  [NSMutableArray arrayWithObjects:@"订单号",@"订单时间",@"开户工号", nil],
                  [NSMutableArray arrayWithObjects:@"ICCID",@"运营商",@"网络制式",@"归属省份",@"所属城市",@"主产品",@"活动包名称", nil],
                  [NSMutableArray arrayWithObjects:@"审核状态", nil],
                  ]];
    _detailArray=[NSMutableArray arrayWithArray:@[
                   [NSMutableArray arrayWithObjects:@"", nil],
                   [NSMutableArray arrayWithObjects:@"",@"",@"", nil],
                   [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil],
                   [NSMutableArray arrayWithObjects:@"", nil],
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
                                                                                    @"orderNo":_order.orderNo
                                                                                    }];

    
    [WebUtils agency_getSonOrderWithParameters:parameters andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSLog(@"%@",obj[@"data"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.detail=[[ChildOrderDetail alloc]initWithDictionary:obj[@"data"]];
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
    [_detailArray[0] replaceObjectAtIndex:0 withObject:_detail.number];
    [_detailArray[1] replaceObjectAtIndex:0 withObject:_detail.orderNo];
    [_detailArray[1] replaceObjectAtIndex:1 withObject:_detail.createDate];
    [_detailArray[1] replaceObjectAtIndex:2 withObject:_detail.acceptUser];
    [_detailArray[2] replaceObjectAtIndex:0 withObject:_detail.iccid];
    [_detailArray[2] replaceObjectAtIndex:1 withObject:_detail.operatorname];
    [_detailArray[2] replaceObjectAtIndex:2 withObject:_detail.network];
    [_detailArray[2] replaceObjectAtIndex:3 withObject:_detail.province];
    [_detailArray[2] replaceObjectAtIndex:4 withObject:_detail.city];
    [_detailArray[2] replaceObjectAtIndex:5 withObject:_detail.packagename];
    [_detailArray[2] replaceObjectAtIndex:6 withObject:_detail.promotion];
    [_detailArray[3] replaceObjectAtIndex:0 withObject:_detail.startName];
//    [_detailArray[3] replaceObjectAtIndex:1 withObject:_detail];
//    [_detailArray[3] replaceObjectAtIndex:2 withObject:_detail];
    if (!IS_EMPTY(_detail.cancelInfo)) {
        [_titleArray addObject:[NSMutableArray arrayWithObjects:@"取消原因", nil]];
        [_detailArray addObject:[NSMutableArray arrayWithObjects:_detail.cancelInfo, nil]];
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
    
    if (indexPath.section==0) {
        cell.detailTextLabel.textColor=[UIColor colorWithWhite:0x66/255.0 alpha:1];
    }
    else if (indexPath.section==4) {
        cell.detailTextLabel.textColor=[Utils colorRGB:@"#EC6C00"];
    }
    else{
        cell.detailTextLabel.textColor=[UIColor colorWithWhite:0x99/255.0 alpha:1];
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
