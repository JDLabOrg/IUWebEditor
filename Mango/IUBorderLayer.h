//
//  IUBorderLayer.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 28..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IUObj.h"


@interface IUBorderLayer : CAShapeLayer{
    IUObj *iu;
    NSBezierPath *path;

}

-(id)initWithIU:(IUObj *)obj;


@end
