//
//  Jastor.h
//  Jastor
//
//  Created by Elad Ossadon on 12/14/11.
//  http://devign.me | http://elad.ossadon.com | http://twitter.com/elado
//
#import <Foundation/Foundation.h>

@interface Jastor : NSObject <NSCoding>

@property (nonatomic, copy) NSString *objectId;
+ (id)objectFromDictionary:(NSDictionary*)dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSMutableDictionary *)toDictionary;

- (NSMutableDictionary *)toDictionary:(BOOL(^)(NSString * propertyName))property;

- (NSDictionary *)map;



- (BOOL)setValueFromJastor:(Jastor *)jastor;
@end
