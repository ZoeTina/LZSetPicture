//
//  LZRootViewController.m
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/12/19.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZRootViewController.h"

#import "LZActionSheet.h"
#import "LZImageManager.h"

@interface LZRootViewController ()<LZActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *avatarBtn;

@property (nonatomic, strong) IBOutlet UIButton *systemBtn;

@end

@implementation LZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"头像选择";
    self.imageView.backgroundColor = kColorWithRGB(211, 211, 211);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.borderColor = kColorWithRGB(211, 0, 0).CGColor;
    [self.avatarBtn addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.systemBtn addTarget:self action:@selector(showSystemActionSheet) forControlEvents:UIControlEventTouchUpInside];
}

/** 显示头像修改弹窗(自定义方式) */
- (void) showActionSheet{
    
    CGFloat width = AUTOLAYOUTSIZE(294);
    lz(weakSelf);
    [[LZImageManager sharedManager] getCircleImageInVc:self
                                              withSize:CGSizeMake(width, width)
                                          withCallback:^(UIImage *image) {
                                              weakSelf.imageView.image = image;
                                          }];
}

/// 直接调用系统方式选取图片裁剪
- (void) showSystemActionSheet{
    lz(weakSelf);

    LZActionSheet *actionSheet = [[LZActionSheet alloc] initWithTitle:@"设置头像"
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@""
                                                    otherButtonTitles:@[@"拍照",@"从手机相册选择"]
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
                                                         
                                                         [weakSelf clickedButtonAtIndex:buttonIndex];
                                                     }];
    [actionSheet showView];
}

/** 选择拍照还是从相册中选择 */
- (void) clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                //来源:相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                //来源:相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 2) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    // 跳转到相机或相册页面 - 获取图片选取器
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = (id)self;
    imagePickerController.allowsEditing = YES;  // 打开图片后是否允许编辑
    imagePickerController.sourceType = sourceType;
    imagePickerController.navigationController.navigationBar.barTintColor = kColorWithRGB(26, 26, 29);

    //    imagePickerController.navigationController.navigationBarHidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:^{
                             
                             YYLog(@"-------------从相册中进行选择");
                         }];
    });
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法(图片编辑后的代理)
//---------------------------------------------------------------------------------------------------------------------------------------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
//---------------------------------------------------------------------------------------------------------------------------------------------
{
    [picker dismissViewControllerAnimated:YES completion:^{
        YYLog(@"关闭选择器");
    }];
    
    if (image != nil) {
        self.imageView.image = image;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
