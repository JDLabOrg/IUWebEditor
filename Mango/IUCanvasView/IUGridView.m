//
//  IUGridView.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 12..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUGridView.h"
#import "IUPointLayer.h"
#import "IUPointTextLayer.h"
#import "IUManager.h"

@implementation IUGridView


- (id)init
{
    self = [super init];
    if (self) {
        
        [self registerForDraggedTypes:@[(id)kUTTypeIUType]];
        
        [self setLayer:[[CALayer alloc] init]];
        [self setWantsLayer:YES];
        [self.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
        
        /* assistant line */
        assistIUs = [NSMutableArray array];
        
        /* selected iu represent */
        self.selectedIUs = [NSMutableArray array];
        [self addObserver:self forKeyPath:@"selectedIUs" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:nil];
    
        /*border Layer*/
        borderManageLayer = [CALayer layer];
        borderManageLayer.contentsGravity = kCAGravityTopLeft;
        [borderManageLayer bind:@"frame" toObject:self.layer withKeyPath:@"frame" options:nil];
        
        [self.layer addSublayer:borderManageLayer];
        
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showBorder" options:NSKeyValueObservingOptionInitial context:nil];
        
        /*shadow Layer*/
        shadowManageLayer = [CALayer layer];
        shadowManageLayer.contentsGravity = kCAGravityTopLeft;
        [shadowManageLayer bind:@"frame" toObject:self.layer withKeyPath:@"frame" options:nil];
        [self.layer addSublayer:shadowManageLayer];
        
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showShadow" options:NSKeyValueObservingOptionInitial context:nil];
        
        /* ghost Image */
        ghostLayer = [CALayer layer];
        ghostLayer.name = @"GhostLayer";
        ghostLayer.opacity = 0.3;
        ghostLayer.contentsGravity = kCAGravityTopLeft;
        [ghostLayer setBackgroundColor:[[NSColor clearColor] CGColor]];
        [ghostLayer setContents:self.sampleImage];
        [self ghostLayerFitToImage];

        [self.layer addSublayer:ghostLayer];
       
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showGhost" options:NSKeyValueObservingOptionInitial context:nil];
        
        [self toggleGhostImage];
        
        /* Text Layer*/
        textManageLayer = [CALayer layer];
        textManageLayer.name = @"textManageLayer";
        textManageLayer.contentsGravity = kCAGravityTopLeft;
        [textManageLayer bind:@"frame" toObject:self.layer withKeyPath:@"frame" options:nil];
        [self.layer addSublayer:textManageLayer];
        
        
        /*sublayer disable animation*/
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSNull null], @"sublayers",
                                           [NSNull null], @"contents",
                                           [NSNull null], @"bounds",
                                           nil];
        self.layer.actions = newActions;

        
    }
    return self;
}

-(BOOL)isFlipped{
    return YES;
}

#pragma mark mouse


-(NSView *)hitTest:(NSPoint)aPoint{
    // return - IUViewManager
    // IUviewManager handles mouse Events
    return [self superview];
}
/*
 * Cannot call drag in superview,
 * accpted in gridView and call superview operation!
 */


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return NSDragOperationEvery;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
    [self.window makeFirstResponder:self];
    return [[self superview] performDragOperation:sender];
}


- (void)rightMouseDown:(NSEvent *)theEvent withIUManager:(IUManager *)iuManager{
    NSLog(@"gridview : rightmousedown");
    NSMenu *popUpMenu = [[self.selectedIUs objectAtIndex:0] popUpMenu];
    if(self.selectedIUs.count > 1 &&
       [iuManager isSameParentforSelectedObjects] ){
        [popUpMenu addItem:[NSMenuItem separatorItem]];
        [popUpMenu addItem:[iuManager embedMenuItem]];
    }
    
    [NSMenu popUpContextMenu:popUpMenu withEvent:theEvent forView:self];
}

#pragma mark -
#pragma mark select IU

/* selected IU change Part */
-(void)selectedIUsWillChange{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSMutableArray *tempPLayer = [[NSMutableArray alloc] init];
        
        for(CALayer *pLayer in self.layer.sublayers){
            if([pLayer isKindOfClass:[IUPointLayer class]]
               || [pLayer isKindOfClass:[IUPointTextLayer class]]){
                [tempPLayer addObject:pLayer];
            }
            
        }
        for(CALayer *pLayer in tempPLayer){
            [pLayer removeFromSuperlayer];
        }

    });
}
-(void)selectedIUsDidChange{
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSMutableArray *tempPointLayers = [NSMutableArray array];
        for (IUObj *iu in self.selectedIUs) {
            if (iu.parent == nil) {
                return;
            }
            
            //Bottom-point가 height가 0일때 가장위로 올수있도록 거꾸로 돌려줌
            NSUInteger location;
            for (int i=7;  i>=0; i--) {
                switch (i) {
                    case 0: location = kIULocationTopLeft; break;
                    case 1: location = kIULocationTopCenter; break;
                    case 2: location = kIULocationTopRight; break;
                    case 3: location = kIULocationMidLeft; break;
                    case 4: location = kIULocationMidRight; break;
                    case 5: location = kIULocationBotLeft; break;
                    case 6: location = kIULocationBotCenter; break;
                    case 7: location = kIULocationBotRight; break;
                }
                
                IUPointLayer *pLayer = [[IUPointLayer alloc] initWithView:self];
                pLayer.iu = iu;
                pLayer.location = location;
    
        
                [self.layer addSublayer:pLayer];
                [tempPointLayers addObject:pLayer];
            }
            
            //TextLayer
            IUPointTextLayer *origin = [[IUPointTextLayer alloc] initWithIU:iu option:kIUPointTextOrigin];
            IUPointTextLayer *size = [[IUPointTextLayer alloc] initWithIU:iu option:kIUPointTextSize];
            [self.layer addSublayer:origin];
            [self.layer addSublayer:size];
            
            
        }
        [self willChangeValueForKey:@"pointLayers"];
        _pointLayers = tempPointLayers;
        [self didChangeValueForKey:@"pointLayers"];
    });
}

#pragma mark -
#pragma mark Ghoust Image

-(void)ghostLayerFitToImage{
    if(self.sampleImage != nil){
        NSSize imageSize = [self.sampleImage size];
        [ghostLayer setFrame:NSMakeRect(0, 0, imageSize.width, imageSize.height)];
    }
}


-(void)setSampleImage:(NSImage *)sampleImage{
    _sampleImage = sampleImage;
    [ghostLayer setContents:sampleImage];
    [self ghostLayerFitToImage];
}


/*
 * ghost layer rect
 * (x, y) = (image.width, image.height)
 *
 * 0 __ x
 * y|__|
 *
 * bound(0, 0, x, y)
 * position (x/2, y/2)
 */

-(void)setSampleImageXModifier:(NSInteger)sampleImageXModifier{
    _sampleImageXModifier = sampleImageXModifier;
    
    CGFloat currentX = ghostLayer.frame.size.width;
    if(currentX!=0) currentX = currentX/2;
    
    currentX += _sampleImageXModifier;
    [ghostLayer setPosition:NSMakePoint(currentX, ghostLayer.position.y)];
}

-(void)setSampleImageYModifier:(NSInteger)sampleImageYModifier{
    _sampleImageYModifier = sampleImageYModifier;
    
    CGFloat currentY = ghostLayer.frame.size.height;
    if(currentY!=0) currentY = currentY/2;
    
    currentY += _sampleImageYModifier;
    [ghostLayer setPosition:NSMakePoint(ghostLayer.position.x, currentY)];
}

-(void)toggleGhostImage{
    if ([[NSUserDefaults  standardUserDefaults] boolForKey:@"showGhost"]) {
        [self.layer bringSublayerToFront:ghostLayer];
        [ghostLayer setHidden:NO];
    }
    else{
        [self.layer bringSublayerToFront:ghostLayer];
        [ghostLayer setHidden:YES];
        
    }
}
-(void)showGhostDidChange{
    [self toggleGhostImage];
}



-(void)turnOffGhost{
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"showGhost"];
    
}
#pragma mark -
#pragma mark Assistant Line

-(void)setAssistantLine:(id)sender{
    IUObj *iu = (IUObj *)[sender representedObject];
    NSUInteger tag = [sender tag];
    
    
    if(tag == 6){
        
        iu.lineLocation = kIULineLocationAll;
    
    }
    else if(tag==7){
        iu.lineLocation = 0;
        
    }
    else{
        NSUInteger currentstate = pow(2, tag);
        iu.lineLocation = iu.lineLocation ^ currentstate;
        
    }
    
    
    //alloc if first line
    if([iu.assitLayer superlayer] == nil && iu.lineLocation != 0
       && iu.disableBorderLayer == NO){
        if(iu.assitLayer ==nil) iu.assitLayer = [[IUAssistantLayer alloc] initWithIU:iu];
        [self.layer addSublayer:iu.assitLayer];
        [assistIUs addObject:iu];
        
    }
    //dealloc if there's no line
    else if(iu.assitLayer != nil && iu.lineLocation ==0){
        [iu.assitLayer removeFromSuperlayer];
        [assistIUs removeObject:iu];
    }
}


#pragma mark -
#pragma mark Border

-(void)setBorderLayer:(id)sender{
    IUObj *iu = (IUObj *)sender;
    
    if(iu.disableBorderLayer == YES) return;
    
    iu.borderLayer = [[IUBorderLayer alloc] initWithIU:iu];
    [borderManageLayer addSublayer:iu.borderLayer];

}

-(void)showBorderDidChange{
    if ([[NSUserDefaults  standardUserDefaults] boolForKey:@"showBorder"]) {
        [self.layer bringSublayerToFront:borderManageLayer];
        [borderManageLayer setHidden:NO];
    }
    else{
        [self.layer bringSublayerToFront:borderManageLayer];
        [borderManageLayer setHidden:YES];
        
    }
}

#pragma mark -
#pragma mark Shadow

-(void)setShadowLayer:(id)sender{
    IUObj *iu = (IUObj *)sender;
    if(iu.enableShadowLayer == NO) return;
    
    iu.shadowLayer = [[IUShadowLayer alloc] initWithIU:iu];
    [shadowManageLayer addSublayer:iu.shadowLayer];
    
}

-(void)showShadowDidChange{
    if ([[NSUserDefaults  standardUserDefaults] boolForKey:@"showShadow"]) {
        [self.layer bringSublayerToFront:borderManageLayer];
        [shadowManageLayer setHidden:NO];
    }
    else{
        [self.layer bringSublayerToFront:borderManageLayer];
        [shadowManageLayer setHidden:YES];
    }
    
}

@end
