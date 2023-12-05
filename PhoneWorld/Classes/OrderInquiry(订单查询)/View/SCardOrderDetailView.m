//
//  SCardOrderDetailView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "SCardOrderDetailView.h"
#import "BaiduMapTool.h"
#import "AgentWriteAndChooseViewController.h"

@interface SCardOrderDetailView ()

@property (nonatomic) NSArray *buttonTitlesArray;
@property (nonatomic) CGFloat leftDistance;
@property (nonatomic) CardDetailType type;

//左边标题数组
@property (nonatomic) NSMutableArray *firstArray;
@property (nonatomic) NSArray *secondArray;
@property (nonatomic) NSArray *thirdArray;

//数据数组
@property (nonatomic) NSMutableArray *firstDataArray;
@property (nonatomic) NSMutableArray *secondDataArray;
@property (nonatomic) NSMutableArray *thirdDataArray;

@property (nonatomic) NSMutableArray *firstLabelArray;
@property (nonatomic) NSMutableArray *secondLabelArray;
@property (nonatomic) NSMutableArray *thirdLabelArray;

@end

@implementation SCardOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame andCardDetailType:(CardDetailType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.titleButtons = [NSMutableArray array];
        self.firstLabelArray = [NSMutableArray array];
        self.secondLabelArray = [NSMutableArray array];
        self.thirdLabelArray = [NSMutableArray array];
        
        self.firstDataArray = [NSMutableArray array];
        self.secondDataArray = [NSMutableArray array];
        self.thirdDataArray = [NSMutableArray array];

        switch (type) {
            case ChengKa:
            {
                self.buttonTitlesArray = @[@"订单信息",@"资费信息",@"客户信息"];
                self.firstArray =  [@[@"订单编号：",@"订单时间：",@"订单类型：",@"开户号码：",@"审核时间：",@"审核结果：",@"取消原因："] mutableCopy];
                self.secondArray = @[@"预存金额：",@"活动包：",@"是否靓号："];
                self.thirdArray = @[@"姓名：",@"身份证号码：",@"证件地址："];
            }
                break;
            case BaiKa:
            {
                self.buttonTitlesArray = @[@"订单信息",@"资费信息",@"客户信息"];
                self.firstArray =  [@[@"订单编号：",@"订单时间：",@"订单类型：",@"开户号码：",@"审核时间：",@"审核结果：",@"取消原因："] mutableCopy];
                self.secondArray = @[@"预存金额：",@"活动包：",@"是否靓号："];
                self.thirdArray = @[@"姓名：",@"身份证号码：",@"证件地址："];
            }
                break;
            case GuoHu:
            {
                self.buttonTitlesArray = @[@"订单信息",@"过户信息"];
                self.firstArray =  [@[@"号码：",@"订单时间：",@"审核时间：",@"审核结果："] mutableCopy];
                self.secondArray = @[@"姓名：",@"身份证号码：",@"证件地址：",@"联系电话："];
            }
                break;
            case BuKa:
            {
                self.buttonTitlesArray = @[@"订单信息",@"补卡信息",@"邮寄信息"];
                self.firstArray =  [@[@"开户号码：",@"订单时间：",@"订单类型：",@"审核时间：",@"审核结果："] mutableCopy];
                self.secondArray = @[@"姓名：",@"身份证号码：",@"证件地址：",@"联系电话："];
                self.thirdArray = @[@"收件人姓名：",@"联系电话：",@"邮寄选项：",@"邮寄地址："];
            }
                break;
            case XieKa:{
                self.buttonTitlesArray = @[@"订单信息",@"资费信息"];
                self.firstArray =  [@[@"订单编号：",@"订单时间：",@"订单类型：",@"写卡激活号码：",@"订单状态：", @"说明："] mutableCopy];
                self.secondArray = @[@"订单金额：",@"保底：",@"活动包："];
            }
        }
        self.leftDistance = (screenWidth - 60*self.buttonTitlesArray.count) / (self.buttonTitlesArray.count*2.0);
        [self headView];
        [self moveView];
        [self contentView];
        
    }
    return self;
}

#pragma mark - LazyLoading -------------------------

- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        for (int i = 0; i < self.buttonTitlesArray.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth/self.buttonTitlesArray.count)*i, 0, screenWidth/self.buttonTitlesArray.count, 40)];
            [button setTitle:self.buttonTitlesArray[i] forState:UIControlStateNormal];
            [_headView addSubview:button];
            [button setTitleColor:[Utils colorRGB:@"#333333"] forState:UIControlStateNormal];
            [button setTitleColor:MainColor forState:UIControlStateSelected];
            button.tag = 10 + i;
            button.titleLabel.font = [UIFont systemFontOfSize:textfont14];
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                button.selected = YES;
            }
            [self.titleButtons addObject:button];
        }
    }
    return _headView;
}

- (UIView *)moveView{
    if (_moveView == nil) {
        _moveView = [[UIView alloc] initWithFrame:CGRectMake(self.leftDistance, 39, 60, 1)];
        [self addSubview:_moveView];
        _moveView.backgroundColor = MainColor;
    }
    return _moveView;
}

- (UIScrollView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.tag = 100;
        _contentView.delegate = self;
        _contentView.contentSize = CGSizeMake(screenWidth*3, 0);
        _contentView.pagingEnabled = YES;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _contentView;
}

- (UIScrollView *)firstView{
    if (_firstView == nil) {
        _firstView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 104)];
        [self.contentView addSubview:_firstView];
        _firstView.backgroundColor = COLOR_BACKGROUND;
        
        for (int i = 0; i < self.firstDataArray.count; i++) {
            UILabel *lb = [[UILabel alloc] init];
            [_firstView addSubview:lb];
            
            if (i == 0) {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth - 30);
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(15);
                }];
            }else{
                UILabel *previousLabel = self.firstLabelArray[i - 1];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth - 30);
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(previousLabel.mas_bottom).mas_equalTo(14);
                }];
            }
            lb.numberOfLines = 0;
            NSString *titleString = [NSString stringWithFormat:@"%@",self.firstArray[i]];
            NSString *dataString = [NSString stringWithFormat:@"%@%@",titleString,self.firstDataArray[i]];
            lb.textColor = [Utils colorRGB:@"#2a2a2a"];
            lb.attributedText = [Utils setTextColor:dataString FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:16] AndRange:NSMakeRange(0, titleString.length) AndColor:[Utils colorRGB:@"#"]];
            [self.firstLabelArray addObject:lb];
            
            if (i == self.firstDataArray.count - 1) {
                UIView *backView = [[UIView alloc] init];
                [_firstView insertSubview:backView atIndex:0];
                backView.backgroundColor = [UIColor whiteColor];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(lb.mas_bottom).mas_equalTo(15);
                }];
            }
        }
        
        // 202011月份新需求，重写功能
        if (self.type == XieKa && self.stateIsLock == true) {
            UIButton *reWriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [reWriteBtn setTitle:@"重写" forState:UIControlStateNormal];
            [reWriteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            reWriteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            reWriteBtn.backgroundColor = MainColor;
            reWriteBtn.layer.cornerRadius = 4;
            @WeakObj(self)
            [[reWriteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @StrongObj(self)

                AgentWriteAndChooseViewController *vc = [[AgentWriteAndChooseViewController alloc] init];
                vc.orderNo = self.writeCardOrderDetailsModel.ePreNo;
                vc.leftTitlesArray = @[@"号码",@"归属地",@"运营商",@"预存话费",@"选号费",@"保底",@"订单金额"];
                vc.typeString = @"写卡激活";
                vc.phoneNumber = self.firstDataArray[3];
                vc.stateIsLock = self.stateIsLock;
                [[[BaiduMapTool getCurrentVC] navigationController] pushViewController:vc animated:true];
            }];
            [_firstView addSubview:reWriteBtn];
            [reWriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.bottom.mas_equalTo(self).offset(-100);
                make.size.mas_equalTo(CGSizeMake(120, 40));
            }];
        }
    }
    return _firstView;
}

- (UIScrollView *)secondView{
    if (_secondView == nil) {
        _secondView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight - 104)];
        [self.contentView addSubview:_secondView];
        _secondView.backgroundColor = COLOR_BACKGROUND;
        
        for (int i = 0; i < self.secondDataArray.count; i++) {
            
            UILabel *lb = [[UILabel alloc] init];
            [_secondView addSubview:lb];
            
            if (i == 0) {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth - 30);
                }];
            }else{
                UILabel *previousLabel = self.secondLabelArray[i - 1];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(-15);
                    make.width.mas_equalTo(screenWidth - 30);
                    make.top.mas_equalTo(previousLabel.mas_bottom).mas_equalTo(14);
                }];
            }
            
            NSString *titleString = [NSString stringWithFormat:@"%@",self.secondArray[i]];
            NSString *dataString = [NSString stringWithFormat:@"%@%@",titleString,self.secondDataArray[i]];
            lb.textColor = [Utils colorRGB:@"#2a2a2a"];
            lb.attributedText = [Utils setTextColor:dataString FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:16] AndRange:NSMakeRange(0, titleString.length) AndColor:[Utils colorRGB:@"#"]];
            
            [self.secondLabelArray addObject:lb];
            
            if (i == self.secondArray.count - 1) {
                UIView *backView = [[UIView alloc] init];
                [_secondView insertSubview:backView atIndex:0];
                backView.backgroundColor = [UIColor whiteColor];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(lb.mas_bottom).mas_equalTo(15);
                }];
            }
        }
    }
    return _secondView;
}

- (UIScrollView *)thirdView{
    if (_thirdView == nil) {
        _thirdView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWidth * 2, 0, screenWidth, screenHeight - 104)];
        [self.contentView addSubview:_thirdView];
        _thirdView.backgroundColor = COLOR_BACKGROUND;
        
        for (int i = 0; i < self.thirdArray.count; i++) {
            
            UILabel *lb = [[UILabel alloc] init];
            [_thirdView addSubview:lb];
            lb.numberOfLines = 0;
            
            if (i == 0) {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.right.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth);
                    make.top.mas_equalTo(15);
                }];
            }else{
                UILabel *previousLabel = self.thirdLabelArray[i - 1];
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(15);
                    make.width.mas_equalTo(screenWidth);
                    make.right.mas_equalTo(-15);
                    make.top.mas_equalTo(previousLabel.mas_bottom).mas_equalTo(14);
                }];
            }
            
            NSString *titleString = [NSString stringWithFormat:@"%@",self.thirdArray[i]];
            NSString *titleDataStr = self.thirdDataArray[i];
//            if ([titleString isEqualToString:@"身份证号码："]) {
//                titleDataStr = [titleDataStr stringByReplacingCharactersInRange:NSMakeRange(5,7) withString:@"*******"];
//            }else if ([titleString isEqualToString:@"联系电话："]){
//                titleDataStr = [titleDataStr stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
//            }
            NSString *dataString = [NSString stringWithFormat:@"%@%@",titleString,titleDataStr];
            lb.textColor = [Utils colorRGB:@"#2a2a2a"];
            lb.attributedText = [Utils setTextColor:dataString FontNumber:[UIFont fontWithName:@"Helvetica-Bold" size:16] AndRange:NSMakeRange(0, titleString.length) AndColor:[Utils colorRGB:@"#"]];
            
            [self.thirdLabelArray addObject:lb];
            
            if (i == self.thirdArray.count - 1) {
                UIView *backView = [[UIView alloc] init];
                [_thirdView insertSubview:backView atIndex:0];
                backView.backgroundColor = [UIColor whiteColor];
                [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.mas_equalTo(0);
                    make.bottom.mas_equalTo(lb.mas_bottom).mas_equalTo(15);
                }];
            }
        }
    }
    return _thirdView;
}

- (SHeadTitleView *)phoneHeadTitleView{
    if (_phoneHeadTitleView == nil) {
        _phoneHeadTitleView = [[SHeadTitleView alloc] init];
        _phoneHeadTitleView.titleLabel.text = @"近期联系电话";
        [self.secondView addSubview:_phoneHeadTitleView];
        UILabel *lastLabel = self.secondLabelArray.lastObject;
        [_phoneHeadTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(lastLabel.mas_bottom).mas_equalTo(15);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(screenWidth);
        }];
    }
    return _phoneHeadTitleView;
}

//- (SHeadTitleView *)bukaHeadTitleView{
//    if (_bukaHeadTitleView == nil) {
//        _bukaHeadTitleView = [[SHeadTitleView alloc] init];
//        _bukaHeadTitleView.titleLabel.text = @"证件信息";
//        InputView *lastIV = self.phoneInputViewsArray.lastObject;
//        [self.secondView addSubview:_bukaHeadTitleView];
//        [_bukaHeadTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.top.mas_equalTo(lastIV.mas_bottom).mas_equalTo(0);
//            make.height.mas_equalTo(44);
//            make.width.mas_equalTo(screenWidth);
//        }];
//    }
//    return _bukaHeadTitleView;
//}

#pragma mark - Set Method ----------------------

// 写卡
- (void)setWriteCardOrderDetailsModel:(WriteCardOrderDetailsModel *)writeCardOrderDetailsModel{
    _writeCardOrderDetailsModel = writeCardOrderDetailsModel;
    
    //    self.firstArray =  [@[@"订单编号：",@"订单时间：",@"订单类型：",@"写卡激活号码：",@"订单状态："] mutableCopy];
    
    self.firstDataArray = [@[_writeCardOrderDetailsModel.ePreNo, _writeCardOrderDetailsModel.createDate, @"写卡激活", _writeCardOrderDetailsModel.number, _writeCardOrderDetailsModel.status?_writeCardOrderDetailsModel.status:@"无", _writeCardOrderDetailsModel.memo4] mutableCopy];
    
    self.secondDataArray = [@[_writeCardOrderDetailsModel.amount, _writeCardOrderDetailsModel.cycle, _writeCardOrderDetailsModel.promotionName] mutableCopy];
    
    [self firstView];
    
    [self secondView];
}

- (void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
    _orderDetailModel = orderDetailModel;
    
    NSString *cardTypeString = @"成卡开户";
    if ([orderDetailModel.cardType isEqualToString:@"ESIM"]) {
        cardTypeString = @"白卡开户";
    }
    
    NSString *orderStateString = @"无";
    if ([orderDetailModel.orderStatus isEqualToString:@"PENDING"] || [orderDetailModel.orderStatus isEqualToString:@"已提交"]) {
        orderStateString = @"已提交";
    }
    if ([orderDetailModel.orderStatus isEqualToString:@"WAITING"] || [orderDetailModel.orderStatus isEqualToString:@"等待中"]) {
        orderStateString = @"等待中";
    }
    if ([orderDetailModel.orderStatus isEqualToString:@"SUCCESS"] || [orderDetailModel.orderStatus isEqualToString:@"成功"]) {
        orderStateString = @"成功";
    }
    if ([orderDetailModel.orderStatus isEqualToString:@"FAIL"] || [orderDetailModel.orderStatus isEqualToString:@"失败"]) {
        orderStateString = @"失败";
    }
    if ([orderDetailModel.orderStatus isEqualToString:@"CANCLE"] || [orderDetailModel.orderStatus isEqualToString:@"已取消"]) {
        orderStateString = @"已取消";
    }
    if ([orderDetailModel.orderStatus isEqualToString:@"CLOSED"] || [orderDetailModel.orderStatus isEqualToString:@"已关闭"]) {
        orderStateString = @"已关闭";
    }

    
    self.firstDataArray = [@[orderDetailModel.orderNo, orderDetailModel.createDate, cardTypeString, orderDetailModel.number, orderDetailModel.updateDate, orderStateString] mutableCopy];
    
    if ([orderStateString isEqualToString:@"已取消"]) {
        [self.firstDataArray addObject:orderDetailModel.cancelInfo];
    }
    
    self.secondDataArray = [@[orderDetailModel.prestore, orderDetailModel.promotion, orderDetailModel.isLiang] mutableCopy];

    self.thirdDataArray = [@[orderDetailModel.customerName, orderDetailModel.certificatesNo, orderDetailModel.address] mutableCopy];
    
    [self firstView];
    [self secondView];
    [self thirdView];
    
//    CGFloat imageWidth = (screenWidth - 111) / 2.0;
    
//    UILabel *lastLabel = self.thirdLabelArray.lastObject;
//    self.recentCustomerView = [[SShowImageView alloc] init];
//    self.recentCustomerView.titleLabel.text = @"证件信息";
//    [self.thirdView addSubview:self.recentCustomerView];
//    [self.recentCustomerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(lastLabel.mas_bottom).mas_equalTo(16);
//        make.height.mas_equalTo(imageWidth + 87);
//    }];
//
//    self.recentCustomerView.firstUrl = orderDetailModel.photoFront;
//    self.recentCustomerView.secondUrl = orderDetailModel.photoBack;
}

- (void)setCardTransferDetailModel:(CardTransferDetailModel *)cardTransferDetailModel{
    _cardTransferDetailModel = cardTransferDetailModel;
    
    NSString *updateString = @"无";
    if (cardTransferDetailModel.updateDate != nil) {
        updateString = [[NSString stringWithFormat:@"%@",cardTransferDetailModel.updateDate] componentsSeparatedByString:@"."].firstObject;
    }
    
    NSString *createString = @"无";
    if (cardTransferDetailModel.createDate != nil) {
        createString = [[NSString stringWithFormat:@"%@",cardTransferDetailModel.createDate] componentsSeparatedByString:@"."].firstObject;
    }
    
    self.firstDataArray = [@[cardTransferDetailModel.number,createString,updateString,cardTransferDetailModel.startName] mutableCopy];

    
    if ([cardTransferDetailModel.startName isEqualToString:@"审核不通过"]) {
        [self.firstArray addObject:@"审核不通过原因："];
        [self.firstDataArray addObject:cardTransferDetailModel.model_description];
    }
    
    
    self.secondDataArray = [@[cardTransferDetailModel.name, cardTransferDetailModel.cardId, cardTransferDetailModel.address, cardTransferDetailModel.tel] mutableCopy];
    
    [self firstView];
    [self secondView];
    [self thirdView];
    
    CGFloat imageWidth = (screenWidth - 111) / 2.0;
    
    self.recentCustomerView = [[SShowImageView alloc] init];
    self.recentCustomerView.titleLabel.text = @"新用户";
    [self.thirdView addSubview:self.recentCustomerView];
    [self.recentCustomerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.width.mas_equalTo(screenWidth);
        make.height.mas_equalTo(imageWidth + 87);
    }];
    
    self.oldCustomerView = [[SShowImageView alloc] init];
    self.oldCustomerView.titleLabel.text = @"原用户";
    [self.thirdView addSubview:self.oldCustomerView];
    [self.oldCustomerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screenWidth);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.recentCustomerView.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(imageWidth + 87);
    }];
    
    self.recentCustomerView.firstUrl = cardTransferDetailModel.photoOne;
    self.recentCustomerView.secondUrl = cardTransferDetailModel.photoThree;
    
    self.oldCustomerView.firstUrl = cardTransferDetailModel.photoTwo;
    self.oldCustomerView.secondUrl = cardTransferDetailModel.photoFour;
    
    [self phoneHeadTitleView];
    
    NSMutableArray *phoneNumberArray = [NSMutableArray array];
    if (cardTransferDetailModel.numOne) {
        [phoneNumberArray addObject:cardTransferDetailModel.numOne];
    }
    if (cardTransferDetailModel.numTwo) {
        [phoneNumberArray addObject:cardTransferDetailModel.numTwo];
    }
    if (cardTransferDetailModel.numThree) {
        [phoneNumberArray addObject:cardTransferDetailModel.numThree];
    }
    
    self.phoneInputViewsArray = [NSMutableArray array];
    
    for (int i = 0; i < phoneNumberArray.count; i ++) {
        
        InputView *inputView = [[InputView alloc] init];
        [self.phoneInputViewsArray addObject:inputView];
        [self.secondView addSubview:inputView];
        inputView.textField.enabled = NO;
        if (i == 0) {
            [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(_phoneHeadTitleView.mas_bottom).mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
        }else{
            InputView *previousIV = self.phoneInputViewsArray[i - 1];
            [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(previousIV.mas_bottom).mas_equalTo(1);
                make.height.mas_equalTo(44);
            }];
        }
        inputView.leftLabel.text = [NSString stringWithFormat:@"电话%d",i + 1];
        
        if (i == 0) {
            inputView.textField.text = cardTransferDetailModel.numOne;
        }
        if (i == 1) {
            inputView.textField.text = cardTransferDetailModel.numTwo;
        }
        if (i == 2) {
            inputView.textField.text = cardTransferDetailModel.numThree;
        }
    }
}

- (void)setCardRepairDetailModel:(CardRepairDetailModel *)cardRepairDetailModel{
    _cardRepairDetailModel = cardRepairDetailModel;
    
    NSString *updateString = @"无";
    if (cardRepairDetailModel.updateDate != nil) {
        updateString = [[NSString stringWithFormat:@"%@",cardRepairDetailModel.updateDate] componentsSeparatedByString:@"."].firstObject;
    }
    
    NSString *startTimeString = [[NSString stringWithFormat:@"%@",_cardTransferListModel.startTime] componentsSeparatedByString:@"."].firstObject;
    
    self.firstDataArray = [@[cardRepairDetailModel.number,startTimeString,@"补卡",updateString,cardRepairDetailModel.startName] mutableCopy];
    
    if ([cardRepairDetailModel.startName isEqualToString:@"审核不通过"]) {
        [self.firstArray addObject:@"审核不通过原因："];
        [self.firstDataArray addObject:cardRepairDetailModel.model_description];
    }
    
    self.secondDataArray = [@[cardRepairDetailModel.name,cardRepairDetailModel.cardId,cardRepairDetailModel.address,cardRepairDetailModel.tel] mutableCopy];
    
    NSString *mailMethod = @"充值一百免邮费";
    
    //邮寄选项
    if ([cardRepairDetailModel.mailMethod isEqualToString:@"0"]) {
        mailMethod = @"顺丰到付";
    }
    
    self.thirdDataArray = [@[cardRepairDetailModel.receiveName, cardRepairDetailModel.receiveTel, mailMethod, cardRepairDetailModel.mailingAddress] mutableCopy];
    
    [self firstView];
    [self secondView];
    [self thirdView];
    
    [self phoneHeadTitleView];
    
    NSMutableArray *phoneNumberArray = [NSMutableArray array];
    if (cardRepairDetailModel.numOne) {
        [phoneNumberArray addObject:cardRepairDetailModel.numOne];
    }
    if (cardRepairDetailModel.numTwo) {
        [phoneNumberArray addObject:cardRepairDetailModel.numTwo];
    }
    if (cardRepairDetailModel.numThree) {
        [phoneNumberArray addObject:cardRepairDetailModel.numThree];
    }
    
    self.phoneInputViewsArray = [NSMutableArray array];
    
    for (int i = 0; i < phoneNumberArray.count; i ++) {
        
        InputView *inputView = [[InputView alloc] init];
        [self.phoneInputViewsArray addObject:inputView];
        [self.secondView addSubview:inputView];
        inputView.textField.enabled = NO;
        if (i == 0) {
            [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(_phoneHeadTitleView.mas_bottom).mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
        }else{
            InputView *previousIV = self.phoneInputViewsArray[i - 1];
            [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(previousIV.mas_bottom).mas_equalTo(1);
                make.height.mas_equalTo(44);
            }];
        }
        inputView.leftLabel.text = [NSString stringWithFormat:@"电话%d",i + 1];
        
        if (i == 0) {
            inputView.textField.text = cardRepairDetailModel.numOne;
        }
        if (i == 1) {
            inputView.textField.text = cardRepairDetailModel.numTwo;
        }
        if (i == 2) {
            inputView.textField.text = cardRepairDetailModel.numThree;
        }
    }
    
//    [self bukaHeadTitleView];
//    CGFloat imageWidth = (screenWidth - 111) / 2.0;
//
//    self.repairShowView = [[SRepairCardShowImageView alloc] init];
//    [self.secondView addSubview:self.repairShowView];
//    [self.repairShowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.bukaHeadTitleView.mas_bottom).mas_equalTo(0);
//        make.height.mas_equalTo(imageWidth + 67);
//        make.bottom.mas_equalTo(-15);
//    }];
//    self.repairShowView.imageUrl = cardRepairDetailModel.photo;
}

#pragma mark - UIScrollView Delegate -----------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 100) {
        CGRect frame = self.moveView.frame;
        frame.origin.x = self.leftDistance + scrollView.contentOffset.x/self.buttonTitlesArray.count;
        self.moveView.frame = frame;
        NSInteger i = scrollView.contentOffset.x / screenWidth;
        
        for (UIButton *b in self.titleButtons) {
            b.selected = NO;
        }
        UIButton *button = [self viewWithTag:10 + i];
        button.selected = YES;
    }
}

#pragma mark - Method ---------------------------

- (void)buttonClickedAction:(UIButton *)button{
    NSInteger i = button.tag - 10;
    for (UIButton *b in self.titleButtons) {
        b.selected = NO;
    }
    button.selected = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.moveView.frame;
        frame.origin.x = self.leftDistance + i * screenWidth/self.buttonTitlesArray.count ;
        self.moveView.frame = frame;
        self.contentView.contentOffset = CGPointMake(screenWidth * i, 0);
    }];
}

@end
