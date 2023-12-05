//
//  WhitePrepareOpenThreeView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "WhitePrepareOpenThreeView.h"

static const CGFloat openWay = 217/375.0;

@interface WhitePrepareOpenThreeView ()

@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSArray *imageNamesArray;

@end

@implementation WhitePrepareOpenThreeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.openArray = [NSMutableArray array];
        self.backgroundColor = COLOR_BACKGROUND;
        self.titlesArray = @[@"识别仪开户",@"扫描开户"];
        self.imageNamesArray = @[@"entrance_pic3",@"entrance_pic4"];
        CGFloat height = openWay * screenWidth;
        for (int i = 0; i < self.titlesArray.count; i ++) {
            OpenWayView *openWay = [[OpenWayView alloc] initWithFrame:CGRectMake(0, i * (height + 10), screenWidth, height)];
            openWay.chooseButton.tag = i;
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
