//
//  MGInitDjangoVC.m
//  Mango
//
//  Created by JD on 13. 5. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGNewDjangoProjectVC.h"

@interface MGNewDjangoProjectVC ()

@end

@implementation MGNewDjangoProjectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nextEnabled = NO;
        [self addObserver:self forKeyPaths:@[@"appDirPath", @"resDirPath", @"templateDirPath"] options:0 context:@"needCheckDjangoEn"];
    }
    
    return self;
}
-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"appDirPath", @"resDirPath", @"templateDirPath"]];
}

-(void)needCheckDjangoEnContextDidChange{
    if (self.appDirPath && self.resDirPath && self.templateDirPath) {
        self.nextEnabled = YES;
    }
    else{
        self.nextEnabled = NO;
    }
}

-(void)appDirPathDidChange{
    self.resDirPath = [self.appDirPath stringByAppendingPathComponent:@"static"];
    self.templateDirPath = [self.appDirPath stringByAppendingPathComponent:@"templates"];
}

-(BOOL)pressFinishBtn{
    NSLog(@"finish");
    self.project.appName = self.appDirPath.lastPathComponent;
    self.project.resDir = [self.appDirPath relativePathTo:self.resDirPath];
    self.project.outputDir = [self.appDirPath relativePathTo:self.templateDirPath];
    [self.project startWithDir:self.appDirPath widget:self.initilizeWidget];

    return YES;
}

- (IBAction)pressAppDirSelectBtn:(id)sender {
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django project directory"] path];
    if (appDir == nil) { // cancel
        return;
    }
    self.appDirPath = appDir;
}

- (IBAction)pressStaticDirSelectBtn:(id)sender {
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django project media directory"] path];
    if (appDir == nil) { // cancel
        return;
    }
    self.resDirPath = appDir;
}

- (IBAction)pressTemplateSelectBtn:(id)sender {
    NSString *appDir = [[[JDFileUtil util] openDirectoryByNSOpenPanel:@"Select Django project template directory"] path];
    if (appDir == nil) { // cancel
        return;
    }
    self.templateDirPath = appDir;
}

@end
