//
//  SFDefaultTab.m
//  tabtest
//
//  Created by Matteo Rattotti on 2/28/10.
//  Copyright 2010 www.shinyfrog.net. All rights reserved.
//

#import "SFDefaultTab.h"

static NSImage  *activeTab;
static NSImage  *inactiveTab;
static NSImage  *closeIcon;

@implementation SFCloseLayer

-(void)setCloseIcon{
    if(!closeIcon){
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"crosswoc" ofType:@"png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        closeIcon= image;
    }
    [self setContents:closeIcon];
    [self setFrame:NSMakeRect(0, 0, closeIcon.size.width, closeIcon.size.height)];
}

@end

@implementation SFLabelLayer
- (BOOL)containsPoint:(CGPoint)p
{
	return FALSE;
}
@end

@implementation SFDefaultTab

- (void) setRepresentedObject: (id) representedObject {
	CAConstraintLayoutManager *layout = [CAConstraintLayoutManager layoutManager];
    [self setLayoutManager:layout];

    _representedObject = representedObject;
    self.frame = CGRectMake(0, 0, 125, 22);
	if(!activeTab) {
        

        
		NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"activeTab" ofType:@"png"];
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        activeTab = image;
		
        imagePath = [[NSBundle mainBundle] pathForResource:@"inactiveTab" ofType:@"png"];
        image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        inactiveTab = image;
		

		
	}
	
	[self setContents: inactiveTab];
    
    
    //close button layer
    SFCloseLayer *closelayer = [SFCloseLayer layer];
    [closelayer setCloseIcon];
    

    //Label layer
    SFLabelLayer *tabLabel = [SFLabelLayer layer];
    [tabLabel setName:@"tabLabel"];
	
	if ([representedObject objectForKey:@"name"] != nil) {
		tabLabel.string = [representedObject objectForKey:@"name"];
	}
	
	[tabLabel setFontSize:11.0f];
	[tabLabel setShadowOpacity:.9f];
	tabLabel.shadowOffset = CGSizeMake(0, -1);
	tabLabel.shadowRadius = 1.0f;
	tabLabel.shadowColor = CGColorCreateGenericRGB(1,1,1, 1);
	tabLabel.foregroundColor = CGColorCreateGenericRGB(0.1,0.1,0.1, 1);
	tabLabel.truncationMode = kCATruncationEnd;
	tabLabel.alignmentMode = kCAAlignmentCenter;
    [tabLabel setFont:@"LucidaGrande"];
    
    
    //set constraint
    //y axis
    CAConstraint * constraint = [CAConstraint constraintWithAttribute:kCAConstraintMidY
                                            relativeTo:@"superlayer"
                                             attribute:kCAConstraintMidY
												offset:-2.0];
    [tabLabel addConstraint:constraint];
    [closelayer addConstraint:constraint];

    //tablabel X - right
	constraint = [CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                            relativeTo:@"superlayer"
                                             attribute:kCAConstraintMaxX
												offset:-35.0];
    [tabLabel addConstraint:constraint];

    //tablabel X - left
	constraint = [CAConstraint constraintWithAttribute:kCAConstraintMinX
                                            relativeTo:@"superlayer"
                                             attribute:kCAConstraintMinX
												offset:20.0];
    [tabLabel addConstraint:constraint];

    //closeBox x- right
    constraint = [CAConstraint constraintWithAttribute:kCAConstraintMaxX
                                            relativeTo:@"superlayer"
                                             attribute:kCAConstraintMaxX
                                                offset:-20.0];
    
    [closelayer addConstraint:constraint];

	
	[self addSublayer:tabLabel];
    [self addSublayer:closelayer];

}

- (void) setSelected: (BOOL) selected {
    [CATransaction begin]; 
    [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];

    if (selected)
        [self setContents:activeTab];
    else
        [self setContents:inactiveTab];
    
    [CATransaction commit];

}
- (id)representedObject{
    return _representedObject;
}

@end
