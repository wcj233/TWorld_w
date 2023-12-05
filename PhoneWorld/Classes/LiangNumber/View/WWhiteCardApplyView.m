//
//  WWhiteCardApplyTableView.m
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "WWhiteCardApplyView.h"
#import "WWhiteCardApplyCell.h"

@implementation WWhiteCardApplyView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
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
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.submitButton.mas_top);
        }];
        UILabel *footerLabel = [UILabel labelWithTitle:@"     注：请如实填写收件人信息；申请数量以实际为准；" color:[Utils colorRGB:@"#FF2626"] font:[UIFont systemFontOfSize:12] alignment:0];
        footerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        self.tableView.tableFooterView = footerLabel;
        //注册
        [self.tableView registerClass:[WWhiteCardApplyCell class] forCellReuseIdentifier:@"WWhiteCardApplyCell"];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *infos = @[@"收货人姓名",@"联系电话",@"收货地址",@"申请数量"];
    WWhiteCardApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWhiteCardApplyCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = infos[indexPath.row];
    cell.placeholdLabel.text = [NSString stringWithFormat:@"请输入%@",infos[indexPath.row]];
    if ([cell.titleLabel.text isEqualToString:@"联系电话"]||[cell.titleLabel.text isEqualToString:@"申请数量"]) {
        cell.infoTextView.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        cell.infoTextView.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        return 74;
    }
    return 44;
}


@end
