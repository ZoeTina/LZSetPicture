//
//  UIImage+LZCrop.h
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WDCrop)

/** 不做任何处理 */
+ (UIImage *)fitScreenWithImage:(UIImage *)image;

#pragma mark - 裁剪图片

/** 矩形 */
- (UIImage *)cropSquareImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/** 圆形 */
- (UIImage *)cropCircleImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;



@end
