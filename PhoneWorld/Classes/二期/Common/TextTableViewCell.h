//
//  TextTableViewCell.h
//  PhoneWorld
//
//  Created by fym on 2018/7/19.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TextTableViewCell : BaseTableViewCell

-(void)setKeyboardType:(UIKeyboardType)type;

-(void)setContentWithText:(NSString *)text placeholder:(NSString *)placeholder limit:(int)limit editBlock:(FAStringCallBackBlock)editBlock;

@end
