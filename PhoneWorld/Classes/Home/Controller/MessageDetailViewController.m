//
//  MessageDetailViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/11/2.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageDetailModel.h"

@interface MessageDetailViewController ()
@property (nonatomic) UIScrollView *imageScrollView;
@property (nonatomic) UIImageView *aboutUsImageView;
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showWaitView];
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        @WeakObj(self);
        [WebUtils requestMessageDetailWithId:self.message_id andCallBack:^(id obj) {
            @StrongObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideWaitView];
            });
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
                if ([code isEqualToString:@"10000"]) {
                    NSDictionary *dic = obj[@"data"];
                    MessageDetailModel *detailModel = [[MessageDetailModel alloc] initWithDictionary:dic error:nil];
                    
                    //content中是url
                    
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:detailModel.content]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.aboutUsImageView.image = image;
                        
                        CGFloat height = image.size.height * screenWidth/image.size.width;
                        
                        [self.imageScrollView setContentSize:CGSizeMake(screenWidth, height)];
                        [self.aboutUsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.top.mas_equalTo(0);
                            make.width.mas_equalTo(screenWidth);
                            make.height.mas_equalTo(height);
                        }];
                        
                    });
                }else{
                    [self showWarningText:obj[@"mes"]];
                }
            }
        }];
    }
}

#pragma mark - LazyLoading

- (UIScrollView *)imageScrollView{
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_imageScrollView];
        [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _imageScrollView;
}

- (UIImageView *)aboutUsImageView{
    if (_aboutUsImageView == nil) {
        _aboutUsImageView = [[UIImageView alloc] init];
        [self.imageScrollView addSubview:_aboutUsImageView];
        [_aboutUsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _aboutUsImageView;
}

@end
