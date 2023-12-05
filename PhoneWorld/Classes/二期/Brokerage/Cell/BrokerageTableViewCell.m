//
//  BrokerageTableViewCell.m
//  PhoneWorld
//
//  Created by fym on 2018/7/21.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "BrokerageTableViewCell.h"

@interface BrokerageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@end

@implementation BrokerageTableViewCell

-(void)setContentWithBrokerage:(BrokerageInfo *)info mark:(NSString *)mark{
    _mobileLabel.text=info.tel;
    _timeLabel.text=info.openTime;
    _valueLabel.text=[NSString stringWithFormat:@"%@%@",mark,info.amount];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
