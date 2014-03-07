//
//  MGStackCellV.m
//  WebGenerator
//
//  Created by jd on 2/1/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGStackCellV.h"

@implementation MGStackCellV

-(void)startEdit{
    //unbind
    [self.textField unbind:@"value"];
    
    //set focus
    [self.textField setEditable:YES];
    [self.textField becomeFirstResponder];
    [self.textField setStringValue:self.objectValue.name];
}

-(void)endEdit{
    [self.textField bind:@"value" toObject:self.objectValue withKeyPath:@"displayText" options:nil];
}

@end
