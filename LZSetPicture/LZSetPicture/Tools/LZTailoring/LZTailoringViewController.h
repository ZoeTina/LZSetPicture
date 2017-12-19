//
//  LZTailoringViewController.h
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ImageMaskViewMode) {
    ImageMaskViewModeSquare = 1, //矩形
    ImageMaskViewModeCircle = 2  //圆形
};

@class LZTailoringViewController;

@protocol LZTailoringViewControllerDelegate <NSObject>

- (void)imageCropper:(LZTailoringViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(LZTailoringViewController *)cropperViewController;
@end


@interface LZTailoringViewController : UIViewController

@property (nonatomic,weak) id<LZTailoringViewControllerDelegate> delegate;

#pragma mark - 控制器相关
/** 裁剪图片 */
@property (nonatomic,strong) UIImage *cutImage;
/** 标题:默认为 @"裁剪图片" */
@property (nonatomic,copy)   NSString *navigationTitle;

#pragma mark - 裁剪图层相关
/** 裁剪尺寸:长宽尺寸默认为 屏幕宽度 */
@property (nonatomic,assign) CGSize cutSize;
/** 裁剪类型:默认为 矩形 */
@property (nonatomic,assign) ImageMaskViewMode mode;
/** 线条颜色:默认为 白色 */
@property (nonatomic,strong) UIColor *linesColor;
/** 是否为虚线: 默认为 NO */
@property (nonatomic,assign,getter = isDotted) BOOL dotted;


@end
