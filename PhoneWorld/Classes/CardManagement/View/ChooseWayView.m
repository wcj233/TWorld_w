//
//  ChooseWayView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 17/2/10.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseWayView.h"

static const CGFloat openWay = 217/375.0;

@interface ChooseWayView ()

@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSArray *imageNamesArray;

@end

@implementation ChooseWayView

- (instancetype)initWithMode:(int)mode
{
    self = [super init];
    if (self) {
        
        self.openArray = [NSMutableArray array];
        self.backgroundColor = COLOR_BACKGROUND;
//        self.titlesArray = @[@"识别仪开户",@"扫描开户"];
        self.titlesArray = @[@"普通开户",@"人脸开户"];
        self.imageNamesArray = @[@"entrance_pic4",@"face_pic"];
        if (mode==1) {
            self.titlesArray = @[@"普通开户"];
            self.imageNamesArray = @[@"entrance_pic4"];
        }else if (mode==2){
            self.titlesArray = @[@"人脸开户"];
            self.imageNamesArray = @[@"face_pic"];
        }

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
        
//        [self containerView];
//        [self shibieyiButton];
//        [self saomiaoButton];
    }
    return self;
}

//- (UIView *)containerView{
//    if (_containerView == nil) {
//        _containerView = [[UIView alloc] init];
//        [self addSubview:_containerView];
//        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(-50);
//            make.centerY.mas_equalTo(0);
//            make.left.right.mas_equalTo(0);
//        }];
//    }
//    return _containerView;
//}
//
//- (UIButton *)shibieyiButton{
//    if (_shibieyiButton == nil) {
//        _shibieyiButton = [Utils returnNextButtonWithTitle:@"识别仪开户"];
//        [self.containerView addSubview:_shibieyiButton];
//        [_shibieyiButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.height.mas_equalTo(80);
//            make.width.mas_equalTo(250);
//            make.centerX.mas_equalTo(0);
//        }];
//        [_shibieyiButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        _shibieyiButton.titleLabel.font = [UIFont systemFontOfSize:20];
//    }
//    return _shibieyiButton;
//}
//
//- (UIButton *)saomiaoButton{
//    if (_saomiaoButton == nil) {
//        _saomiaoButton = [Utils returnNextButtonWithTitle:@"扫描开户"];
//        [self.containerView addSubview:_saomiaoButton];
//        [_saomiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.shibieyiButton.mas_bottom).mas_equalTo(40);
//            make.height.mas_equalTo(80);
//            make.width.mas_equalTo(250);
//            make.centerX.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//        }];
//        [_saomiaoButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        _saomiaoButton.titleLabel.font = [UIFont systemFontOfSize:20];
//    }
//    return _saomiaoButton;
//}

//- (void)buttonClickAction:(UIButton *)button{
//    _ChooseCallBack(button.currentTitle);
//}


@end
