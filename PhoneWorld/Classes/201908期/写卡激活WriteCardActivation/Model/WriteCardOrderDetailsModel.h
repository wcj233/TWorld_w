//
//Created by ESJsonFormatForMac on 19/11/18.
//

#import <JSONModel/JSONModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface WriteCardOrderDetailsModel : JSONModel

@property (nonatomic, assign) NSNumber<Optional> *amount;

@property (nonatomic, copy) NSString<Optional> *status;

@property (nonatomic, copy) NSString<Optional> *ePreNo;

@property (nonatomic, copy) NSString<Optional> *memo4;

@property (nonatomic, copy) NSString<Optional> *promotionName;

@property (nonatomic, copy) NSString<Optional> *number;

@property (nonatomic, copy) NSString<Optional> *createDate;

@property (nonatomic, copy) NSString<Optional> *type;

@property (nonatomic, copy) NSString<Optional> *cycle;

@end

NS_ASSUME_NONNULL_END
