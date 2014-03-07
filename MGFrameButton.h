//
//  MGFrameButton.h
//  WebGenerator
//
//  Created by JD on 2/14/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IUObj.h"

@class IUController;

@interface MGFrameButton : NSButton
@property (nonatomic, weak) NSString      *flagValuePath;
@property (nonatomic, weak) IUController  *controller;
@property (nonatomic) IUNeedsDisplayActionType    type;
@end
