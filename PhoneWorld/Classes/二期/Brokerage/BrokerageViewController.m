//
//  BrokerageViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/21.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BrokerageViewController.h"
#import "BrokerageListViewController.h"
#import "PeriodActionSheet.h"
#import "TimeUtil.h"

@interface BrokerageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong)BrokerageListViewController *listVC1;
@property(nonatomic,strong)BrokerageListViewController *listVC2;
@property(nonatomic,strong)BrokerageListViewController *listVC3;
@property(nonatomic,retain)NSArray<BrokerageListViewController *> *vcArray;
@property(nonatomic,retain)NSArray<UIButton *> *buttonArray;

@property(nonatomic,assign)BOOL *shouldRefresh;

@property(nonatomic,assign)int currentPage;

@property(nonatomic,retain)BillPeriodInfo *period;
@property(nonatomic,strong)PeriodActionSheet *periodActionSheet;

@end

@implementation BrokerageViewController

-(void)setTotalBrokerage:(NSString *)total index:(int)index{
    if (index==_currentPage) {
        if (total) {
            _totalLabel.text=[NSString stringWithFormat:@"%@%@元",index==2?@"-":@"",total];
        }
        else{
            _totalLabel.text=@"0元";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的佣金";

    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"账期" style:UIBarButtonItemStylePlain target:self action:@selector(right)];
    right.tintColor=[Utils colorRGB:@"#008BD5"];
    self.navigationItem.rightBarButtonItem=right;
    
    _scrollView.delegate=self;
    
    _vcArray=@[_listVC1,_listVC2,_listVC3];
    _buttonArray=@[_button1,_button2,_button3];
    
    _shouldRefresh=malloc(3*sizeof(BOOL));
    _shouldRefresh[0]=YES;
    _shouldRefresh[1]=YES;
    _shouldRefresh[2]=YES;
    
    _currentPage=0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_shouldRefresh[_currentPage]) {
        [_vcArray[_currentPage] refresh];
        _shouldRefresh[_currentPage]=NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float x=scrollView.contentOffset.x;
//    NSLog(@"%.2f",x);
    for (int i=0; i<3; i++) {
        if (_shouldRefresh[i]) {
            if (x<(i+1)*screenWidth&&x>(i-1)*screenWidth) {
                [_vcArray[i] refresh];
                _shouldRefresh[i]=NO;
            }
        }
    }
    
    int page=roundf(scrollView.contentOffset.x/screenWidth);
    if (page!=_currentPage) {
        [_buttonArray objectAtIndex:_currentPage].enabled=YES;
        _currentPage=page;
        [_buttonArray objectAtIndex:_currentPage].enabled=NO;
        
        [self setTotalBrokerage:_vcArray[_currentPage].total index:_currentPage];
    }
}

- (IBAction)PageButtonTouched:(UIButton *)sender {
    int index=(int)[_buttonArray indexOfObject:sender];
    
    [_scrollView setContentOffset:CGPointMake(index*screenWidth, 0) animated:YES];
}

-(void)right{
    [self presentViewController:self.periodActionSheet animated:YES completion:nil];
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
        for (int i=0; i<month; i++) {
            BillPeriodInfo *period=[[BillPeriodInfo alloc]init];
            period.year=year;
            period.month=month-i;
            [periodArray addObject:period];
        }
        
        [_periodActionSheet setPeriodArray:periodArray confirmBlock:^(id object) {
            if (object) {
                if ([object isKindOfClass:[BillPeriodInfo class]]) {
                    weakSelf.period=object;
                    NSString *periodString=[NSString stringWithFormat:@"%d%02d",weakSelf.period.year,weakSelf.period.month];
                    for (int i=0;i<weakSelf.vcArray.count;i++) {
                        [weakSelf.vcArray objectAtIndex:i].periodString=periodString;
                        if (i==weakSelf.currentPage) {
                            [[weakSelf.vcArray objectAtIndex:i] refresh];
                        }
                        else{
                            weakSelf.shouldRefresh[i]=YES;
                        }
                    }
                    
                }
            }
        }];
    }
    return _periodActionSheet;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"List1"]) {
        _listVC1=segue.destinationViewController;
        _listVC1.parentVC=self;
        [_listVC1 setType:1];
    }
    else if ([segue.identifier isEqualToString:@"List2"]) {
        _listVC2=segue.destinationViewController;
        _listVC2.parentVC=self;
        [_listVC2 setType:2];
    }
    else if ([segue.identifier isEqualToString:@"List3"]) {
        _listVC3=segue.destinationViewController;
        _listVC3.parentVC=self;
        [_listVC3 setType:3];
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
