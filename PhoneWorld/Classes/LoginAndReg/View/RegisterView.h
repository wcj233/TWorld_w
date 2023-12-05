//
//  RegisterView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/17.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIScrollView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) void(^registerCallBack) (id obj,NSString *phoneNumberString,NSString *captchaString);

@property (nonatomic) UIButton *nextButton;

@property (nonatomic) CityModel *currentCityModel;

@property (nonatomic) ProvinceModel *currentProvinceModel;


@end
