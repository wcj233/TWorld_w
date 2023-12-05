//
//  LCanBookModel.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/17.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LCanBookModel : JSONModel

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString<Optional> *prodOfferId;
@property (nonatomic, strong) NSString<Optional> *prodOfferName;
@property (nonatomic, strong) NSString<Optional> *prodOfferDesc;
@property (nonatomic, strong) NSString<Optional> *ifSelectable;
@property (nonatomic, strong) NSString<Optional> *isModel;

@end
