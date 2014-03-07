//
//  IUHttpLog.h
//  Mango
//
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import <Foundation/Foundation.h>

@interface IUHttpLog : NSObject

+(void)sendNewIUObjLog:(NSString*)IUType;
+(void)sendRunLog;
+(void)sendNewProjectLog:(NSString*)projectType cloudType:(NSString*)cloudType git:(NSString*)gitType;
+(void)sendMail:(NSString*)emailAddr message:(NSString*)message;
+(void)sendNewUserLog;
@end
