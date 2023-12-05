//
//  LOrderTopView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/27.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "LOrderTopView.h"

@interface LOrderTopView ()

@property (nonatomic) NSArray *titlesArray;

@property (nonatomic) CGFloat leftDistance;
@property (nonatomic) CGFloat allWidth;//所有button标题文字宽度

@end

@implementation LOrderTopView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andType:(TopButtonsViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.type = type;
        self.titlesArray = titles;
        self.titlesButtonArray = [NSMutableArray array];
        self.leftDistance = 10;
        for (int i = 0; i < self.titlesArray.count; i++) {
            NSString *str = self.titlesArray[i];
            CGSize size = [Utils sizeWithFont:[UIFont systemFontOfSize:textfont14] andMaxSize:CGSizeMake(0, 20) andStr:str];
            self.allWidth += size.width;
        }
        CGFloat distance = (screenWidth - self.allWidth - 20)/(self.titlesArray.count - 1);//文字之间间距

        //添加按钮
        for (int i = 0; i < self.titlesArray.count; i ++) {
            
            NSString *str = self.titlesArray[i];
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = 10 + i;
            btn.titleLabel.font = [UIFont systemFontOfSize:textfont14];
            [btn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[Utils colorRGB:@"#333333"] forState:UIControlStateNormal];//未选中颜色
            [btn setTitleColor:MainColor forState:UIControlStateSelected];//选中颜色
            btn.selected = NO;
            if (i == 0) {
                btn.selected = YES;
            }
            [btn addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.titlesButtonArray addObject:btn];
            
            if (type == TopButtonsViewTypeTwo) {
                //topview上的button均分
                btn.frame = CGRectMake(i*screenWidth/self.titlesArray.count, 0, screenWidth/self.titlesArray.count, 40);
            }else{
                //topView上的title string间距均分
                CGSize size = [Utils sizeWithFont:[UIFont systemFontOfSize:textfont14] andMaxSize:CGSizeMake(0, 20) andStr:str];
                CGFloat btnWidth = size.width;
                
                btn.frame = CGRectMake(self.leftDistance, 0, btnWidth, 40);
                self.leftDistance += (btnWidth + distance);
            }
            
            if (i == 0) {
                self.currentButton = btn;
            }
        }
        
        //添加下划线
        self.lineView = [[UIView alloc] init];
        [self addSubview:self.lineView];
        self.lineView.backgroundColor = MainColor;
        if (type == TopButtonsViewTypeOne) {
            self.lineView.frame = CGRectMake(self.currentButton.frame.origin.x, 39, self.currentButton.frame.size.width, 1);
        }else{
            self.lineView.frame = CGRectMake(0, 39, self.currentButton.frame.size.width, 1);
        }
    }
    return self;
}

- (void)buttonClickedAction:(UIButton *)button{
    
    _TopButtonsCallBack(button.tag);
    
    for (UIButton *btn in self.titlesButtonArray) {
        btn.selected = NO;
    }
    button.selected = YES;
    
    //下划线动画
    if (self.type == TopButtonsViewTypeOne) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = CGRectMake(button.frame.origin.x, 39, button.frame.size.width, 1);
            self.lineView.frame = frame;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = CGRectMake(0, 39, button.frame.size.width, 1);
            self.lineView.frame = frame;
        }];
    }
    
}

@end
