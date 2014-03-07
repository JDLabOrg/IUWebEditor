//
//  MGInitDjangoVC.h
//  Mango
//
//  Created by JD on 13. 5. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGNewProjectVC.h"

@interface MGNewDjangoProjectVC : MGNewProjectVC
@property   NSString    *appDirPath;
@property   NSString    *resDirPath;
@property   NSString    *templateDirPath;
@end
