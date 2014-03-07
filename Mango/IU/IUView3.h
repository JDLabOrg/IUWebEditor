//
//  IUView3.h
//  Mango
//
//  Created by JD on 7/6/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class IULayerOld;
@class IUFrame;

/* important ! IUView should 'not' know about IU */
/* this will destroy IU - View seperation */

/* only IUFrame is bound with IUView3 directly */

@interface IUView3 : NSView{

}

//@property id <NSDraggingDestination> draggingDelegate;


@property NSImage   *image;
@property NSString  *string;
@property (weak) IUFrame   *iuFrame;

@property NSColor   *bgColor;
@property NSImage   *bgImage;
@property BOOL      bgRepeat;

@property NSString  *webSource;

@property NSURL     *webBaseURL;


@property NSColor   *borderColor;

@property (readonly) NSView *contentView;
@property NSView *childView;


@property NSUInteger additionalWidth;
@property NSUInteger additionalHeight;

-(id)initWithIUFrame:(IUFrame*)_iuFrame;

// called by subclasses
-(id)initWithIUFrame:(IUFrame*)_iuFrame wantsLayer:(BOOL)wantsLayer;

// should be coded by subclasses
-(id)InitWithIUFrameContentView;

-(id)copyView;
-(void)stopWebViewLoading;

-(void)addIUSubview:(IUView3*)aView;
-(void)insertIUSubview:(IUView3 *)aView;
-(void)insertIUSubview:(IUView3 *)aView positioned:(NSWindowOrderingMode)place relativeTo:(IUView3*)otherView;
-(void)removeFromIUSuperview;
-(void)removeIUSubview:(IUView3*) subView;
@end