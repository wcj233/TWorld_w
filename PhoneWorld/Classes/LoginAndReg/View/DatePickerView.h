//
//  DatePickerView.h
//  库存管理
//
//  Created by liuyang on 2017/7/12.
//  Copyright © 2017年 同牛科技. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd = 1,
    
}DateType;

@protocol DatePickerViewDelegate <NSObject>

- (void)getSelectProvince:(NSString *)province city:(NSString *)city;

@end

@interface DatePickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIDatePicker * datePickerView;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UIButton * cannelBtn;
@property(nonatomic,assign)BOOL isDatePiker;

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

@property (nonatomic, assign) DateType type;

@property(nonatomic, assign) UIDatePickerMode pickerMode;

+(id)datePickerView;

-(instancetype)initWithChooseNum;
@property(nonatomic, strong) UIPickerView *numPickerView;
@property(nonatomic, strong) NSArray *nums;
@property(nonatomic, strong) NSString *selectedDate;

@property(nonatomic, strong) NSString *selectedTime;

@property(nonatomic, strong) NSMutableArray *provinceArr;
@property(nonatomic, strong) NSArray *cityArr;
@property(nonatomic, strong) NSArray *areaArr;

@property(nonatomic, strong) NSString *selectedProvince;
@property(nonatomic, strong) NSString *selectedCity;
@property(nonatomic, strong) NSString *selectedArea;



@end
