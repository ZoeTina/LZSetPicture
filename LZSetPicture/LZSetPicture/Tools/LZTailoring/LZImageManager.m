//
//  LZImageManager.m
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZImageManager.h"
#import "LZTailoringViewController.h"
#import "LZActionSheet.h"

typedef NS_ENUM(NSInteger, LZImageType){
    LZImageTypeOriginal = 1, // 原始图片
    LZImageTypeSquare = 2,   // 矩形
    LZImageTypeCircle = 3,   // 圆形
};

@interface LZImageManager()<LZTailoringViewControllerDelegate,LZActionSheetDelegate>

@property(nonatomic,assign) LZImageType imageType;

@property(nonatomic,copy) getImageBlock callBack;

@property (nonatomic, assign) CGSize cutSize;


@end

@implementation LZImageManager

LZSingletonM(Manager);

#pragma mark - 获取原始图片
-(void)getOriginalImageInVC:(UIViewController *)controller withCallback:(getImageBlock) getimageblock
{
    
    self.imageType = LZImageTypeOriginal;

    self.callBack = getimageblock;
    
    self.cutSize = CGSizeZero;
    
    [self getImage:controller];

}

#pragma mark - 获取矩形图片
-(void)getSquareImageInVC:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock
{
    self.imageType = LZImageTypeSquare;
    
    self.callBack = getimageblock;
    
    self.cutSize = size;
    
    [self getImage:controller];

}
#pragma mark - 获取圆形图片
-(void)getCircleImageInVc:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock
{
    self.imageType = LZImageTypeCircle;
    self.callBack = getimageblock;
    self.cutSize = size;
    [self getImage:controller];
}


#pragma mark - 调起相机/相册

/**
 * 调起相机/相册
 *
 * @param controller 需要在哪个控制器上显示
 */
-(void)getImage:(UIViewController *)controller {
    LZActionSheet *actionSheet = [[LZActionSheet alloc] initWithTitle:nil
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@[@"拍照",@"从手机相册选择"]
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
                                                         
                                                         [self clickedButtonAtIndex:buttonIndex controller:controller];
                                                     }];
    [actionSheet show];
    
}

/** 选择拍照还是从相册中选择 */

/**
 * 选择拍照还是从相册中选择
 *
 * @param buttonIndex 被点击按钮的索引
 * @param controller  需要在哪个控制器上显示
 */
- (void) clickedButtonAtIndex:(NSInteger)buttonIndex controller:(UIViewController *)controller{
    
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
    imagePickerController.allowsEditing = NO;  // 打开图片后是否允许编辑
    imagePickerController.sourceType = sourceType;
//    imagePickerController.navigationController.navigationBarHidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:imagePickerController
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
//        self.headerImageView.image = image;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    switch (self.imageType) {
            //原始
        case LZImageTypeOriginal:
        {
            [picker dismissViewControllerAnimated:YES completion:nil];
            !self.callBack ? :self.callBack(image);
        }
            break;
            //矩形
        case LZImageTypeSquare:
        {

            LZTailoringViewController *cutVC = [[LZTailoringViewController alloc] init];
            cutVC.delegate  = self;
            cutVC.cutImage  = image;
            cutVC.navigationTitle = @"移动和缩放";
            
            cutVC.cutSize   = self.cutSize;
            cutVC.mode      = ImageMaskViewModeSquare;
            
            cutVC.dotted    = NO;
            cutVC.linesColor= [UIColor clearColor];

            [picker pushViewController:cutVC animated:YES];
        }
            break;
            // 圆形
        case LZImageTypeCircle:
        {
            
            LZTailoringViewController *cutVC = [[LZTailoringViewController alloc] init];
            cutVC.delegate  = self;
            cutVC.cutImage  = image;
            cutVC.navigationTitle = @"移动和缩放";
            
            cutVC.cutSize   = self.cutSize;
            cutVC.mode      = ImageMaskViewModeCircle;
            
            cutVC.dotted    = NO;
            cutVC.linesColor= [UIColor clearColor];

            [picker pushViewController:cutVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - LZTailoringControllerDelegate
- (void)imageCropper:(LZTailoringViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];

     !self.callBack ? :self.callBack(editedImage);
}
- (void)imageCropperDidCancel:(LZTailoringViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
