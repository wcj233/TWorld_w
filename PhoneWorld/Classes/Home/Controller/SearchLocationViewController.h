//
//  SearchLocationViewController.h
//  PhoneWorld
//
//  Created by sheshe on 2021/1/11.
//  Copyright © 2021 xiyoukeji. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^selectedLocationBlock)(BMKPoiInfo *location);

@interface SearchLocationViewController : BaseViewController

@property (nonatomic) NSString *city;
@property (nonatomic) NSString *prince;
@property (nonatomic, copy) selectedLocationBlock mycallBack;

@end

NS_ASSUME_NONNULL_END
