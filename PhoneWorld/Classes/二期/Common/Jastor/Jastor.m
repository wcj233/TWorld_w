#import "Jastor.h"
#import "JastorRuntimeHelper.h"

@implementation Jastor

@synthesize objectId;
static NSString *idPropertyName = @"id";
static NSString *idPropertyNameOnObject = @"objectId";

Class nsDictionaryClass;
Class nsArrayClass;

+ (id)objectFromDictionary:(NSDictionary*)dictionary {
    id item = [[[self alloc] initWithDictionary:dictionary] autorelease];
    return item;
}

- (BOOL)setValueFromJastor:(Jastor *)jastor{
    if (![NSStringFromClass([self class]) isEqualToString:NSStringFromClass([jastor class])]) {
        return NO;
    }
    for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
        [self setValue:[jastor valueForKey:key] forKey:key];
    }
    return YES;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (!nsDictionaryClass) nsDictionaryClass = [NSDictionary class];
	if (!nsArrayClass) nsArrayClass = [NSArray class];
	
	if ((self = [super init]) && dictionary != nil && dictionary != [NSNull null] && [[dictionary class] isSubclassOfClass:[NSDictionary class]]) {
		for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
			
			id value = [dictionary valueForKey:[[self map] valueForKey:key]];
			
			if (value == [NSNull null] || value == nil) {
                
                //nsstring null换空串
                if([[JastorRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]] isEqual:[NSString class]]){
                    value=@"";
                }
                else{
                    continue;
                }
            }
            
            if ([JastorRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			
			// handle dictionary
			if ([value isKindOfClass:nsDictionaryClass]) {
				Class klass = [JastorRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]];
				value = [[[klass alloc] initWithDictionary:value] autorelease];
			}
			// handle array
			else if ([value isKindOfClass:nsArrayClass]) {
				
				NSMutableArray *childObjects = [NSMutableArray arrayWithCapacity:[(NSArray*)value count]];
				
                int index = 0;
				for (id child in value) {
                    if ([[child class] isSubclassOfClass:nsDictionaryClass]) {
                        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@_class:", key]);
                        if ([self respondsToSelector:selector]) {
                            Class arrayItemType = [self performSelector:selector withObject:[NSNumber numberWithInt:index]];
                            if ([arrayItemType isSubclassOfClass:[NSDictionary class]]) {
                                [childObjects addObject:child];
                            } else if ([arrayItemType isSubclassOfClass:[Jastor class]]) {
                                Jastor *childDTO = [[[arrayItemType alloc] initWithDictionary:child] autorelease];
                                [childObjects addObject:childDTO];
                            }
                        } else {
                            [childObjects addObject:child];
                        }
					} else {
						[childObjects addObject:child];
					}
                    index++;
				}
				
				value = childObjects;
            }
            
            // handle all others
            Class klass = [JastorRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]];
            if([klass isSubclassOfClass:[NSNumber class]] && [[value class] isSubclassOfClass:[NSString class]]) {
                NSNumber* number = [[[NSNumberFormatter alloc] init] numberFromString:value];
                if(number) {
                    [self setValue:number forKey:key];
                }
                else {
                    [self setValue:@(0) forKey:key];
                }
            }
            else if ([klass isSubclassOfClass:[NSString class]] &&[[value class] isSubclassOfClass:[NSNumber class]]) {
                [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
            }
            else {
                [self setValue:value forKey:key];
            }
		}
		
		id objectIdValue;
		if (dictionary != nil && (NSNull*)dictionary != [NSNull null] && [dictionary count] != 0 && (objectIdValue = [dictionary objectForKey:idPropertyName]) && objectIdValue != [NSNull null]) {
			if (![objectIdValue isKindOfClass:[NSString class]]) {
				objectIdValue = [NSString stringWithFormat:@"%@", objectIdValue];
			}
			[self setValue:objectIdValue forKey:idPropertyNameOnObject];
		}
	}
	return self;	
}

- (void)dealloc {
	self.objectId = nil;
	
//	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
//		//[self setValue:nil forKey:key];
//	}
	
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder*)encoder {
	[encoder encodeObject:self.objectId forKey:idPropertyNameOnObject];
	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
		[encoder encodeObject:[self valueForKey:key] forKey:key];
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
		[self setValue:[decoder decodeObjectForKey:idPropertyNameOnObject] forKey:idPropertyNameOnObject];
		
		for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
            if ([JastorRuntimeHelper isPropertyReadOnly:[self class] propertyName:key]) {
                continue;
            }
			id value = [decoder decodeObjectForKey:key];
			if (value != [NSNull null] && value != nil) {
				[self setValue:value forKey:key];
			}
		}
	}
	return self;
}

- (NSMutableDictionary *)toDictionary {
	return [self toDictionary:^BOOL(NSString *propertyName) {
        return YES;
    }];
}

- (NSMutableDictionary*) toDictionary:(BOOL (^)(NSString *))property {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.objectId) {
        [dic setObject:self.objectId forKey:idPropertyName];
    }
	
	for (NSString *key in [JastorRuntimeHelper propertyNames:[self class]]) {
        if (property && !property(key)) {
            continue;
        }
		id value = [self valueForKey:key];
        if (value && [value isKindOfClass:[Jastor class]]) {
			[dic setObject:[value toDictionary] forKey:[[self map] valueForKey:key]];
        } else if (value && [value isKindOfClass:[NSArray class]] && ((NSArray*)value).count > 0) {
            id internalValue = [value objectAtIndex:0];
            if (internalValue && [internalValue isKindOfClass:[Jastor class]]) {
                NSMutableArray *internalItems = [NSMutableArray array];
                for (id item in value) {
                    [internalItems addObject:[item toDictionary]];
                }
				[dic setObject:internalItems forKey:[[self map] valueForKey:key]];
            } else {
				[dic setObject:value forKey:[[self map] valueForKey:key]];
            }
        } else if (value != nil) {
			[dic setObject:value forKey:[[self map] valueForKey:key]];
        } else{
            Class class=[JastorRuntimeHelper propertyClassForPropertyName:key ofClass:[self class]];
            if ([class isSubclassOfClass:[NSString class]]) {
                [dic setObject:@"" forKey:[[self map] valueForKey:key]];
            }
            else if ([class isSubclassOfClass:[NSArray class]]) {
                [dic setObject:@[] forKey:[[self map] valueForKey:key]];
            }
        }
	}
    return dic;
}

- (NSDictionary *)map {
	NSArray *properties = [JastorRuntimeHelper propertyNames:[self class]];
	NSMutableDictionary *mapDictionary = [[[NSMutableDictionary alloc] initWithCapacity:properties.count] autorelease];
	for (NSString *property in properties) {
		[mapDictionary setObject:property forKey:property];
	}
	return [NSDictionary dictionaryWithDictionary:mapDictionary];
}

- (NSString *)description {
    NSMutableDictionary *dic = [self toDictionary];
	
	return [NSString stringWithFormat:@"#<%@: id = %@ %@>", [self class], self.objectId, [dic description]];
}

- (BOOL)isEqual:(id)object {
	if (object == nil || ![object isKindOfClass:[Jastor class]]) return NO;
	
	Jastor *model = (Jastor *)object;
	
	return [self.objectId isEqualToString:model.objectId];
}

@end
