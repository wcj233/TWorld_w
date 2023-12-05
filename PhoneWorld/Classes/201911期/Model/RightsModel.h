//
//Created by ESJsonFormatForMac on 19/12/13.
//

#import <Foundation/Foundation.h>

@class Prods;
@interface RightsModel : NSObject

@property (nonatomic, strong) NSArray *prods;

@property (nonatomic, copy) NSString *memo2;

@end
@interface Prods : NSObject

@property (nonatomic, assign) CGFloat orderAmount;

@property (nonatomic, assign) CGFloat productAmount;

@property (nonatomic, assign) NSInteger productId;

@property (nonatomic, assign) NSInteger isCancleFlag;

@property (nonatomic, assign) NSInteger grade;

@property (nonatomic, copy) NSString *memo1;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *productDetails;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *name;

@end
