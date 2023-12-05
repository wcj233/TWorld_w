//
//  NewFinishedCardDetailViewController.h
//  PhoneWorld
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "PhoneDetailModel.h"

@interface NewFinishedCardDetailViewController : BaseViewController

@property(nonatomic, assign) int cardOpenMode;//开户方式
@property(nonatomic, assign) BOOL isFaceCheck;//是否是人脸

-(void)setPhone:(PhoneDetailModel *)phone;

@end
