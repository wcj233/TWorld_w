//
//  AgentResultView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentResultView : UIScrollView

@property (nonatomic) UIView *whiteBackView;

@property (nonatomic) UIImageView *showImageView;
@property (nonatomic) UILabel *promptLabel;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UILabel *showLabel;

@property (nonatomic) NSMutableArray<UILabel *> *dataLabelsArray;

@end
