//
//  UIImage+LZCrop.m
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "UIImage+LZCrop.h"

@implementation UIImage (LZCrop)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/** 不做任何处理 */
+ (UIImage *)fitScreenWithImage:(UIImage *)image {

    CGSize newSize;
    BOOL min = image.size.height>image.size.width;
    if (min && image.size.width<kScreenWidth) {
        CGFloat scale = kScreenWidth/image.size.width;
        newSize = CGSizeMake(kScreenWidth, image.size.height*scale);
    }else if (min && image.size.width >= kScreenWidth){ // 比圆大
        CGFloat scale = kScreenWidth/image.size.width;
        newSize = CGSizeMake(kScreenWidth, image.size.height*scale);
    }else{
        CGFloat scale = kScreenWidth/image.size.height;
        newSize = CGSizeMake(image.size.width * scale, kScreenWidth);
    }
    image = [self imageWithImageSimple:image scaledToSize:newSize];
    return image;
}

#pragma mark - 裁剪图片
/** 矩形 */
- (UIImage *)cropSquareImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height { 
    
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

/** 矩形 */
- (UIImage *)cropCircleImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {

    // 画布大小
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGSize size = CGSizeMake(width, height);
    // 创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    // 1.绘制一个扇形路径
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,width,height)];
    // 2.利用path进行裁剪
    [clipPath addClip];
    [image drawAtPoint:CGPointZero];
    // 3.返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
