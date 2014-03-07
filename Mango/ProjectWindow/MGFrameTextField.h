//
//  MGFrameTextField.h
//  WebGenerator
//
//  Created by JD on 1/18/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUController.h"
@interface MGFrameTextField : NSTextField

@property IUController *controller;

@property NSString *conditionlKeyPath;
@property NSString *trueKeyPath;
@property NSString *falseKeyPath;

@property NSString      *trueCheckSel;
@property NSString          *falseCheckSel;

@property IUNeedsDisplayActionType displayActionType;

@end
