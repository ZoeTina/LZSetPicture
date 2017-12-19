//
//  LZActionSheet.m
//  LZSetPicture
//
//  Created by 寕小陌 on 2016/12/20.
//  Copyright © 2016年 寜小陌. All rights reserved.
//

#import "LZActionSheet.h"

// 标题字体大小
#define LZTitleFont     [UIFont systemFontOfSize:15.0f]

#define LZTitleHeight 60.0f         // 标题高度
#define LZButtonHeight  49.0f       // 按钮高度
#define LZDarkShadowViewAlpha 0.35f // 透明度
#define LZShowAnimateDuration 0.0f // 显示动画时间,0.25
#define LZHideAnimateDuration 0.0f // 隐藏动画时间,0.25

@interface LZActionSheet () {
    
    NSString *_cancelButtonTitle;
    NSString *_destructiveButtonTitle;
    NSArray *_otherButtonTitles;
    
    
    UIView *_buttonBackgroundView;
    UIView *_darkShadowView;
}


@property (nonatomic, copy) LZActionSheetBlock actionSheetBlock;

@end

@implementation LZActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LZActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {

    self = [super init];
    if(self) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle.length>0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *args = [NSMutableArray array];
        
        if(_destructiveButtonTitle.length) {
            [args addObject:_destructiveButtonTitle];
        }
        
        [args addObject:otherButtonTitles];
        
        if (otherButtonTitles) {
            va_list params;
            va_start(params, otherButtonTitles);
            id buttonTitle;
            while ((buttonTitle = va_arg(params, id))) {
                if (buttonTitle) {
                    [args addObject:buttonTitle];
                }
            }
            va_end(params);
        }
        
        _otherButtonTitles = [NSArray arrayWithArray:args];
     
        [self _initSubViews];
    }
    
    return self;
}


- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles actionSheetBlock:(LZActionSheetBlock) actionSheetBlock; {
    
    self = [super init];
    if(self) {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle.length>0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *titleArray = [NSMutableArray array];
        if (_destructiveButtonTitle.length) {
            [titleArray addObject:_destructiveButtonTitle];
        }
        [titleArray addObjectsFromArray:otherButtonTitles];
        _otherButtonTitles = [NSArray arrayWithArray:titleArray];
        self.actionSheetBlock = actionSheetBlock;
        
        [self _initSubViews];
    }
    
    return self;
    
}


- (void)_initSubViews {

    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    _darkShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //之前的背景颜色为黑色半透明
    _darkShadowView.backgroundColor = kColorWithRGB(20, 20, 20);
    _darkShadowView.alpha = 0.0f;
    [self addSubview:_darkShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissView:)];
    [_darkShadowView addGestureRecognizer:tap];
    
    
    _buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _buttonBackgroundView.backgroundColor = kColorWithRGB(220, 220, 220);
    [self addSubview:_buttonBackgroundView];
    
    if (self.title.length) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, LZButtonHeight-LZTitleHeight, kScreenWidth, LZTitleHeight)];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = kColorWithRGB(125, 125, 125);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonBackgroundView addSubview:titleLabel];
    }
    
    
    for (int i = 0; i < _otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = LZTitleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0 && _destructiveButtonTitle.length) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
    
        UIImage *image = [UIImage imageNamed:@"LZActionSheet.bundle/actionSheetHighLighted.png"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = LZButtonHeight * (i + (_title.length>0?1:0));
        button.frame = CGRectMake(0, buttonY, kScreenWidth, LZButtonHeight);
        [_buttonBackgroundView addSubview:button];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = kColorWithRGB(210, 210, 210);
        line.frame = CGRectMake(0, buttonY, kScreenWidth, 0.5);
        [_buttonBackgroundView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = _otherButtonTitles.count;
    [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = LZTitleFont;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"LZActionSheet.bundle/actionSheetHighLighted.png"];
    [cancelButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = LZButtonHeight * (_otherButtonTitles.count + (_title.length>0?1:0)) + 5;
    cancelButton.frame = CGRectMake(0, buttonY, kScreenWidth, LZButtonHeight);
    [_buttonBackgroundView addSubview:cancelButton];
    
    CGFloat height = LZButtonHeight * (_otherButtonTitles.count+1 + (_title.length>0?1:0)) + 5;
    //修改之前是有动画的
    _buttonBackgroundView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height);
//    _buttonBackgroundView.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
}

- (void)_didClickButton:(UIButton *)button {

    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:button.tag];
    }
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(button.tag);
    }
    
    [self _hide];
}

- (void)_dismissView:(UITapGestureRecognizer *)tap {

    if (_delegate && [_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        [_delegate actionSheet:self didClickedButtonAtIndex:_otherButtonTitles.count];
    }
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(_otherButtonTitles.count);
    }
    
    [self _hide];
}

- (void)show {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.hidden = NO;
    [UIView animateWithDuration:LZShowAnimateDuration animations:^{
        _darkShadowView.alpha = LZDarkShadowViewAlpha;
        _buttonBackgroundView.transform = CGAffineTransformMakeTranslation(0, -_buttonBackgroundView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)_hide {
    
    [UIView animateWithDuration:LZHideAnimateDuration animations:^{
        _darkShadowView.alpha = 0;
//        _buttonBackgroundView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
@end
