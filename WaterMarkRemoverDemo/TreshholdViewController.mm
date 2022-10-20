//
//  TreshholdViewController.m
//  OImageKarry
//
//  Created by juliao on 2021/3/25.
//  Copyright © 2022 juliano. All rights reserved.
//
/* opencv2下载链接
 Download the opencv2.framework from the link and import it to your project:
 https://sourceforge.net/projects/opencvlibrary/files/4.6.0/opencv-4.6.0-ios-framework.zip/download
 */

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import "SKCropDrawerView.h"
#import "TreshholdViewController.h"
#import "UIImage+Hello.h"
#import "UIImageView+Hello.h"
#import "SKImagePickerHelper.h"

@interface TreshholdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *originImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property(nonatomic,strong) UIImage *originImg;
@property (assign, nonatomic)  CGFloat treshValue;
@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property(nonatomic,strong) SKCropDrawerView *drawerView;
@property (weak, nonatomic) IBOutlet UISwitch *swtContrl;
@property(nonatomic,strong) NSMutableArray *imageTempArr;


@end

@implementation TreshholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageTempArr = @[].mutableCopy;
    self.image = [UIImage imageNamed:@"apper.png"];
    self.originImg = self.image;
    
    
    self.imageView.image = self.image;
    [self.imageView enableTapPreview];
    [self.imageView2 enableTapPreview];
    [self.originImageView enableTapPreview];
    self.treshValue = 150;
    self.slider.value = 150;
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithTitle:@"Select Image" style:(UIBarButtonItemStylePlain) target:self action:@selector(selectImage)];
    self.navigationItem.rightBarButtonItem = leftItem;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    _drawerView = [[SKCropDrawerView alloc] init];
    [self.imgBgView addSubview:_drawerView];
    [self resetImageView];
}
- (IBAction)sliderValueDidChange:(id)sender {
    self.treshValue = self.slider.value;
   
}
-(void)setTreshValue:(CGFloat)treshValue
{
    _treshValue = treshValue;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%0.2lf",self.treshValue];
    [self updateTreshImage];
}
-(void)updateTreshImage
{
    if (!self.image) {
        return;
    }
    cv::Mat orignImg;
    UIImageToMat(self.image,orignImg);
    //
    cv::Mat greyImg;
    cv::cvtColor(orignImg, greyImg, cv::COLOR_BGR2GRAY);
    
    
    cv::Mat threshImg;
    cv::threshold(greyImg, threshImg, self.treshValue, 255,  cv::THRESH_BINARY);
    
    UIImage *tresh_Image = MatToUIImage(threshImg);
    self.imageView.image = tresh_Image;
}

- (IBAction)selectImage {
    
    [[SKImagePickerHelper share] showImagePickerWithContainer:self complition:^(UIImage *selectedImage) {
            if (selectedImage) {
                self.image = selectedImage.normalizedImage;
                self.originImg = self.image;
                [self resetImageView];
               [self updateTreshImage];
            }
        }];
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate=self;
//    //    imagePickerController.allowsEditing=YES;
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)resetImageView {
    
   
//    if(_imageAspectRatio > selfAspectRatio) {
//        _paddingLeftRight = 0;
//        _paddingTopBottom = floor((SKHEIGHT(self) - SKWIDTH(self) / _imageAspectRatio) / 2.0);
//        _imageView.frame = CGRectMake(0, _paddingTopBottom, SKWIDTH(self), floor(SKWIDTH(self) / _imageAspectRatio));
//
//    }
//    else {
//        _paddingTopBottom = 0;
//        _paddingLeftRight = floor((SKWIDTH(self) - SKHEIGHT(self) * _imageAspectRatio) / 2.0);
//        _imageView.frame = CGRectMake(_paddingLeftRight, 0, floor(SKHEIGHT(self) * _imageAspectRatio), SKHEIGHT(self));
//    }
    
    
    UIImage *currentImage =  self.image;
    
    
    size_t w = CGImageGetWidth(currentImage.CGImage);
    size_t h = CGImageGetHeight(currentImage.CGImage);
    CGFloat imgPiexH = currentImage.size.height;
    CGFloat imgPiexW = currentImage.size.width;
    
    if (!(imgPiexW > 0.0 && imgPiexH > 0.0)) {
        return;
    }
    CGFloat imgW = imgPiexW;
    CGFloat imgH = imgPiexH;
    if (imgPiexW > imgPiexH)
    {
        imgW = imgH * imgPiexW/imgPiexH;
    }else
    {
        imgH = imgW * imgPiexH/imgPiexW;
    }
    CGFloat coverW = self.imgBgView.frame.size.width;
    CGFloat coverH = self.imgBgView.frame.size.height;

    if (imgW > coverW) {
        imgW = coverW;
        imgH = imgW * imgPiexH / imgPiexW;
    }

    if (imgH > coverH) {
        imgH = coverH - 20;
        imgW = imgH * imgPiexW/imgPiexH;
    }
   
     CGRect imgFrame = CGRectMake((coverW - imgW) * 0.5, (coverH - imgH) * 0.5, imgW, imgH);
    _imageView.frame = imgFrame;
    
    _drawerView.frame =  _imageView.frame;
    [_drawerView resetPointArray];
//    NSLog(@"**********imageFrame:%@,size:%zu,%lf",NSStringFromCGRect(_imageView.frame),w,h);
    
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//     self.image = image.normalizedImage;
////    UIImageOrientation orientation =  image.imageOrientation;
//    [self updateTreshImage];
//
//
//}

-(IBAction)filterImage
{
    
   
    UIImage *img = self.originImg;
    if (!img) {
        return;
    }
    cv::Mat orignImg;
    UIImageToMat(img,orignImg);
    
    cv::Mat rgbImg;
    cv::cvtColor(orignImg, rgbImg, cv::COLOR_BGRA2BGR);
    //
//    cv::Mat greyImg;
//    cv::cvtColor(orignImg, greyImg, cv::COLOR_BGRA2GRAY);
//    CGFloat width = CGImageGetWidth(img.CGImage);
//    cv::Scalar scalr = cv::Scalar(0,0,0,0);
//    cv::Size size = cv::Size(img.size.width,img.size.height);
//    cv::Mat imgMask =
//    cv::Mat(img.size.width, img.size.height, CV_8UC1, &scalr);
//
//
//
//    cv::Mat threshImg;
//    cv::threshold(greyImg, threshImg,67, 255,  cv::THRESH_BINARY);
//    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
//
//
//
//    cv::dilate(threshImg, threshImg, kernel);
//    cv::Mat destImg;
//    cv::inpaint(rgbImg, threshImg, destImg, 10, cv::INPAINT_NS);
//
    
    NSArray *pts =   _drawerView.cropPointArray;
    CGPoint startPt  = [pts.firstObject CGPointValue];
    CGPoint endPt = [pts[2] CGPointValue];
    CGFloat xRate = img.size.width  / _imageView.frame.size.width ;
    CGFloat yRate =  img.size.height  / _imageView.frame.size.height;
    
    
    CGFloat x1 = startPt.x * xRate;
    CGFloat y1 = startPt.y * yRate;
    
    CGFloat x2 = endPt.x * xRate;
    CGFloat y2 = endPt.y * yRate;
    CGFloat clipW = sqrt((x1- x2) * (x1- x2) );
    CGFloat clipH = sqrt((y1- y2) * (y1- y2));
  
    cv::Rect clipRect = cv::Rect(x1, y1, clipW, clipH);
  
    cv::Mat clipMask = rgbImg(clipRect);
    cv::Mat imageROI(rgbImg,clipRect);
    
    cv::Mat greyImg;
    cv::cvtColor(clipMask, greyImg, cv::COLOR_BGRA2GRAY);
    cv::Mat clipthreshImg;
    cv::threshold(greyImg, clipthreshImg,self.treshValue, 255,  cv::THRESH_BINARY);
    if (self.swtContrl.isOn) {
        
        cv::bitwise_not(clipthreshImg, clipthreshImg);
    }
   
//    cv::Mat image(100 , 100 , CV_8UC3);
//    int rows = image.rows;
//    int cols = image.cols;
//
//    for (int i=0; i<rows ; i++)
//    {
//        for (int j=0; j<cols ; j++)
//        {
//            if ( image.at<cv::Vec3b>(i,j)[2] > 190) {
//                image.at<cv::Vec3b>(i,j)[0]= 20;  // B 通道
//                image.at<cv::Vec3b>(i,j)[1]= 20;
//            }else
//            {
//                image.at<cv::Vec3b>(i,j)[0]= 0;  // B 通道
//                image.at<cv::Vec3b>(i,j)[1]= 0;//G
//                image.at<cv::Vec3b>(i,j)[2]= 0;   // R 通道
//            }
//
//        }
//    }
    
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
    cv::dilate(clipthreshImg, clipthreshImg, kernel);
    
    cv::Mat destImg;
    cv::inpaint(clipMask, clipthreshImg, destImg, 10, cv::INPAINT_NS);
    
//    rgbImg(clipRect) = destImg;
//   cv::bitwise_and(<#InputArray src1#>, <#InputArray src2#>, <#OutputArray dst#>)
   

    
    
    
    destImg.copyTo(clipMask);
    UIImage *clip_Image = MatToUIImage(rgbImg);
    self.imageView2.image = clip_Image;
    return;
    
//    UIImage *mask_Image = MatToUIImage(threshImg);
//    self.imageView2.image = mask_Image;
//
//    UIImage *tresh_Image = MatToUIImage(destImg);
//    self.imageView.image = tresh_Image;
//    cv::Mat resizeImg2;
//    cv::resize(destImg, resizeImg2, cv::Size(img.size.width,img.size.height));
//
//
////    cv::Mat destImg2;
////    cv::addWeighted(resizeImg2, 1.0, rgbImg, 1.0, 3, destImg2);
//    UIImage *clip_Image2 = MatToUIImage(resizeImg2);
//    self.imageView2.image = clip_Image2;
//
//
//
//    return;
    // 1.创建一个基于位图的上下文(开启一个基于位图的上下文)
        UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);

        // 2.画背景
        [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];

        // 3.画右下角的水印
        UIImage *waterImage = clip_Image;

        [waterImage drawInRect:CGRectMake(x1, y1, clipW, clipH)];

        // 4.从上下文中取得制作完毕的UIImage对象
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

        // 5.结束上下文
        UIGraphicsEndImageContext();
        self.imageView2.image = newImage;
    
}
-(IBAction)filterImage2
{
    UIImage *img = self.originImg;
    if (!img) {
        return;
    }
    cv::Mat orignImg;
    UIImageToMat(img,orignImg);
    
    cv::Mat rgbImg;
    cv::cvtColor(orignImg, rgbImg, cv::COLOR_BGRA2BGR);
    
    ///阈值处理
    cv::Mat filtImg;
    rgbImg.copyTo(filtImg);
    
//    cv::Mat image(100 , 100 , CV_8UC3);
    int rows = filtImg.rows;
    int cols = filtImg.cols;

    for (int i=0; i<rows ; i++)
    {
        for (int j=0; j<cols ; j++)
        {
            if ( filtImg.at<cv::Vec3b>(i,j)[2] > 190) {
                filtImg.at<cv::Vec3b>(i,j)[0]= 20;  // B 通道
                filtImg.at<cv::Vec3b>(i,j)[1]= 20;
            }else
            {
                filtImg.at<cv::Vec3b>(i,j)[0]= 0;  // B 通道
                filtImg.at<cv::Vec3b>(i,j)[1]= 0;//G
                filtImg.at<cv::Vec3b>(i,j)[2]= 0;   // R 通道
            }

        }
    }
    
    cv::Mat greyImg;
    cv::cvtColor(filtImg, greyImg, cv::COLOR_BGRA2GRAY);
//    cv::Mat clipthreshImg;
//    cv::threshold(greyImg, greyImg,190, 0,  cv::THRESH_BINARY);
    
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
    cv::dilate(greyImg, greyImg, kernel);
    
    
    
    cv::Mat destImg;
    
    cv::inpaint(rgbImg, greyImg, destImg, 10, cv::INPAINT_TELEA);
    
   

    
    UIImage *clip_Image = MatToUIImage(destImg);
    self.imageView2.image = clip_Image;
    
    
}
-(void)setOriginImg:(UIImage *)originImg
{
    _originImg = originImg;
    _originImageView.image = originImg;
}
- (IBAction)apply:(id)sender {
    UIImage *image =  self.imageView2.image ;
    if (image) {
        [_imageTempArr addObject:self.originImg];
        self.image = image;
        self.originImg = self.image;
        [self resetImageView];
       [self updateTreshImage];
        
    }
    
}

- (IBAction)undo:(id)sender {
    if (_imageTempArr.count) {
       UIImage *image =  _imageTempArr.lastObject;
        self.image = image;
        self.originImg = self.image;
        [self resetImageView];
       [self updateTreshImage];
        [_imageTempArr removeObject:image];
    }
}


//-(cv::Mat)GetRedComponet(cv::Mat srcImg)
//{
//    //如果直接对srcImg处理会改变main()函数中的实参
//    cv::Mat dstImg = srcImg.clone();
//    cv::Mat<Vec3b>::iterator it = dstImg.begin<Vec3b>();
//    cv::Mat<Vec3b>::iterator itend = dstImg.end<Vec3b>();
//    for(; it != itend; it++)
//    {
//        if((*it)[2] > 190)//对红色分量做阈值处理
//        {
//            (*it)[0] = 0;
//            (*it)[1] = 0;
//            //(*it)[2] = 255;//红色分量保持不变
//        }
//
//        else
//        {
//            (*it)[0] = 0;
//            (*it)[1] = 0;
//            (*it)[2] = 0;
//        }
//    }
//    return dstImg;
//}
 
//void Inpainting(Mat oriImg, Mat maskImg)
//{
//    Mat grayMaskImg;
//    Mat element = getStructuringElement(MORPH_RECT, Size(7, 7));
//    dilate(maskImg, maskImg, element);//膨胀后结果作为修复掩膜
//    //将彩色图转换为单通道灰度图，最后一个参数为通道数
//    cvtColor(maskImg, grayMaskImg, CV_BGR2GRAY, 1);
//    //修复图像的掩膜必须为8位单通道图像
//    Mat inpaintedImage;
//    inpaint(oriImg, grayMaskImg, inpaintedImage, 3, INPAINT_TELEA);
//    imshow("原图", oriImg);
//    imshow("图像复原结果图", inpaintedImage);
//    waitKey(0);
//}

@end
