//
//  ProductCell.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCell : UITableViewCell

@property (nonatomic) UIView *container;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *introduceLabel;
@property (nonatomic) UILabel *codeLabel;
@property (nonatomic) UIView *lineView;
@property (nonatomic) UIButton *purchaseButton;

@end
