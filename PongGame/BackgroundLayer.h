//
//  BackgroundLayer.h
//  PongGame
//
//  Created by Thomas on 2016-09-06.
//  Copyright © 2016 Thomas Månsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BackgroundLayer : NSObject

+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient;
+(CAGradientLayer*) orangeGradient;
@end
