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
+ (void)showInfo:(nonnull NSString *)message;

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view;

+ (void)showInfo:(nonnull NSString *)message duration:(NSTimeInterval)duration;

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view vertical:(CGFloat)vertical;

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view duration:(NSTimeInterval)duration;

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view vertical:(CGFloat)vertical duration:(NSTimeInterval)duration;

/** 纯图 Toast */
+ (void)showImage:(nonnull UIImage *)image;

/** 图文 Toast */
+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image;

+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image duration:(NSTimeInterval)duration;

+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image inView:(nullable UIView *)view duration:(NSTimeInterval)duration;

/**
 图文 Toast
 
 @param message     显示信息
 @param image         显示图片
 @param view           显示在 view 上，传 nil，显示在 window
 @param vertical  相对于 view 高度的比例，取值 0.0-1.0，默认：0.4
 @param duration  显示时间，默认：1.5s
 */
+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image inView:(nullable UIView *)view vertical:(CGFloat)vertical duration:(NSTimeInterval)duration;


+ (void)showSuccess:(nullable NSString *)message;

+ (void)showFailed:(nullable NSString *)message;

+ (void)showWarning:(nullable NSString *)message;

@end

NS_ASSUME_NONNULL_END
