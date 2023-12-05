//
//  ChooseProductView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/6/3.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseProductView.h"
#import "LCYPopView.h"

@interface ChooseProductView ()

@property (nonatomic, strong) LCYPopView *popView;

@end

@implementation ChooseProductView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.productArray = [NSMutableArray array];
        [self contentTableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoneAction)];
        [self.headView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setProductArray:(NSMutableArray<LCanBookModel *> *)productArray{
    _productArray = productArray;
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
        [_contentTableView registerClass:[ProductCell class] forCellReuseIdentifier:@"ProductCell"];
        _contentTableView.backgroundColor = COLOR_BACKGROUND;
        
        self.headView = [[ChooseProductHeadView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
        _contentTableView.tableHeaderView = self.headView;
    }
    return _contentTableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.productArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductCell"];
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    /*----数据显示----*/
//    LCanBookModel *model = self.productArray[indexPath.section];
//    cell.nameLabel.text = model.prodOfferName;
//    cell.introduceLabel.text = [NSString stringWithFormat:@"%@",model.prodOfferDesc];
    
    RightsModel *model = self.productArray[indexPath.section];
    Prods *prodsModel = model.prods.firstObject;
    cell.nameLabel.text = prodsModel.name;
    cell.introduceLabel.text = [NSString stringWithFormat:@"%@",prodsModel.productDetails];
    
    //cell.codeLabel.text = model.prodOfferId;
    
    cell.purchaseButton.tag = indexPath.section;
    [cell.purchaseButton addTarget:self action:@selector(purchaseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)purchaseAction:(UIButton *)button{
    _ChooseProductCallBack(button.tag);
}

#pragma mark - Method ------

- (void)choosePhoneAction{
    _PopCallBack();
}

- (void)showSuccessPopView:(NSString *)imageName title:(NSString *)title{
    self.popView = [[LCYPopView alloc] initWithImageName:imageName andTitle:title];
    self.popView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    
    //看这里看这里看这里
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(dismissPopviewAction) userInfo:nil repeats:NO];
}

- (void)dismissPopviewAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.popView.hidden = YES;
        self.popView = nil;
    });
}

@end
