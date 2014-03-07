//
//  IUPage.h
//  Mango
//
//  Created by JD on 13. 2. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUFile.h"
@class MGFileItem;
@class IUTemplate;
@interface IUPage : IUFile{
    MGFileItem  *templateFileItem;
    NSString    *templateName;
    NSString    *title;
    BOOL        autoResizePageHeight;
}

@property MGFileItem *templateFileItem;
@property BOOL      autoResizePageHeight;
@property NSString  *templateName;
@property NSString  *title, *author, *pageDesc, *keywords;
@property     IUTemplate  *templateIU;
@end
