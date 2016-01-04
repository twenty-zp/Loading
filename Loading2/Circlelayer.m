//
//  Circlelayer.m
//  动画
//
//  Created by iLogiEMAC on 15/12/30.
//  Copyright © 2015年 zp. All rights reserved.
//

#import "Circlelayer.h"

@interface Circlelayer()
{
    CGFloat temp;
   
}
@end
@implementation Circlelayer

@dynamic progress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"])
    {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    
    //圆心
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat kRadius = CGRectGetWidth(self.bounds) * 0.5 - 5 * 2 ;

    //M:
    CGFloat origin_M = -M_PI_2;
    CGFloat end_M = - 2* M_PI;
    CGFloat current_M = origin_M + (end_M - origin_M ) * self.progress;
    
    //N:
    CGFloat origin_N = - M_PI;
    CGFloat end_N = - 4*M_PI;
    CGFloat current_N = origin_N +  (end_N - origin_N) * self.progress;
    
    UIBezierPath * path  = [UIBezierPath bezierPath] ;

    [path addArcWithCenter:center radius:kRadius startAngle:current_M endAngle:current_N clockwise:NO];
    
   
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor brownColor].CGColor);
    CGContextSetLineWidth(ctx, 5);
    CGContextStrokePath(ctx);
}
@end
