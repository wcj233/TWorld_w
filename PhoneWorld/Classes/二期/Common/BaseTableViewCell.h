//
//  BaseTableViewCell.h
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;

-(void)setContentWithTitle:(NSString *)title;

@end
