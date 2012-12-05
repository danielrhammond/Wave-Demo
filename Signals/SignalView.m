//
//  SignalView.m
//  Signals
//
//  Created by Daniel Hammond on 12/5/12.
//  Copyright (c) 2012 Daniel Hammond. All rights reserved.
//

#import "SignalView.h"

@interface SignalView ()

@property (nonatomic, strong) NSString *text;

@end

@implementation SignalView

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text]) {
        return;
    }
    _text = text;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    CGPoint lastPoint = (CGPoint){0.0f,round(height/2.0f)};
    [path moveToPoint:lastPoint];
    for (double x = 0; x <= 1.0; x+=0.01) {
        CGPoint newPoint = (CGPoint){x*width,[self secondOrderResponseForProgress:x]*height/2.0};
//        CGPoint midPoint = (CGPoint){(lastPoint.x+newPoint.x)/2.0,(lastPoint.y+newPoint.y)/2.0};
//        [path addQuadCurveToPoint:newPoint controlPoint:midPoint];
        [path addLineToPoint:newPoint];
    }
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] CGColor]);
    CGContextAddPath(ctx, [path CGPath]);
    CGContextStrokePath(ctx);
}


- (double)secondOrderResponseForProgress:(double)p
{
    double omega = 40.0;
    double zeta = arc4random_uniform(40)/100.0f;
    NSLog(@"z=%F",zeta);
    double beta = sqrt(1 - zeta * zeta);
    double phi = atan(beta / zeta);
    return 1.0 + -1.0 / beta * exp(-zeta * omega * p) * sin(beta * omega * p + phi);
}

@end
