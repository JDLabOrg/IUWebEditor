//
//  IUSyncWindowController.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 5..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUSyncWindowController : NSWindowController{
    MGProjectWC     *pWC;
    NSString        *commitMessage;
    NSString        *branch;
    NSString        *remote;
    NSView  *currentView;
}

@property MGProjectWC *pWC;
@property NSString  *commitMessage;
@property NSString  *remote;
@property NSString  *branch;
@property (strong) IBOutlet NSView *contentView;
@property (strong) IBOutlet NSView *processingView;
@property (weak) IBOutlet NSProgressIndicator *syncIndi;
@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)pressSync:(id)sender;
- (id)initWithWindowNibName:(NSString *)windowNibName PWC:(MGProjectWC *)PWC;


@end
