//
//  IUSyncWindowController.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 5..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUSyncWindowController.h"
#import "MGProjectWC.h"

@interface IUSyncWindowController ()

@end

@implementation IUSyncWindowController


@synthesize pWC;
@synthesize commitMessage;
@synthesize remote;
@synthesize branch;



- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.branch = @"master";
        self.remote = @"heroku";
        self.commitMessage = [JDDateTimeUtil stringForToday];
    }
    return self;
}
- (id)initWithWindowNibName:(NSString *)windowNibName PWC:(MGProjectWC *)PWC{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        pWC = PWC;
        self.branch = @"master";
        self.remote = @"heroku";
        self.commitMessage = [JDDateTimeUtil stringForToday];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    currentView = _contentView;
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)viewServerPressed:(id)sender {
    NSURL   *url = self.pWC.project.serverURL;
    [[NSWorkspace sharedWorkspace] openURL:url];
}


- (IBAction)pressSync:(id)sender{
    __block int finish = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        [pWC sync:remote branch:branch message:commitMessage];
        finish = 1;
    });
    return;
}



@end
