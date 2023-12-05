//
//  LuckyRecordModel.h
//  PhoneWorld
//
//  Created by andy on 2018/4/26.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LuckyRecordModel : JSONModel

@property(nonatomic, copy) NSString <Optional>*createDate;
@property(nonatomic, copy) NSString <Optional>*name;
@property(nonatomic, copy) NSString <Optional>*type;

//@property(nonatomic, copy) NSString *<Optional>time;
//@property(nonatomic, copy) NSString *<Optional>time;


@end
