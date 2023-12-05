//
//  MemberSystemCollectionCell.h
//  PhoneWorld
//
//  Created by Allen on 2019/12/16.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberSystemCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *bgBtn;

@property (nonatomic, strong) Prods *model;

@property (nonatomic, copy) void (^clickBgBtnBlock)(MemberSystemCollectionCell *cell);

@end

NS_ASSUME_NONNULL_END
