//
//  ChoosePackageTableView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/19.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "ChoosePackageTableView.h"
#import "ChoosePackageDetailViewController.h"
#import "ChoosePackageDetailView.h"

@interface ChoosePackageTableView ()

@property (nonatomic) NSArray *titles;
@property (nonatomic) int currentIndex;

@end

@implementation ChoosePackageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.packagesDic = [NSArray array];
        self.currentDic = [NSDictionary dictionary];
        self.titles = @[@"套餐选择",@"活动包选择",@"预存金额"];
        [self registerClass:[NormalTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (void)setDetailModel:(PhoneDetailModel *)detailModel{
    _detailModel = detailModel;
    self.inputView.textField.text = detailModel.prestore;
}

- (void)setImsiModel:(IMSIModel *)imsiModel{
    _imsiModel = imsiModel;
    self.inputView.textField.text = [NSString stringWithFormat:@"%d元",imsiModel.prestore];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        self.inputView = [[InputView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
        self.inputView.textField.userInteractionEnabled = NO;
        self.inputView.textField.placeholder = @"请输入预存金额";
        self.inputView.leftLabel.font = [UIFont systemFontOfSize:textfont16];
        self.inputView.textField.font = [UIFont systemFontOfSize:textfont16];
        if (self.detailModel) {
            self.inputView.textField.text = [NSString stringWithFormat:@"%@元",self.detailModel.prestore];
        }else if(self.imsiModel){
            self.inputView.textField.text = [NSString stringWithFormat:@"%d元",self.imsiModel.prestore];
        }
        self.inputView.leftLabel.text = @"预存金额";
        self.inputView.textField.userInteractionEnabled = NO;

        [cell.contentView addSubview:self.inputView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        CGSize titleSize = [Utils sizeWithFont:[UIFont systemFontOfSize:textfont16] andMaxSize:CGSizeMake(0, 20) andStr:self.titles[indexPath.row]];
        cell.titleLabel.text = self.titles[indexPath.row];
        [cell.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(titleSize.width+1.0);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(0);
        }];
        cell.detailLabel.text = @"请选择";
        [cell.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(cell.rightImageView.mas_left).mas_equalTo(-10);
            make.height.mas_equalTo(30);
            make.left.mas_equalTo(cell.titleLabel.mas_right).mas_equalTo(10);
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
     套餐选择
     活动包选择
     */
    
    self.currentIndex = (int)indexPath.row;
    
    NormalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.currentCell = cell;
    
    UIViewController *viewController = [self viewController];

    switch (indexPath.row) {
        case 0:
        {
            ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
            vc.title = @"套餐选择";
            vc.packagesDic = self.packagesDic;//所有套餐
            
            [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                self.currentDic = currentDic;
                cell.detailLabel.text = self.currentDic[@"name"];
                
                NormalTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
                cell.detailLabel.text = @"请选择";
                self.currentPromotionDic = nil;

            }];
            
            [viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
            if (!self.currentDic[@"id"]) {
                [Utils toastview:@"套餐未选择"];
            }else{
                
                ChoosePackageDetailViewController *vc = [[ChoosePackageDetailViewController alloc] init];
                vc.title = @"活动包选择";
                
                
                [vc setChoosePackageDetailCallBack:^(NSDictionary *currentDic){
                    self.currentPromotionDic = currentDic;
                    cell.detailLabel.text = self.currentPromotionDic[@"name"];
                }];
                
                vc.currentID = self.currentDic[@"id"];//当前选中套餐ID
                [viewController.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
    }
}

@end
