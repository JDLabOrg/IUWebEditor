//
//  IUBGView.h
//  Mango
//
//  Created by JD on 3/29/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JDView.h"

@class  IUObj;

@interface IUBGView : JDView{
    IUObj *obj;
    NSImage     *bgImg;
    JDImageView  *bgImgView;
    NSInteger   numVRepeatedV;
    NSInteger   numHRepeatedV;
}

-(id)initWithIU:(IUObj*)_obj;
-(NSImage*)bgImg;
@end