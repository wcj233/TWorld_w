//
//  RedBagFillInfoPhotoCell.h
//  PhoneWorld
//
//  Created by Allen on 2019/11/26.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedBagFillInfoPhotoVM : NSObject

@property (nonatomic, strong) UIImage *frontCardIamge;

@property (nonatomic, strong) UIImage *backCardIamge;

@property (nonatomic, strong) UIImage *handCardIamge;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RedBagFillInfoPhotoCell : UITableViewCell

@property (nonatomic, strong) UIButton *frontCardBtn;

@property (nonatomic, strong) UIButton *backCardBtn;

@property (nonatomic, strong) UIButton *handCardBtn;

@property (nonatomic, strong) RedBagFillInfoPhotoVM *model;

//0、1、2
@property (nonatomic, copy) void(^clickBtnBlock)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
