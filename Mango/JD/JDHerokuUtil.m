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
        [self updateLoginInfo];;
    }
    return self;
}

-(void)updateLoginInfo{
    NSString *netrc = [@"~/.netrc" stringByExpandingTildeInPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:netrc]) {
        NSString *str = [NSString stringWithContentsOfFile:netrc encoding:NSUTF8StringEncoding error:nil];
        if ([str length] > 30) {
            self.logined = YES;
            NSArray *emailPatterns = [str RGXMatchAllStringsWithPatten:RGXEmailPattern];
            self.loginID = [emailPatterns objectAtIndex:0];
            return;
        }
    }
    self.logined = NO;
    self.loginID = nil;
}


+(NSString*)loginID{
    [JDLogUtil log:@"loginID" log:@"heroku"];
    NSString *resPath = [[NSBundle mainBundle] pathForResource:@"herokuauth.sh" ofType:nil];
    NSString *errLog, *log;
    NSInteger resultCode = [JDFileUtil launch:resPath atDirectory:@"/" arguments:nil stdOut:&log stdErr:&errLog];
    if (resultCode == 0) {
        return [[log trim] lastLine];
    }
    return nil;
}

-(BOOL)create:(NSString*)appName resultLog:(NSString**)resultLog{
    [JDLogUtil log:@"create" log:@"heroku"];
    NSString *stdOut;
    NSString *stdErr;
    NSInteger returnCode = [JDFileUtil launch:@"/usr/bin/heroku" atDirectory:@"/" arguments:@[@"create",appName] stdOut:&stdOut stdErr:&stdErr];
    if (returnCode) {
        if (resultLog) {
            *resultLog = stdErr;
        }
        return NO;
    }
    if (resultLog) {
        *resultLog = stdOut;
    }
    return YES;
}

-(void)login:(NSString*)myid password:(NSString*)mypasswd{
    [JDLogUtil log:@"login" log:@"heroku"];
    NSString *resPath = [[NSBundle mainBundle] pathForResource:@"heroku_login" ofType:nil];
    self.logging = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        NSInteger resultCode = [JDFileUtil launch:resPath atDirectory:@"/" arguments:@[myid, mypasswd] stdOut:nil stdErr:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.logging = NO;
            [self updateLoginInfo];
            [self.loginDelegate herokuUtil:self loginProcessFinishedWithResultCode:resultCode];
        });
    });
}

-(BOOL)combineGit{
    [JDFileUtil launch:@"/usr/bin/heroku" atDirectory:project.absoluteGitDir arguments:@[@"git:remote", @"-a", project.appName] stdOut:nil stdErr:nil];
    return YES;
}


@end
