//
//  WorkerSignInTableView.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WorkerSignInView.h"
#import "WWhiteCardApplyCell.h"

@implementation WorkerSignInView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.submitButton = [[UIButton alloc]init];
        [self.submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitButton.backgroundColor = [Utils colorRGB:@"#EC6C00"];
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(170, 40));
            make.bottom.mas_equalTo(-80);
        }];
        self.submitButton.layer.cornerRadius = 4;
        self.submitButton.layer.masksToBounds = YES;
        
        self.tableView = [[UITableView alloc]init];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.submitButton.mas_top);
        }];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        //注册
        [self.tableView registerClass:[WWhiteCardApplyCell class] forCellReuseIdentifier:@"WWhiteCardApplyCell"];
        self.tableView.backgroundColor = COLOR_BACKGROUND;
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *infos = @[@"姓名",@"手机号",@"身份证",@"电子邮箱",@"省市",@"详细地址"];
    WWhiteCardApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWhiteCardApplyCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.placeholdLabel.text = [NSString stringWithFormat:@"输入%@",infos[indexPath.row]];
    if (/*[@[@"姓名",@"手机号",@"身份证"] containsObject:infos[indexPath.row]]*/![infos[indexPath.row] isEqualToString:@"电子邮箱"]) {
        cell.titleLabel.attributedText = [self backTextContent:infos[indexPath.row]];
//        if ([infos[indexPath.row] isEqualToString:@"姓名"]) {
//            cell.infoTextView.text = self.model.contact;
//            cell.placeholdLabel.hidden = YES;
//        }else if ([infos[indexPath.row] isEqualToString:@"手机号"]){
//            cell.infoTextView.text = self.model.tel;
//            cell.placeholdLabel.hidden = YES;
//        }else{
//            cell.placeholdLabel.hidden = NO;
//        }
        cell.placeholdLabel.hidden = NO;
        [cell contentSizeToFit];
    }else{
        cell.titleLabel.text = infos[indexPath.row];
        cell.placeholdLabel.hidden = NO;
    }
    if ([infos[indexPath.row] isEqualToString:@"省市"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.infoTextView.userInteractionEnabled = NO;
        [cell.placeholdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
        }];
        [cell.infoTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-28);
        }];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.infoTextView.userInteractionEnabled = YES;
        [cell.infoTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
        }];
        [cell.placeholdLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
        }];
    }
    
    return cell;
}

-(NSMutableAttributedString *)backTextContent:(NSString *)title{
    NSMutableAttributedString *s1 = [[NSMutableAttributedString alloc]initWithString:@"* " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[Utils colorRGB:@"#FF2525"]}];
    NSMutableAttributedString *s2 = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[Utils colorRGB:@"#333333"]}];
    [s1 appendAttributedString:s2];
    return s1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==5) {
        return 85;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==4) {
        if(_pikerView==nil){
            _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            _backWindowView.backgroundColor = [UIColor blackColor];
            _backWindowView.alpha = 0.0;
            [[UIApplication sharedApplication].keyWindow addSubview:_backWindowView];
            _pikerView = [[DatePickerView alloc]initWithChooseNum];
            
            _pikerView.delegate = self;
            _pikerView.frame= CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257);
        }
        [[UIApplication sharedApplication].keyWindow addSubview:_pikerView];
        
        @WeakObj(self);
        [[_pikerView rac_signalForSelector:@selector(cannelBtnClick)]subscribeNext:^(id x) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [_backWindowView removeFromSuperview];
                _backWindowView = nil;
                _pikerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257);
            } completion:^(BOOL finished) {
                @StrongObj(self);
                [self.pikerView removeFromSuperview];
                self.pikerView = nil;
            }];
        }];
        
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _backWindowView.alpha = 0.5;
            _pikerView.frame = CGRectMake(0, SCREEN_HEIGHT-257, SCREEN_WIDTH, 257);
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)getSelectProvince:(NSString *)province city:(NSString *)city{
    WWhiteCardApplyCell *cell = (WWhiteCardApplyCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    cell.placeholdLabel.hidden = YES;
    self.selectedPro = province;
    self.selectedCity = city;
    if (city) {
        cell.infoTextView.text = [NSString stringWithFormat:@"%@ %@",province,city];
    }else{
        cell.infoTextView.text = [NSString stringWithFormat:@"%@",province];
    }
    
    [cell contentSizeToFit];
    @WeakObj(self);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _pikerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 257);
    } completion:^(BOOL finished) {
        @StrongObj(self);
        [self.pikerView removeFromSuperview];
        self.pikerView = nil;
    }];
}

-(void)setModel:(PersonalInfoModel *)model{
    _model = model;
    [self.tableView reloadData];
}

@end
