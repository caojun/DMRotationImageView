//
//  ViewController.m
//  DMRotationImageViewDemo
//
//  Created by Dream on 2016/11/30.
//  Copyright © 2016年 Jun. All rights reserved.
//

#import "ViewController.h"
#import "DMRotationImageView.h"

@interface ViewController () <DMRotationImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *m_imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
}


#pragma mark - DMRotationImageViewDelegate
- (void)rotationImageViewBegin:(DMRotationImageView *)view
{
    NSLog(@"begin");
}

- (void)rotationImageViewMove:(DMRotationImageView *)view
{
    NSLog(@"move");
}

- (void)rotationImageViewEnd:(DMRotationImageView *)view
{
    NSLog(@"end");
    
    self.m_imageView.image = [view curDrawImage];
}

- (void)rotationImageView:(nonnull DMRotationImageView *)view
             didDrawImage:(nonnull UIImage *)image
{
    self.m_imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
