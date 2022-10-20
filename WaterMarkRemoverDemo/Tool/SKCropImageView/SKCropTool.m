//
//  SKCropTool.m
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import "SKCropTool.h"

@implementation SKCropTool
+(UIImage *)fixOrientation:(UIImage *)oimage{
    
    if (oimage.imageOrientation == UIImageOrientationUp)
        return oimage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (oimage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, oimage.size.width, oimage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, oimage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, oimage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (oimage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, oimage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, oimage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, oimage.size.width, oimage.size.height,
                                             CGImageGetBitsPerComponent(oimage.CGImage), 0,
                                             CGImageGetColorSpace(oimage.CGImage),
                                             CGImageGetBitmapInfo(oimage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (oimage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,oimage.size.height,oimage.size.width), oimage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,oimage.size.width,oimage.size.height), oimage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

+ (UIImage *)cropImage:(UIImage *)image rect:(CGRect)rect
{
    
    UIImage *fixedImage = [self fixOrientation:image];
    CGImageRef imageRef = CGImageCreateWithImageInRect([fixedImage CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

// 根据path切割图片
+ (UIImage*)cropImage:(UIImage *)aImage withPath:(UIBezierPath*)path {

    @autoreleasepool {

        UIImage * image = [aImage copy];

        // 解决图片不是朝上的问题 - 重置为UIImageOrientationUp
        if (image.imageOrientation != UIImageOrientationUp) {

            UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
            [image drawInRect:(CGRect){0, 0, image.size}];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }

        //开始绘制图片
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);

        CGContextRef contextRef = UIGraphicsGetCurrentContext();

        UIBezierPath * clipPath = path;
        CGContextAddPath(contextRef, clipPath.CGPath);
        CGContextClosePath(contextRef);
        CGContextClip(contextRef);

        //坐标系转换
        CGContextTranslateCTM(contextRef, 0, image.size.height);
        CGContextScaleCTM(contextRef, image.scale, -image.scale);
        CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
        CGContextDrawImage(contextRef, drawRect, [image CGImage]);
        UIImage *destImg = UIGraphicsGetImageFromCurrentImageContext();

        //结束绘画
        UIGraphicsEndImageContext();

        //转成png格式 会保留透明
        NSData * data = UIImageJPEGRepresentation(destImg, .5);
        UIImage * dImage = [UIImage imageWithData:data];

        return dImage;
    }
}
@end
