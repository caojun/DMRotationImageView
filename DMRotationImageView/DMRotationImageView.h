/**
 The MIT License (MIT)
 
 Copyright (c) 2016 Jun
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DMRotationImageView;

@protocol DMRotationImageViewDelegate <NSObject>

@optional
- (void)rotationImageViewBegin:(nonnull DMRotationImageView *)view;
- (void)rotationImageViewMove:(nonnull DMRotationImageView *)view;
- (void)rotationImageViewEnd:(nonnull DMRotationImageView *)view;

- (void)rotationImageView:(nonnull DMRotationImageView *)view
             didDrawImage:(nonnull UIImage *)image;

@end

@interface DMRotationImageView : UIView

@property (nullable, nonatomic, weak) IBOutlet id<DMRotationImageViewDelegate> delegate;

@property (nullable, nonatomic, strong) IBInspectable UIImage *image;
/// 当前角度, 0 - 360
@property (nonatomic, assign) IBInspectable CGFloat curAngle;

+ (instancetype)rotationImageViewWithImage:(nullable UIImage *)image;
- (instancetype)initWithImage:(nullable UIImage *)image;

- (nullable UIImage *)curDrawImage;

@end

NS_ASSUME_NONNULL_END

