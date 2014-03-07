//
//  IUViewManagerGridV.m
//  Mango
//
//  Created by JD on 13. 8. 5..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUPointLayer.h"


@implementation IUPointLayer{
    BOOL observing;
    NSUInteger location;
}

@synthesize iu;
@synthesize location;

-(id)initWithView:(IUGridView *)view{
    self = [super init];
    if (self) {
        observing = YES;
        gridView = view;
        [self addObserver:self forKeyPaths:@[@"iu.iuFrame.gridFrameFromScreen"] options:0 context:@"draw"];
        [self addObserver:self forKeyPath:@"location" options:0 context:@"draw"];

        self.backgroundColor = [[NSColor lightGrayColor] CGColor];
        self.borderColor = [[NSColor blackColor] CGColor];
        self.borderWidth = 0.3;

        
        /*disable animation*/
        /*sublayer disable animation*/
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSNull null], @"position",
                                           [NSNull null], @"bounds",
                                           nil];
        self.actions = newActions;

    }
    return self;
}

-(void)dealloc{
        [self removeObserver:self forKeyPath:@"iu.iuFrame.gridFrameFromScreen"];
        [self removeObserver:self forKeyPath:@"location"];
        observing = FALSE;
}


-(void)drawContextDidChange{
    if (self.location == 0) {
        return;
    }
    

    self.frame=NSMakeRect(0, 0, 6, 6);
    NSRect iuFrame = [self.iu.iuFrame gridFrameFromScreen];

    switch (self.location) {
        case kIULocationTopLeft:
           
            [self setCenter: NSPointMake(iuFrame.origin.x, iuFrame.origin.y)];
            break;
        case kIULocationTopCenter:
            [self setCenter: NSPointMake(iuFrame.origin.x+iuFrame.size.width/2, iuFrame.origin.y)];
            break;
        case kIULocationTopRight:
           
            [self setCenter: NSPointMake(iuFrame.origin.x+iuFrame.size.width, iuFrame.origin.y)];
            break;
        case kIULocationMidLeft:
            
            [self setCenter: NSPointMake(iuFrame.origin.x, iuFrame.origin.y+iuFrame.size.height/2)];
            break;
        case kIULocationMidRight:
            
            [self setCenter: NSPointMake(iuFrame.origin.x+iuFrame.size.width, iuFrame.origin.y+iuFrame.size.height/2)];
            break;
        case kIULocationBotLeft:
            
            [self setCenter: NSPointMake(iuFrame.origin.x, iuFrame.origin.y+iuFrame.size.height)];
            break;
        case kIULocationBotCenter:
            
            [self setCenter: NSPointMake(iuFrame.origin.x+iuFrame.size.width/2, iuFrame.origin.y+iuFrame.size.height)];
            break;
        case kIULocationBotRight:
                        
            [self setCenter: NSPointMake(iuFrame.origin.x+iuFrame.size.width, iuFrame.origin.y+iuFrame.size.height)];
            break;
            
            
    }
    [[NSApp mainWindow] invalidateCursorRectsForView:[NSApp mainWindow].contentView];
}

@end
