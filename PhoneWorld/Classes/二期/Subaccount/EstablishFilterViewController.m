//
//  EstablishFilterViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "EstablishFilterViewController.h"
#import "DetailTableViewCell.h"
#import "TextTableViewCell.h"
#import "TimeUtil.h"
#import "DateActionSheet.h"

@interface EstablishFilterViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property(nonatomic,retain)NSArray<NSString *> *titleArray;
@property(nonatomic,retain)NSArray<UIButton *> *buttonArray;

@property(nonatomic,copy)FAObjectCallBackBlock filterBlock;

@property(nonatomic,retain)OrderFilterInfo *orderFilter;
@end

@implementation EstablishFilterViewController

-(void)setOrderFilter:(OrderFilterInfo *)orderFilter{
    _orderFilter=[[OrderFilterInfo alloc]init];
    
//    @property(nonatomic,assign)int status;
//    @property(nonatomic,copy)NSString *mobile;
//    @property(nonatomic,copy)NSString *way;
//    @property(nonatomic,assign)int startTime;
////    @property(nonatomic,assign)int endTime;
    _orderFilter.status=orderFilter.status;
    _orderFilter.mobile=orderFilter.mobile;
    _orderFilter.way=orderFilter.way;
    _orderFilter.startTime=orderFilter.startTime;
    _orderFilter.endTime=orderFilter.endTime;
    
    [_tableView reloadData];
}

-(void)setFilterBlock:(FAObjectCallBackBlock)filterBlock{
    _filterBlock=filterBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _buttonArray=@[_button1,_button2,_button3];
    _titleArray=@[@"手机号码",@"受理渠道",@"开始时间",@"结束时间"];
    
    
    _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.dataSource=self;
    _tableView.delegate=self;
}

-(IBAction)indexButtonTouched:(UIButton *)sender{
    sender.enabled=NO;
    sender.titleLabel.font=[UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    for (UIButton *button in _buttonArray) {
        if (button!=sender) {
            button.enabled=YES;
            button.titleLabel.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        }
    }
    
    int index=(int)[_buttonArray indexOfObject:sender];
    
    _orderFilter.status=index;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
            text=_orderFilter.mobile;
            placeholder=@"请输入11位手机号码";
            break;
        }
        case 1:{
            type=1;
            limit=0;
            text=_orderFilter.way;
            placeholder=@"请输入渠道关键字";
            break;
        }
        case 2:{
            text=_orderFilter.startTime==0?@"":[[TimeUtil getInstance] dateStringFromSecondYMR:_orderFilter.startTime separator:@"-"];
            placeholder=@"请选择";
            break;
        }
        case 3:{
            text=_orderFilter.endTime==0?@"":[[TimeUtil getInstance] dateStringFromSecondYMR:_orderFilter.endTime separator:@"-"];
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
            if (indexPath.row==0) {
                _orderFilter.mobile=str;
            }
            else if (indexPath.row==1) {
                _orderFilter.way=str;
            }
        }];
        if (indexPath.row==0) {
            [cell setKeyboardType:UIKeyboardTypeNumberPad];
        }
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
    if (indexPath.row==0||indexPath.row==1) {
        return NO;
    }
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==2) {
        
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Popover" bundle:nil];
        DateActionSheet *vc=[story instantiateViewControllerWithIdentifier:@"DateActionSheet"];
        WEAK_SELF
        [vc setCurrentTime:_orderFilter.startTime ConfirmBlock:^(int type) {
            weakSelf.orderFilter.startTime=type;
            [weakSelf.tableView reloadData];
        }];
        [self.parentVC presentViewController:vc animated:YES completion:nil];
    }
    else if (indexPath.row==3) {
        
        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Popover" bundle:nil];
        DateActionSheet *vc=[story instantiateViewControllerWithIdentifier:@"DateActionSheet"];
        WEAK_SELF
        [vc setCurrentTime:_orderFilter.endTime ConfirmBlock:^(int type) {
            weakSelf.orderFilter.endTime=type;
            [weakSelf.tableView reloadData];
        }];
        [self.parentVC presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)reset:(id)sender {
    _orderFilter=[[OrderFilterInfo alloc]init];
    [_tableView reloadData];
    [self indexButtonTouched:_button1];
}

- (IBAction)search:(id)sender {
    
    [self.view endEditing:YES];
    if (!IS_EMPTY(_orderFilter.mobile)) {
        if (![Utils isMobile:_orderFilter.mobile]) {
            [Utils toastview:@"请输入正确格式手机号"];
            return;
        }
    }
    if (_filterBlock) {
        _filterBlock(_orderFilter);
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
