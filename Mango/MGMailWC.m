//
//  MGMailWC.m
//  Mango
//
/// Copyright (c) 2004-2012, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import "MGMailWC.h"
#import "IUHttpLog.h"

@interface MGMailWC ()

@end

@implementation MGMailWC

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)send:(id)sender {
    // TODO :
    
    //check email address
    NSString* emailString = [self.email stringValue];
    if(emailString == nil){
        [JDLogUtil alert:@"No email address, Please write it."];
        return;
    }
    if(![emailString containsString:@"@"]){
        [JDLogUtil alert:@"Invalid email address, Please insert vaild address."];
        return;
    }
    
    
    NSString* msgString = [[self.msg textStorage] string];
    if(msgString == nil){
        [JDLogUtil alert:@"No messages, Please write it."];
        return;
    }
    if([msgString length] > 5000){
        [JDLogUtil alert:@"Maximum length is 5000"];
        return;
    }

    // send email
    //send post to httplog
    [IUHttpLog sendMail:emailString message:msgString];
    
    [self close];
    
}
@end
