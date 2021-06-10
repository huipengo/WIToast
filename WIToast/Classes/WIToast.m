//
//  WIToast.m
//  WIToast
//
//  Created by huipeng on 2020/10/24.
//

#import "WIToast.h"

#ifndef dispatch_main_toast_async_safe
#define dispatch_main_toast_async_safe(block)                                                                            \
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) { \
        block();                                                                                                         \
    } else {                                                                                                             \
        dispatch_async(dispatch_get_main_queue(), block);                                                                \
    }
#endif

// toast 默认展示时间
static NSTimeInterval const im_toast_duration = 1.5f;
// toast 默认消失时间
static NSTimeInterval const im_toast_fade_duration = 0.3f;

static CGFloat const im_vertical = 0.4f;

static CGFloat const im_view_max_width = 150.0f;
static CGFloat const im_toast_constant = 12.0f;

static CGFloat const im_image_width  = 44.0f;
static CGFloat const im_image_height = 44.0f;

// 纯文本最大宽度
static CGFloat const im_text_max_width  = 220.0f;

// 纯文本最大高度差
static CGFloat const im_text_max_height_space = 150.0f;

@interface WIToast ()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat vertical;

@end

@implementation WIToast

- (instancetype)init {
    if (self = [super init]) {
        self.vertical           = im_vertical;
        self.layer.cornerRadius = 6.0f;
        self.backgroundColor    = [[UIColor blackColor] colorWithAlphaComponent:0.86f];
    }
    return self;
}

- (void)setTextAlignment:(CGFloat)height {
    self.messageLabel.textAlignment = (height > 30.0f) ? NSTextAlignmentLeft : NSTextAlignmentCenter;
}

/** 纯文本 toast */
- (void)initializeTextToast:(NSString *)message {
    if (![_messageLabel isDescendantOfView:self]) {
        [self addSubview:self.messageLabel];
    }
    self.messageLabel.text = message;
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.0f];
    self.messageLabel.font = font;
    
    CGSize r_size = CGSizeMake(im_text_max_width, [UIScreen mainScreen].bounds.size.height - im_text_max_height_space);
    CGSize size = [self sizeWithBounding:message
                                rectSize:r_size
                           attributeFont:font];
    [self setTextAlignment:size.height];

    [self __layoutTextConstraints];
}

/** 纯图 toast */
- (void)initializeImageToast:(UIImage *)image {
    if (![self.imageView isDescendantOfView:self]) {
        [self addSubview:self.imageView];
    }
    self.imageView.image = image;

    [self __layoutImageConstraints];
}

/** 图文 toast */
- (void)initializeImageTextToast:(NSString *)message image:(UIImage *)image {
    if (![WIToast wb_isEmpty:message]) {
        if (![_messageLabel isDescendantOfView:self]) {
            [self addSubview:self.messageLabel];
        }
        self.messageLabel.text = message;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.0f];
        self.messageLabel.font = font;
        
        CGFloat m_width = (im_view_max_width - im_toast_constant * 2);
        CGSize r_size = CGSizeMake(m_width, [UIScreen mainScreen].bounds.size.height - im_text_max_height_space);
        CGSize size = [self sizeWithBounding:message
                                    rectSize:r_size
                               attributeFont:font];
        [self setTextAlignment:size.height];
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    
    if (image) {
        if (![self.imageView isDescendantOfView:self]) {
            [self addSubview:self.imageView];
        }
        self.imageView.image = image;
    }

    [self __layoutImageTextConstraints];
}

- (void)initWithMessage:(NSString *)message image:(UIImage *)image {
    BOOL isEmpty = [WIToast wb_isEmpty:message];
    // 图文 Toast
    if ((!isEmpty) && image) {
        [self initializeImageTextToast:message image:image];
    }
    // 图片 Toast
    else if (isEmpty && image) {
        [self initializeImageToast:image];
    }
    // 纯文本 Toast
    else if ((!isEmpty) && (!image)) {
        [self initializeTextToast:message];
    }
}

+ (NSBundle *)_im_bundle {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSURL *URL = [bundle URLForResource:@"WIToast" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:URL];
}

+ (nullable UIImage *)_im_image:(NSString *)imageName {
    NSBundle *bundle = [self _im_bundle];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

#pragma mark - show toast
+ (void)showSuccess:(nullable NSString *)message {
    UIImage *image = [self _im_image:@"wi_success"];
    [self showInfo:message image:image];
}

+ (void)showFailed:(nullable NSString *)message {
    UIImage *image = [self _im_image:@"wi_failed"];
    [self showInfo:message image:image];
}

+ (void)showWarning:(nullable NSString *)message {
    UIImage *image = [self _im_image:@"wi_warning"];
    [self showInfo:message image:image];
}

/** 纯文本 Toast */
+ (void)showInfo:(nonnull NSString *)message {
    [self showInfo:message duration:im_toast_duration];
}

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view {
    [self showInfo:message inView:view duration:im_toast_duration];
}

+ (void)showInfo:(nonnull NSString *)message duration:(NSTimeInterval)duration {
    [self showInfo:message inView:nil duration:duration];
}

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view vertical:(CGFloat)vertical {
    [self showInfo:message inView:view vertical:vertical duration:im_toast_duration];
}

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view duration:(NSTimeInterval)duration {
    [self showInfo:message inView:view vertical:im_vertical duration:duration];
}

+ (void)showInfo:(nonnull NSString *)message inView:(nullable UIView *)view vertical:(CGFloat)vertical duration:(NSTimeInterval)duration {
    [self showInfo:message image:nil inView:view vertical:vertical duration:duration];
}

/** 纯图 Toast */
+ (void)showImage:(nonnull UIImage *)image {
    [self showInfo:nil image:image];
}

/** 图文 Toast */
+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image {
    [self showInfo:message image:image duration:im_toast_duration];
}

+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image duration:(NSTimeInterval)duration {
    [self showInfo:message image:image inView:nil duration:duration];
}

+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image inView:(nullable UIView *)view duration:(NSTimeInterval)duration {
    [self showInfo:message image:image inView:view vertical:im_vertical duration:duration];
}

+ (void)showInfo:(nullable NSString *)message image:(nullable UIImage *)image inView:(nullable UIView *)view vertical:(CGFloat)vertical duration:(NSTimeInterval)duration {
    BOOL isEmpty = [self wb_isEmpty:message];
    if (isEmpty && (image == nil)) { return; }
    
    dispatch_main_toast_async_safe(^{
        WIToast *toast = [[WIToast alloc] init];
        if (!view) {
            UIWindow *window = [self lastWindow];
            [window addSubview:toast];
        } else {
            [view addSubview:toast];
        }
        toast.vertical = vertical;
        [toast initWithMessage:message image:image];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:im_toast_fade_duration
                animations:^{
                    toast.alpha = 0.0f;
                }
                completion:^(BOOL finished) {
                    [toast removeFromSuperview];
                }];
        });
    });
}

+ (UIWindow *)lastWindow {
    UIWindow *lastWindow = [UIApplication sharedApplication].windows.lastObject;
    if ((lastWindow == nil) || lastWindow.hidden || [lastWindow isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
        lastWindow = [UIApplication sharedApplication].keyWindow;
    }
    return lastWindow;
}

#pragma mark--
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel               = [[UILabel alloc] init];
        _messageLabel.textColor     = [UIColor whiteColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.lineBreakMode = NSLineBreakByClipping;
    }
    return _messageLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (CGFloat)vertical {
    _vertical = (_vertical < 0.0f) ? 0.0f : ((_vertical > 1.0f) ? 1.0f : _vertical);
    return _vertical;
}

- (void)__layoutTextConstraints {
    self.translatesAutoresizingMaskIntoConstraints              = NO;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *view_centerX = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.superview
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0];

    NSLayoutConstraint *view_top = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:self.superview.frame.size.height * self.vertical];

    NSLayoutConstraint *label_centerX = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];

    NSLayoutConstraint *label_centerY = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0];

    NSLayoutConstraint *label_width = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:im_text_max_width];

    NSLayoutConstraint *label_top = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:im_toast_constant];

    NSLayoutConstraint *label_left = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:im_toast_constant];

    NSLayoutConstraint *label_bottom = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-im_toast_constant];

    NSLayoutConstraint *label_right = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0
                                                                    constant:-im_toast_constant];

    [self.superview addConstraints:@[ view_centerX, view_top ]];
    [self addConstraints:@[ label_centerX, label_centerY, label_width, label_left, label_right, label_top, label_bottom ]];
    [self layoutIfNeeded];
}

- (void)__layoutImageConstraints {
    self.translatesAutoresizingMaskIntoConstraints              = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints    = NO;

    NSLayoutConstraint *view_width = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:im_view_max_width];

    NSLayoutConstraint *view_centerX = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.superview
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0];

    NSLayoutConstraint *view_centerY = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.superview
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0];

    NSLayoutConstraint *image_centerX = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];

    NSLayoutConstraint *image_top = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:25.0];

    NSLayoutConstraint *image_width = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:im_image_width];

    NSLayoutConstraint *image_height = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:im_image_height];

    NSLayoutConstraint *image_bottom = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-25.0];
    
    [self.superview addConstraints:@[ view_width, view_centerX, view_centerY ]];
    [self addConstraints:@[ image_centerX, image_top, image_width, image_height, image_bottom ]];
    [self layoutIfNeeded];
}

- (void)__layoutImageTextConstraints {
    self.translatesAutoresizingMaskIntoConstraints              = NO;
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.translatesAutoresizingMaskIntoConstraints    = NO;

    NSLayoutConstraint *view_width = [NSLayoutConstraint constraintWithItem:self
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:im_view_max_width];

    NSLayoutConstraint *view_centerX = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.superview
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0];

    NSLayoutConstraint *view_centerY = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.superview
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0];

    NSLayoutConstraint *image_centerX = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];

    NSLayoutConstraint *image_top = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:25.0];

    NSLayoutConstraint *image_width = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:im_image_width];

    NSLayoutConstraint *image_height = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:im_image_height];

    NSLayoutConstraint *label_centerX = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0];

    NSLayoutConstraint *label_width = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1.0
                                                                    constant:(im_view_max_width - im_toast_constant * 2)];

    NSLayoutConstraint *label_top = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.imageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:15.0f];

    NSLayoutConstraint *label_left = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:im_toast_constant];

    NSLayoutConstraint *label_bottom = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-25.0];

    NSLayoutConstraint *label_right = [NSLayoutConstraint constraintWithItem:self.messageLabel
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationLessThanOrEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0
                                                                    constant:-im_toast_constant];

    [self.superview addConstraints:@[ view_width, view_centerX, view_centerY ]];
    [self addConstraints:@[ image_centerX, image_top, image_width, image_height,
                            label_left, label_right, label_centerX, label_top, label_bottom, label_width ]];
    [self layoutIfNeeded];
}

+ (BOOL)wb_isEmpty:(nullable NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (!string ||
        [string isKindOfClass:[NSNull class]] ||
        string.length == 0 ||
        [string isEqualToString:@""]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

- (CGSize)sizeWithBounding:(NSString *)text rectSize:(CGSize)rectSize attributeFont:(UIFont *)attributeFont {
    if ([self.class wb_isEmpty:text]) {
        return CGSizeZero;
    }
    
    NSDictionary *attributes = @{ NSFontAttributeName: attributeFont };
    
    CGSize stringSize = [text boundingRectWithSize:rectSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                           context:nil].size;
    
    return CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
}

@end
