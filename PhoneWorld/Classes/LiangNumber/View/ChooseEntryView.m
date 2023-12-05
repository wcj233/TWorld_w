//
//  ChooseEntryView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseEntryView.h"

static const CGFloat openWay = 170/375.0;

@interface ChooseEntryView ()

@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSArray *imageNamesArray;

@end

@implementation ChooseEntryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.openArray = [NSMutableArray array];
        self.backgroundColor = COLOR_BACKGROUND;
        //self.titlesArray = @[@"代理商靓号",@"话机世界靓号"];
        self.titlesArray=@[@"话机世界靓号",@"代理商靓号",@"白卡申请"];
        self.imageNamesArray = @[@"entrance_pic1",@"entrance_pic2",@"face_pic copy"];
        CGFloat height = openWay * screenWidth;
        for (int i = 0; i < self.titlesArray.count; i ++) {
            OpenWayView *openWay = [[OpenWayView alloc] initWithFrame:CGRectMake(0, i * (height + 10), screenWidth, height)];
            openWay.chooseButton.tag = i;
            [openWay.chooseButton setTitle:@"查看详情" forState:UIControlStateNormal];
            openWay.titleLabel.text = self.titlesArray[i];
            openWay.backImageView.image = [UIImage imageNamed:self.imageNamesArray[i]];
            [self.openArray addObject:openWay];
            [self addSubview:openWay];
        }
        self.contentSize = CGSizeMake(screenWidth, height * self.titlesArray.count + 10);
    }
    return self;
}

@end
