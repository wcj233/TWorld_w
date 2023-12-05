//
//  SCardOrderDetailViewController.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/5.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import "CardTransferListModel.h"
#import "WriteCardModel.h"

@interface SCardOrderDetailViewController : BaseViewController

@property (nonatomic) NSString *order_id;//订单号
@property (nonatomic) CardDetailType type;

@property (nonatomic) CardTransferListModel *cardTransferListModel;//上一个页面的模型数据（过户／补卡的）

@property(nonatomic,strong)WriteCardModel *writeCardModel;

@end
