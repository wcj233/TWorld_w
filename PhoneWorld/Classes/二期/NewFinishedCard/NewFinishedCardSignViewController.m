//
//  NewFinishedCardSignViewController.m
//  PhoneWorld
//
//  Created by fym on 2018/7/30.
//  Copyright © 2018年 xiyoukeji. All rights reserved.
//

#import "NewFinishedCardSignViewController.h"
#import "SignBoxViewController.h"
#import "TimeUtil.h"

@interface NewFinishedCardSignViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *agreementImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreementHeight;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property(nonatomic,retain)UIImage *agreementImage;

@property(nonatomic,copy) SignCallBackBlock signBlock;
@end

@implementation NewFinishedCardSignViewController

-(void)setSignBlock:(SignCallBackBlock)signBlock{
    _signBlock=signBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"开户协议";
//    @WeakObj(self);
//    [WebUtils agency_getAgreementAddressCallBack:^(id obj) {
//        @StrongObj(self);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideWaitView];
//        });
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            NSString *code = [NSString stringWithFormat:@"%@",obj[@"code"]];
//            if ([code isEqualToString:@"10000"]) {
//                [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:obj[@"data"]] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                    if (image) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            CGSize size=image.size;
//                            self.agreementHeight.constant=screenWidth*size.height/size.width;
//                            self.agreementImageView.image=image;
//                            self.agreementImage=image;
//                        });
//                    }
//                    else{
//                        [Utils toastview:@"协议图片加载失败"];
//                    }
//                }];
//            }
//        }
//    }];
    
    // 协议图片
    UIImage *protocolImage = [UIImage imageNamed:@"agreement8"];
    CGSize size = protocolImage.size;
    self.agreementHeight.constant = screenWidth * size.height / size.width;
    self.agreementImageView.image = protocolImage;
    self.agreementImage = protocolImage;
}

- (IBAction)sign:(id)sender {
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Popover" bundle:nil];
    SignBoxViewController *vc=[story instantiateViewControllerWithIdentifier:@"SignBoxViewController"];
    vc.popoverPresentationController.sourceView=self.view;
    
    WEAK_SELF
    [vc setCompletionBlock:^(UIImage *image) {
        weakSelf.signImageView.image=image;
        weakSelf.signImageView.backgroundColor=[Utils colorRGB:@"#EFEFEF"];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    
    if (!_agreementImage) {
        [Utils toastview:@"协议图片加载失败"];
        return;
    }
    
    if (_signImageView.image) {
        if (_signBlock) {
            
            
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            style.lineBreakMode=NSLineBreakByCharWrapping;
            
            NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:[[TimeUtil getInstance] dateStringFromSecondYMR:[[TimeUtil getInstance] currentSecond] separator:@"  "] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor colorWithWhite:0 alpha:1]}];
            CGSize textSize= [str boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            
            UIGraphicsBeginImageContext(CGSizeMake(textSize.width, textSize.height));
            
            [str drawInRect:CGRectMake(0, 0, textSize.width, textSize.height)];
            
            UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            CGSize totalSize=_agreementImage.size;
            
            
            UIGraphicsBeginImageContext(CGSizeMake(totalSize.width, totalSize.height));
            
            [_agreementImage drawInRect:CGRectMake(0, 0, totalSize.width, totalSize.height)];
            
            UIImage *image=self.signImageView.image;
            CGRect imageFrame=CGRectMake(totalSize.width*0.1, totalSize.height-totalSize.width*0.55, totalSize.width*0.6, totalSize.width*0.6*image.size.height/image.size.width);
            [image drawInRect:imageFrame];
            
            float ratio=10;
            [textImage drawInRect:CGRectMake(totalSize.width*0.16, totalSize.height-totalSize.width*0.15, totalSize.width/(ratio/2), totalSize.width*textSize.height/textSize.width/(ratio/2))];
            
            UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
            //5.结束图片的绘制
            UIGraphicsEndImageContext();

//            self.agreementImageView.image=watermarkImg;
            
            
            
            _signBlock(watermarkImg);
            if (self.isNonreturn) {
                //不返回
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else{
        [Utils toastview:@"请签名"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)init{
    if (self = [super init]) {
        _isNonreturn = NO;
    }
    return self;
}

@end
