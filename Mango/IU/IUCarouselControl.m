//
//  IUCarouselControl.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 29..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUCarouselControl.h"

@implementation IUCarouselControl

-(id)instantiateWithType:(IUCarouselControlType)type{
    [super instantiate];
    self.iuFrame.verticalCenter = YES;
    self.iuFrame.defaultScreenFrame.pixelWidth = 50;
    self.iuFrame.defaultScreenFrame.pixelHeight = 50;
    self.bg.color = nil;
    self.type = type;
    
    switch (self.type) {
        case IUCarouselControlPrev:
            self.iuFrame.currentScreenFrame.pixelX=0;
            self.bg.img = @"leftarrow.png";
            break;
            
        case IUCarouselControlNext:
            self.bg.img = @"rightarrow.png";
            break;
        default:
            DLog(@"Error : No Type(type is not set)");
            break;
    }
    
    
    return self;
}
- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}


#pragma mark -
#pragma mark Class String Setting

-(NSString*)HTMLClassString{
    NSMutableString *str = [[NSMutableString alloc] initWithString:[super HTMLClassString]];
    
    switch (self.type) {
        case IUCarouselControlPrev:
            [str appendString:@"IUPrev "];
            break;
        case IUCarouselControlNext:
            [str appendString:@"IUNext "];
            break;
        default:
            break;
    }
    
    [str trim];
    return str;
}

-(NSString*)outputHTMLClassString{
    NSMutableString *str = [[NSMutableString alloc] initWithString:[super outputHTMLClassString]];
    
    switch (self.type) {
        case IUCarouselControlPrev:
            [str appendString:@"IUPrev "];
            break;
        case IUCarouselControlNext:
            [str appendString:@"IUNext "];
            break;
        default:
            break;
    }
    
    [str trim];
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
