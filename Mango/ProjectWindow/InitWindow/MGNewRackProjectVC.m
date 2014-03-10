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
        case 0: self.cloud = nil; break;
        case 1: {
            /* if heroku, check heroku toolbelt */
            if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/heroku"] == NO) {
                NSAlert *alertMsg = [NSAlert alertWithMessageText:@"Heroku Error" defaultButton:@"OK" alternateButton:@"Visit Heroku download page" otherButton:nil informativeTextWithFormat:@"Please install Heroku, or select no cloud"];
                NSInteger intV = [alertMsg runModal];
                if (intV == 0) {
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://toolbelt.heroku.com/"]];
                }
                self.cloudIdx = 0;
                return;
            }

            self.cloud = @"heroku";
            self.gitSelectDisable = YES;
            self.gitIdx = 2;
            self.myID = [JDHerokuUtil loginID];
            break;
        }
    }
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
        /* if heroku, check heroku toolbelt */
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/heroku"] == NO) {
            NSAlert *alertMsg = [NSAlert alertWithMessageText:@"Heroku error" defaultButton:@"OK" alternateButton:@"Visit Heroku download page" otherButton:nil informativeTextWithFormat:@"Please install Heroku, or select no cloud"];
            NSInteger intV = [alertMsg runModal];
            if (intV == 0) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://toolbelt.heroku.com/"]];
            }
            return NO;
        }
        if ([JDHerokuUtil isLogined] == NO) {
            //login
            [self.project.herokuUtil login:@"jdyang@jdlab.org" password:@"******"];

            while (1) {
                if (self.herokuResult) {
                    break;
                }
            }
            
            if ([JDHerokuUtil isLogined] == NO) {
                [JDLogUtil alert:@"Heroku login failed"];
                return NO;
            }
            else{
                [JDLogUtil alert:@"Heroku login success" title:@"Heroku Login Result"];
            }
        }
        @try {
            [self.project.herokuUtil create:self.appName];
        }
        @catch (NSException *exception) {
            [JDLogUtil alert:[exception reason]];
            return NO;
        }
    }
    
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select directory for project"] path];
    if (appDir == nil) { // cancel
        return NO;
    }
    
    @try {
        [self.project startWithDir:appDir widget:self.initilizeWidget];
    }
    @catch (NSException *exception) {
        [JDLogUtil alert:exception.description title:@"Unknown Error"];
        return NO;
    }

    return YES;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"cloudIdx"];
    [self removeObserver:self forKeyPath:@"gitIdx"];
    [self removeObserver:self forKeyPath:@"appName"];
}

@end
