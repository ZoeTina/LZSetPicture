//
//  LZActionSheet.h
//  LZSetPicture
//
//  Created by 寕小陌 on 2016/12/20.
//  Copyright © 2016年 寜小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LZActionSheetDelegate;

typedef void(^LZActionSheetBlock)(NSInteger buttonIndex);

@interface LZActionSheet : UIView

/**
 *  type delegate
 *
 *  @param title                  title            (可以为空)
 *  @param delegate               delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
                     delegate:(id<LZActionSheetDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  type block
 *
 *  @param title                  title            (可以为空)
 *  @param actionSheetBlock       delegate
 *  @param cancelButtonTitle      "取消"按钮         (默认有)
 *  @param destructiveButtonTitle "警示性"(红字)按钮  (可以为空)
 *  @param otherButtonTitles      otherButtonTitles
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
             actionSheetBlock:(LZActionSheetBlock) actionSheetBlock;


@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<LZActionSheetDelegate> delegate;

- (void)showView;

@end


#pragma mark - ACActionSheet delegate

@protocol LZActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(LZActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end
