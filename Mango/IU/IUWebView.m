//
//  IUWebView.m
//  Mango
//
//  Created by JD on 7/6/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUWebView.h"

@implementation IUWebView
/*
-(id)initWithIUFrame:(IUFrame *)_iuFrame{
    self = [super initWithIUFrame:_iuFrame wantsLayer:NO];
    if (self) {
        [self addObserver:self forKeyPath:@"source" options:0 context:nil];
        [self addObserver:self forKeyPath:@"image" options:0 context:nil];
    }
    return self;
}

-(void)sourceDidChange{
    NSString *modifiedSource = [NSString stringWithFormat:@"<body style='margin:0px; padding:0px'>\n %@ \n</body>", self.source];
    self.webSource = modifiedSource;
}

-(void)imageDidChange{
    self.contentView.layer.contents = self.image;
}

- (NSView *)hitTest:(NSPoint)aPoint{
    return self;
}
 */
@end
