//
//  WWhiteCardOrderDetailSecondCell.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiteCardDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WWhiteCardOrderDetailSecondCell : UITableViewCell

@property(nonatomic, strong) UILabel *reasonLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) WhiteCardDetailModel *model;

@end

NS_ASSUME_NONNULL_END
