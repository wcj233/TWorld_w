//
//  WhiteCardListModel.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/11/6.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface WhiteCardListModel : JSONModel

@property(nonatomic, strong) NSNumber<Optional> *orderId;
@property(nonatomic, strong) NSNumber<Optional> *actualSum;
@property(nonatomic, strong) NSNumber<Optional> *applySum;
@property(nonatomic, strong) NSString<Optional> *orderNumber;
@property(nonatomic, strong) NSString<Optional> *createDate;
@property(nonatomic, strong) NSString<Optional> *auditStatusName;

@end

NS_ASSUME_NONNULL_END
