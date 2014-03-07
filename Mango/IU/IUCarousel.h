//
//  IUCarousel.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUView.h"
#import "IUCarouselControl.h"
#import "IUCarouselControlBar.h"
#import "IUCarouselItem.h"
#import "IUCarouselItemBox.h"
#import "IUDefinition.h"

@interface IUCarousel : IUView{
}

@property IUCarouselItemBox *box;
@property IUCarouselControl *prev, *next;
@property IUCarouselControlBar *navibar;

@end
