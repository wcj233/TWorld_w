//
//  MemberSystemListCell.h
//  PhoneWorld
//
//  Created by Allen on 2019/12/16.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberSystemCollectionCell.h"
#import "RightsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberSystemListCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) RightsModel *model;

@property (nonatomic, copy) void (^selectedModelBlock)(Prods *model);
@end

NS_ASSUME_NONNULL_END
