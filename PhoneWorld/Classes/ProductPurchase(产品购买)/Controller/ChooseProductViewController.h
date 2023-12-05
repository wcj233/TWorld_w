//
//  ChooseProductViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LCanBookModel.h"

@interface ChooseProductViewController : BaseViewController

@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *verificationCode;
@property (nonatomic, strong) NSMutableArray<LCanBookModel *> *productArray;

@end
