//
//  IUCarouselControl.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUView.h"
#import "IUDefinition.h"



@interface IUCarouselControl : IUObj

@property IUCarouselControlType type;

-(id)instantiateWithType:(IUCarouselControlType)type;

@end
