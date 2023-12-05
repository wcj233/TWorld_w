//
//  PeriodActionSheet.m
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "PeriodActionSheet.h"

@interface PeriodActionSheet () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property(nonatomic,retain)NSArray<BillPeriodInfo *> *periodArray;

@property(nonatomic,copy)FAObjectCallBackBlock confirmBlock;
@end

@implementation PeriodActionSheet

-(void)setPeriodArray:(NSArray<BillPeriodInfo *> *)periodArray confirmBlock:(FAObjectCallBackBlock)confirmBlock{
    _periodArray=periodArray;
    _confirmBlock=confirmBlock;
    [_pickerView reloadAllComponents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource=self;
    _pickerView.delegate=self;
    
    [_pickerView selectRow:0 inComponent:0 animated:NO];
}

-(CGRect)slideInTargetFrameOfState:(FASlideInAnimationState)state{
    float height=220;
    if (state==FASlideInAnimationStatePresenting) {
        return CGRectMake(0, screenHeight-height, screenWidth, height);
    }
    else{
        return CGRectMake(0, screenHeight, screenWidth, height);
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _periodArray.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 31;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d年%d月",[_periodArray objectAtIndex:row].year,[_periodArray objectAtIndex:row].month];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirm:(id)sender {
    if (_confirmBlock) {
        _confirmBlock([_periodArray objectAtIndex:(int)[_pickerView selectedRowInComponent:0]]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
