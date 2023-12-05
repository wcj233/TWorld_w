//
//  ChooseTypeCell.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTypeCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTitleArray:(NSArray *)titlesArray;

@property (nonatomic) NSMutableArray<UIButton *> *allArray;

@property (nonatomic) UIButton *currentButton;

@end
