//
//  SKCropCrornerView.m
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import "SKCropCrornerView.h"
#import "SKCropTool.h"

@implementation SKCropCrornerView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return  self;
}

-(void)drawCornerLine
{
    if(_cornerShapeLayer && _cornerShapeLayer.superlayer) {
        [_cornerShapeLayer removeFromSuperlayer];
    }
    _cornerShapeLayer = [CAShapeLayer layer];
    _cornerShapeLayer.lineWidth = 0.5;
    _cornerShapeLayer.strokeColor = SKBrushColor.CGColor;
    _cornerShapeLayer.fillColor = SKBrushColor.CGColor;
    
    UIBezierPath *cornerPath =  [UIBezierPath bezierPathWithArcCenter:CGPointMake(SKWIDTH(self) * 0.5, SKHEIGHT(self) * 0.5) radius:8 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    _cornerShapeLayer.path = cornerPath.CGPath;
    [self.layer addSublayer: _cornerShapeLayer];
}

@end
