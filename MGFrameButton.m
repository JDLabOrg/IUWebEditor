//
//  MGFrameButton.m
//  WebGenerator
//
//  Created by JD on 2/14/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGFrameButton.h"
#import "IUController.h"

@implementation MGFrameButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)setFlagValuePath:(NSString *)flagValuePath{
    _flagValuePath = flagValuePath;
    if (self.controller && self.flagValuePath) {
        [self.controller addObserver:self forKeyPath:self.flagValuePath options:0 context:nil];
        [self setTarget:self];
        [self setAction:@selector(performClick:)];
    }
}

-(void)setController:(IUController *)controller{
    _controller = controller;
    if (self.controller && self.flagValuePath) {
        [self.controller addObserver:self forKeyPath:self.flagValuePath options:0 context:nil];
        [self setTarget:self];
        [self setAction:@selector(performClick:)];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:self.flagValuePath]) {
        id currentValue = [self.controller valueForKeyPath:self.flagValuePath];
        BOOL classFlag = [currentValue isKindOfClass:[NSNumber class]];
        if (classFlag && [currentValue boolValue]) {
            [self setIntegerValue:1];
        }
        else{
            [self setIntegerValue:0];
        }
    }
    else{
        // never come to here
        assert(0);
    }
}


- (void)performClick:(id)sender{
    id currentValue = [self.controller valueForKeyPath:self.flagValuePath];
    if ([currentValue isKindOfClass:[NSNumber class]] && [currentValue boolValue]) {
        [self.controller setValue:@(NO) forKeyPath:self.flagValuePath];
    }
    else{
        [self.controller setValue:@(YES) forKeyPath:self.flagValuePath];
    }
    [self.controller updateIU:self.type];
}


@end
