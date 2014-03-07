//
//  IUCSS.h
//  Mango
//
//  Created by JD on 13. 8. 29..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUProperty.h"

@interface IUCSSBorder : IUProperty
@property   (nonatomic) NSColor     *color;
@property   (nonatomic) int         radius;
@property   (nonatomic) int         size;
@end

@interface IUCSS : IUProperty



@property (nonatomic) BOOL disableBorder, disableShadow;//disable in IUPage


@property   IUObj   *iu;
@property   (nonatomic) BOOL        enable;
/* output */
@property   (nonatomic) NSDictionary    *CSSDict2;

/* background color */
@property   (nonatomic) BOOL        BGGradientEnable;
@property   (nonatomic) NSColor     *BGColor1;
@property   (nonatomic) NSColor     *BGColor2;

/* box shadow color */
@property   (nonatomic) BOOL        boxShadowEnable;
@property   (nonatomic) NSColor     *boxShadowColor;
@property   (nonatomic) int  boxShadowVertical;
@property   (nonatomic) int  boxShadowHorizontal;
@property   (nonatomic) int  boxShadowSpread;
@property   (nonatomic) int  boxShadowBlur;

/* box border */

@property   (nonatomic) BOOL    boxBorderEnable;

@property   (nonatomic) NSString    *borderSize;
@property   (nonatomic) NSColor     *borderColor;
@property   (nonatomic) NSString    *borderRadius;

@property   (nonatomic) int topBorderSize;
@property   (nonatomic) int leftBorderSize;
@property   (nonatomic) int rightBorderSize;
@property   (nonatomic) int bottomBorderSize;

@property   (nonatomic) NSColor *topBorderColor;
@property   (nonatomic) NSColor *leftBorderColor;
@property   (nonatomic) NSColor *rightBorderColor;
@property   (nonatomic) NSColor *bottomBorderColor;

@property   (nonatomic) int topLeftBorderRadius;
@property   (nonatomic) int topRightBorderRadius;
@property   (nonatomic) int bottomLeftBorderRadius;
@property   (nonatomic) int bottomRightBorderRadius;


-(id)initWithIU:(IUObj *)obj;
/* border */
+(NSArray*)propertyListExclude;

@end
