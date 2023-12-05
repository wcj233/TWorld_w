//
//  FACallBackBlock.h
//  iiiBTC
//
//  Created by fym on 2018/2/10.
//  Copyright © 2018年 fym. All rights reserved.
//

#ifndef FACallBackBlock_h
#define FACallBackBlock_h


typedef void (^FACallBackBlock)(void);
typedef void (^FAIntCallBackBlock)(int type);
typedef void (^FAStringCallBackBlock)(NSString *str);
typedef void (^FAArrayCallBackBlock)(NSArray *array);
typedef void (^FADictionaryCallBackBlock)(NSDictionary *dict);
typedef void (^FAObjectCallBackBlock)(id object);

#endif /* FACallBackBlock_h */
