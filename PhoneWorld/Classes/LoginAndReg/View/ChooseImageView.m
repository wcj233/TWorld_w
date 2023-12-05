//
//  ChooseImageView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/20.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "ChooseImageView.h"
#import <Photos/Photos.h>
#import "WatermarkMaker.h"
#import "MainTabBarController.h"
#import "AVCaptureViewController.h"
#import "JQAVCaptureViewController.h"

@interface ChooseImageView ()

@property (nonatomic) NSString *title;
@property (nonatomic) UIButton *currentImageButton;
@property (nonatomic) NSArray *details;
@property (nonatomic) NSInteger count;
@end

@implementation ChooseImageView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDetail:(NSArray *)details andCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageViews = [NSMutableArray array];
        self.imageButtons = [NSMutableArray array];
        self.removeButtons = [NSMutableArray array];
        self.titleLabelsArray = [NSMutableArray array];
        self.title = title;
        self.details = details;
        self.count = count;
        [self titleLB];
        [self addContent];
        self.watermark=NO;
    }
    return self;
}

- (UILabel *)titleLB{
    if (_titleLB == nil) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = self.title;
        _titleLB.textColor = [Utils colorRGB:@"#333333"];
        _titleLB.font = [UIFont systemFontOfSize:textfont14];
//        NSRange range = [_titleLB.text rangeOfString:@"（点击图片可放大）"];
//        _titleLB.attributedText = [Utils setTextColor:_titleLB.text FontNumber:[UIFont systemFontOfSize:12] AndRange:range AndColor:[Utils colorRGB:@"#000000"]];
        [self addSubview:_titleLB];
//        [_titleLB sizeToFit];
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
//            make.width.mas_equalTo(_titleLB.frame.size.width);
            make.height.mas_equalTo(16);
        }];
    }
    return _titleLB;
}


-(void)setButtonImages:(NSArray *)buttonImages{
    _buttonImages = buttonImages;
    for (int i = 0; i<buttonImages.count; i++) {
        UIButton *imageButton = (UIButton *)[self viewWithTag:1000+i];
        [imageButton setImage:[UIImage imageNamed:buttonImages[i]] forState:UIControlStateNormal];
//        imageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}
- (void)addContent{
    UILabel *lastLabel;
    for (int i = 0; i < self.count; i++) {
        CGFloat imageWidth = (screenWidth - 75)/3.0;
        if (self.count>3) {
            imageWidth = (screenWidth-75)/2;
        }
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(17 + (imageWidth + 20)*i, 40, imageWidth, imageWidth)];
        [self addSubview:imageButton];
        imageButton.layer.cornerRadius = 3;
        imageButton.layer.masksToBounds = YES;
        imageButton.layer.borderColor = [Utils colorRGB:@"#cccccc"].CGColor;
        imageButton.layer.borderWidth = 1;
        [imageButton setTitle:@"+" forState:UIControlStateNormal];
        [imageButton setTitleColor:[Utils colorRGB:@"#cccccc"] forState:UIControlStateNormal];
        imageButton.titleLabel.font = [UIFont systemFontOfSize:textfont30];
        imageButton.tag = 1000 + i;
        [imageButton addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageButtons addObject:imageButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17 + (20 + imageWidth)*i, 40, imageWidth, imageWidth)];
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        imageView.hidden = YES;
        imageView.tag = i;
        [self.imageViews addObject:imageView];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(9 + imageWidth +(imageWidth + 20)*i, 32, 16, 16)];
        removeButton.backgroundColor = [UIColor redColor];
        removeButton.layer.cornerRadius = 8;
        removeButton.layer.masksToBounds = YES;
        [removeButton setTitle:@"X" forState:UIControlStateNormal];
        [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        removeButton.titleLabel.font = [UIFont systemFontOfSize:textfont12];
        removeButton.hidden = YES;
        removeButton.tag = 1100+i;
        [removeButton addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeButton];
        [self.removeButtons addObject:removeButton];
        
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(7 + (imageWidth + 20) *i, (imageWidth + 44), (imageWidth + 20), 40)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.numberOfLines = 0;
        [self addSubview:lb];
        lb.text = self.details[i];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:textfontImage];
        [self.titleLabelsArray addObject:lb];
        [lb sizeToFit];
        lb.frame= CGRectMake(7 + (imageWidth + 20) *i, (imageWidth + 44), (imageWidth + 20), lb.bounds.size.height);
        
        if (self.count>3) {
            
            if (lastLabel) {
                imageButton.frame = CGRectMake((75/3) + (imageWidth + 20)*(i%2), 40+(imageWidth+10+lastLabel.bounds.size.height+10)*(i/2), imageWidth, imageWidth);
                imageView.frame = CGRectMake((75/3) + (imageWidth + 20)*(i%2), 40+(imageWidth+10+lastLabel.bounds.size.height+10)*(i/2), imageWidth, imageWidth);
            }else{
                imageButton.frame = CGRectMake((75/3) + (imageWidth + 20)*(i%2), 40+(imageWidth+10+lb.bounds.size.height+10)*(i/2), imageWidth, imageWidth);
                imageView.frame = CGRectMake((75/3) + (imageWidth + 20)*(i%2), 40+(imageWidth+10+lb.bounds.size.height+10)*(i/2), imageWidth, imageWidth);
            }
            
            lb.frame= CGRectMake(7 + (imageWidth + 20) *(i%2), CGRectGetMaxY(imageView.frame)+10, (imageWidth + 20), lb.bounds.size.height);
            removeButton.frame = CGRectMake(9 + imageWidth +(imageWidth + 20)*(i%2), CGRectGetMinY(imageView.frame)-8, 16, 16);
        }
        
        if (i == 2) {
            self.lastInstrusctLabel = lb;
        }
        if (i == 0) {
            lastLabel = lb;
        }
    }
}

#pragma mark - UIImagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSInteger i = self.currentImageButton.tag - 1000;
    UIImageView *imageV = self.imageViews[i];
    
    NSString *detailString = self.details[i];
    if (_watermark) {
        if ([detailString isEqualToString:@"身份证正面照"]) {
            
            imageV.hidden = NO;
            imageV.image = [WatermarkMaker watermarkImageForImage:image];;
            UIButton *addImageButton = self.imageButtons[i];
            addImageButton.userInteractionEnabled = NO;
            UIButton *removeButton = self.removeButtons[i];
            removeButton.hidden = NO;
            UIViewController *viewController = [self viewController];
            [viewController dismissViewControllerAnimated:YES completion:nil];
            [self.chooseImageViewDelegate scanForInformation];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"scanForInformation" object:nil];
        }
        else {
            if (i==1) {
                imageV.hidden = NO;
                imageV.image = [WatermarkMaker watermarkImageForImage:image];
                UIButton *addImageButton = self.imageButtons[i];
                addImageButton.userInteractionEnabled = NO;
                UIButton *removeButton = self.removeButtons[i];
                removeButton.hidden = NO;
                UIViewController *viewController = [self viewController];
                [viewController dismissViewControllerAnimated:YES completion:nil];
            }else{
                imageV.hidden = NO;
                imageV.image = [WatermarkMaker otherStyleWatermarkImageForImage:image];
                UIButton *addImageButton = self.imageButtons[i];
                addImageButton.userInteractionEnabled = NO;
                UIButton *removeButton = self.removeButtons[i];
                removeButton.hidden = NO;
                UIViewController *viewController = [self viewController];
                [viewController dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }
    else{
        
        imageV.hidden = NO;
        imageV.image = image;
        UIButton *addImageButton = self.imageButtons[i];
        addImageButton.userInteractionEnabled = NO;
        UIButton *removeButton = self.removeButtons[i];
        removeButton.hidden = NO;
        UIViewController *viewController = [self viewController];
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark - Method
- (void)chooseImageAction:(UIButton *)button{
    NSInteger i = button.tag - 1000;
    self.currentImageButton = button;
    __weak ChooseImageView *weakself = self;
    UIViewController *viewController = [self viewController];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:self.details[i] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    NSLog(@"Authorized");
                    
                    if ([self.details[i] isEqualToString:@"身份证正面照"]) {
                        AVCaptureViewController *vc = [[AVCaptureViewController alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        vc.type = self.details[i];
                        vc.myBlock = ^(UIImage *captureImage) {
                            NSInteger i = self.currentImageButton.tag - 1000;
                            UIImageView *imageV = self.imageViews[i];
                            if (_watermark) {
                                    imageV.hidden = NO;
                                    imageV.image = [WatermarkMaker watermarkImageForImage:captureImage];;
                                    UIButton *addImageButton = self.imageButtons[i];
                                    addImageButton.userInteractionEnabled = NO;
                                    UIButton *removeButton = self.removeButtons[i];
                                    removeButton.hidden = NO;
                                    [self.chooseImageViewDelegate scanForInformation];
                            }
                            else{
                                imageV.hidden = NO;
                                imageV.image = captureImage;
                                UIButton *addImageButton = self.imageButtons[i];
                                addImageButton.userInteractionEnabled = NO;
                                UIButton *removeButton = self.removeButtons[i];
                                removeButton.hidden = NO;
                            }
                        };
                        [viewController presentViewController:vc animated:YES completion:nil];
                    } else if([self.details[i] isEqualToString:@"身份证背面照"] || [self.details[i] isEqualToString:@"身份证反面照"]) {
                        JQAVCaptureViewController *vc = [[JQAVCaptureViewController alloc] init];
                        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                        vc.backBlock = ^(UIImage *captureImage) {
                            NSInteger i = self.currentImageButton.tag - 1000;
                            UIImageView *imageV = self.imageViews[i];
                            if (_watermark) {
                                    imageV.hidden = NO;
                                    imageV.image = [WatermarkMaker watermarkImageForImage:captureImage];;
                                    UIButton *addImageButton = self.imageButtons[i];
                                    addImageButton.userInteractionEnabled = NO;
                                    UIButton *removeButton = self.removeButtons[i];
                                    removeButton.hidden = NO;
                            }
                            else{
                                imageV.hidden = NO;
                                imageV.image = captureImage;
                                UIButton *addImageButton = self.imageButtons[i];
                                addImageButton.userInteractionEnabled = NO;
                                UIButton *removeButton = self.removeButtons[i];
                                removeButton.hidden = NO;
                            }
                        };
                        [viewController presentViewController:vc animated:YES completion:nil];
                    }else {
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.delegate = weakself;
                        
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        
                        [viewController presentViewController:imagePicker animated:YES completion:nil];
                    }
                    
                    
                    
                }else{
                    NSLog(@"Denied or Restricted");
                    [weakself showWarningAction];
                }
            });
        }];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = weakself;
        imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [viewController presentViewController:imagePicker2 animated:YES completion:nil];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    /*******1.12新增 readModes控制的是身份证正面照、身份证正面+卡板合照、身份证背面照三个照片框的权限；
     readModesTwo控制的是本人现场正面免冠照的权限***********/
    if (self.isFinished||[self.typeString isEqualToString:@"靓号"]||self.count == 4) {
        NSDictionary *modeDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"kaihuMode"];
        NSNumber *modeNum = modeDic[@"readModes"];
        if ([self.typeString isEqualToString:@"靓号"]&&i == 2) {
            //靓号目前只有三张图 最后一个对应的是现场
            modeNum = modeDic[@"readModesTwo"];
        }
        if (i == 3) {//看readModesTwo
            modeNum = modeDic[@"readModesTwo"];
        }

        if (modeNum.intValue==1) {//仅拍照
            [ac addAction:action1];
        }else if (modeNum.intValue==2){//仅相册
            [ac addAction:action2];
        }else{
            [ac addAction:action1];
            [ac addAction:action2];
        }
    }else{
        [ac addAction:action1];
        [ac addAction:action2];
    }
    
    [ac addAction:action3];
    [viewController presentViewController:ac animated:YES completion:nil];
}

- (void)removeAction:(UIButton *)button{
    NSInteger i = button.tag - 1100;
    UIImageView *imageV = self.imageViews[i];
    imageV.hidden = YES;
    button.hidden = YES;
    UIButton *addImageButton = self.imageButtons[i];
    addImageButton.userInteractionEnabled = YES;
    
    if (i == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseImageViewRemoveImageAction" object:button];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeModal index:0 photoModelBlock:^NSArray *{
        //创建多大容量数组
        NSMutableArray *modelsM = [NSMutableArray array];
        PhotoModel *pbModel=[[PhotoModel alloc] init];
        pbModel.mid = 11;
        //设置查看大图的时候的图片
        pbModel.image = imageV.image;
        pbModel.sourceImageView = imageV;//点击返回时图片做动画用
        [modelsM addObject:pbModel];
        return modelsM;
    }];
}

- (void)showWarningAction{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中授权使用相册和相机" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [[self viewController] presentViewController:ac animated:YES completion:nil];
}

@end
