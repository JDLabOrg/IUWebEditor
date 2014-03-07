//
//  IUCarouselControlBar.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUObj.h"
#import "IUCarouselControlBarItem.h"

@interface IUCarouselControlBar : IUView{
    IUCarouselControlBarItem *item;
}
-(void)setBarItems;

@end
