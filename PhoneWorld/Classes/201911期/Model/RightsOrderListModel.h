//
//  RightsOrderListModel.h
//  PhoneWorld
//
//  Created by Allen on 2019/12/24.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RightsOrderListModel : NSObject

@property (nonatomic, strong) NSString *orderNo;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString *productId;

@property (nonatomic, strong) NSString *number;

@property (nonatomic, strong) NSString *productName;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *statusName;

@property (nonatomic, assign) NSInteger operateType;

@property (nonatomic, assign) CGFloat orderAmount;

@property (nonatomic, strong) NSString *createDate;

@end

NS_ASSUME_NONNULL_END
