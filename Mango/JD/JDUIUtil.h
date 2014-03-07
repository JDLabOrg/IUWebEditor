//
//  JDUtil.h
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

NSPoint NSPointWithInt(NSPoint p);
NSPoint NSPointMake(CGFloat x, CGFloat y);
NSRect  NSRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
NSRect NSRectModifyX(NSRect rect, float x);
NSRect NSRectModifyY(NSRect rect, float y);
NSRect NSRectModifyWidth(NSRect rect, float width);
NSRect NSRectModifyHeight(NSRect rect, float height);
NSRect NSRectModifyOrigin(NSRect rect, NSPoint origin);
NSRect NSRectExpandLeft(NSRect rect, float x);
NSRect NSRectExpandTop(NSRect rect, float y);
NSRect NSRectExpandBottom(NSRect rect, float y);
NSRect NSRectExpandRight(NSRect rect, float y);
NSRect NSRectIntersect(NSRect a, NSRect b);
NSRect NSRectModifyXY(NSRect rect, float x, float y);
BOOL   isNSRectContainsRect(NSRect rect, NSRect subrect);

@interface JDUIUtil : NSObject
+(NSRect)frame:(NSRect)frame modify:(CGFloat)modifier;
+(NSPoint)point:(NSPoint)point modify:(CGFloat)modifier;

+(void)view:(NSView*)view addSubviewFullFrame:(NSView*)subview;
+(void)view:(NSView*)view addSubviewFullFrame:(NSView*)subview atPosition:(NSWindowOrderingMode)place;
+(void)view:(NSView*)view setCenterWithView:(NSView*)originView;
+(void)view:(NSView*)view fillColor:(NSColor*)color;

//+(CGColorRef)NSColorToCGColor:(NSColor*)color;
+(NSColor *)randomOpaqueColor;
+(NSPoint)pointRound:(NSPoint)point;
+(NSPoint)pointRoundf:(NSPoint)point;
+(NSPoint)pointDiff:(NSPoint)point1 from:(NSPoint)point;
+(NSRect)rectBetweenTwoPointFrom:(NSPoint)point1 to:(NSPoint)point2;
+(NSString *)NSColorToHexString:(NSColor*)color;
+ (NSColor*)hexColorToNSColor:(NSString*)inColorString;

@end

@interface NSView(JDExtension)
-(id)addSubviewFullFrame:(NSView*)subview;
-(id)addSubviewFullFrame:(NSView*)subview atPosition:(NSWindowOrderingMode)place;
- (void)addSubviewFullFrame:(NSView *)aView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView;
-(void)setX:(CGFloat)x;
-(void)setY:(CGFloat)y;
-(void)setWidth:(CGFloat)width;
-(void)setHeight:(CGFloat)height;
-(BOOL)hasSubview:(NSView*)subview;
-(void)removeAllSubview;
@end

@interface NSImageView(JDExtension)
-(id)addSubviewWithTopLeftFixed:(NSView*)subview;
@end


@interface NSBezierPath(JDExtenstion)
-(void)strokeHorizentalLine:(CGFloat)y fromX:(CGFloat)x1 toX:(CGFloat)x2;
-(void)strokeVerticalLine:(CGFloat)x fromY:(CGFloat)y1 toY:(CGFloat)y2;
-(void)drawline:(NSPoint)start end:(NSPoint)end;
-(CGPathRef)quartzPath;
@end

@interface NSColor(JDExtenstion)
-(NSString*) rgbString;
-(NSColor*) complementaryColor;
@end

@interface NSString(JDExtenstion2)
-(NSColor*) color;
@end



@interface NSUserDefaults(JDColorSupport)
- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey;
- (NSColor *)colorForKey:(NSString *)aKey;
@end


@interface NSScrollView(JDExtension)
-(void)scrollOnTop;
-(void)scrollOnBottom;
@end

@interface NSButton(JDExtension)
- (void)setTitle:(NSString*)title withColor:(NSColor*)color;
@end

BOOL isValidRect(NSRect aRect);
BOOL isSameColor(NSColor *color1, NSColor *color2);

