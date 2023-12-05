//
//  NumberDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/12.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "LiangNumberModel.h"

@interface NumberDetailViewController : BaseViewController

@property (nonatomic) NSArray *leftTitlesArray;
//代理商靓号模型
@property (nonatomic) LiangNumberModel *numberModel;

@end
