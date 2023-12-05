//
//  LProductDetailView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2018/1/15.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LProductDetailView.h"

@interface LProductDetailView ()

@property (nonatomic, strong) NSArray *leftTitleArray;

@end

@implementation LProductDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftTitleArray = @[@"产品名称",@"手机号",@"订购时间",@"订单状态",@"产品详情"];
        [self contentTableView];
    }
    return self;
}

- (void)setBookedModel:(LBookedModel *)bookedModel{
    _bookedModel = bookedModel;
    CGSize size = [Utils sizeWithFont:font16 andMaxSize:CGSizeMake(screenWidth - 31, 0) andStr:bookedModel.prodOfferDesc];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, screenWidth - 30, size.height)];
    label.textColor = [Utils colorRGB:@"#333333"];
    label.font = font16;
    label.text=self.bookedModel.prodOfferDesc;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, size.height + 44)];
    [footerView addSubview:label];
    footerView.backgroundColor = [UIColor whiteColor];
    
    _contentTableView.tableFooterView = footerView;
    
    [self.contentTableView reloadData];
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[NormalShowCell class] forCellReuseIdentifier:@"NormalShowCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalShowCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NormalShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NormalShowCell"];
    }
    
    cell.leftLabel.text = self.leftTitleArray[indexPath.row];
    if (indexPath.row == 3) {
        cell.rightLabel.textColor = [Utils colorRGB:@"#EC6C00"];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.rightLabel.text = self.bookedModel.prodOfferName;
        }
            break;
        case 1:
        {
            cell.rightLabel.text = self.bookedModel.number;
        }
            break;
        case 2:
        {
            NSString *timeString = [self.bookedModel.createDate componentsSeparatedByString:@"."].firstObject;

            cell.rightLabel.text = timeString;
        }
            break;
        case 3:
        {
            cell.rightLabel.text = self.bookedModel.orderStatusName;
        }
            break;
        default:
        
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

@end
