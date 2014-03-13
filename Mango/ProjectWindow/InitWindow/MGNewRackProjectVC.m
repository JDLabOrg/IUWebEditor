//
//  MGInitRackVC.m
//  Mango
//
//  Created by JD on 13. 5. 9..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGNewRackProjectVC.h"
#import "MGNewProjectVC.h"
#import "JDHerokuUtil.h"
#import "MGHerokuLoginWC.h"

@interface MGNewRackProjectVC ()

@end

@implementation MGNewRackProjectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addObserver:self forKeyPath:@"cloudIdx" options:0 context:nil];
        [self addObserver:self forKeyPath:@"gitIdx" options:0 context:nil];
        [self addObserver:self forKeyPath:@"appName" options:0 context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(herokuCheck) name:kNotiHerokuLogin object:nil];
        self.nextEnabled = NO;
    }
    self.cloudIdx = 0;
    return self;
}

-(void)herokuCheck{
    self.herokuResult = YES;
}

-(void)cloudIdxDidChange{
    self.gitSelectDisable = NO;

    switch (_cloudIdx) {
        case 0:{
            self.cloud = nil;
            self.myID = nil;
            self.gitSelectDisable = NO;
            break;
        }
        case 1: {
            /* if heroku, check heroku toolbelt */
            if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/heroku"] == NO) {
                /* heroku toolbelt not exist */
                NSAlert *alertMsg = [NSAlert alertWithMessageText:@"Heroku Error" defaultButton:@"OK" alternateButton:@"Visit Heroku download page" otherButton:nil informativeTextWithFormat:@"Please install Heroku, or select no cloud"];
                NSInteger intV = [alertMsg runModal];
                if (intV == 0) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://toolbelt.heroku.com/"]];
                }
                self.cloudIdx = 0;
                return;
            }
            else{
                /* heroku toolbelt exist */
                [self.project.herokuUtil updateLoginInfo];
                if (self.project.herokuUtil.logined == NO) {
                    if (hWC == nil) {
                        hWC = [[MGHerokuLoginWC alloc] initWithWindowNibName:@"MGHerokuLoginWC"];
                        hWC.herokuUtil = self.project.herokuUtil;
                    }
                    [self.view.window beginSheet:hWC.window completionHandler:^(NSModalResponse returnCode){
                        switch (returnCode) {
                            case NSModalResponseOK:{
                                    [self setHerokuAsCloud];
                                }
                                break;
                            default:{
                                self.cloudIdx = 0;
                            }
                        }
                    }];
                }
                else {
                    [self setHerokuAsCloud];
                }
            }

        }
    }
}

-(void)setHerokuAsCloud{
    self.cloud = @"heroku";
    self.myID = self.project.herokuUtil.loginID;
    self.gitIdx = 2;
    self.gitSelectDisable = YES;
}

-(void)gitIdxDidChange{
    switch (_gitIdx) {
        case 0: self.git = nil; break;
        case 1: self.git = @"source"; break;
        case 2: self.git = @"output"; break;
    }
}

-(void)appNameDidChange{
    if ([self.appName length]) {
        self.nextEnabled = YES;
    }
    else{
        self.nextEnabled = NO;
    }
}


-(BOOL)pressFinishBtn{
    if ([self.cloud isEqualToString:@"heroku"]) {
        if (self.project.herokuUtil.logined == NO) {
            [JDLogUtil alert:@"Heroku Error"];
            return NO;
        }
        //heroku init
        NSString *resultLog;
        BOOL createResult = [self.project.herokuUtil create:self.appName resultLog:&resultLog];
        if (createResult == NO) {
            [JDLogUtil alert:resultLog title:@"Heroku Error"];
            return NO;
        }
    }
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select directory for project"] path];
    if (appDir == nil) { // cancel
        return NO;
    }
    return [self.project startWithDir:appDir widget:self.initilizeWidget];
}


-(void)dealloc{
    [self removeObserver:self forKeyPath:@"cloudIdx"];
    [self removeObserver:self forKeyPath:@"gitIdx"];
    [self removeObserver:self forKeyPath:@"appName"];
}

@end
