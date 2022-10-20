# WaterMarkRemoverDemo
基于opencv的图像去水印iOSDemo<br>
```objc
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
   
    
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
    cv::dilate(clipthreshImg, clipthreshImg, kernel);
    
    cv::Mat destImg;
    cv::inpaint(clipMask, clipthreshImg, destImg, 10, cv::INPAINT_NS);
    

   

    
    
    
    destImg.copyTo(clipMask);
    UIImage *clip_Image = MatToUIImage(rgbImg);
    self.imageView2.image = clip_Image;
 
    
}
```
    
