//
//  GetCodeViewController.h
//  PhoneWorld
//
//  Created by sheshe on 2022/2/18.
//  Copyright © 2022 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GetCodeViewController : UIViewController

@property (nonatomic, strong) NSString *tel;
@property (nonatomic) void(^CodeSuccessCallBack)(void);

@end

NS_ASSUME_NONNULL_END
