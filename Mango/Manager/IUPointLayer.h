//
//  IUViewManagerGridV.h
//  Mango
//
//  Created by JD on 13. 8. 5..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUGridView.h"

#define kIULocationTop     1
#define kIULocationLeft    2
#define kIULocationRight   4
#define kIULocationBot     8

#define kIULocationTopCenter      kIULocationTop   //1+2 = 3
#define kIULocationMidLeft        kIULocationLeft   //1+2 = 3
#define kIULocationMidRight      kIULocationRight   //1+2 = 3
#define kIULocationBotCenter      kIULocationBot   //1+2 = 3

#define kIULocationTopLeft      kIULocationTopCenter + kIULocationMidLeft   //1+2 = 3
#define kIULocationTopRight     kIULocationTopCenter + kIULocationMidRight  //1+4 = 5
#define kIULocationBotLeft      kIULocationBotCenter + kIULocationMidLeft   //8+2 = 10
#define kIULocationBotRight     kIULocationBotCenter + kIULocationMidRight  //8+4 = 12


@interface  IUPointLayer :CALayer{
    IUGridView* gridView;
}
@property   (nonatomic) IUObj       *iu;
@property   (nonatomic)NSUInteger  location;
@property   (nonatomic) NSCursor    *cursor;
@property   (nonatomic) BOOL        dragging;

-(id)initWithView:(IUGridView *)view;
@end
