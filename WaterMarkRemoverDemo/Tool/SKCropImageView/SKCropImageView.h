//
//  SKCropImageView.h
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SKCropImageView : UIView
///待裁剪图片
@property(nonatomic,strong) UIImage *cropImage;
///裁剪后的图片
- (UIImage *)currentCroppedImage;
///重新设置边界
- (void)resetImageView;
@end


