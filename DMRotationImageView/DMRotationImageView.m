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

#import "DMRotationImageView.h"


typedef NS_ENUM(NSUInteger, DMRotationDrawType) {
    /// 旋转
    DMRotationDrawTypeRotate,
    /// 直接更新角度
    DMRotationDrawTypeUpdateAngle,
};

@interface DMRotationImageView ()

@property (nonatomic, assign) CGFloat beginAngle;
@property (nullable, nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) CGFloat curAngleBak;

@property (nonatomic, assign, getter=isPenDown) BOOL penDown;
@property (nonatomic, assign) DMRotationDrawType drawType;

@end

@implementation DMRotationImageView
{
    UIImage *_image;
}

// 弧度 = 角度 * Pi / 180;
- (CGFloat)angleWithPoint:(CGPoint)point
{
    CGFloat angle = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat len = 0;
    CGPoint center = {CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
    
    if (point.x == center.x)
    {
        if (point.y < center.y)
        {
            return 90;
        }
        else if (point.x == center.x)
        {
            return 0;
        }
        else
        {
            return 270;
        }
    }
    else if (point.y == center.y)
    {
        if (point.x < center.x)
        {
            return 180;
        }
        else
        {
            return 0;
        }
    }
    
    if (point.x > center.x)
    {
        width = point.x - center.x;
        
        if (point.y < center.y)
        {
            //第一象限
            height = center.y - point.y;
            len = sqrt((width * width) + (height * height));
            
            angle = asin(height / len) * 180 / M_PI;
        }
        else
        {
            //第四象限
            height = point.y - center.y;
            len = sqrt((width * width) + (height * height));
            
            angle = 360 - (asin(height / len) * 180 / M_PI);
        }
    }
    else
    {
        width = center.x - point.x;
        
        if (point.y < center.y)
        {
            //第二象限
            height = center.y - point.y;
            len = sqrt((width * width) + (height * height));
            
            angle = 180 - asin(height / len) * 180 / M_PI;
        }
        else
        {
            //第三象限
            height = point.y - center.y;
            len = sqrt((width * width) + (height * height));
            
            angle = 180 + (asin(height / len) * 180 / M_PI);
        }
    }

//    NSLog(@"width = %@, height = %@, angle=%@", @(width), @(height), @(angle));
    
    angle = angle * M_PI / 180;
    
    return angle;
}

- (CGFloat)angleBeginPoint:(CGPoint)beginPoint
                  endPoint:(CGPoint)endPoint
{
    CGFloat x = endPoint.x - beginPoint.x;
    CGFloat y = endPoint.y - beginPoint.y;
    CGFloat len = sqrt(x * x + y * y);
    CGFloat cos = x / len;
    CGFloat radian = acos(cos);

    CGFloat angle = 180.0 / (M_PI / radian);
    if (y < 0)
    {
        angle = -angle;
    }
    else if ((0 == y) && (x < 0))
    {
        angle = 180;
    }
    
    return angle;
}

+ (instancetype)rotationImageViewWithImage:(nullable UIImage *)image
{
    return [[self alloc] initWithImage:image];
}

- (instancetype)initWithImage:(nullable UIImage *)image
{
    self = [super init];
    if (self)
    {
        self.sourceImage = image;
        [self defaultSetting];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultSetting];
    }
    
    return self;
}

- (void)defaultSetting
{

}

- (void)beganTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *th = touches.anyObject;
    CGPoint point = [th locationInView:self];
    self.beginAngle = [self angleWithPoint:point];
    self.curAngleBak = self.curAngle;
}

- (void)movedTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *th = touches.anyObject;
    CGPoint point = [th locationInView:self];
    
    CGFloat angle = [self angleWithPoint:point];
    _curAngle = self.curAngleBak + angle - self.beginAngle;
    self.drawType = DMRotationDrawTypeRotate;

    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.penDown = YES;
    [self beganTouch:touches withEvent:event];
    
    if ([self.delegate respondsToSelector:@selector(rotationImageViewBegin:)])
    {
        [self.delegate rotationImageViewBegin:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.isPenDown)
    {
        [self movedTouch:touches withEvent:event];
        
        if ([self.delegate respondsToSelector:@selector(rotationImageViewMove:)])
        {
            [self.delegate rotationImageViewMove:self];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.isPenDown)
    {
        self.penDown = NO;
        
        [self movedTouch:touches withEvent:event];
        
        if ([self.delegate respondsToSelector:@selector(rotationImageViewEnd:)])
        {
            [self.delegate rotationImageViewEnd:self];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (self.isPenDown)
    {
        self.penDown = NO;
        
        [self movedTouch:touches withEvent:event];
        
        if ([self.delegate respondsToSelector:@selector(rotationImageViewEnd:)])
        {
            [self.delegate rotationImageViewEnd:self];
        }
    }
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.sourceImage = image;
}

- (UIImage *)image
{
    return _image;
}

- (void)drawRect:(CGRect)rect
{
    if (nil != self.sourceImage)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();

        [self drawImage:context rect:rect];
        
        if (DMRotationDrawTypeRotate == self.drawType)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(rotationImageView:didDrawImage:)])
                {
                    UIImage *image = [self curDrawImage];
                    [self.delegate rotationImageView:self didDrawImage:image];
                }
            });
        }
    }
}

- (void)drawImage:(CGContextRef)context rect:(CGRect)rect
{
    CGContextTranslateCTM(context, rect.size.width / 2, rect.size.height / 2);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, _curAngle);
    
    rect.origin.x = -rect.size.width / 2;
    rect.origin.y = -rect.size.height / 2;
    CGContextDrawImage(context, rect, self.sourceImage.CGImage);
    
    CGContextFlush(context);
    CGContextFillPath(context);
}

- (nullable UIImage *)curDrawImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawImage:context rect:self.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setCurAngle:(CGFloat)curAngle
{
    _curAngle = curAngle;
    self.drawType = DMRotationDrawTypeUpdateAngle;
    [self setNeedsDisplay];
}

@end

