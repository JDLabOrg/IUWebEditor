//
//  IUIconViewBox.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 2. 19..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUIconViewBox.h"

#pragma mark -
#pragma mark NSBox-Extension (double click)

@implementation IUIconViewBox

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

-(void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    if (theEvent.clickCount == 2) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(doubleClick:)]) {
            NSLog(@"Runs through here");
            [self.delegate performSelector:@selector(doubleClick:) withObject:self];
        }
    }
}

@end

#pragma mark -
#pragma mark NScollectionItem

@implementation IUIconCollectionItem

- (void)doubleClick:(id)sender{
    NSLog(@"double click in the collecionItem");
    if([self collectionView] && [[self collectionView] delegate]
       && [[[self collectionView] delegate] respondsToSelector:@selector(doubleClick:)]){
        [[[self collectionView] delegate] performSelector:@selector(doubleClick:) withObject:self];
    }
}

@end