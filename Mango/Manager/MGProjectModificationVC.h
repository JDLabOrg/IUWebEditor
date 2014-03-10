//
//  MGProjectModificationVC.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 20..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MGProjectModificationVC : NSViewController{
    MGProjectWC *pWC;
    NSString *basePath;
    NSString *selectedProjectType;
}

@property NSString *appName;
@property (weak) IBOutlet NSComboBox *projectType;

@property NSString *resDir;
@property NSString *IUMLDir;
@property NSString *objDir;
@property NSString *outputDir;

@property NSString *cloud;
@property NSString *git;
@property BOOL disableTableType, disableMobileType;

- (void)setIUProject:(MGProjectWC *)currentWC;
- (IBAction)selectProjectType:(id)sender;

- (IBAction)selectResDir:(id)sender;
- (IBAction)selectIUMLDir:(id)sender;
- (IBAction)selectObjDir:(id)sender;
- (IBAction)selectOutputDir:(id)sender;

- (IBAction)applyAll:(id)sender;

@end
