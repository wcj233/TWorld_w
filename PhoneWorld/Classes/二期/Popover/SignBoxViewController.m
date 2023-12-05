//
//  SignBoxViewController.m
//  SignDemo
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "SignBoxViewController.h"
#import "DrawView.h"

@interface SignBoxViewController () <UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet DrawView *drawView;


@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;


@property (nonatomic, copy) SignBoxCallBackBlock completionBlock;

@end

@implementation SignBoxViewController

-(void)setCompletionBlock:(SignBoxCallBackBlock)completionBlock{
    _completionBlock=completionBlock;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    
    self.modalPresentationStyle= UIModalPresentationPopover;
    CGFloat width=SCREEN_WIDTH-30;
    CGFloat height=SCREEN_HEIGHT-120;
    self.preferredContentSize = CGSizeMake(width, height);
    self.popoverPresentationController.sourceRect = CGRectMake(SCREEN_WIDTH/2-width/2,SCREEN_HEIGHT/2-height/2,width,height);
    //    self.popoverPresentationController.sourceView = viewController.view;
    self.popoverPresentationController.permittedArrowDirections = 0;
    self.popoverPresentationController.delegate = self;
//    self.popoverPresentationController.backgroundColor=[UIColor blueColor];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _contentWidth.constant=self.view.frame.size.height;
    _contentHeight.constant=self.view.frame.size.width;
    
    //    DrawView *drawView=[[DrawView alloc] init];
    //    drawView.frame=CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.width/4);
    //    [self.view addSubview:drawView];
    //    self.drawView=drawView;
    //设置画板背景颜色
    self.drawView.backgroundColor=[UIColor clearColor];
    //设置画笔宽度
    self.drawView.lineWidth=8;
    //设置画笔颜色
    self.drawView.lineColor=[UIColor blackColor];
    
    _contentView.transform=CGAffineTransformRotate(CGAffineTransformIdentity, 3*M_PI_2);
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone; //不适配
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;   //点击蒙版popover消失， 默认YES
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clean:(id)sender {
    [_drawView clean];
}

- (IBAction)save:(id)sender {
    if (_drawView.edited) {
        if (_completionBlock) {
            _completionBlock([_drawView save]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
