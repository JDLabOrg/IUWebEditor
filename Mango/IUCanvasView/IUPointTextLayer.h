//
//  IUPointTextLayer.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 19..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define kIUPointTextOrigin  1
#define kIUPointTextSize    2

@interface IUPointTextLayer : CATextLayer{
    IUObj *iu;
    NSInteger option;
    NSRect textRect;
}

-(id)initWithIU:(IUObj *)obj option:(NSInteger)select;
@end
