//
//  PersonalInfoView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/15.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "PersonalInfoView.h"
#import "InputView.h"
#import "PersonalInfoViewCell.h"

@interface PersonalInfoView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) NSMutableArray *leftTitles;
@end

@implementation PersonalInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACKGROUND;
        
        self.leftTitles = [@[@"用户名",@"姓名",@"手机号码",@"证件地址",@"电子邮箱",@"渠道名称",@"上级名称",@"上级电话"] mutableCopy];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *grade = [ud objectForKey:@"grade"];
                
        if ([grade isEqualToString:@"lev3"]) {
            [self.leftTitles addObject:@"上级推荐码"];
        }
        if ([grade isEqualToString:@"lev2"]) {
            [self.leftTitles addObjectsFromArray:@[@"本人推荐码",@"上级推荐码"]];
        }
        if ([grade isEqualToString:@"lev1"]) {
            [self.leftTitles addObject:@"本人推荐码"];
        }
        
        [self.leftTitles addObjectsFromArray:@[@"渠道地址"]];
        
        self.tableView = UITableView.new;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self);
            make.bottom.mas_equalTo(self).mas_equalTo(-kXBottomHeight);
        }];
        UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40*self.leftTitles.count)];
        leftV.backgroundColor = [UIColor whiteColor];
        [self addSubview:leftV];
    }
    return self;
}

- (void)setPersonModel:(PersonalInfoModel *)personModel{
    _personModel = personModel;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoViewCell"];
    if (cell == nil) {
        cell = [[PersonalInfoViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PersonalInfoViewCell"];
    }
    cell.textLabel.text = self.leftTitles[indexPath.row];
    cell.model = self.personModel;
    return cell;
}


@end
