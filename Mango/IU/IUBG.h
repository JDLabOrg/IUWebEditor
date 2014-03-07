//
//  IUBG.h
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUProperty.h"
#import "IUDefinition.h"

@interface IUBG  : IUProperty{
    NSColor     *color;
    NSColor     *oldColor;
    NSString    *imgType; // 'web', 'local'
    BOOL        imgRepeat;
    
    IUObj     *iu;
}



@property NSInteger  x, y;
@property (nonatomic) BOOL      imgRepeat;
@property (nonatomic) NSString  *img;
@property NSString  *imgType;
@property (nonatomic) NSColor   *color;
@property NSString  *sizeName;
@property (nonatomic)   IUBGSize  bgSize;

-(void)setRandomOpaqueColor;
-(id)initWithIU:(IUObj*)iu;
-(NSImage*)image;
+(NSString *)stringToSize:(IUBGSize)size;

@end