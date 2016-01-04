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
    basic.repeatCount = MAXFLOAT;


    basic.duration = 5;
   
    [_layer addAnimation:basic forKey:nil];
    
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
