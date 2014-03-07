//
//  IUFrameForScreenType.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 2..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUProperty.h"
#import "IUDefinition.h"


#define IUScreenDefaultSize 1024
#define IUScreenTabletSize 800
#define IUScreenMobileSize 320

@class IUObj;

@interface IUScreenFrame : IUProperty


@property (nonatomic) IUObj *iu;
@property (nonatomic) BOOL loaded;
@property (nonatomic) IUScreenType type;

@property (nonatomic) BOOL flowLayout;

//frame
@property (nonatomic) CGFloat percentX, percentY, percentWidth, percentHeight;
@property (nonatomic) CGFloat pixelX, pixelY, pixelWidth, pixelHeight;
@property (nonatomic) BOOL percentFlagX, percentFlagY, percentFlagWidth, percentFlagHeight;

//flowlayout
@property (nonatomic) CGFloat percentMarginLeft, percentMarginRight, percentMarginTop, percentMarginBottom;
@property (nonatomic) CGFloat pixelMarginLeft, pixelMarginRight, pixelMarginTop, pixelMarginBottom;
@property (nonatomic) BOOL percentFlagMarginLeft, percentFlagMarginRight, percentFlagMarginTop, percentFlagMarginBottom;

@property (nonatomic, readonly) NSMutableDictionary *extraData;

+(NSString *)stringForScreenType:(IUScreenType)type;
-(void)copyWithOrigin:(IUScreenFrame *)origin;

-(NSMutableDictionary *)dict;
-(void)loadWithDict:(NSDictionary *)dict;

-(NSRect)absoluteframe;
-(NSRect)mixedframe;

-(void)setPixelRect:(CGRect)rect;

//For CSSDict
-(CGFloat)x;
-(CGFloat)y;
-(CGFloat)width;
-(CGFloat)height;


-(CGFloat)marginLeft;
-(CGFloat)marginRight;
-(CGFloat)marginTop;
-(CGFloat)marginBottom;


-(NSString *)xModifier;
-(NSString *)yModifier;
-(NSString *)widthModifier;
-(NSString *)heightModifier;

-(NSString *)marginLeftModifier;
-(NSString *)marginRightModifier;
-(NSString *)marginTopModifier;
-(NSString *)marginBottomModifier;

@end
