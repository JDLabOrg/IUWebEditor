//
//  IUCloseWindowController.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 12. 26..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUCloseWindowController.h"

@interface IUCloseWindowController ()

@end

@implementation IUCloseWindowController

-(id)initWithWindowNibName:(NSString *)windowNibName withName:(NSString *)aName{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        self.name = aName;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)dontSaveClose:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseStop];
}

- (IBAction)saveClose:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}

- (IBAction)cancelClose:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}
@end
