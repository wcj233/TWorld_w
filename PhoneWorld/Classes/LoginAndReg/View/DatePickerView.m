//
//  DatePickerView.m
//  库存管理
//
//  Created by liuyang on 2017/7/12.
//  Copyright © 2017年 同牛科技. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView ()
@property (nonatomic, strong) NSString *selectDate;

@end

@implementation DatePickerView

+(id)datePickerView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

-(instancetype)initWithChooseNum{
    if (self = [super init]) {
        
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * toolView = [[UIView alloc]init];
        [self addSubview:toolView];
        toolView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(SCREEN_WIDTH-18-100, 10, 100, 22);
        [toolView addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _sureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(18, 10, 100, 22);
        [toolView addSubview:_cannelBtn];
        
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _cannelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        CGFloat width = SCREEN_WIDTH-18*2-80*2;
        UILabel * titleLab = [[UILabel alloc]init];
        [toolView addSubview:titleLab];
        titleLab.frame = CGRectMake((SCREEN_WIDTH-width)/2, 12, width, 17);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"请选择";
        titleLab.font = [UIFont systemFontOfSize:16];
        titleLab.textColor = [UIColor blackColor];
        
        UIView * lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.frame = CGRectMake(0, 42, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = COLOR_BACKGROUND;
        
        self.provinceArr = [NSMutableArray array];
        NSString *pathDataStr =  [[NSBundle mainBundle] pathForResource:@"addressNew" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:pathDataStr];
        for (NSString *item in [dic allKeys]){
            // 遍历取到 省份
            NSDictionary *provinceDic = dic[item];
            [self.provinceArr addObject:provinceDic];
        }
//        self.provinceArr = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addressNew" ofType:@"plist"]];
        self.selectedProvince = [[self.provinceArr objectAtIndex:0] objectForKey:@"name"];
        self.cityArr = [[self.provinceArr objectAtIndex:0] objectForKey:self.selectedProvince];
        self.selectedCity = [[self.cityArr objectAtIndex:0] objectForKey:@"name"];
//        self.areaArr = [[self.cityArr objectAtIndex:0] objectForKey:@"areas"];
//        self.selectedArea = [self.areaArr firstObject];
        
        _numPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 52, SCREEN_WIDTH, 195)];
        [self addSubview:_numPickerView];
        _numPickerView.delegate = self;
        _numPickerView.dataSource = self;
        
        
        
    }
    return self;
}


-(void)cannelBtnClick{
   
}

-(void)sureBtnClick
{
//    NSString *location = [NSString stringWithFormat:@"%@省 %@市",self.selectedProvince,self.selectedCity];
    if (!self.selectedArea) {
//        location = [location stringByAppendingString:[NSString stringWithFormat:@" %@区",self.selectedArea]];
        self.selectedArea = @"";
    }
    if (self.selectedCity) {
        [self.delegate getSelectProvince:self.selectedProvince city:self.selectedCity];
    }else{
        [self.delegate getSelectProvince:self.selectedProvince city:nil];

    }
}

#pragma mark - UIPickerView delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    
    if (component==0) {
        
        return [self.provinceArr count];
        
    }else if(component==1)
        
    {
        
        return [self.cityArr count];
        
    }else
        
    {
        
        return [self.self.areaArr count];
        
    }
    
}

/**
 
 *返回pickerView分几列，因为是省市区选择，所以分3列
 
 */

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 2;
    
}

/**
 
 *触发的事件
 
 */

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    if (component==0) {
        self.selectedProvince = [[self.provinceArr objectAtIndex:row] objectForKey:@"name"];
        self.cityArr = [[self.provinceArr objectAtIndex:row] objectForKey:self.selectedProvince];
        self.selectedCity = [self.cityArr.firstObject objectForKey:@"name"];
        

        [pickerView selectRow:0 inComponent:1 animated:NO];

        [self.numPickerView reloadComponent:1];

//        if ([self.cityArr count]!=0) {
//
//            self.areaArr = [[self.cityArr objectAtIndex:0] objectForKey:@"areas"];
//            self.selectedArea = [self.areaArr firstObject];
//            [pickerView selectRow:0 inComponent:2 animated:NO];
//
//            [self.numPickerView reloadComponent:2];
//
//
//
//        }
//        NSDictionary *provinceDic = self.provinceArr[row];
//        self.selectedProvince = provinceDic[@"name"];
//        WCJGetCityApi *cityApi = [[WCJGetCityApi alloc]initWithParent_id:provinceDic[@"id"]];
//        @weakify(self);
//        [cityApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//            @strongify(self);
//            NSArray *body = request.responseObject[@"body"];
//            self.cityArr = body;
//            [self.numPickerView reloadComponent:1];
//            NSDictionary *cityDic = self.cityArr.firstObject;
//            self.selectedCity = cityDic[@"name"];
//            WCJGetAreaApi *areaApi = [[WCJGetAreaApi alloc]initWithParent_id:cityDic[@"id"]];
//            @weakify(self);
//            [areaApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//                @strongify(self);
//                self.areaArr = request.responseObject[@"body"];
//                NSDictionary *areaDic = self.areaArr[0];
//                self.selectedArea = areaDic[@"name"];
//                [self.numPickerView reloadComponent:2];
//            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//            }];
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        }];
        
    }
    
    else if (component==1)
        
    {
        self.selectedCity = [[self.cityArr objectAtIndex:row] objectForKey:@"name"];
//        self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"areas"];
//        self.selectedArea = self.areaArr.firstObject;
//        
//        [pickerView selectRow:0 inComponent:2 animated:NO];
//        [self.numPickerView reloadComponent:2];
//        NSDictionary *cityDic = self.cityArr[row];
//        self.selectedCity = cityDic[@"name"];
//        self.areaArr = [[self.cityArr objectAtIndex:row] objectForKey:@"areas"];
//        WCJGetAreaApi *areaApi = [[WCJGetAreaApi alloc]initWithParent_id:cityDic[@"id"]];
//        @weakify(self);
//        [areaApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//            @strongify(self);
//            self.areaArr = request.responseObject[@"body"];
//            NSDictionary *areaDic = self.areaArr[0];
//            self.selectedArea = areaDic[@"name"];
//            [pickerView selectRow:0 inComponent:2 animated:NO];
//            [self.numPickerView reloadComponent:2];
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//
//        }];
        
    }else{
//        NSDictionary *areaDic = self.areaArr[row];
//        self.selectedArea = areaDic[@"name"];
        self.selectedArea = self.areaArr[row];
    }
    
    
    
}



/**
 
 *通过自定义view去显示pickerView中的内容,这样做的好处是可以自定义的调整pickerView中显示内容的格式
 
 */

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
    
    myView.textAlignment = NSTextAlignmentCenter;
    
    myView.font = [UIFont systemFontOfSize:15];         //用label来设置字体大小
    
    if (component==0) {
        
        myView.text =[[self.provinceArr objectAtIndex:row] objectForKey:@"name"];
//        NSDictionary *provinceDic = self.provinceArr[row];
//        myView.text = provinceDic[@"name"];
        
    }else if (component==1)
        
    {
//        NSDictionary *cityDic = self.cityArr[row];
//        myView.text = cityDic[@"name"];
        myView.text =[[self.cityArr objectAtIndex:row] objectForKey:@"name"];
        
    }else
        
    {
        
//        NSDictionary *areaDic = self.areaArr[row];
//        myView.text = areaDic[@"name"];
        myView.text =[self.areaArr objectAtIndex:row];
        
    }
    
    return myView;
    
}

//-(void)setProvinceArr:(NSArray *)provinceArr{
//    _provinceArr = provinceArr;
//    [self.numPickerView reloadAllComponents];
//}

@end
