//
//  RedBagFillInfoVCodeCell.h
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedBagFillInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedBagFillInfoVCodeCell : UITableViewCell

@property (strong, nonatomic) UITextField *tf;
@property (strong, nonatomic) RedBagFillInfoModel *infoModel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *verificationCodeBtn;

@property (nonatomic, copy) BOOL(^clickVCodeBlock)(void);

@property (nonatomic, copy) void(^changeTFTextBlock)(RedBagFillInfoVCodeCell *cell, NSString *str);

@end

NS_ASSUME_NONNULL_END
