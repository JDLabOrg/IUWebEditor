//
//  MGHerokuLoginWC.m
//  WebGenerator
//
//  Created by JD on 3/11/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGHerokuLoginWC.h"
#import "JDHerokuUtil.h"

@interface MGHerokuLoginWC ()

@end

@implementation MGHerokuLoginWC

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        [self addObserver:self forKeyPaths:@[@"loginID", @"loginPassword"] options:0 context:nil];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.progressIndi startAnimation:self];
    [self.progressIndi setHidden:YES];
    [self controlTextDidChange:nil];
}


-(void)setHerokuUtil:(JDHerokuUtil *)herokuUtil{
    _herokuUtil = herokuUtil;
    _herokuUtil.loginDelegate = self;
}

- (IBAction)pressLogin:(id)sender {
    [self.loginButton setEnabled:NO];
    [self.idTF setEnabled:NO];
    [self.passwordTF setEnabled:NO];
    [self.progressIndi setHidden:NO];
    [self.herokuUtil login:self.loginID password:self.loginPassword];
}


- (void)controlTextDidChange:(NSNotification *)aNotification{
    if ([self.loginID isValidEmail] == NO){
        self.loginEnabled = NO;
        self.statusText = @"Enter ID and Password";
        return;
    }
    if ([self.loginPassword length] < 8) {
        self.loginEnabled = NO;
        self.statusText = @"Enter ID and Password";
        return;
    }
    self.statusText = nil;
    self.loginEnabled = YES;
    return;
}

- (IBAction)pressCancel:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

#pragma mark Heroku Login Delegate
-(void)herokuUtil:(JDHerokuUtil*)util loginProcessFinishedWithResultCode:(NSInteger)resultCode{
    if (resultCode == 0) {
        //login successed
        [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    }
    else {
        self.statusText = @"Login Failed";
    }
    //login failed
    [self.idTF setEnabled:YES];
    [self.passwordTF setEnabled:YES];
    [self.progressIndi setHidden:YES];
}

@end
