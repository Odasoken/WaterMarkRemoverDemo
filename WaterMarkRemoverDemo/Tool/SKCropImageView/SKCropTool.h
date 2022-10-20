//
//  SKCropTool.h
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SKWIDTH(_view) CGRectGetWidth(_view.bounds)
#define SKHEIGHT(_view) CGRectGetHeight(_view.bounds)
#define MAXX(_view) CGRectGetMaxX(_view.frame)
#define MAXY(_view) CGRectGetMaxY(_view.frame)
#define MINX(_view) CGRectGetMinX(_view.frame)
#define MINY(_view) CGRectGetMinY(_view.frame)
#define SKBrushColor [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0.0/255.0 alpha:1.0]

@interface SKCropTool : NSObject
+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect;
// 根据path切割图片
+ (UIImage*)cropImage:(UIImage *)aImage withPath:(UIBezierPath*)path;
@end


