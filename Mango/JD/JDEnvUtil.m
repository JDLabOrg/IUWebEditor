//
//  JDEnvUtil.m
//  Mango
//
//  Created by JD on 13. 5. 18..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDEnvUtil.h"

@implementation JDEnvUtil
-(BOOL) isFirstExecution{
    if  ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstExecution"] == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstExecution"];
        return NO;
    }
    return YES;
}
@end
