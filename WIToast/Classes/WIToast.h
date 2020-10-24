//
//  IToast.h
//  IToast
//
//  Created by huipeng on 2020/10/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WIToast : UIView

/** 纯文本 Toast */
+ (void)showInfo:(NSString * _Nonnull)message;

+ (void)showInfo:(NSString * _Nonnull)message duration:(NSTimeInterval)duration;

+ (void)showInfo:(NSString * _Nonnull)message inView:(UIView * _Nullable)view duration:(NSTimeInterval)duration;

+ (void)showInfo:(NSString * _Nonnull)message inView:(UIView * _Nullable)view vertical:(CGFloat)vertical duration:(NSTimeInterval)duration;

/** 纯图 Toast */
+ (void)showImage:(UIImage * _Nonnull)image;

/** 图文 Toast */
+ (void)showInfo:(NSString * _Nullable)message image:(UIImage * _Nullable)image;

+ (void)showInfo:(NSString * _Nullable)message image:(UIImage * _Nonnull)image duration:(NSTimeInterval)duration;

+ (void)showInfo:(NSString * _Nullable)message image:(UIImage * _Nonnull)image inView:(UIView * _Nullable)view duration:(NSTimeInterval)duration;

/**
 图文 Toast
 
 @param message     显示信息
 @param image         显示图片
 @param view           显示在 view 上，传 nil，显示在 window
 @param vertical  相对于 view 高度的比例，取值 0.0-1.0，默认：0.5
 @param duration  显示时间，默认：2.0s
 */
+ (void)showInfo:(NSString * _Nullable)message image:(UIImage * _Nullable)image inView:(UIView * _Nullable)view vertical:(CGFloat)vertical duration:(NSTimeInterval)duration;


+ (void)showSuccess:(NSString * _Nullable)message;

+ (void)showFailed:(NSString * _Nullable)message;

+ (void)showWarning:(NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END
