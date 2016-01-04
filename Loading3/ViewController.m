//
//  ViewController.m
//  动画
//
//  Created by iLogiEMAC on 15/12/30.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "ViewController.h"
#import "Circlelayer.h"


static NSString * const kName = @"name";
static NSString * const kProgress = @"progress";
static NSString * const kMoveLayerGroup = @"moveLayerGroup";

@interface ViewController ()
{
    Circlelayer * _layer;
    CAShapeLayer * _moveLayer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Circlelayer * layer = [Circlelayer layer];
    layer.progress = 0;
    layer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    layer.masksToBounds = YES;
    
    layer.bounds = CGRectMake(100, 100, 80, 80);
    [self.view.layer addSublayer:layer];
    _layer = layer;
    
    
    CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"progress"];
    basic.fromValue = @0.0;
    basic.toValue = [NSNumber numberWithFloat:1.0];
    basic.fillMode =  kCAFillModeForwards;
    basic.removedOnCompletion = NO;
    basic.repeatCount = 1;
    
    basic.delegate = self;
    basic.duration = 5;
    [basic setValue:kProgress forKey:kName];
    [_layer addAnimation:basic forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:kName] isEqualToString:kProgress]) {
        //执行红点抛物线
        [self doHandlePao];
    }else if ([[anim valueForKey:kName] isEqualToString:kMoveLayerGroup])
    {
        
    }
}
- (void)doHandlePao
{
    CGFloat SSFrom = 0;
    CGFloat SSTo = 0.9;
    
    // SE(strokeEnd)
    CGFloat SEFrom = 0.1;
    CGFloat SETo = 1;
    CAShapeLayer * moveLayer = [CAShapeLayer layer];
    moveLayer.bounds = self.view.bounds;
    moveLayer.strokeStart = SSTo;
    moveLayer.strokeEnd = SETo;
    moveLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    //圆心
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.layer.bounds), CGRectGetMidY(self.view.layer.bounds));
    CGFloat kRadius = CGRectGetWidth(_layer.bounds) * 0.5 - 5 * 2 ;
    
    //圆心
    UIBezierPath * path  = [UIBezierPath bezierPath] ;
    //圆弧的距离
    CGFloat d = kRadius / 2;
    
    //    //画半弧
    //    //半弧的圆心
    CGPoint arcCenter = CGPointMake(center.x - d - kRadius, center.y);
    CGFloat arcRadius = 2 * kRadius + d;
    CGFloat endAngle =  - asin(2*kRadius / arcRadius);
    
    [path addArcWithCenter:arcCenter radius:arcRadius startAngle:0 endAngle:endAngle clockwise:NO];
    
    moveLayer.strokeColor = [UIColor redColor].CGColor;
    moveLayer.fillColor = nil;
    moveLayer.path = path.CGPath;
    moveLayer.lineWidth = 3;
    
    
    [self.view.layer addSublayer:moveLayer];
    
    _moveLayer = moveLayer;
    [self addAnimationSSFrom:SSFrom to:SSTo SEFrom:SEFrom to:SETo];
}
- (void)addAnimationSSFrom:(CGFloat)ssfrom to:(CGFloat)ssto SEFrom:(CGFloat)sefrom to:(CGFloat)seto
{
    CABasicAnimation * startAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startAnimation.fromValue = @(ssfrom);
    startAnimation.toValue = @(ssto);
    
    
    CABasicAnimation * endAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endAnimation.fromValue = @(sefrom);
    endAnimation.toValue = @(seto);
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.animations = @[startAnimation,endAnimation];
    group.duration = 3;
    group.repeatCount = 1;
    
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [group setValue:kMoveLayerGroup forKey:kName];
    [_moveLayer addAnimation:group forKey:nil];
    
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
