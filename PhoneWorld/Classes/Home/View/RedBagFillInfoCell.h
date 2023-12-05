//
//  RedBagFillInfoCell.h
//  PhoneWorld
//
//  Created by sheshe on 2021/1/11.
//  Copyright © 2021 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedBagFillInfoCell : UITableViewCell<ChooseImageViewDelegate>

@property (nonatomic) ChooseImageView *chooseImageView;


@end

NS_ASSUME_NONNULL_END
