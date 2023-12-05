//
//  NewFinishedCardDetailViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "NewFinishedCardDetailViewController.h"
#import "DetailTableViewCell.h"
#import "TextTableViewCell.h"
#import "DisplayTableViewCell.h"

#import "ChoosePackageDetailViewController.h"
#import "InformationCollectionViewController.h"

@interface NewFinishedCardDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,retain)NSArray<NSString *> *titleArray;

@property (nonatomic,retain)PhoneDetailModel *phone;

@property (nonatomic) NSArray *packagesDic;//所有套餐
@property (nonatomic) NSDictionary *currentDic;//当前选中套餐
@property (nonatomic) NSDictionary *currentPromotionDic;//当前选中活动包

@end

@implementation NewFinishedCardDetailViewController

-(void)setPhone:(PhoneDetailModel *)phone{
    _phone=phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"号码详情";
    
    if (_phone.packages) {
        self.packagesDic=_phone.packages;
    }
    else{
        self.packagesDic = [NSArray array];
    }
    self.currentDic = [NSDictionary dictionary];
    
    _titleArray=@[@"号码",@"归属地",@"运营商",@"预存话费",@"状态",@"套餐选择",@"活动包选择"];
    
    _tableView.backgroundColor=COLOR_BACKGROUND;
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.estimatedRowHeight = 60;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==5||indexPath.row==6) {
        return 70;
//        return UITableViewAutomaticDimension;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int type=0;
    NSString *text=@"";
    NSString *placeholder=@"";
//    int limit=100;
    
    switch (indexPath.row) {
        case 0:{
            type=2;
            text=_phone.number;
            break;
        }
        case 1:{
            type=2;
            text=_phone.cityName;
            break;
        }
        case 2:{
            type=2;
            text=_phone.operatorName;
            break;
        }
        case 3:{
            type=2;
            text=_phone.prestore;
            break;
        }
        case 4:{
            type=2;
            text=_phone.numberStatus;
            break;
        }
        case 5:{
            text=_currentDic[@"name"];
            placeholder=@"请选择";
            break;
        }
        case 6:{
            text=_currentPromotionDic[@"name"];
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
    else if (type==2){
        NSString *identifier=@"DisplayTableViewCell";
        DisplayTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell=[[DisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        [cell setContentWithDetail:text];

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
    if (indexPath.row==5||indexPath.row==6) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==5) {
        // 套餐选择
        WEAK_SELF
        ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
        vc.title = @"套餐选择";
        vc.packagesDic = self.packagesDic;//所有套餐

        [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
            weakSelf.currentDic = currentDic;
            [weakSelf.tableView reloadData];
            
            NormalTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
            cell.detailLabel.text = @"请选择";
            weakSelf.currentPromotionDic = nil;
            
        }];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row==6) {
        
        if (!self.currentDic[@"id"]) {
            [Utils toastview:@"套餐未选择"];
        }
        else{
            WEAK_SELF
            
            ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
            vc.title = @"活动包选择";
            
            
            [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                weakSelf.currentPromotionDic = currentDic;
                [weakSelf.tableView reloadData];
            }];
            
            vc.currentID = self.currentDic[@"id"];//当前选中套餐ID
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (IBAction)next:(id)sender {
    if (!self.currentDic) {
        [Utils toastview:@"请选择套餐"];
        return;
    }
    
    if (!self.currentPromotionDic) {
        [Utils toastview:@"请选择活动包"];
        return;
    }
    
//    __weak __typeof(self)weakSelf = self;
//    [WebUtils requestWithCardModeWithCallBack:^(id obj) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            if ([obj[@"code"] isEqualToString:@"10000"]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [[NSUserDefaults standardUserDefaults]setObject:obj[@"data"] forKey:@"kaihuMode"];
//                    [[NSUserDefaults standardUserDefaults]synchronize];
                    InformationCollectionViewController *vc = [[InformationCollectionViewController alloc] init];
                    vc.isFaceCheck = self.isFaceCheck;
                    vc.isFinished = YES;
                    vc.detailModel = self.phone;
                    vc.currentPackageDictionary = self.currentDic;
                    vc.currentPromotionDictionary = self.currentPromotionDic;
                    vc.cardOpenMode = self.cardOpenMode;
                    vc.moneyString = [_phone.prestore stringByReplacingOccurrencesOfString:@"元" withString:@""];
                    [self.navigationController pushViewController:vc animated:YES];
                    
//                });
//
//
//            }
//        }
//    }];
    
   
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
