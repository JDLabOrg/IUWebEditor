//
//  IUCarousel.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUCarousel.h"
#import "IUCarouselItem.h"
#import "IUViewManager.h"


@implementation IUCarousel

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelWidth = 700;
    self.iuFrame.defaultScreenFrame.pixelHeight = 400;
    self.bg.color = nil;
    
    
    //box 
    self.box =[[IUCarouselItemBox alloc] init];
    [self.box instantiate];
    [self addIU:self.box error:nil];
    
    
    //navi control
    self.navibar = [[IUCarouselControlBar alloc] init];
    [self.navibar instantiate];
    self.navibar.iuFrame.currentScreenFrame.pixelY = self.iuFrame.currentScreenFrame.pixelHeight - self.navibar.iuFrame.currentScreenFrame.pixelHeight;
    [self addIU:self.navibar error:nil];

    //prev control
    self.prev = [[[IUCarouselControl alloc] init] instantiateWithType:IUCarouselControlPrev];
    [self addIU:self.prev error:nil];
    
    //next control
    self.next = [[[IUCarouselControl alloc] init] instantiateWithType:IUCarouselControlNext];
    self.next.iuFrame.currentScreenFrame.pixelX = self.iuFrame.currentScreenFrame.pixelWidth - self.next.iuFrame.currentScreenFrame.pixelWidth;
    [self addIU:self.next error:nil];
    

    
    //add sample Item
    IUCarouselItem *item = [[[IUCarouselItem alloc] init] instantiate];
    item.bg.img = @"winter.jpg";
    item.bg.bgSize = IUBGSizeStretch;
    [self.box addIU:item error:nil];
    
    IUCarouselItem *item2 = [[[IUCarouselItem alloc] init] instantiate];
    item2.bg.img = @"london.jpg";
    item2.bg.bgSize = IUBGSizeStretch;
    [self.box addIU:item2 error:nil];
    
    //navibar initialize
    [self.navibar setBarItems];
    
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    
    
    [self addObserver:self forKeyPath:@"box.children" options:0 context:nil];
    [self.iuManager.pWC.iuController addObserver:self forKeyPath:@"selectedObjects" options:0 context:nil];
    
}
-(void)dealloc{
    
    [self removeObserver:self forKeyPath:@"box.children"];
    [self.iuManager.pWC.iuController removeObserver:self forKeyPath:@"selectedObjects"];
    
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    if(self.children){
        for(IUObj *obj in self.children){
            if([obj isKindOfClass:[IUCarouselItemBox class]]){
                self.box = (IUCarouselItemBox *)obj;
            }
            else if([obj isKindOfClass:[IUCarouselControl class]]){
                if(((IUCarouselControl *)obj).type == IUCarouselControlPrev){
                    self.prev = (IUCarouselControl *)obj;
                }
                else if(((IUCarouselControl *)obj).type == IUCarouselControlNext){
                    self.next = (IUCarouselControl *)obj;
                    
                }
            }
            else if([obj isKindOfClass:[IUCarouselControlBar class]]){
                self.navibar = (IUCarouselControlBar *)obj;
            }
            else{
                DLog(@"Error : there is no children other type");
            }
        }
    }
}

#pragma mark -
#pragma mark class inspector

-(void)selectCarousel:(NSInteger)index{
    NSString *js = [NSString stringWithFormat:@"selectIUCarousel('%@', %ld)", self.fullIUName, index];
    [self.iuManager.iuViewManager runOneLineJS:js];
    self.box.currentIndex = index;
}

-(void)selectedObjectsDidChange{
    NSArray *selectedObjects = self.iuManager.pWC.iuController.selectedObjects;
    NSInteger index;
    if( selectedObjects.count ==1){
        IUObj *obj = [selectedObjects objectAtIndex:0];
        if([self.box.children containsObject:obj] &&
           [obj isKindOfClass:[IUCarouselItem class]]){
            index = [obj.parent.children indexOfObject:obj];
            [self selectCarousel:index];
        }
    }
}

-(void)box_childrenDidChange{
    [self.navibar setBarItems];
    if(self.box.currentIndex >= self.box.children.count){
        //bug : delete last item
        //move position to new lastitem, but controlbaritem can't be selected
        [self selectCarousel:self.box.children.count-1];
    }
}



#pragma mark -
#pragma mark shouldXXX

-(BOOL)shouldInsertIU:(IUObj *__autoreleasing *)insertedIU{
    IUObj *iu = *insertedIU;
    if ([iu isKindOfClass:[IUCarouselItemBox class]]
        || [iu isKindOfClass:[IUCarouselControl class]]
        ) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark javascript
-(void)javascriptDidInsert{
    [super javascriptDidInsert];
    [self selectCarousel:0];
}


@end
