//
//  IUBGView.m
//  Mango
//
//  Created by JD on 3/29/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUBGView.h"
#import "IUObj.h"

@implementation IUBGView

-(NSImage*)bgImg{
    return bgImgView.image;
}

-(id)initWithIU:(IUObj*)_obj{
    self = [super init];
    if (self) {
        bgImgView =[[JDImageView alloc] init];
        [self addSubviewFullFrame:bgImgView];
        [bgImgView setImageScaling:NSImageScaleNone];
        obj=_obj;
        
        
        [obj.bg addObserver:self forKeyPath:@"color" options:0 context:nil];
        /*
        [obj addObserver:self forKeyPath:@"bgX" options:0 context:@"bgFrame"];
        [obj addObserver:self forKeyPath:@"bgY" options:0 context:@"bgFrame"];
        [obj addObserver:self forKeyPath:@"bgImgRepeat" options:0 context:@"bgRepeat"];
        [obj addObserver:self forKeyPath:@"bgColor" options:0 context:@"bgColor"];
        [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
         */
        self.autoresizesSubviews = NO;
    }
    return self;
}

-(NSImage*)imageFromImageFileName:(NSString*)imageFileName{
    if ([imageFileName isHTMLURL]){
        return [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:imageFileName]];
    }
    else{
        NSString *filePath = [obj.iuManager.pWC.project.resDir stringByPathConcat:imageFileName];
        return [[NSImage alloc] initWithContentsOfFile:filePath];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setNeedsDisplay:YES];
//    NSString *contextStr = (__bridge NSString *)(context);
    /*
    if ([contextStr isEqualToString:@"bgImg"]) {
        bgImg = [self imageFromImageFileName:obj.bgImgFileName];
        bgImgView.image = bgImg;
        bgImgView.imageAlignment = NSImageAlignTopLeft;
        [bgImgView setNeedsDisplay:YES];
    }
    else if ([contextStr isEqualToString:@"bgFrame"]){
        [bgImgView setX:obj.bgX];
        [bgImgView setY:obj.bgY];
    }
    else if ([contextStr isEqualToString:@"bgColor"]){
    }
    [obj.view setNeedsDisplay:YES];
    [self setNeedsDisplay:YES];
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
     */
}

-(void)bgRepeatImgDraw{
    /*
    if (obj.bgImgRepeat) {
        [bgImgView setX:0];
        [bgImgView setY:0];

        NSInteger requiredNumHRepeatedV = NSWidth(self.frame) / bgImg.size.width + 1;
        NSInteger requiredNumVRepeatedV = NSHeight(self.frame) / bgImg.size.height + 1;

        if (requiredNumHRepeatedV > numHRepeatedV || requiredNumVRepeatedV > numVRepeatedV) {
            NSArray *bgVs = [NSArray arrayWithArray: bgImgView.subviews];
            for (NSView *view in bgVs) {
                [view removeFromSuperview];
            }

            numHRepeatedV = requiredNumVRepeatedV;
            numVRepeatedV = requiredNumVRepeatedV;
            
            for (int i=0; i<numHRepeatedV ; i++) {
                for (int j=0; j<numVRepeatedV; j++) {
                    NSRect frame = NSRectFromCGRect(CGRectMake(bgImg.size.width * i, bgImg.size.height * j, bgImg.size.width, bgImg.size.height));
                    [JDLogUtil log:@"bgFrame" frame:frame];
                    JDImageView *smallV = [[JDImageView alloc] initWithFrame:frame];
                    smallV.image = bgImg;
                    [bgImgView addSubviewWithTopLeftFixed:smallV];
                }
            }
        }
    }
    else{
        numHRepeatedV = 0;
        numVRepeatedV = 0;
        [bgImgView setX:obj.bgX];
        [bgImgView setY:obj.bgY];

        NSArray *bgVs = [NSArray arrayWithArray: bgImgView.subviews];
        for (NSView *view in bgVs) {
            [view removeFromSuperview];
        }
        [bgImgView setNeedsDisplay:YES];
    }
     */
}

-(void)frameDidChange:(NSDictionary*)change{
    [self bgRepeatImgDraw];
}

-(void)bgImgRepeatOfObject:(id)object didChange:(NSDictionary*)change{
    [self bgRepeatImgDraw];
}

-(void)drawRect:(NSRect)dirtyRect{
    [obj.bg.color set];
//    [[NSColor redColor] set];
    NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
}

@end
