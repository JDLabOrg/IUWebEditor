//
//  MGUtil.h
//  Mango
//
//  Created by JD on 13. 2. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

#ifdef MGKEYWORD
#define MGKEYWORD
const NSString *MGKeywordAction = @"kMGKeywordAction";
#endif

#define MGImageFolder [NSImage imageNamed:@"Folder21.png"]
#define kUTTypeIUType       @"kUTTypeIUType"
#define kUTTypeIUProperty   @"kUTTypeIUProperty"





@interface MGUtil : NSObject{
}

+(NSString*)keywordToNSString:(NSInteger)key type:(NSString*)type;
+(NSInteger)NSStringToKeyword:(NSString*)string;
+(NSDictionary*)itemDict:(NSString*)name type:(NSString*)type children:(NSArray*)children;
+(NSDictionary*)itemDict:(NSString*)name type:(NSString*)type;


@end