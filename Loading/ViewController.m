//
//  ViewController.m
//  动画
//
//  Created by iLogiEMAC on 15/12/30.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ViewController.h"
#import "Circlelayer.h"



@interface ViewController ()
{
    Circlelayer * _layer;
 
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //方法1：
    CAShapeLayer * circle = [CAShapeLayer layer];
    circle.bounds = self.view.bounds;
    circle.position = self.view.center;
    
    UIBezierPath  * circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)) radius:30 startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    circle.path = circlePath.CGPath;
    circle.strokeColor = [UIColor blueColor].CGColor;
    circle.fillColor = nil;
    [self.view.layer addSublayer:circle];
    
    circle.strokeStart = 0.26;
    circle.strokeEnd = 0.5;
    //通过圆的strokeStart 改变来进行改变
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(0.26);
    strokeStartAnimation.toValue = @(0);
    //通过圆的strokeEnd 改变来进行改变
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @0.5;
    strokeEndAnimation.toValue =@(1.0);
    //通过圆的transform.rotation.z 改变来进行改变
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(-5*M_PI);
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.duration = 5;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[strokeStartAnimation,strokeEndAnimation,rotationAnimation];
    [circle addAnimation:group forKey:nil];

//    方法2:
//    Circlelayer * layer = [Circlelayer layer];
//    layer.progress = 0;
//    layer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//
//    layer.masksToBounds = YES;
//
//    layer.bounds = CGRectMake(100, 100, 80, 80);
//    [self.view.layer addSublayer:layer];
//    _layer = layer;
//    
//    
//    CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"progress"];
//    basic.fromValue = @0.0;
//    basic.toValue = [NSNumber numberWithFloat:1.0];
//    basic.fillMode =  kCAFillModeForwards;
//    basic.removedOnCompletion = NO;
//    basic.repeatCount = MAXFLOAT;
//
//
//    basic.duration = 5;
//   
//    [_layer addAnimation:basic forKey:nil];
    
}


- (IBAction)sender:(id)sender {
    
    _layer.progress += 0.01;
    
    
    
}
- (void)handleDisplayLink:(CADisplayLink *)lik
{
 
    if (_layer.progress >= 1.0) {
        return [lik invalidate];
    }
   
    _layer.progress += 0.001;
  

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
