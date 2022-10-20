//
//  SKCropCrornerView.h
//  OImageKarry
//
//  Created by juliao on 2021/3/18.
//  Copyright © 2022 juliano. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SKCropCrornerView : UIView
@property(nonatomic,strong) CAShapeLayer *cornerShapeLayer;

-(void)drawCornerLine;
@end


