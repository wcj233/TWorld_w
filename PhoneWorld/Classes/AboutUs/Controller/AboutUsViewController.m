//
//  AboutUsViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/14.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic) UIScrollView *imageScrollView;
@property (nonatomic) UIImageView *aboutUsImageView;
@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self imageScrollView];
    
    self.title = @"关于我们";
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake(0, 0, 100, 100);
    self.indicatorView.center = CGPointMake(screenWidth/2, (screenHeight-64)/2);
    [self.view addSubview:self.indicatorView];
    [self.indicatorView setHidesWhenStopped:YES];
    [self.indicatorView startAnimating];
    
    [self requestAboutUs];
    
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
        NSString *appendingString = [NSString stringWithFormat:@"/Documents/AboutUs.arch"];
        NSString *path = [NSHomeDirectory() stringByAppendingString:appendingString];
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        if (imageData) {
            _aboutUsImageView.image = [UIImage imageWithData:imageData];
        }
    }
    return _aboutUsImageView;
}

#pragma mark - Method

- (void)requestAboutUs{
    [WebUtils requestAboutUsWithCallBack:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
            if ([code isEqualToString:@"10000"]) {
                NSString *information = [NSString stringWithFormat:@"%@",obj[@"data"][@"information"]];//这是图片地址
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:information]];
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                //做图片缓存
                NSString *appendingString = [NSString stringWithFormat:@"/Documents/AboutUs.arch"];
                NSString *path = [NSHomeDirectory() stringByAppendingString:appendingString];
                    
                [imageData writeToFile:path atomically:YES];
                
                //@"https://pic2.zhimg.com/a8573b0b6c395104c5729bbe9a57c55d_r.jpg"
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.aboutUsImageView.image = image;
                    
                    CGFloat height = image.size.height * screenWidth/image.size.width;
                    
                    [self.imageScrollView setContentSize:CGSizeMake(screenWidth, height)];
                    [self.aboutUsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.mas_equalTo(0);
                        make.width.mas_equalTo(screenWidth);
                        make.height.mas_equalTo(height);
                    }];
                    
                    [self.indicatorView stopAnimating];
                });
            }else{
                [self showWarningText:obj[@"mes"]];
            }
        }
    }];
}

@end
