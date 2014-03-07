//
//  IUText.h
//  Mango
//
//  Created by JD on 13. 2. 3..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUObj.h"

@interface IUText : IUObj{
    
}

#define IUTextLineHeightAuto -1

@property BOOL          enableHeading;
@property NSInteger    headingLevel;

@property NSString    *variable;
@property NSString    *sampleText;
@property (nonatomic) NSMutableAttributedString *attributeText;
@property NSString     *htmlText;


//default value for inherit class
@property (nonatomic)   CGFloat   fontSize;
@property NSColor     *fontColor;
@property NSTextAlignment   alignmentIdx;
@property (nonatomic) CGFloat         lineHeight;


- (void)attributeTextContextDidChange;

@end