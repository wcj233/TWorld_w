//
//Created by ESJsonFormatForMac on 19/12/18.
//

#import <Foundation/Foundation.h>


@interface RightsOrderDetailsModel : NSObject

@property (nonatomic, assign) CGFloat orderAmount;

@property (nonatomic, assign) NSInteger productId;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, assign) NSInteger operateType;

@property (nonatomic, copy) NSString *statusName;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *memberAccount;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, copy) NSString *productAmount;

@property (nonatomic, copy) NSString *status;

@end
