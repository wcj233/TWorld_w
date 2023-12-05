//
//  WWhiteCardApplyCell.h
//  PhoneWorld
//
//  Created by 王陈洁 on 2018/10/18.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWhiteCardApplyCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *infoTextView;
@property(nonatomic, strong) UILabel *placeholdLabel;

- (void)contentSizeToFit;

@end

NS_ASSUME_NONNULL_END
