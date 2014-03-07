//
//  NSToolbarImageV.m
//  WebGenerator
//
//  Created by JD on 1/18/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "JDDragAndDropImageV.h"

@implementation JDDragAndDropImageV{
    BOOL mouseDragging;
    NSString    *insertionKeyPath;
    NSString    *draggedType;
}

-(id)init{
    self = [super init];
    if (self) {
        [self unregisterDraggedTypes];
    }
    return self;
}

-(void)awakeFromNib{
    [self unregisterDraggedTypes];
}

-(void)registerForImageDraggedType:(NSString *)newDraggedType{
    draggedType = newDraggedType;
    [super registerForDraggedTypes:@[draggedType]];
}


-(void)setInsertionKeyPath:(NSString *)keyPath{
    insertionKeyPath = keyPath;
}



- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender{
    NSPasteboard *pBoard = sender.draggingPasteboard;
    NSString *imageURL = [pBoard stringForType:draggedType];
    [self.insertionObj setValue:imageURL forKeyPath:insertionKeyPath];
    return YES;
}

-(void)mouseUp:(NSEvent *)theEvent{
    if ([NSCursor currentCursor] == [NSCursor disappearingItemCursor]) {
        [self.insertionObj setValue:nil forKeyPath:insertionKeyPath];
    }
    [NSCursor pop];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    if (self.image == nil) {
        return;
    }
    
    NSRect viewFrameInWindowCoords = [self convertRect: [self bounds] toView: nil];
    if (NSPointInRect(theEvent.locationInWindow, viewFrameInWindowCoords) == NO){
        [[NSCursor disappearingItemCursor] push];
    }
    else{
        [NSCursor pop];
    }
}


@end
