//
//  LJYUserProtelController.m
//  PhoneWorld
//
//  Created by 李健宇 on 2018/6/20.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "LJYUserProtelController.h"
#import <WebKit/WebKit.h>

@interface LJYUserProtelController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *enlargeImage;
@property (nonatomic, strong) WKWebView *wkWebView;
@end
//现在是测试！！！！！！！！！！
//#define mainPath @"http://121.46.26.224:8088/newagency/AgencyInterface"

//现在是正式！！！！！！！！！！
//#define mainPath @"http://121.46.26.224:8080/newagency/AgencyInterface"

@implementation LJYUserProtelController

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        NSString *string = [mainPath componentsSeparatedByString:@"newagency"].firstObject;
        NSString *urlString = [NSString stringWithFormat:@"%@notices/ios_xy.png", string];
        [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
    return _wkWebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    
    [self.view addSubview:self.wkWebView];
    
    
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.delegate = self;
//    self.scrollView = scrollView;
//
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userProtel.png"]];
//    self.enlargeImage = imageView;
//    scrollView.minimumZoomScale = 0.7;
//    scrollView.maximumZoomScale = 3;
//
//
//    scrollView.contentSize =[UIImage imageNamed:@"userProtel.png"].size;
//    [scrollView addSubview:imageView];
//
//
//
//    [self.view addSubview:scrollView];
    // Do any additional setup after loading the view.
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    
//    return self.enlargeImage;
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    
//    CGRect frame = self.enlargeImage.frame;
//    
//    frame.origin.y = (self.scrollView.frame.size.height - self.enlargeImage.frame.size.height) > 0 ? (self.scrollView.frame.size.height - self.enlargeImage.frame.size.height) * 0.5 : 0;
//    frame.origin.x = (self.scrollView.frame.size.width - self.enlargeImage.frame.size.width) > 0 ? (self.scrollView.frame.size.width - self.enlargeImage.frame.size.width) * 0.5 : 0;
//    self.enlargeImage.frame = frame;
//    
//    self.scrollView.contentSize = CGSizeMake(self.enlargeImage.frame.size.width + 30, self.enlargeImage.frame.size.height + 30);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
