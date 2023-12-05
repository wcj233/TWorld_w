//
//  DateActionSheet.m
//  PhoneWorld
//
//  Created by fym on 2018/7/25.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "DateActionSheet.h"

@interface DateActionSheet ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property(nonatomic,assign)int currentTime;
@property(nonatomic,copy)FAIntCallBackBlock confirmBlock;

@end

@implementation DateActionSheet

-(void)setCurrentTime:(int)currentTime ConfirmBlock:(FAIntCallBackBlock)confirmBlock{
    _currentTime=currentTime;
    _confirmBlock=confirmBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_currentTime>0) {
        [_datePicker setDate:[NSDate dateWithTimeIntervalSince1970:_currentTime]];
    }
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

- (IBAction)confirm:(id)sender {
    if (_confirmBlock) {
        _confirmBlock([_datePicker.date timeIntervalSince1970]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
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
