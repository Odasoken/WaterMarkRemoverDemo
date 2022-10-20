//
//  SKImagePickerHelper.h
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface SKImagePickerHelper : NSObject

+(instancetype)share;
-(void)showImagePickerWithContainer:(UIViewController *)containerVC type:(NSInteger)type complition:(void(^)(UIImage * selectedImage))completion;
-(void)showImagePickerWithContainer:(UIViewController *)containerVC complition:(void(^)(UIImage * selectedImage))completion;
@end


