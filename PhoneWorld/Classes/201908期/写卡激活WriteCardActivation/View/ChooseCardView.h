//
//  ChooseCardView.h
//  PhoneWorld
//
//  Created by Allen on 2019/8/19.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickCardBlock)(NSString * _Nonnull phoneNumber);

NS_ASSUME_NONNULL_BEGIN

@interface ChooseCardView : UIView

@property(nonatomic,strong)NSArray *dataArray;

@property (copy, nonatomic) ClickCardBlock clickCardBlock;

@end

NS_ASSUME_NONNULL_END
