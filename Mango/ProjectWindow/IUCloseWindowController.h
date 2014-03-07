//
//  IUCloseWindowController.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 12. 26..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUCloseWindowController : NSWindowController

@property NSString *name;

-(id)initWithWindowNibName:(NSString *)windowNibName withName:(NSString *)aName;
- (IBAction)dontSaveClose:(id)sender;
- (IBAction)saveClose:(id)sender;
- (IBAction)cancelClose:(id)sender;

@end
