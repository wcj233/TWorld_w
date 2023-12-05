//
//  LuckdrawViewController.m
//  PhoneWorld
//
//  Created by andy on 2018/4/25.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LuckdrawViewController.h"
#import "LuckyRecordVC.h"

@interface LuckdrawViewController ()
@property(nonatomic, strong) UILabel *activityTimeLab;
@property(nonatomic, strong) UILabel *activityDetailLab;
@property(nonatomic, strong) UILabel *LuckyDrawNumLab;
@property(nonatomic, strong) UILabel *LuckyDrawDetailLab;
@property(nonatomic, strong) UIView *DrawView;

@end

@implementation LuckdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抽奖活动";
    
    [self prepareData];
    [self configUI];
    [self showDrawView];

}
#pragma mark intviewcontroller
-(void)prepareData
{
   
    [self getLuckyNum];
   
    [self getWarningText];

    
}


-(void)getLuckyNum
{
    @WeakObj(self);
    [WebUtils requestgetLuckNumbertWithCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //有警告文字
                dispatch_async(dispatch_get_main_queue(), ^{
                    int numbers = [obj[@"data"][@"numbers"] intValue];
                    _LuckyDrawNumLab.text = [[NSString alloc]initWithFormat:@"您还有%d次抽奖机会",numbers];
                });
            }
        }
    }];
}


-(void)getLuckyDraw
{
    @WeakObj(self);
    [WebUtils requestluckyDrawWithCallBack:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        
        if ([dic[@"code"] integerValue] == 10000) {
            
            //有警告文字
            dispatch_async(dispatch_get_main_queue(), ^{
                _DrawView.hidden = NO;
                _LuckyDrawDetailLab.text = dic[@"mes"];
            });

        }else
        {
            [self showWarningText:obj[@"mes"]];

        }
        
        [self getLuckyNum];

        
        
    }];
}

- (void)getWarningText{
    
    @WeakObj(self);
    
    [WebUtils requestWarningTextWithType:3 andCallBack:^(id obj) {
        @StrongObj(self);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                //有警告文字
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *warningString = @"";
                    NSArray *tipsArray = obj[@"data"][@"tips"];

                    for (int i = 0; i < tipsArray.count; i ++) {
                        NSDictionary *tipsDic = tipsArray[i];
                        if ([tipsDic[@"sequence"] intValue]==1) {
                            self.activityTimeLab.text=tipsDic[@"tips"];
                        }
                        else{
                            
                            warningString = [warningString stringByAppendingString:[NSString stringWithFormat:@"%d.%@\n",i,tipsDic[@"tips"]]];
                        }

                    }
                    
                    
                    _activityDetailLab.text = warningString;

//                    self.transferCardView.warningLabel.text = warningString;
//
//                    [self.transferCardView.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.top.mas_equalTo(self.transferCardView.warningLabel.mas_bottom).mas_equalTo(40);
//                        make.centerX.mas_equalTo(0);
//                        make.height.mas_equalTo(40);
//                        make.width.mas_equalTo(171);
//                        make.bottom.mas_equalTo(-40);
//                    }];

                });
                
            }
        }
    }];
}


-(void)configUI
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"bg"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIImageView *hbbgimageView = [[UIImageView alloc]init];
    [imageView addSubview:hbbgimageView];
    hbbgimageView.image = [UIImage imageNamed:@"hbbg"];
    [hbbgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(imageView);
        make.width.mas_equalTo(295);
        make.height.mas_equalTo(316);
    }];
    
    UIButton *drawBtn = [[UIButton alloc]init];
//    drawBtn.backgroundColor = [UIColor redColor];
    [drawBtn addTarget:self action:@selector(drawAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:drawBtn];
    [drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hbbgimageView.mas_bottom).offset(-10);
        make.centerX.mas_equalTo(imageView);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(60);
    }];
    
    [drawBtn setImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    
    
    UIImageView *ruleimageView = [[UIImageView alloc]init];
    [imageView addSubview:ruleimageView];
    ruleimageView.image = [UIImage imageNamed:@"说明bg"];
    [ruleimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.centerX.mas_equalTo(imageView);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(178);
    }];
    
    UILabel * huodongLab = [[UILabel alloc]init];
    huodongLab.text = @"活动时间";
    huodongLab.font = [UIFont systemFontOfSize:10];
    huodongLab.textColor = [Utils colorRGB:@"#666666"];
    [ruleimageView addSubview:huodongLab];
    [huodongLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    
    
    _activityTimeLab = [[UILabel alloc]init];
    _activityTimeLab.text = @"2017.01.01-2017.01.20";
    _activityTimeLab.font = [UIFont systemFontOfSize:10];
    _activityTimeLab.textColor = [Utils colorRGB:@"#999999"];
    [ruleimageView addSubview:_activityTimeLab];
    [_activityTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(huodongLab.mas_bottom).mas_offset(2);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    
    UILabel * huodongRuleLab = [[UILabel alloc]init];
    huodongRuleLab.text = @"活动规则";
    huodongRuleLab.font = [UIFont systemFontOfSize:10];
    huodongRuleLab.textColor = [Utils colorRGB:@"#666666"];
    [ruleimageView addSubview:huodongRuleLab];
    [huodongRuleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(_activityTimeLab.mas_bottom).mas_offset(2);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(15);
    }];
    
    _activityDetailLab = [[UILabel alloc]init];
    _activityDetailLab.text = @"fnjdskanfjkdlanskjfdnjkalnfdjklanfdjknafjkdlsajfdbsajlbfdjklsabfjdksabfdkjlsbajfldbsajklfbdlajksbfdjlsabfdlsabfldsbakljfklj";
    _activityDetailLab.numberOfLines = 0;
    _activityDetailLab.font = [UIFont systemFontOfSize:10];
    _activityDetailLab.textColor = [Utils colorRGB:@"#999999"];
    [ruleimageView addSubview:_activityDetailLab];
    [_activityDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(huodongRuleLab.mas_bottom).mas_offset(-2);
        make.right.mas_equalTo(-20);
//        make.bottom.mas_equalTo(-10);
    }];


    _LuckyDrawNumLab = [[UILabel alloc]init];
    _LuckyDrawNumLab.text = @"您还有0次抽奖机会";
    _LuckyDrawNumLab.numberOfLines = 0;
    _LuckyDrawNumLab.textAlignment = 1;
    _LuckyDrawNumLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
//    _LuckyDrawNumLab.font = [UIFont systemFontOfSize:16];
    _LuckyDrawNumLab.textColor = [Utils colorRGB:@"#EC6C00"];
    [hbbgimageView addSubview:_LuckyDrawNumLab];
    [_LuckyDrawNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(76);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        
        //        make.bottom.mas_equalTo(-10);
    }];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"抽奖记录" style:UIBarButtonItemStylePlain target:self action:@selector(gotoRecordVCAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textfont14], NSForegroundColorAttributeName:[Utils colorRGB:@"#008BD5"]} forState:UIControlStateNormal];
    

    
}

#pragma mark buttonAction
-(void)drawAction
{
    [self getLuckyDraw];

}
-(void)gotoRecordVCAction
{
    LuckyRecordVC *vc = [[LuckyRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)hiddenDrawView
{
    _DrawView.hidden = YES;
}

-(void)showDrawView
{
    
    _DrawView = [[UIView alloc]init];
    _DrawView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4];
    [self.view addSubview:_DrawView];
    
    [_DrawView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(0);
        
    }];
    
    UIImageView *hbbgimageView = [[UIImageView alloc]init];
    [_DrawView addSubview:hbbgimageView];
    hbbgimageView.userInteractionEnabled = YES;
    hbbgimageView.image = [UIImage imageNamed:@"tcbg"];
    [hbbgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150);
        make.centerX.mas_equalTo(_DrawView);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(260);
    }];

    
    UIButton *drawBtn = [[UIButton alloc]init];
    //    drawBtn.backgroundColor = [UIColor redColor];
    [drawBtn addTarget:self action:@selector(hiddenDrawView) forControlEvents:UIControlEventTouchUpInside];
    [hbbgimageView addSubview:drawBtn];
    [drawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.centerX.mas_equalTo(hbbgimageView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
    }];
    
    [drawBtn setImage:[UIImage imageNamed:@"tcbtn"] forState:UIControlStateNormal];
    

//    UIButton *hiddenBtn = [[UIButton alloc]init];
////        hiddenBtn.backgroundColor = [UIColor redColor];
//    [hiddenBtn addTarget:self action:@selector(hiddenDrawView) forControlEvents:UIControlEventTouchUpInside];
//    [hbbgimageView addSubview:hiddenBtn];
//    [hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//        make.right.mas_equalTo(0);
//
//    }];

    
    
    
    _LuckyDrawDetailLab = [[UILabel alloc]init];
    _LuckyDrawDetailLab.text = @"恭喜！您获得现金500元";
    _LuckyDrawDetailLab.numberOfLines = 0;
//    _LuckyDrawDetailLab.backgroundColor = [UIColor redColor];
    _LuckyDrawDetailLab.textAlignment = 1;
    _LuckyDrawDetailLab.font = [UIFont fontWithName:@"Jkaton" size:18];
    //    _LuckyDrawNumLab.font = [UIFont systemFontOfSize:16];
    _LuckyDrawDetailLab.textColor = [Utils colorRGB:@"#000000"];
    [hbbgimageView addSubview:_LuckyDrawDetailLab];
    [_LuckyDrawDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(50);
    }];
    
    
    _DrawView.hidden = YES;

}
    
@end
