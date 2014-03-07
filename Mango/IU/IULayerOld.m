//
//  IULayer.m
//  Mango
//
//  Created by JD on 13. 5. 29..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IULayerOld.h"
#import "JDUIUtil.h"
#import "JDTransformer.h"

@implementation IULayerOld
@synthesize contentsLayer;

-(id)initWithIUView:(IUView3*)_iuView{
    self = [super init];
    if (self) {
        iuView = _iuView;
        
        // i don't know why, but iuview's frame is changed, redraw should be recalled,
        // otherwise, iulayer will be gone
        

        // add bg Layer
        bgImageLayer = [CALayer layer];
        bgImageLayer.contentsGravity = kCAGravityBottomLeft;
        [self addSublayer:bgImageLayer];
        bgImageLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
        bgImageRepeatLayers = [NSMutableArray array];

        //set Content Layer
        contentsLayer = [CATextLayer layer];
        [self addSublayer:contentsLayer];
        contentsLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
        contentsLayer.contentsGravity = kCAGravityResize;
        
        //set Cover Layer
        coverLayer = [CALayer layer];
        [self addSublayer:coverLayer];
        coverLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
        
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"showBorder" options:NSKeyValueObservingOptionInitial context:nil];
        
        self.masksToBounds = YES;
        
        [iuView addObserver:self forKeyPaths:@[@"frame", @"bgColor",@"bgImage",@"bgRepeat", @"image",@"contentsScale"] options:0 context:@"redraw"];
    }
    return self;
}

-(void)redrawContextOfObject:(id)obj didChange:(NSDictionary*)change{
//    NSLog(@"redrawContextOfObject",nil );
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:0.05];
    for (CALayer *layer in bgImageRepeatLayers) {
        [layer removeFromSuperlayer];
    }
    [bgImageRepeatLayers removeAllObjects];
    bgImageLayer.backgroundColor = [iuView.bgColor CGColor];

    if (iuView.bgRepeat == NO) {
        if (iuView.bgImage) {
            bgImageLayer.contents = iuView.bgImage;
        }
        else{
            bgImageLayer.contents = nil;
        }
    }
    else{
        bgImageLayer.contents = nil;
        bgImageLayer.backgroundColor = [[NSColor colorWithPatternImage:iuView.bgImage] CGColor]; // - (CGColor) CGColor; is only available in OS X 10.8 and later
    }
    
    if (iuView.image) {
        contentsLayer.contents = iuView.image;
    }
    else{
        contentsLayer.contents = nil;
    }
    [contentsLayer setNeedsDisplay];
}


- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:event]; // Default Animation for 'event'
    if ([event isEqualToString:@"position"] || [event isEqualToString:@"bounds"]) {
        return nil;
    }
    else{
        ani.duration = .3;
    }
    return ani;
}


-(id)initWithIU:(IUObj*)_iu{
    /*
    self = [super init];
    if (self) {
        bgImageLayer = [CALayer layer];
        bgImageLayer.contentsGravity = kCAGravityBottomLeft;
        [self addSublayer:bgImageLayer];

        bgImageRepeatLayers = [NSMutableArray array];
        
        coverLayer = [CALayer layer];
        [self addSublayer:coverLayer];
        [coverLayer bind:@"frame" toObject:self withKeyPath:@"bounds" options:nil];
        
        contentsLayer = [CATextLayer layer];
        [self addSublayer:contentsLayer];
        contentsLayer.zPosition = 10;
        contentsLayer.contentsGravity = kCAGravityResize;
        [contentsLayer bind:@"frame" toObject:self withKeyPath:@"bounds" options:nil];

        iu = _iu;
        self.shouldRasterize = YES;
        JDNSColorToCGColorTransformer *t = [[JDNSColorToCGColorTransformer alloc] init];
        [self bind:@"backgroundColor" toObject:_iu withKeyPath:@"bg.color" options:@{NSValueTransformerBindingOption : t}];
        //[self bind:@"zPosition" toObject:_iu withKeyPath:@"frame.layout.z" options:nil];
        
        [_iu addObserver:self forKeyPath:@"needsDisplay"   options:0     context:@"redraw"];
        [_iu addObserver:self forKeyPath:@"frame.layout.rect"   options:0     context:@"redraw"];
        [_iu addObserver:self forKeyPaths:@[@"bg.img", @"bg.x", @"bg.y", @"bg.imgRepeat"]   options:0     context:@"redraw"];

        [self addObserver:self forKeyPath:@"contentImage"   options:0     context:@"redraw"];
        

        self.masksToBounds = YES;
        self.delegate = self;
    }
    return self;
     */
    return nil;
}

-(void)showBorderDidChange{
    /*
     Code deleted dut to duplecated function (view.layer will do same thing)
    BOOL border = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBorder"];
    if (border) {
        self.borderWidth = 1;
        self.borderColor = [iuView.borderColor CGColor];
    }
    else{
        self.borderWidth = 0;
    }
     */
}

-(void)dealloc{
//    [self removeObserver:self forKeyPath:@"showBorder"];
}



@end