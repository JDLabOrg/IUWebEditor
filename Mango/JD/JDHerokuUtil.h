//
//  JDHerokuUtil.h
//  Mango
//
//  Created by JD on 13. 5. 17..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@class  IUProject;

#define kNotiHerokuLogin @"kNotiHerokuLogin"

@interface JDHerokuUtil : NSObject{
    IUProject   *project;
}


+(BOOL)isLogined;
+(NSString*)loginID;
-(id)initWithProject:(IUProject*)project;
-(void)create:(NSString*)appName;
-(void)login:(NSString*)myid password:(NSString*)mypasswd;
-(void)combineGit;
@end