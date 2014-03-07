//
//  IUGhostImageView.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 24..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUGhostImageView.h"
#import "IUController.h"
#import "IUFile.h"

@implementation IUGhostImageView{
    BOOL mouseDragging;
}



-(void)awakeFromNib{
    [self registerForDraggedTypes:@[kIUImageURL]];
    [self addObserver:self forKeyPath:@"pWC.selectedIUManager.rootIU.sampleImage" options:0 context:nil];
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"pWC.selectedIUManager.rootIU.sampleImage"];
}
-(void)pWC_selectedIUManager_rootIU_sampleImageDidChange{
    
    NSString *imageURL = self.pWC.selectedIUManager.rootIU.sampleImage;
    if (imageURL != nil) {
        self.image = [[NSImage alloc] initWithContentsOfFile: [self.pWC.selectedIUManager.rootIU.project.absoluteResDirPath stringByAppendingPathComponent:imageURL]];
        return;
    }
    self.image = nil;
}

-(void)setPWC:(MGProjectWC *)pWC{
    _pWC = pWC;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender{
    NSPasteboard *pBoard = sender.draggingPasteboard;
    NSString *imageURL = [pBoard stringForType:kIUImageURL];
    
    self.pWC.selectedIUManager.rootIU.sampleImage = imageURL;
    return YES;
}

-(void)mouseUp:(NSEvent *)theEvent{
    if ([NSCursor currentCursor] == [NSCursor disappearingItemCursor]) {
        self.pWC.selectedIUManager.rootIU.sampleImage = nil;
    }
    [[NSCursor arrowCursor] set];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    if (self.image == nil) {
        return;
    }
    
    NSRect viewFrameInWindowCoords = [self convertRect: [self bounds] toView: nil];
    if (NSPointInRect(theEvent.locationInWindow, viewFrameInWindowCoords) == NO){
        [[NSCursor disappearingItemCursor] set];
    }
    else{
        [[NSCursor arrowCursor] set];
    }
}


@end
