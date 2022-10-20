//
//  SKCropImageView.m
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import "SKCropImageView.h"
#import "SKCropDrawerView.h"
#import "SKCropTool.h"

#define SKWIDTH(_view) CGRectGetWidth(_view.bounds)
#define SKHEIGHT(_view) CGRectGetHeight(_view.bounds)
#define MAXX(_view) CGRectGetMaxX(_view.frame)
#define MAXY(_view) CGRectGetMaxY(_view.frame)
#define MINX(_view) CGRectGetMinX(_view.frame)
#define MINY(_view) CGRectGetMinY(_view.frame)






@interface SKCropImageView()
@property(nonatomic,strong) NSMutableArray *pointsArray;
@property(nonatomic,strong) NSArray  *cornerViewArray;
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) SKCropDrawerView *drawerView;

/* 放大镜 */
@property (nonatomic, strong) UIImageView *magnifierImageView;

/* 全屏的截图 */
@property (nonatomic, strong) UIImage *cutScreenImage;
@property (assign, nonatomic)  CGFloat magnifierWidth;
@property (assign, nonatomic)  CGFloat magnification;
@property (assign, nonatomic) CGFloat paddingLeftRight;     //图片左右距离边缘距离
@property (assign, nonatomic) CGFloat paddingTopBottom;     //图片上下距离边缘距离
@property (assign, nonatomic) CGFloat imageAspectRatio;     //图片宽高比





@end

@implementation SKCropImageView

- (UIImageView *)magnifierImageView {
    if (!_magnifierImageView) {
        _magnifierImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.magnifierWidth, self.magnifierWidth)];
        _magnifierImageView.layer.masksToBounds = YES;
        _magnifierImageView.layer.borderColor = [[UIColor grayColor] CGColor];
        _magnifierImageView.layer.borderWidth = 1;
        _magnifierImageView.layer.cornerRadius = self.magnifierWidth/2;
    }
    return _magnifierImageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _magnifierWidth = 50.5;
    _magnification = 1.5;
    
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _drawerView = [[SKCropDrawerView alloc] init];
    [self addSubview:_drawerView];
    
//    NSMutableArray *arr = @[].mutableCopy;
//    SKCropCrornerView *cornerLt =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    SKCropCrornerView *cornerRt =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    SKCropCrornerView *cornerLb =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    SKCropCrornerView *cornerRb =  [[SKCropCrornerView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [arr addObject:cornerLt];
//    [arr addObject:cornerRt];
//    [arr addObject:cornerLb];
//    [arr addObject:cornerRb];
//    _cornerViewArray = arr;
    return self;
}
-(void)setCropImage:(UIImage *)cropImage
{
    _cropImage = cropImage;
    _imageView.image = cropImage;
    _imageAspectRatio = cropImage.size.width / cropImage.size.height;
    [self resetImageView];
}

/**
 根据图片宽高比，设置_imageView的frame
 */
- (void)resetImageView {
    
    CGFloat selfAspectRatio = SKWIDTH(self) / SKHEIGHT(self);
    if(_imageAspectRatio > selfAspectRatio) {
        _paddingLeftRight = 0;
        _paddingTopBottom = floor((SKHEIGHT(self) - SKWIDTH(self) / _imageAspectRatio) / 2.0);
        _imageView.frame = CGRectMake(0, _paddingTopBottom, SKWIDTH(self), floor(SKWIDTH(self) / _imageAspectRatio));
       
    }
    else {
        _paddingTopBottom = 0;
        _paddingLeftRight = floor((SKWIDTH(self) - SKHEIGHT(self) * _imageAspectRatio) / 2.0);
        _imageView.frame = CGRectMake(_paddingLeftRight, 0, floor(SKHEIGHT(self) * _imageAspectRatio), SKHEIGHT(self));
    }
    _drawerView.frame =  _imageView.frame;
    [_drawerView resetPointArray];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGFloat oldw = SKWIDTH(_imageView);
//    _imageView.frame = CGRectMake(20, 20, SKWIDTH(self) - 40, SKHEIGHT(self) - 40);
//    if (oldw
//                != SKWIDTH(_imageView)) {
//        _drawerView.frame =  _imageView.frame;
//        [_drawerView resetPointArray];
//    }
//    if (oldw
//        != SKWIDTH(_imageView)) {
//        [self resetPointArray];
//    }
    
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    if (!_pointsArray) {
//        [self resetPointArray];
//    }
    
}



-(CGPoint)skcovertedPoint:(CGPoint)pt{
    return [self convertPoint:pt fromView:_imageView];
}



- (void)drawRect:(CGRect)rect {
//    [self drawLines];
//    [self drawPointArray];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = touches.anyObject;
//
//    CGPoint point = [touch locationInView:self];
//    self.magnifierImageView.center = CGPointMake(point.x, point.y - 50);
//    self.cutScreenImage = [self snapshot:self];
//    UIImage *image =  [self ct_imageFromImage:self.cutScreenImage inRect:CGRectMake(point.x-self.magnifierWidth/_magnification/2, point.y-self.magnifierWidth/_magnification/2, self.magnifierWidth/_magnification, self.magnifierWidth/_magnification)];
//    self.magnifierImageView.image = image;
//    [self addSubview:self.magnifierImageView];
//
//   NSInteger index =  [self getNearPointIndex:[self skcovertedPoint:point]];
//    self.runPointIndex = index;
//    self.lastPoint = point;
//    NSLog(@"***************最近的点：%ld",index);
//}
//
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    UITouch *touch = touches.anyObject;
//
//    CGPoint point = [touch locationInView:self];
//    self.magnifierImageView.center = CGPointMake(point.x, point.y - 90);
//    UIImage *image =  [self ct_imageFromImage:self.cutScreenImage inRect:CGRectMake(point.x-self.magnifierWidth/_magnification/2, point.y-self.magnifierWidth/_magnification/2, self.magnifierWidth/_magnification, self.magnifierWidth/_magnification)];
//    self.magnifierImageView.image = image;
//
//    CGFloat xPadding = point.x - self.lastPoint.x;
//    CGFloat yPadding = point.y - self.lastPoint.y;
//    self.lastPoint = point;
//    NSLog(@"***************移动距离：x%lf,y%lf",xPadding,yPadding);
//    [self movePoint:xPadding y:yPadding];
//
//
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.magnifierImageView removeFromSuperview];
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:self];
//    CGFloat xPadding = point.x - self.lastPoint.x;
//    CGFloat yPadding = point.y - self.lastPoint.y;
//    self.lastPoint = point;
//    NSLog(@"***************移动距离：x%lf,y%lf",xPadding,yPadding);
//    [self movePoint:xPadding y:yPadding];
//}
//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.magnifierImageView removeFromSuperview];
//}

//截图
- (UIImage *)snapshot:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    
    return newImage;
}

- (UIImage *)currentCroppedImage {
    //根据图片和原始尺寸换算，得到最终截取图片
    if (!(_cropImage.size.width > 0.0)) {
        return nil;
    }
    CGFloat xScale = self.cropImage.size.width/self.imageView.bounds.size.width;
    CGFloat yScale = self.cropImage.size.height/self.imageView.bounds.size.height;

        /*
         将imageview的路径转换为图片的路径
         这样可以使图片在切割时不用缩放，防止图片失真
         */
        UIBezierPath *path = [UIBezierPath bezierPath];
    NSArray *_pointsArray = [self.drawerView cropPointArray];
    if (_pointsArray.count) {
        CGPoint lt = [_pointsArray[0] CGPointValue];
        CGPoint rt = [_pointsArray[1] CGPointValue];
        CGPoint rb = [_pointsArray[2] CGPointValue];
        CGPoint lb = [_pointsArray[3] CGPointValue];
        [path moveToPoint:CGPointMake(lt.x * xScale, lt.y * yScale)];
        [path addLineToPoint:CGPointMake(lb.x * xScale, lb.y * yScale)];
        [path addLineToPoint:CGPointMake(rb.x * xScale, rb.y * yScale)];
        [path addLineToPoint:CGPointMake(rt.x * xScale, rt.y * yScale)];
        [path addLineToPoint:CGPointMake(lt.x * xScale, lt.y * yScale)];
        [path closePath];
        UIImage *clipImage = [SKCropTool cropImage:self.cropImage withPath:path];
        return clipImage;
    }

    
    return nil;
    

    
}

@end
