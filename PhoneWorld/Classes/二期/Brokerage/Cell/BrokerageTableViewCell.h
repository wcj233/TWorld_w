//
//  BrokerageTableViewCell.h
//  PhoneWorld
//
//  Created by fym on 2018/7/21.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokerageTableViewCell : UITableViewCell

-(void)setContentWithBrokerage:(BrokerageInfo *)info mark:(NSString *)mark;

@end
