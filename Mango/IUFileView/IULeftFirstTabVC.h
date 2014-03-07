//
//  IUObjectInspector.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 28..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MGImageViewController;
@class MGClassSelectVC;

@interface IULeftFirstTabVC : NSViewController{

}

@property MGProjectWC* pWC;
@property IBOutlet MGImageViewController   *iVC;
@property (strong) IBOutlet NSArrayController *imageArrayController;
@property IBOutlet NSPopover *helpPopover;
@property (strong) IBOutlet MGClassSelectVC *classSelectVC;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;
- (IBAction)pressOpenImageFolder:(id)sender;
- (IBAction)showHelpPopover:(id)sender;
- (IBAction)reloadImage:(id)sender;

@end
