//
//  LZImageMaskView.h
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZTailoringViewController.h"


@protocol LZImageMaskViewDelegate<NSObject>

- (void)layoutScrollViewWithRect:(CGRect) rect;

@end


@interface LZImageMaskView : UIView

@property (nonatomic, weak) id<LZImageMaskViewDelegate>  delegate;

/** 裁剪尺寸:长宽尺寸默认为 屏幕宽度 */
@property (nonatomic,assign) CGSize cutSize;
/** 裁剪类型:默认为 矩形 */
@property (nonatomic,assign) ImageMaskViewMode mode;
/** 线条颜色:默认为 白色 */
@property (nonatomic,strong) UIColor *linesColor;
/** 是否为虚线: 默认为 NO */
@property (nonatomic,assign,getter = isDotted) BOOL dotted;

@end
