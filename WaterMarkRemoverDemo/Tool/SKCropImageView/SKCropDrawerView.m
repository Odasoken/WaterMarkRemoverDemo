//
//  TKCropDrawerView.m
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import "SKCropDrawerView.h"
#import "SKCropCrornerView.h"
#import "SKCropTool.h"
static const CGFloat marginSpace = 5;
typedef NS_ENUM(NSInteger, TKCropAreaCornerPosition) {
    TKCropCornerTopLeft,
    TKCropCornerTopRight,
  
    TKCropCornerBottomRight,
    TKCropCornerBottomLeft,
};

@interface SKCropDrawerView()
@property(nonatomic,strong) NSMutableArray *pointsArray;
@property (assign, nonatomic)  CGPoint lastPoint;
@property (assign, nonatomic)  NSInteger runPointIndex;
@property(nonatomic,strong) SKCropCrornerView *cornerTopLeft;
@property(nonatomic,strong) SKCropCrornerView *cornerTopRight;
@property(nonatomic,strong) SKCropCrornerView *cornerBottomLeft;
@property(nonatomic,strong) SKCropCrornerView *cornerBottomRight;
@property(nonatomic,strong) UIBezierPath *clipPath;

@end
@implementation SKCropDrawerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    //    NSMutableArray *arr = @[].mutableCopy;
        _cornerTopLeft =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _cornerTopRight =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _cornerBottomLeft =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _cornerBottomRight =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [self addSubview:_cornerTopLeft];
    [self addSubview:_cornerTopRight];
    [self addSubview:_cornerBottomLeft];
    [self addSubview:_cornerBottomRight];
    return self;
}

-(void)resetPointArray
{
    NSMutableArray *arr = @[].mutableCopy;
    CGPoint ptTopLeft = CGPointMake(0, 0);
    CGPoint ptTopRight = CGPointMake(SKWIDTH(self), 0);
    CGPoint ptBottomLeft = CGPointMake(0, SKHEIGHT(self));
    CGPoint ptBottomRight = CGPointMake(SKWIDTH(self),  SKHEIGHT(self));
    
    [arr addObject:@(ptTopLeft)];
    [arr addObject:@(ptTopRight)];
    [arr addObject:@(ptBottomRight)];
    [arr addObject:@(ptBottomLeft)];
    _pointsArray = arr;
    [self setNeedsDisplay];
    
}
-(NSArray *)cropPointArray
{
    return [_pointsArray copy];
}

-(void)drawLines
{
    if (_pointsArray.count) {
        CGPoint lt = [_pointsArray[0] CGPointValue];
        CGPoint rt = [_pointsArray[1] CGPointValue];
        CGPoint rb = [_pointsArray[2] CGPointValue];
        CGPoint lb = [_pointsArray[3] CGPointValue];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:lt];
        [path addLineToPoint:lb];
         [path addLineToPoint:rb];
          [path addLineToPoint:rt];
           [path addLineToPoint:lt];
        [SKBrushColor setStroke];
        [path stroke];
        
    }
}

-(CGRect)cropRect
{
    if (_pointsArray.count) {
        CGPoint lt = [_pointsArray[0] CGPointValue];
        CGPoint rt = [_pointsArray[1] CGPointValue];
        CGPoint rb = [_pointsArray[2] CGPointValue];
        CGPoint lb = [_pointsArray[3] CGPointValue];
        
    }
    
    return CGRectZero;
}

-(void)drawPointArray{
    if (_pointsArray.count) {
        CGPoint lt = [_pointsArray[0] CGPointValue];
        CGPoint rt = [_pointsArray[1] CGPointValue];
        CGPoint rb = [_pointsArray[2] CGPointValue];
        CGPoint lb = [_pointsArray[3] CGPointValue];
        _cornerTopLeft.center = lt;
        _cornerTopRight.center = rt;
        _cornerBottomLeft.center = lb;
        _cornerBottomRight.center = rb;
        
        [_cornerTopLeft drawCornerLine];
        [_cornerTopRight drawCornerLine];
        [_cornerBottomLeft drawCornerLine];
        [_cornerBottomRight drawCornerLine];
    }
//    for (NSNumber *number in _pointsArray) {
//       CGPoint pt =  number.CGPointValue;
//        pt = pt;
//    UIBezierPath *path =  [UIBezierPath bezierPathWithArcCenter:pt radius:10 startAngle:0 endAngle:M_PI * 2 clockwise:true];
//        [[UIColor greenColor] setFill];
//        [path fill];
//    }
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    
    CGPoint point = [touch locationInView:self];
//    self.magnifierImageView.center = CGPointMake(point.x, point.y - 50);
//    self.cutScreenImage = [self snapshot:self];
//    UIImage *image =  [self ct_imageFromImage:self.cutScreenImage inRect:CGRectMake(point.x-self.magnifierWidth/_magnification/2, point.y-self.magnifierWidth/_magnification/2, self.magnifierWidth/_magnification, self.magnifierWidth/_magnification)];
//    self.magnifierImageView.image = image;
//    [self addSubview:self.magnifierImageView];
    
   NSInteger index =  [self getNearPointIndex:point];
    self.runPointIndex = index;
    self.lastPoint = point;
//    NSLog(@"***************最近的点：%ld",index);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    
    CGPoint point = [touch locationInView:self];
//    self.magnifierImageView.center = CGPointMake(point.x, point.y - 90);
//    UIImage *image =  [self ct_imageFromImage:self.cutScreenImage inRect:CGRectMake(point.x-self.magnifierWidth/_magnification/2, point.y-self.magnifierWidth/_magnification/2, self.magnifierWidth/_magnification, self.magnifierWidth/_magnification)];
//    self.magnifierImageView.image = image;
    
    CGFloat xPadding = point.x - self.lastPoint.x;
    CGFloat yPadding = point.y - self.lastPoint.y;
    self.lastPoint = point;
//    NSLog(@"***************移动距离：x%lf,y%lf",xPadding,yPadding);
    [self movePoint:xPadding y:yPadding];
    
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.magnifierImageView removeFromSuperview];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    CGFloat xPadding = point.x - self.lastPoint.x;
    CGFloat yPadding = point.y - self.lastPoint.y;
    self.lastPoint = point;
//    NSLog(@"***************移动距离：x%lf,y%lf",xPadding,yPadding);
    [self movePoint:xPadding y:yPadding];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self.magnifierImageView removeFromSuperview];
}

-(void)movePoint:(CGFloat)xOffset  y:(CGFloat)yOffset
{
    NSNumber *pObj =  _pointsArray[_runPointIndex];
    CGPoint currentPt = pObj.CGPointValue;
    
    
    CGPoint pt_TopLeft = [_pointsArray[TKCropCornerTopLeft] CGPointValue];
    CGPoint pt_TopRight= [_pointsArray[TKCropCornerTopRight] CGPointValue];
    CGPoint pt_BottomLeft = [_pointsArray[TKCropCornerBottomLeft] CGPointValue];
    CGPoint pt_BottomRight = [_pointsArray[TKCropCornerBottomRight] CGPointValue];
    CGFloat marginSpace = 25;
    switch (_runPointIndex) {
        case TKCropCornerTopLeft:
        {
            [self movePoint:currentPt type:TKCropCornerTopLeft xOffset:xOffset y:yOffset];
            [self movePoint:pt_BottomLeft type:TKCropCornerBottomLeft xOffset:xOffset y:0];
            [self movePoint:pt_TopRight type:TKCropCornerTopRight xOffset:0 y:yOffset];
        }
        break;
        case TKCropCornerTopRight:
        {
            [self movePoint:currentPt type:TKCropCornerTopRight xOffset:xOffset y:yOffset];
            [self movePoint:pt_TopLeft type:TKCropCornerTopLeft xOffset:0 y:yOffset];
            [self movePoint:pt_BottomRight type:TKCropCornerBottomRight xOffset:xOffset y:0];
        }
        break;
        case TKCropCornerBottomRight:
        {
            [self movePoint:currentPt type:TKCropCornerBottomRight xOffset:xOffset y:yOffset];
            [self movePoint:pt_BottomLeft type:TKCropCornerBottomLeft xOffset:0 y:yOffset];
            [self movePoint:pt_TopRight type:TKCropCornerTopRight xOffset:xOffset y:0];
        
        }
        break;
        case TKCropCornerBottomLeft:
        {
            [self movePoint:currentPt type:TKCropCornerBottomLeft xOffset:xOffset y:yOffset];
            [self movePoint:pt_TopLeft type:TKCropCornerTopLeft xOffset:xOffset y:0];
            [self movePoint:pt_BottomRight type:TKCropCornerBottomRight xOffset:0 y:yOffset];
        
        }
        break;
        default:
        break;
    }
    
    [self setNeedsDisplay];
    
}

/// 移动当前点
/// @param xOffset 水平偏移量
/// @param yOffset 垂直偏移量
-(void)movePoint:(CGPoint)currentPt type:(TKCropAreaCornerPosition)type  xOffset:(CGFloat)xOffset  y:(CGFloat)yOffset
{
    
    CGPoint pt2 = currentPt;
    CGFloat x =  pt2.x + xOffset;
    CGFloat y =  pt2.y + yOffset;
    
    
    CGPoint pt_TopLeft = [_pointsArray[TKCropCornerTopLeft] CGPointValue];
    CGPoint pt_TopRight= [_pointsArray[TKCropCornerTopRight] CGPointValue];
    CGPoint pt_BottomLeft = [_pointsArray[TKCropCornerBottomLeft] CGPointValue];
    CGPoint pt_BottomRight = [_pointsArray[TKCropCornerBottomRight] CGPointValue];
   
    switch (type) {
        case TKCropCornerTopLeft:
        {
            x = MAX(x, 0.0);
            y = MAX(y, 0.0);
            //判断是否可以下移
            if (y >= (pt_BottomLeft.y - marginSpace)) {
                y = pt_BottomLeft.y - marginSpace;
            }
            if (y >= (pt_BottomRight.y - marginSpace)) {
                y = pt_BottomRight.y - marginSpace;
            }
            //判断是否可以右移
            if (x >= (pt_TopRight.x - marginSpace)) {
                x = pt_TopRight.x  - marginSpace;
            }
            if (x >= (pt_BottomRight.x - marginSpace)) {
                x = pt_BottomRight.x  - marginSpace;
            }
            CGPoint destPt = CGPointMake(x, y);
            _pointsArray[TKCropCornerTopLeft] = @(destPt);
        }
            break;
            
        case TKCropCornerTopRight:
        {
            //判断是否在边界内
            x = MIN(x, SKWIDTH(self));
            y = MAX(y, 0.0);
            //判断是否可以下移
            if (y >= (pt_BottomRight.y - marginSpace)) {
                y = pt_BottomRight.y - marginSpace;
            }
            
            if (y >= (pt_BottomLeft.y - marginSpace)) {
                y = pt_BottomLeft.y - marginSpace;
            }
            
            ///判断是否可以左移
            if (x <= (pt_TopLeft.x + marginSpace)) {
                x = pt_TopLeft.x  + marginSpace;
            }
            if (x <= (pt_BottomLeft.x + marginSpace)) {
                x = pt_BottomLeft.x  + marginSpace;
            }
            CGPoint destPt = CGPointMake(x, y);
            _pointsArray[TKCropCornerTopRight] = @(destPt);
        }
            break;
        case TKCropCornerBottomLeft:
        {
            x = MAX(x, 0.0);
            y = MIN(y, SKHEIGHT(self));
            //判断是否可以上移
            if (y <= (pt_TopLeft.y + marginSpace)) {
                y = pt_TopLeft.y + marginSpace;
            }
            if (y <= (pt_TopRight.y + marginSpace)) {
                y = pt_TopRight.y + marginSpace;
            }
            //判断是否可以右移
            if (x >= (pt_BottomRight.x - marginSpace)) {
                x = pt_BottomRight.x  - marginSpace;
            }
            if (x >= (pt_TopRight.x - marginSpace)) {
                x = pt_TopRight.x  - marginSpace;
            }
            CGPoint destPt = CGPointMake(x, y);
            _pointsArray[TKCropCornerBottomLeft] = @(destPt);
        }
            break;
            
        case TKCropCornerBottomRight:
        {
            x = MIN(x, SKWIDTH(self));
            y = MIN(y, SKHEIGHT(self));
            //判断是否可以上移
            if (y <= (pt_TopRight.y + marginSpace)) {
                y = pt_TopRight.y + marginSpace;
            }
            if (y <= (pt_TopLeft.y + marginSpace)) {
                y = pt_TopLeft.y + marginSpace;
            }
            //判断是否可以左移
            if (x <= (pt_BottomLeft.x + marginSpace)) {
                x = pt_BottomLeft.x  + marginSpace;
            }
            if (x <= (pt_TopLeft.x + marginSpace)) {
                x = pt_TopLeft.x  + marginSpace;
            }
            CGPoint destPt = CGPointMake(x, y);
            _pointsArray[TKCropCornerBottomRight] = @(destPt);
        }
            break;
            
        default:
            break;
    }
    
    
}

-(NSInteger)getNearPointIndex:(CGPoint)pt
{
    CGFloat distance = 0;
    NSInteger index = -1;
    for (NSInteger i = 0; i < _pointsArray.count; i++)  {
        NSNumber *obj = _pointsArray[i];
        CGFloat d = [self calculateDist:obj.CGPointValue point2:pt];
        
        if (i == 0 || d < distance) {
            distance = d;
            index = i;
        }
    }
    
    return  index;
}

///计算两点之间的
-(CGFloat)calculateDist:(CGPoint)point1 point2:(CGPoint)point2
{
    CGFloat x = point1.x  - point2.x;
    CGFloat y = point1.y  - point2.y;
    return x * x + y * y;
}

- (void)drawRect:(CGRect)rect {
    [self drawLines];
    [self drawPointArray];
}
@end
