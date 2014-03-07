//
//  IUTextPanelWC.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 23..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGProjectWC.h"

@interface IUTextPanelWC : NSWindowController <NSWindowDelegate,NSTextViewDelegate, NSTextFieldDelegate>{
}

@property (strong) IBOutlet NSPanel *iutextPanel;
@property (unsafe_unretained) IBOutlet NSTextView *textV;
@property NSString *linkStr;

#pragma mark PUBLIC CLASS Methods
+(IUTextPanelWC *)sharedInstanceWithPWC:(MGProjectWC *)pWC;

#pragma mark PUBLIC INSTANCE Methods
-(void)setPWC:(MGProjectWC *)pwc;
- (IBAction)bgColorChangBtnClick:(id)sender;
@end
