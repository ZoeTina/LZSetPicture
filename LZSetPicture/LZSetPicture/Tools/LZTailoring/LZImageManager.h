//
//  LZImageManager.h
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSingleton.h"

typedef void(^getImageBlock)(UIImage * image);

@interface LZImageManager : NSObject

LZSingletonH(Manager);


/**
 获取原始图片-不裁剪

 @param controller 传入的控制器
 @param getimageblock 回调
 */
-(void)getOriginalImageInVC:(UIViewController *)controller withCallback:(getImageBlock) getimageblock;


/**
 获取矩形图片-裁剪

 @param controller 传入的控制器
 @param size 裁剪尺寸
 @param getimageblock 回调
 */
-(void)getSquareImageInVC:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock;


/**
 获取圆形图片-裁剪

 @param controller 传入的控制器
 @param size 裁剪尺寸
 @param getimageblock 回调
 */
-(void)getCircleImageInVc:(UIViewController *)controller withSize:(CGSize)size  withCallback:(getImageBlock) getimageblock;

@end
