//
//  MemberSystemListCell.m
//  PhoneWorld
//
//  Created by Allen on 2019/12/16.
//  Copyright © 2019 xiyoukeji. All rights reserved.
//

#import "MemberSystemListCell.h"

@implementation MemberSystemListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLab = [UILabel labelWithTitle:@"优酷VIP" color:rgba(51, 51, 51, 1) fontSize:16];
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.top.mas_equalTo(14);
            make.height.mas_equalTo(22);
        }];
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        // 设置每个item的大小
        layout.itemSize = CGSizeMake(110, 68);
        
//        // 设置列间距
        layout.minimumInteritemSpacing = 15;
//
//        // 设置行间距
//        layout.minimumLineSpacing = 5;
        
        //每个分区的四边间距UIEdgeInsetsMake
//        layout.sectionInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
        
        // 设置布局方向(滚动方向)
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        /** 初始化mainCollectionView */
        self.collection = [[UICollectionView alloc]initWithFrame:CGRectZero  collectionViewLayout:layout];
        self.collection.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collection];
        [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self).mas_equalTo(5);
            make.trailing.mas_equalTo(self);
            make.top.mas_equalTo(self->_titleLab.mas_bottom).mas_equalTo(11);
            make.bottom.mas_equalTo(-19);
            make.height.mas_equalTo(68);
        }];
        self.collection.backgroundColor = [UIColor whiteColor];
        self.collection.delegate = self;
        /** mainCollectionView 的布局(必须实现的) */
        self.collection.collectionViewLayout = layout;
        
        [self.collection setContentSize:CGSizeMake(CGFLOAT_MAX, 0)];
        
//        设置代理协议
        self.collection.delegate = self;
        
//        设置数据源协议
        self.collection.dataSource = self;
        [self.collection registerClass:[MemberSystemCollectionCell class] forCellWithReuseIdentifier:@"MemberSystemCollectionCell"];

    }
    return self;
}

- (void)setModel:(RightsModel *)model{
    _model = model;
    
    self.titleLab.text = _model.memo2;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.prods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MemberSystemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberSystemCollectionCell" forIndexPath:indexPath];
    cell.model = self.model.prods[indexPath.row];
    
    @WeakObj(self);
    cell.clickBgBtnBlock = ^(MemberSystemCollectionCell * _Nonnull cell) {
        @StrongObj(self);
//        for (MemberSystemCollectionCell *tempCell in self.collection.visibleCells) {
//            tempCell.bgBtn.selected = NO;
//        }
        
//        cell.bgBtn.selected = !cell.bgBtn.isSelected;
//
//        if (cell.bgBtn.selected) {
//            cell.bgBtn.backgroundColor = rgba(0, 129, 235, 1);
//        }else{
//            cell.bgBtn.backgroundColor = UIColor.whiteColor;
//        }
//
        if (self.selectedModelBlock) {
            self.selectedModelBlock(cell.model);
        }
    };
    
    return cell;
}

@end
