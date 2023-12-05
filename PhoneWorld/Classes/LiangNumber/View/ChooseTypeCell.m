//
//  ChooseTypeCell.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 2017/5/9.
//  Copyright © 2017年 xiyoukeji. All rights reserved.
//

#import "ChooseTypeCell.h"

@implementation ChooseTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andTitleArray:(NSArray *)titlesArray{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.allArray = [NSMutableArray array];
        
        for (int i = 0; i < titlesArray.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15+(75*i), 14, 60, 28)];
            [button setTitle:titlesArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[Utils colorRGB:@"#999999"] forState:UIControlStateNormal];
            [button setTitleColor:[Utils colorRGB:@"#008bd5"] forState:UIControlStateSelected];
            
            button.layer.cornerRadius = 4;
            button.layer.borderColor = [Utils colorRGB:@"#999999"].CGColor;
            button.layer.borderWidth = 1.0;
            button.layer.masksToBounds = YES;
            
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:textfont14];
            button.selected = NO;
            
            if (i == 0) {
                button.selected = YES;
                button.layer.borderColor = [Utils colorRGB:@"#008bd5"].CGColor;
            }
            
            [self.contentView addSubview:button];
            
            [self.allArray addObject:button];
        }
        
        self.currentButton = self.allArray.firstObject;
    }
    return self;
}

- (void)buttonClickedAction:(UIButton *)button{
    self.currentButton = button;
    for (int i = 0; i < self.allArray.count; i ++) {
        UIButton *currentButton = self.allArray[i];
        currentButton.selected = NO;
        currentButton.layer.borderColor = [Utils colorRGB:@"#999999"].CGColor;
    }
    button.selected = YES;
    button.layer.borderColor = [Utils colorRGB:@"#008bd5"].CGColor;
}

@end
