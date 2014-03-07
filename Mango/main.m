//
//  main.m
//  Mango
//
//  Created by JD on 13. 1. 26..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUHttpLog.h"


int main(int argc, char *argv[])
{
    
      return NSApplicationMain(argc, (const char **)argv);
        
    /*
     httplog for exception
        NSLog(@"occur@ exception");
        //send post to httplog
        NSMutableDictionary *httpdic =[[NSMutableDictionary alloc] init];
        if([e.description length] > 1000){
            [httpdic setValue:[e.description substringWithRange:NSMakeRange(0, 3000)] forKey:@"desc"];
        }else{
            [httpdic setValue:e.description forKey:@"desc"];
        }
        
        if([e.description length] > 3000){
            [httpdic setValue:[e.debugDescription substringWithRange:NSMakeRange(0, 3000)] forKey:@"bug_desc"];
        }else{
            [httpdic setValue:e.debugDescription forKey:@"bug_desc"];
        }
        
        [IUHttpLog sendHttpLog:@"iubug" post:httpdic];
    */
    
    
}