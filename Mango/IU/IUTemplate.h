//
//  IUBG.h
//  Mango
//
//  Created by JD on 13. 2. 9..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//


// IUBG make background of webpage
// it has no width & height
// it can have zindex 0 ~ 99

#import "IUFile.h"
#import "IUWidget.h"

@class IUHeaderWrapper;
@class IUBody;

@interface IUTemplate : IUFile{
}

//@property IUHeaderWrapper   *headerWrapper;
@property (readonly) IUBody            *body;


@end
