//
//  LZTailoringViewController.m
//  LZSetPicture
//
//  Created by 寕小陌 on 2017/09/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZTailoringViewController.h"
#import "LZImageMaskView.h"
#import "UIImage+LZCrop.h"

@interface LZTailoringViewController ()<UIScrollViewDelegate,LZImageMaskViewDelegate>

/** 用于缩放 */
@property (nonatomic,strong) UIScrollView *scrollView;
/** 显示图片 */
@property (nonatomic,strong) UIImageView * imageView;
/** 显示裁剪形状和区域 */
@property (nonatomic,strong) LZImageMaskView *maskView;
/** 宽度 */
@property (nonatomic,assign) CGFloat cropWidth;
/** 高度 */
@property (nonatomic,assign) CGFloat cropHeight;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic,assign) UIEdgeInsets imageInset;
@end

@implementation LZTailoringViewController
-(instancetype)init
{
    if (self = [super init])
    {
        self.cutSize  = CGSizeZero;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.cutImage = [UIImage fitScreenWithImage:self.cutImage];
    /** 初始化UIScrollview */
    [self initScrollview];
    /** 创建中间视图 */
    [self initMaskView];
    /** 创建顶部工具栏视图 */
    [self initTopView];
    /** 创建底部工具栏视图 */
    [self initBottomView];
}
#pragma mark - UI相关

/** 初始化UIScrollview */
-(void)initScrollview
{
    //可以缩放/滚动的scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_scrollView];
    
    _scrollView.delegate = self;
    NSLog(@"self.cutImage.size -- %f",self.cutImage.size.height);
    NSLog(@"self.cutImage.size -- %f",self.cutImage.size.width);
    _scrollView.contentSize = self.cutImage.size;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = YES;
    
    
    //imageview
    self.imageView = [[UIImageView alloc] initWithImage:self.cutImage];
    [_scrollView addSubview:_imageView];
    _imageView.center = self.view.center;
    
    // 修改部分--没效果
    [self.imageView setClipsToBounds:YES];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizesSubviews = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

-(void)initMaskView {
    
    self.maskView = [[LZImageMaskView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
    _maskView.delegate  = self;
    
    _maskView.cutSize   = self.cutSize;
    _maskView.mode      = self.mode;
    
    _maskView.dotted    = self.isDotted;
    _maskView.linesColor= self.linesColor;
    
}

/** 创建顶部工具栏视图 */
-(void)initTopView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 61)];
    titleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:titleView];

    NSString *titleStr = _navigationTitle?_navigationTitle:@"移动和缩放";
    UIButton *titleBtn = [self buttonWithTitle:titleStr];
    titleBtn.frame = CGRectMake(0, 0, kScreenWidth, 61);
    [titleView addSubview:titleBtn];
}

/** 创建底部工具栏视图 */
-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    [self.view addSubview:bottomView];
    
    UIButton *cancelBtn = [self buttonWithTitle:@"取消"];
    cancelBtn.frame = CGRectMake(13, 0, 100, 50);
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [self buttonWithTitle:@"完成"];
    confirmBtn.frame = CGRectMake(kScreenWidth - 113.0f, 0, 100, 50);
    confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [confirmBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
    
}

/** 创建公共按钮 */
- (UIButton *)buttonWithTitle:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [button.titleLabel setNumberOfLines:0];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    return button;
}

#pragma mark - buttonAction
-(void)cancelBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropperDidCancel:)]) {
        [self.delegate imageCropperDidCancel:self];
    }
}
- (void)sureBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropper:didFinished:)]) {
        [self.delegate imageCropper:self didFinished:[self cropImage]];
    }
}
#pragma mark - setter方法
-(void)setCutSize:(CGSize)cutSize
{
    _cropWidth = cutSize.width > 0 ? cutSize.width:kScreenWidth;
    _cropHeight = cutSize.height > 0 ? cutSize.height:kScreenWidth;
    _cutSize = CGSizeMake(_cropWidth, _cropHeight);
}
#pragma mark - 裁剪图片
- (UIImage *)cropImage {
    CGFloat zoomScale = _scrollView.zoomScale;
    
    CGFloat offsetX = _scrollView.contentOffset.x;
    CGFloat offsetY = _scrollView.contentOffset.y;
    CGFloat aX = offsetX>=0 ? offsetX+_imageInset.left : (_imageInset.left - ABS(offsetX));
    CGFloat aY = offsetY>=0 ? offsetY+_imageInset.top : (_imageInset.top - ABS(offsetY));
    
    aX = aX / zoomScale;
    aY = aY / zoomScale;
    
    CGFloat aWidth =  MAX(self.cropWidth / zoomScale, self.cropWidth);
    CGFloat aHeight = MAX(self.cropHeight / zoomScale, self.cropHeight);
    if (zoomScale>1) {
        aWidth = self.cropWidth/zoomScale;
        aHeight = self.cropHeight/zoomScale;
    }
    
    UIImage *image = nil;
    if (self.mode == ImageMaskViewModeCircle) {
        image = [self.cutImage cropCircleImageWithX:aX y:aY width:aWidth height:aHeight];
    } else {
        image = [self.cutImage cropSquareImageWithX:aX y:aY width:aWidth height:aHeight];
    }
        
    return image;
}


#pragma mark - LZImageMaskViewDelegate
-(void)layoutScrollViewWithRect:(CGRect)rect {
    _rect = rect;
    CGFloat top = (self.cutImage.size.height-rect.size.height)/2;
    CGFloat left = (self.cutImage.size.width-rect.size.width)/2;
    CGFloat bottom = self.view.bounds.size.height-top-rect.size.height;
    CGFloat right = self.view.bounds.size.width-rect.size.width-left;
    self.scrollView.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
    
    CGFloat maskCircleWidth = rect.size.width;
    
    CGSize imageSize = self.cutImage.size;

    CGFloat minimunZoomScale = imageSize.width < imageSize.height ? maskCircleWidth / imageSize.width : maskCircleWidth / imageSize.height;
    CGFloat maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = minimunZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
    self.scrollView.zoomScale = self.scrollView.zoomScale < minimunZoomScale ? minimunZoomScale : self.scrollView.zoomScale;
    _imageInset = self.scrollView.contentInset;
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end
