//
//  IUAssistantLayer.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 19..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IUObj.h"
#define kIULineLocationLeft         1
#define kIULineLocationCenter       2
#define kIULineLocationRight        4
#define kIULineLocationTop          8
#define kIULineLocationMiddle       16
#define kIULineLocationBottom       32
#define kIULineLocationAll          63

@interface IUAssistantLayer : CAShapeLayer{
    IUObj *iu;
    NSBezierPath *path;
}

-(id)initWithIU:(IUObj *)obj;

@end
