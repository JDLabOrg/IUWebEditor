//
//  IUShadowLayer.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 2. 14..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IUObj.h"

@interface IUShadowLayer : CALayer{
    IUObj *iu;
}

-(id)initWithIU:(IUObj *)obj;

@end
