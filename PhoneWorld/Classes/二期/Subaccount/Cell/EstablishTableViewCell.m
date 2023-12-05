//
//  EstablishTableViewCell.m
//  PhoneWorld
//
//  Created by fym on 2018/7/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "EstablishTableViewCell.h"

@interface EstablishTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *wayLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation EstablishTableViewCell

-(void)setContentWithChildOrder:(ChildOrderInfo *)info{
    _mobileLabel.text=info.number;
    _orderLabel.text=[NSString stringWithFormat:@"单号：%@",info.orderNo];
    _wayLabel.text=[NSString stringWithFormat:@"受理渠道：%@",info.acceptUser];
    _statusLabel.text=info.statusName;
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
