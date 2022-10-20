//
//  UIImageView+Hello.m
//  HelloKitty
//
//  Created by lx on 2021/4/19.
//  Copyright © 2021 lx. All rights reserved.
//

#import "UIImageView+Hello.h"
#import "XLPhotoBrowser.h"




@implementation UIImageView (Hello)
//-(instancetype)init
//{
//    self = [super init];
//    [self enableTapPreview];
//    return self;
//}
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self enableTapPreview];
//}
-(void)enableTapPreview
{
    self.userInteractionEnabled = true;
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

-(void)tapAction
{
    UIImage *image = self.image;
    if (image) {
        XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:@[image] currentImageIndex:0];
        browser.browserStyle = XLPhotoBrowserStyleSimple;
//        [browser show];
//        browser.datasource = self;
    }
}

//- (UIImageView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
//{
//    return self;
//}
@end
