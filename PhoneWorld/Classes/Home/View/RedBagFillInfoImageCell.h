//
//  RedBagFillInfoImageCell.h
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseImageView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RedBagFillInfoImageCellDelegate <NSObject>

-(void)scanForInformation;

@end

@interface RedBagFillInfoImageCell : UITableViewCell<ChooseImageViewDelegate>

@property (nonatomic) ChooseImageView *chooseImageView;

/*****添加扫描代理****/
@property(nonatomic, weak) id<RedBagFillInfoImageCellDelegate> redBagFillInfoImageCellDelegate;

@end

NS_ASSUME_NONNULL_END
