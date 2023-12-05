//
//  STopOrderDetailView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/6.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "STopOrderDetailView.h"

@interface STopOrderDetailView ()

@property (nonatomic) NSArray *titleArray;

@end

@implementation STopOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame andLeftTitlesArray:(NSArray *)titlesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleArray = titlesArray;
        self.labelsArray = [NSMutableArray array];
        
        for (int i = 0; i < self.titleArray.count; i++) {
            
            UILabel *lb = [[UILabel alloc] init];
            [self addSubview:lb];
            
            if (i == 0) {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth);
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(15);
                }];
            }else{
                UILabel *previousLabel = self.labelsArray[i - 1];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth);
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(previousLabel.mas_bottom).mas_equalTo(14);
                }];
            }
            lb.numberOfLines = 0;
            
            lb.textColor = [Utils colorRGB:@"#2a2a2a"];
            
            [self.labelsArray addObject:lb];
            
            if (i == self.titleArray.count - 1) {
                lb.textColor = MainColor;
                UIView *backView = [[UIView alloc] init];
                [self insertSubview:backView atIndex:0];
                backView.backgroundColor = [UIColor whiteColor];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(lb.mas_bottom).mas_equalTo(15);
                }];
            }
            
        }
    }
    return self;
}

- (void)setRechargeListModel:(RechargeListModel *)rechargeListModel{
    _rechargeListModel = rechargeListModel;
    
    NSArray *dataArray = @[rechargeListModel.orderNo, rechargeListModel.startTime, rechargeListModel.number, rechargeListModel.payAmount, rechargeListModel.startName];
    
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *label = self.labelsArray[i];
        NSString *titleString = [NSString stringWithFormat:@"%@",self.titleArray[i]];
        NSString *dataString = [NSString stringWithFormat:@"%@%@",self.titleArray[i],dataArray[i]];
        
        if (i==3) {
            dataString = [NSString stringWithFormat:@"%@%0.2f",self.titleArray[i],[dataArray[i]floatValue] ];

        }
        
        label.attributedText = [Utils setTextColor:dataString FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:16] AndRange:NSMakeRange(0, titleString.length) AndColor:[Utils colorRGB:@"#"]];
        
        
        
    }
    
}

- (void)setRightsOrderListModel:(RightsOrderListModel *)rightsOrderListModel{
    _rightsOrderListModel = rightsOrderListModel;
    
    NSArray *dataArray = @[_rightsOrderListModel.orderNo, _rightsOrderListModel.createDate, _rightsOrderListModel.number, @(_rightsOrderListModel.orderAmount).stringValue, _rightsOrderListModel.statusName];
    
    for (int i = 0; i < dataArray.count; i ++) {
        UILabel *label = self.labelsArray[i];
        NSString *titleString = [NSString stringWithFormat:@"%@",self.titleArray[i]];
        NSString *dataString = [NSString stringWithFormat:@"%@%@",self.titleArray[i],dataArray[i]];
        
        if (i==3) {
            dataString = [NSString stringWithFormat:@"%@%0.2f",self.titleArray[i],[dataArray[i]floatValue] ];

        }
        
        label.attributedText = [Utils setTextColor:dataString FontNumber:[UIFont systemFontOfSize:16] AndRange:NSMakeRange(0, titleString.length) AndColor:[Utils colorRGB:@"#"]];
    }
}

@end
