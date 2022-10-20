//
//  SKImagePickerHelper.m
//  OImageKarry
//
//  Created by juliao on 2021/3/18 .
//  Copyright © 2022 juliano. All rights reserved.
//

#import "SKImagePickerHelper.h"
static SKImagePickerHelper *_shareInstance = nil;
@interface SKImagePickerHelper()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,copy) void(^selectedCompletion)(UIImage * selectedImage);

@end
@implementation SKImagePickerHelper
+(instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}



-(void)showImagePickerWithContainer:(UIViewController *)containerVC type:(NSInteger)type complition:(void(^)(UIImage * selectedImage))completion
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate=self;
    //    imagePickerController.allowsEditing=YES;
    imagePickerController.sourceType = type == 0 ? UIImagePickerControllerSourceTypePhotoLibrary :UIImagePickerControllerSourceTypeCamera;
        [containerVC presentViewController:imagePickerController animated:YES completion:nil];
    self.selectedCompletion = completion;
}


-(void)showImagePickerWithContainer:(UIViewController *)containerVC complition:(void(^)(UIImage * selectedImage))completion
{
    
    [self showImagePickerWithContainer:containerVC type:0 complition:completion];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    [picker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
     
   if(self.selectedCompletion)
   {
       self.selectedCompletion(image);
       self.selectedCompletion = nil;
   }
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if(self.selectedCompletion)
    {
        self.selectedCompletion(nil);
    }
}
@end
