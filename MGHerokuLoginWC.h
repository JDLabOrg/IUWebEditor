//
//  MGHerokuLoginWC.h
//  WebGenerator
//
//  Created by JD on 3/11/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class JDHerokuUtil;
@protocol JDHerokuUtilLoginDelegate;

@interface MGHerokuLoginWC : NSWindowController <JDHerokuUtilLoginDelegate, NSTextFieldDelegate>
@property (nonatomic) JDHerokuUtil *herokuUtil;
@property (nonatomic) NSString  *loginID;
@property (nonatomic) NSString  *loginPassword;
@property (nonatomic) NSString  *statusText;

@property (nonatomic) BOOL  loginEnabled;

@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSTextField *idTF;
@property (weak) IBOutlet NSTextField *passwordTF;
@property (weak) IBOutlet NSTextField *loginStatusTF;
@property (weak) IBOutlet NSProgressIndicator *progressIndi;

@end
