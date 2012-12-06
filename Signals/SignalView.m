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
@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation SignalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.paths = [NSMutableArray array];
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text]) {
        return;
    }
    _text = text;
    //self.paths = self.paths ?: [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0.0f), ^{
        NSArray *tags = [text linguisticTagsInRange:NSMakeRange(0, text.length)
                                             scheme:NSLinguisticTagSchemeLexicalClass
                                            options:NSLinguisticTaggerOmitOther
                                        orthography:nil
                                        tokenRanges:nil];
        int nounCount = [[tags indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {return [obj isEqualToString:NSLinguisticTagNoun];}] count];
        int verbCount = [[tags indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {return [obj isEqualToString:NSLinguisticTagVerb];}] count];
        double verbRatio = (double)verbCount / [tags count];
        double nounRatio = (double)nounCount / [tags count];
        double omega = 200*nounRatio;
        double zeta = MAX(0.001, verbRatio);
        
        NSLog(@"nouns:%F verbs:%F",nounRatio,verbRatio);
        self.paths = [NSMutableArray array];
        [self.paths addObject:[self pathForOmega:omega+omega*nounRatio zeta:zeta]];
        [self.paths addObject:[self pathForOmega:omega-omega*nounRatio zeta:zeta]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    });
}

- (UIBezierPath*)pathForOmega:(double)omega zeta:(double)zeta
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *inversePath = [UIBezierPath bezierPath];
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    CGFloat padding = round(width * 0.10);
    CGFloat drawableWidth = width - padding * 2.0;
    CGPoint lastPoint = (CGPoint){padding,[self secondOrderResponseForT:0.0f omega:omega zeta:zeta]*height/2.0};
    CGPoint inverseLastPoint = (CGPoint){width-padding,[self secondOrderResponseForT:0.0f omega:omega zeta:zeta]*height/2.0};
    [path moveToPoint:lastPoint];
    [inversePath moveToPoint:inverseLastPoint];
    for (double x = 0; x <= 1; x+=0.01) {
        CGPoint newPoint = (CGPoint){padding+x*drawableWidth,[self secondOrderResponseForT:x omega:omega zeta:zeta]*height/2.0};
        CGPoint midPoint = (CGPoint){(lastPoint.x+newPoint.x)/2.0,(lastPoint.y+newPoint.y)/2.0};
        [path addQuadCurveToPoint:newPoint controlPoint:midPoint];
        [inversePath addQuadCurveToPoint:(CGPoint){width-newPoint.x,newPoint.y} controlPoint:(CGPoint){width-midPoint.x,midPoint.y}];
        lastPoint = newPoint;
    }
    [path appendPath:inversePath];
    return path;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Generate a pleasant color by taking a nice green as a base color and averaging it and a completely random color
    for (UIBezierPath *path in self.paths) {
        UIColor *color = [UIColor colorWithRed:(168/255.0f+arc4random_uniform(255)/255.0f)/2.0
                                         green:(214/255.0f+arc4random_uniform(255)/255.0f)/2.0
                                          blue:(105/255.0f+arc4random_uniform(255)/255.0f)/2.0
                                         alpha:1.0];
        CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
        CGContextAddPath(ctx, [path CGPath]);
        CGContextStrokePath(ctx);
    }
}


- (double)secondOrderResponseForT:(double)t omega:(double)omega zeta:(double)zeta
{
    double beta = sqrt(1 - zeta * zeta);
    double phi = atan(beta / zeta);
    return 1.0 + -1.0 / beta * exp(-zeta * omega * t) * sin(beta * omega * t + phi);
}

@end
