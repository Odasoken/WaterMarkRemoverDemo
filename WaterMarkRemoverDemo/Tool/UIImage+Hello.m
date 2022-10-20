//
//  UIImage+Hello.m
//  OImageKarry
//
//  Created by lx on 2021/4/27.
//  Copyright © 2021 lx. All rights reserved.
//

#import "UIImage+Hello.h"

@implementation UIImage (Hello)
- (UIImage *)normalizedImage {
    UIImageOrientation orientation = self.imageOrientation;
    if ( orientation == UIImageOrientationUp) return self;

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
@end
