//
//  IUModificationProjectVC.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 20..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUModificationProjectVC.h"

@interface IUModificationProjectVC ()

@end

@implementation IUModificationProjectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setWantsLayer:YES];
        [self.view.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
        
        //comboBox Setting
        [self.projectType addItemsWithObjectValues:@[@"Default", @"Presentation", @"Django"]];
    }
    return self;
}

-(void)setIUProject:(MGProjectWC *)currentWC{
    pWC = currentWC;
    
    basePath = pWC.project.fileDir;
    
    self.appName = pWC.project.appName;
    self.resDir = pWC.project.resDir;
    self.IUMLDir = pWC.project.IUMLDir;
    self.objDir =  pWC.project.objectDir;
    self.outputDir = pWC.project.outputDir;
    
    if(pWC.project.cloud)
        self.cloud = pWC.project.cloud;
    else
        self.cloud = @"";
    if(pWC.project.git)
        self.git = pWC.project.git;
    else
        self.git = @"";
    
    self.disableMobileType = pWC.project.disableMobileType;
    self.disableTableType = pWC.project.disableTabletType;
    
    
    selectedProjectType = pWC.project.projectType;
    NSInteger index = [[self projectTypeList] indexOfObject:pWC.project.projectType];
    [self.projectType selectItemAtIndex:index];
    
}

/* Change Project Tyep */
- (NSArray*)projectTypeList{
    return @[@"IURackProject", @"IUPresProject", @"IUDjangoProject"];
}
- (IBAction)selectProjectType:(id)sender {
    NSLog(@"here");
    NSComboBoxCell *selected = ((NSComboBox *)sender).selectedCell;
    selectedProjectType =  [selected objectValueOfSelectedItem];
}


/* choose path !*/
-(NSString *)choosePath:(NSString *)originalPath{
    NSString *currentPath = [[[JDFileUtil util] openDirectoryByNSOpenPanel] path];
    if(![currentPath containsString:basePath]){
        //상위폴더임!
        return originalPath;
    }
    
    NSInteger index = [basePath length];
    NSMutableString *relativePath = [[NSMutableString alloc] initWithString:[currentPath substringFromIndex:index+1]];
    [relativePath insertString:@"/" atIndex:[relativePath length]];
    if(relativePath ==nil){
        return originalPath;
    }
    return relativePath;
}

- (IBAction)selectResDir:(id)sender {
    self.resDir = [self choosePath:self.resDir];
}

- (IBAction)selectIUMLDir:(id)sender {
    self.IUMLDir = [self choosePath:self.IUMLDir];
}

- (IBAction)selectObjDir:(id)sender {
    self.objDir = [self choosePath:self.objDir];
}

- (IBAction)selectOutputDir:(id)sender {
    self.outputDir = [self choosePath:self.outputDir];
}



- (IBAction)applyAll:(id)sender {
    if(self.appName == nil){
        [JDLogUtil alert:@"No app name"];
        return;
    }
    
    if(selectedProjectType == nil){
        [JDLogUtil alert:@"No project type"];
        return;
    }
    
    if(self.resDir == nil){
        [JDLogUtil alert:@"No resource Directory"];
        return;
    }
    
    if(self.IUMLDir == nil){
        [JDLogUtil alert:@"No IUML Directory"];
        return;
    }
    
    if(self.objDir == nil){
        [JDLogUtil alert:@"No object Directory"];
        return;
    }
    
    pWC.project.appName = self.appName;
    pWC.project.projectType = selectedProjectType;
    pWC.project.resDir = self.resDir;
    pWC.project.IUMLDir = self.IUMLDir;
    pWC.project.objectDir = self.objDir;
    pWC.project.cloud = self.cloud;
    pWC.project.git = self.git;
 
    pWC.project.disableTabletType = self.disableTableType;
    pWC.project.disableMobileType = self.disableMobileType;
    
    [pWC saveAllProject];
    [pWC.window close];
}

@end
