//
//  IUCarouselControlBar.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUCarouselControlBar.h"
#import "IUCarousel.h"

@implementation IUCarouselControlBar

-(id)instantiate{
    [super instantiate];
    self.iuFrame.horizontalCenter = YES;
    self.iuFrame.defaultScreenFrame.pixelHeight = (IUCarouselControlBarItemSize +5);
    self.iuFrame.defaultScreenFrame.pixelWidth = 0;
    self.bg.color = nil;
    
    item = [[IUCarouselControlBarItem alloc] init];
    [item instantiate];
    [self addIU:item error:nil];
    
    
    
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    
}

-(void)dealloc{
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    if(self.children){
        for(IUObj *obj in self.children){
            if([obj isKindOfClass:[IUCarouselControlBarItem class]]){
                item = (IUCarouselControlBarItem *)obj;
            }
            else{
                DLog(@"Error : there is no children with other types");
            }
        }
    }
}

-(void)setBarItems{
    [self setNeedsDisplayStartGrouping];
    NSInteger currentItemCount = ((IUCarousel *)self.parent).box.children.count;
       
    self.iuFrame.currentScreenFrame.pixelWidth = currentItemCount*(IUCarouselControlBarItemSize+5);
    
    [self setNeedsDisplay:IUNeedsDisplayActionAll];
    [self setNeedsDisplayEndGrouping];
}

- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}

#pragma mark -
#pragma mark HTML

-(NSString *)innerHTML2:(id)caller{
    NSMutableString *str = [NSMutableString string];
    NSInteger currentItemCount = ((IUCarousel *)self.parent).box.children.count;

    for(int i=0; i<currentItemCount; i++){
        item.currentIndex = i;
        if([item HTMLSource2:caller]){
            [str appendString:[item HTMLSource2:caller]];
            [str appendString:@"\n"];
        }
    }
    return str;
}

-(NSMutableString*)innerOutputHTML2{
    NSMutableString *str = [NSMutableString string];
    NSInteger currentItemCount = ((IUCarousel *)self.parent).box.children.count;
    
    for(int i=0; i<currentItemCount; i++){
        item.currentIndex = i;
        if([item outputHTMLSource2:self]){
            [str appendString:[item outputHTMLSource2:self]];
            [str appendString:@"\n"];
        }
    }
    return str;
}

-(IUObj*)requestFocusAvariableIU{
    if (self.parent.hasFocus || self.parent.childHasFocus) {
        return self;
    }
    else{
        return [self.parent requestFocusAvariableIU];
    }
}


@end
