//
//  BillInquiryViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BillInquiryViewController.h"
#import "DetailTableViewCell.h"
#import "TextTableViewCell.h"
#import "PeriodActionSheet.h"
#import "TimeUtil.h"
#import "BillDetailViewController.h"

@interface BillInquiryViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain)NSArray<NSString *> *titleArray;
@property(nonatomic,retain)NSString *mobile;
@property(nonatomic,retain)BillPeriodInfo *period;

@property(nonatomic,strong)PeriodActionSheet *periodActionSheet;
@end

@implementation BillInquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账单查询";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    _titleArray=@[@"手机号码",@"账期"];
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorColor=[UIColor colorWithWhite:0.98 alpha:1];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    UIView *footer=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
    
    UIButton *nextButton = [Utils returnNextButtonWithTitle:@"查询"];
    [footer addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(171);
    }];
    [nextButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableFooterView=footer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int type=0;
    NSString *text=@"";
    NSString *placeholder=@"";
    int limit=100;
    
    switch (indexPath.row) {
        case 0:{
            type=1;
            limit=11;
            text=_mobile;
            placeholder=@"请输入11位手机号码";
            break;
        }
        case 1:{
            if (!_period) {
                text=@"";
            }
            else {
                text=[NSString stringWithFormat:@"%d年%d月",_period.year,_period.month];
            }
            placeholder=@"请选择";
            break;
        }
        default:
            break;
    }
    
    BaseTableViewCell *baseCell;
    
    if (type==0) {
        NSString *identifier=@"DetailTableViewCell";
        DetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        WEAK_SELF;
        [cell setContentWithDetail:text placeholder:placeholder];
        baseCell=cell;
    }
    else if (type==1){
        NSString *identifier=@"TextTableViewCell";
        TextTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        WEAK_SELF;
        [cell setContentWithText:text placeholder:placeholder limit:limit editBlock:^(NSString *str) {
            NSLog(@"did edit : %@",str);
            weakSelf.mobile=str;
        }];
        [cell setKeyboardType:UIKeyboardTypeNumberPad];
        baseCell=cell;
    }
    else{
        //防错
        NSString *identifier=@"BaseTableViewCell";
        baseCell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (baseCell==nil) {
            baseCell=[[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    [baseCell setContentWithTitle:[_titleArray objectAtIndex:indexPath.row]];
    return baseCell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1) {
        [self presentViewController:self.periodActionSheet animated:YES completion:nil];
    }
}

-(PeriodActionSheet *)periodActionSheet{
    if (!_periodActionSheet) {
        WEAK_SELF
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Popover" bundle:nil];
        _periodActionSheet=[story instantiateViewControllerWithIdentifier:@"PeriodActionSheet"];
        
        NSDateComponents *date=[[TimeUtil getInstance] currentDateCompoent];
        int year=(int)date.year;
        int month=(int)date.month;
        
        NSMutableArray *periodArray=[NSMutableArray array];
        for (int i=1; i<4; i++) {
            BillPeriodInfo *period=[[BillPeriodInfo alloc]init];
            if (month<=i) {
                period.year=year-1;
                period.month=month+12-i;
            }
            else{
                period.year=year;
                period.month=month-i;
            }
            [periodArray addObject:period];
        }
        
        [_periodActionSheet setPeriodArray:periodArray confirmBlock:^(id object) {
            if (object) {
                if ([object isKindOfClass:[BillPeriodInfo class]]) {
                    weakSelf.period=object;
                    [weakSelf.tableView reloadData];
                }
            }
        }];
    }
    return _periodActionSheet;
}


- (void)buttonClickAction:(UIButton *)button{
    [self.view endEditing:YES];

    if (![Utils isMobile:_mobile]) {
        [Utils toastview:@"请输入正确格式手机号"];
        return;
    }

    if (!_period) {
        [Utils toastview:@"请选择账期"];
        return;
    }
    
    [self showWaitView];
    @WeakObj(self);
    [WebUtils agency_getBillWithTel:_mobile accountPeriod:[NSString stringWithFormat:@"%d%02d",_period.year,_period.month] andCallBack:^(id obj) {
        @StrongObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWaitView];
        });
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                
                NSLog(@"%@",obj[@"data"]);
                BillInfo *bill=[[BillInfo alloc]initWithDictionary:obj[@"data"]];
                
                UIStoryboard* story = [UIStoryboard storyboardWithName:@"Bill" bundle:nil];
                BillDetailViewController *vc=[story instantiateViewControllerWithIdentifier:@"BillDetailViewController"];
                [vc setBill:bill];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
    
    
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
