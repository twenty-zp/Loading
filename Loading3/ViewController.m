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
static NSString * const kPositionY = @"positiony";
@interface ViewController ()
{
    Circlelayer * _layer;
    CAShapeLayer * _moveLayer;
    CAShapeLayer * _lineLayer;
    
    CGFloat finalPosition;
    
    CGFloat kRadius;
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
        //执行向下滑动
        [self doHandleTranslate];
    }
        else if ([[anim valueForKey:kName] isEqualToString:kPositionY])
    {
        //执行线条变粗
        [self dohandleStep3];
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
     kRadius = CGRectGetWidth(_layer.bounds) * 0.5 - 5 * 2 ;
    
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
    group.duration = 1;
    group.repeatCount = 1;
    group.delegate = self;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [group setValue:kMoveLayerGroup forKey:kName];
    [_moveLayer addAnimation:group forKey:nil];
    
}


- (IBAction)sender:(id)sender {
    _layer.progress += 0.01;
    
}
- (void)doHandleTranslate
{
    [_moveLayer removeFromSuperlayer];
   
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.bounds = CGRectMake(0, 0, 2, 15);

    CGFloat y = CGRectGetMidY(self.view.bounds) - 2* kRadius + (lineLayer.bounds.size.height)*0.5;
    lineLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), y);
    lineLayer.backgroundColor= [UIColor blueColor].CGColor;
    lineLayer.lineWidth = 2;
    lineLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:lineLayer];
    _lineLayer= lineLayer;
    
    finalPosition = CGRectGetMidY(self.view.bounds) -  kRadius -5;
    
    CABasicAnimation * yAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    yAnimation.fromValue = @(y);
    yAnimation.toValue = @(finalPosition);
    yAnimation.removedOnCompletion = NO;
    yAnimation.delegate = self;
    yAnimation.duration = 3;
    [yAnimation setValue:kPositionY forKey:kName];
    yAnimation.fillMode = kCAFillModeForwards;
    [lineLayer addAnimation:yAnimation forKey:nil];
    
}

- (void)dohandleStep3
{
    //逐渐移出细线
    [self removeSmallLine];
    //逐渐添加粗线
    [self addBlodLine];
    //圆变形
    [self transformCircle];
}
- (void)removeSmallLine
{
    [_lineLayer removeFromSuperlayer];
    
    CGPoint beginPoint = _lineLayer.position;
    beginPoint.y = finalPosition;
    _lineLayer.position = beginPoint;
    
    //划线的点
    CGPoint startPoint = CGPointMake(_lineLayer.position.x, _lineLayer.position.y-_lineLayer.bounds.size.height*0.5);

    
    CAShapeLayer * smallLine = [CAShapeLayer layer];
     smallLine.frame = self.view.layer.bounds;
  
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(_lineLayer.position.x, startPoint.y + _lineLayer.bounds.size.height+0.2*2*kRadius)];
    smallLine.path = path.CGPath;
    smallLine.strokeColor = _lineLayer.backgroundColor;
    smallLine.fillColor = nil;
    smallLine.contentsScale = [UIScreen mainScreen].scale;
    smallLine.lineWidth = 2;
    
    //刚开始的起始点为0
    CGFloat SSFrom = 0;
    CGFloat SSTo = 1.0;
    
    CGFloat SEFrom = _lineLayer.bounds.size.height / ( _lineLayer.bounds.size.height + 0.2*2*kRadius);
    CGFloat SETo = 1.0;
    
    [self.view.layer addSublayer:smallLine];
    
    CABasicAnimation *smallLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    smallLineAnimation.fromValue = @(SSFrom);
    smallLineAnimation.toValue =@(SSTo);
    
    CABasicAnimation *smallLineEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    smallLineEnd.fromValue = @(SEFrom);
    smallLineEnd.toValue =@(SETo);
    
    CAAnimationGroup * smallLineGroup = [CAAnimationGroup animation];
    smallLineGroup.duration = 5;
    smallLineGroup.fillMode = kCAFillModeForwards;
    smallLineGroup.removedOnCompletion = NO;
    smallLineGroup.animations = @[smallLineAnimation,smallLineEnd];
    [smallLine addAnimation:smallLineGroup forKey:nil];
    
}
- (void)addBlodLine
{
  
}
- (void)transformCircle
{
    CGRect frame = _layer.frame;
    _layer.anchorPoint = CGPointMake(0.5, 1);
    _layer.frame = frame;
//    _layer.transform = CATransform3DMakeScale(1.1, 0.8, 1);
    
    CABasicAnimation * scaleY = [CABasicAnimation animation];
    scaleY.keyPath = @"transform.scale.y";
    scaleY.fromValue = @(1.0);
    scaleY.toValue = @(0.8);
    
    CABasicAnimation * scaleX = [CABasicAnimation animation];
    scaleX.fromValue = @(1.0);
    scaleX.toValue = @(1.1);
    scaleX.keyPath = @"transform.scale.x";
    
    CAAnimationGroup * xyGroup = [CAAnimationGroup animation];
    xyGroup.animations = @[scaleX,scaleY];
    xyGroup.duration = 5;
    [_layer addAnimation:xyGroup forKey:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
