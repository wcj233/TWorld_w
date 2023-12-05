//
//  TopAndInquiryView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/20.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "TopAndInquiryView.h"
#import "TopView.h"
#import "FilterView.h"
#import "TopAndInquiryViewController.h"

#define leftDistance (screenWidth - 210)/2.0

@interface TopAndInquiryView ()

@property (nonatomic) TopView *topView;
@property (nonatomic) FilterView *selectView;
@property (nonatomic) UIView *grayView;
@property (nonatomic) NSArray *arrTitles;

@end

@implementation TopAndInquiryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.arrTitles = @[@"起始时间：",@"截止时间：",@"",@""];
        
        self.topView = [[TopView alloc] initWithFrame:CGRectZero andTitles:@[@""] andResultTitles:@[@"起始时间：",@"截止时间："]];
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(-40);
            make.height.mas_equalTo(80);
        }];
        
        self.contentView = [[OrderTwoView alloc] init];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        /*-----筛选框new--------*/
        self.selectView = [[FilterView alloc] initWithFrame:CGRectMake(0, 40, screenWidth, 160)];
        self.selectView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.selectView];
        self.selectView.hidden = YES;
        self.selectView.orderStates = nil;
        self.selectView.titles = @[@"起始时间",@"截止时间"];
        self.selectView.details = @[@"请选择",@"请选择"];
        [self.selectView.filterTableView reloadData];
        
        
        CGRect frame1 = self.selectView.cancelButton.frame;
        frame1.origin.y = 64+40+200;
        CGRect frame2 = self.selectView.closeImagePickerButton.frame;
        frame2.origin.y = 64+40+200;
        self.selectView.cancelButton.frame = frame1;
        self.selectView.closeImagePickerButton.frame = frame2;
        
        [self.selectView.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenHeight - 64 - 40 - 200 );
        }];
        
        [self.selectView.beginDatePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(screenWidth);
            make.height.mas_equalTo(screenHeight - 64 - 40 - 200 );
        }];
        
        [self.selectView.findBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftDistance);
            make.top.mas_equalTo(112);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
        [self.selectView.resetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-leftDistance);
            make.top.mas_equalTo(112);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(30);
        }];
        
        [self grayView];
        
        @WeakObj(self);
        
        [self.topView setCallback:^(NSInteger tag) {
            /*---按钮点击事件-没有按钮--*/
            
        }];
        
        [self.topView setTopCallBack:^(id obj) {
            @StrongObj(self);
            [self endEditing:YES];

            // 点击筛选栏时的操作
            if (self.selectView.hidden == NO) {
                self.topView.showButton.transform = CGAffineTransformMakeRotation(M_PI_2*2);
                [UIView animateWithDuration:0.3 animations:^{
                    self.selectView.alpha = 0;
                    self.grayView.alpha = 0;
                } completion:^(BOOL finished) {
                    self.selectView.hidden = YES;
                    self.grayView.hidden = YES;
                }];
            }else{
                self.topView.showButton.transform = CGAffineTransformIdentity;
                self.selectView.hidden = NO;
                self.grayView.hidden = NO;
                self.selectView.alpha = 0;
                self.grayView.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    self.selectView.alpha = 1;
                    self.grayView.alpha = 0.5;
                } completion:^(BOOL finished) {
                }];
            }
        }];
        
        [self.selectView setFilterCallBack:^(NSArray *array,NSString *string) {
            @StrongObj(self);
            int k = 0;
            for (int i = 0; i < array.count; i++) {
                if ([array[i] isEqualToString:@"无"]) {
                    k ++;
                }
            }
            if (k == array.count) {
                //说明没有查询条件
                
                [TopAndInquiryViewController sharedTopAndInquiryViewController].inquiryConditionArray = array;

                
                [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(-40);
                    make.height.mas_equalTo(80);
                }];
                
            }else{
                if ([string isEqualToString:@"查询"]) {
                    [TopAndInquiryViewController sharedTopAndInquiryViewController].inquiryConditionArray = array;
                    [[TopAndInquiryViewController sharedTopAndInquiryViewController].inquiryView.contentView.orderTwoTableView.mj_header beginRefreshing];
                }
                
                for (int i = 0; i < array.count; i++) {
                    UILabel *lb = self.topView.resultArr[i];
                    if (array[i]) {
                        lb.text = [NSString stringWithFormat:@"%@%@",self.arrTitles[i],array[i]];
                        lb.font = [UIFont systemFontOfSize:14*screenWidth/414.0];
                    }
                }
                
                [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(0);
                    make.top.mas_equalTo(-40);
                    make.height.mas_equalTo(110);
                }];
            }
            
            self.topView.showButton.transform = CGAffineTransformMakeRotation(M_PI_2*2);
            
            if ([string isEqualToString:@"查询"]) {
                [[TopAndInquiryViewController sharedTopAndInquiryViewController].inquiryView.contentView.orderTwoTableView.mj_header beginRefreshing];
                self.selectView.hidden = YES;
                self.grayView.hidden = YES;
            }
        }];
        
        [self.selectView setDismissPickerViewCallBack:^(id obj) {
            
            @StrongObj(self);
            self.selectView.beginDatePicker.hidden = YES;
            self.selectView.pickView.hidden = YES;
            self.selectView.pickerView.hidden = YES;
            self.selectView.closeImagePickerButton.hidden = YES;
            self.selectView.cancelButton.hidden = YES;
        }];
    }
    return self;
}

- (UIView *)grayView{
    if (_grayView == nil) {
        _grayView = [[UIView alloc] init];
        [self addSubview:_grayView];
        _grayView.backgroundColor = [UIColor lightGrayColor];
        _grayView.alpha = 0.5;
        [_grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.selectView.mas_bottom).mas_equalTo(0);
        }];
        _grayView.hidden = YES;
        UITapGestureRecognizer *tapGrayGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_grayView addGestureRecognizer:tapGrayGR];
    }
    return _grayView;
}

#pragma mark - Method
- (void)tapAction{
    [self endEditing:YES];
    @WeakObj(self);
    if (self.selectView.hidden == NO) {
        self.topView.showButton.transform = CGAffineTransformMakeRotation(M_PI_2*2);
        [UIView animateWithDuration:0.3 animations:^{
            @StrongObj(self);
            self.selectView.alpha = 0;
            self.grayView.alpha = 0;
        } completion:^(BOOL finished) {
            @StrongObj(self);
            self.selectView.hidden = YES;
            self.grayView.hidden = YES;
        }];
    }else{
        self.topView.showButton.transform = CGAffineTransformIdentity;
        self.selectView.hidden = NO;
        self.grayView.hidden = NO;
        self.selectView.alpha = 0;
        self.grayView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            @StrongObj(self);
            self.selectView.alpha = 1;
            self.grayView.alpha = 0.5;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
