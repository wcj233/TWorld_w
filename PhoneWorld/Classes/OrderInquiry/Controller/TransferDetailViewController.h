//
//  TransferDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/17.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "CardTransferListModel.h"

@interface TransferDetailViewController : BaseViewController

@property (nonatomic) CardTransferListModel *listModel;

@property (nonatomic) NSString *modelId;

@end
