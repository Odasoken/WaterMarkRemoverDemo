# WaterMarkRemoverDemo
基于opencv的图像去水印iOSDemo<br>
# 步骤
1、设置treshhold阀值对图片进行二值化处理<br>
2、选择待修复图像的修复区域imageROI（Region of Interest）<br>
3、对图像进行膨胀和侵蚀处理<br>
4、使用cv::INPAINT_NS算法进行图像修复<br>
 <img src="https://github.com/Odasoken/WaterMarkRemoverDemo/blob/main/demo1.png" width="50%" height="50%">
# 核心代码
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
    
    //计算待修复矩形区域（水印在图片中的位置）
    CGFloat x1 = startPt.x * xRate;
    CGFloat y1 = startPt.y * yRate;
    
    CGFloat x2 = endPt.x * xRate;
    CGFloat y2 = endPt.y * yRate;
    CGFloat clipW = sqrt((x1- x2) * (x1- x2) );
    CGFloat clipH = sqrt((y1- y2) * (y1- y2));
  
    cv::Rect clipRect = cv::Rect(x1, y1, clipW, clipH);
  
    cv::Mat clipMask = rgbImg(clipRect);
    //设置待修复矩形区域（水印区域）
    cv::Mat imageROI(rgbImg,clipRect);

    //灰度图
    cv::Mat greyImg;
    cv::cvtColor(clipMask, greyImg, cv::COLOR_BGRA2GRAY);
    cv::Mat clipthreshImg;
    //  二值化处理
    cv::threshold(greyImg, clipthreshImg,self.treshValue, 255,  cv::THRESH_BINARY);


    if (self.swtContrl.isOn) {
        
        cv::bitwise_not(clipthreshImg, clipthreshImg);
    }
   
    //侵蚀处理
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(3,3));
    cv::dilate(clipthreshImg, clipthreshImg, kernel);
    
    cv::Mat destImg;
    //图像修复
    cv::inpaint(clipMask, clipthreshImg, destImg, 10, cv::INPAINT_NS);
    

   

    
    
    ///显示修复后的图片
    destImg.copyTo(clipMask);
    UIImage *clip_Image = MatToUIImage(rgbImg);
    self.imageView2.image = clip_Image;
 
    
}
```
    
