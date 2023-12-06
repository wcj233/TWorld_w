//
//  ChooseIDTypeAlertV.h
//  PhoneWorld
//
//  Created by sheshe on 2023/12/6.
//  Copyright © 2023 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseIDTypeAlertV : UIView

- (void)showAnimation;

//tag 1 普通 2 外国
@property (nonatomic, copy) void(^OkBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
