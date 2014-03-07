//
//  JDHerokuUtil.m
//  Mango
//
//  Created by JD on 13. 5. 17..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDHerokuUtil.h"

@implementation JDHerokuUtil


-(id)initWithProject:(IUProject*)_project{
    self = [super init];
    if (self) {
        project = _project;
    }
    return self;
}

+(BOOL)isLogined{
    [JDLogUtil log:@"isLogined" log:@"heroku"];
    NSString *netrc = [@"~/.netrc" stringByExpandingTildeInPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:netrc] == NO) {
        return NO;
    }
    else if ([[NSData dataWithContentsOfFile:netrc] length] == 0){
        return NO;
    }
    return YES;
}

+(NSString*)loginID{
    [JDLogUtil log:@"loginID" log:@"heroku"];
    NSString *resPath = [[NSBundle mainBundle] pathForResource:@"herokuauth.sh" ofType:nil];
    NSString *result = [[JDFileUtil util] launch:resPath atDirectory:@"/" argument:nil];
    if ([JDFileUtil util].lastStatusCode == 0) {
        return [[result trim] lastLine];
    }
    else{
        return nil;
    }
}

-(void)create:(NSString*)appName{
    [JDLogUtil log:@"create" log:@"heroku"];
    [[JDFileUtil util] launch:@"/usr/bin/heroku" atDirectory:@"/" arguments:@[@"create",appName]];
}

-(void)login:(NSString*)myid password:(NSString*)mypasswd{
    [JDLogUtil log:@"login" log:@"heroku"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        NSString *resPath = [[NSBundle mainBundle] pathForResource:@"heroku_login" ofType:nil];
        [[JDFileUtil util] launch:resPath atDirectory:@"/" arguments:@[myid, mypasswd]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiHerokuLogin object:nil];
    });
}

-(void)combineGit{
    [[JDFileUtil util] launch:@"/usr/bin/heroku" atDirectory:project.absoluteGitDir arguments:@[@"git:remote", @"-a", project.appName]];
}


@end
