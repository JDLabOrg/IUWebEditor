//
//  IUGridView.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 12..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IUGridView : NSView{
    CALayer     *ghostLayer, *borderManageLayer, *shadowManageLayer;
    CALayer     *textManageLayer;
    NSMutableArray *assistIUs;
}


@property NSArray   *selectedIUs;
@property (readonly)    NSArray *pointLayers;

//ghost layer property!
@property   (nonatomic) NSImage     *sampleImage;
@property   (nonatomic) NSInteger   sampleImageXModifier;
@property   (nonatomic) NSInteger   sampleImageYModifier;


- (void)rightMouseDown:(NSEvent *)theEvent withIUManager:(IUManager *)iuManager;

-(void)setAssistantLine:(id)sender;
-(void)setBorderLayer:(id)sender;
-(void)setShadowLayer:(id)sender;

@end
