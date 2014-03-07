//
//  MGToolbarDelegate.h
//  WebGenerator
//
//  Created by JD on 1/17/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGFrameTextField.h"
#import "MGFrameButton.h"

@class MGProjectWC;
@class JDDragAndDropImageV;

@interface MGToolbarDelegate : NSObject <NSToolbarDelegate, NSTextFieldDelegate>

@property (weak)   IBOutlet MGProjectWC *pWC;
@property (weak) IBOutlet NSToolbar *toolbar;


@property (strong) IBOutlet NSView *frameV;
@property (weak) IBOutlet MGFrameTextField *xTF;
@property (weak) IBOutlet MGFrameTextField *yTF;
@property (weak) IBOutlet MGFrameTextField *wTF;
@property (weak) IBOutlet MGFrameTextField *hTF;

@property (strong) IBOutlet NSView *flowFrameV;
@property (weak) IBOutlet MGFrameTextField *marginTopTF;
@property (weak) IBOutlet MGFrameTextField *marginLeftTF;
@property (weak) IBOutlet MGFrameTextField *marginRightTF;
@property (weak) IBOutlet MGFrameTextField *marginBottomTF;


@property (strong) IBOutlet NSView *opacityView;

@property (strong) IBOutlet NSView *centerV;

@property (strong) IBOutlet NSButton *vCenterBtn;
@property (strong) IBOutlet NSButton *hCenterBtn;

@property (strong) IBOutlet NSButton *flowBtn;

@property (strong) IBOutlet NSButton *overflowBtn;
@property (strong) IBOutlet NSButton *visibleBtn;
@property (strong) IBOutlet NSButton *fitBtn;

@property (strong) IBOutlet NSButton *clearColorBtn;

@property (strong) IBOutlet NSView *bgV;
@property (strong) IBOutlet NSPopUpButton *screenSelectBtn;

@property (strong) IBOutlet NSImageView *lineV;

@property (weak) IBOutlet NSTextField *bgXBtn;
@property (weak) IBOutlet NSTextField *bgYBtn;
@property (weak) IBOutlet NSButton *bgManualBtn;
@property (weak) IBOutlet NSButton *bgRepeatBtn;
@property (weak) IBOutlet NSTextField *bgXLabel;
@property (weak) IBOutlet NSTextField *bgYLabel;
@property (weak) IBOutlet NSTextField *bgTitle;

@property (weak) IBOutlet MGFrameButton *xFlagBtn;
@property (weak) IBOutlet MGFrameButton *yFlagBtn;
@property (weak) IBOutlet MGFrameButton *wFlagBtn;
@property (weak) IBOutlet MGFrameButton *hFlagBtn;
@property (weak) IBOutlet MGFrameButton *topFlagBtn;
@property (weak) IBOutlet MGFrameButton *leftFlagBtn;
@property (weak) IBOutlet MGFrameButton *bottomFlagBtn;
@property (weak) IBOutlet MGFrameButton *rightFlagBtn;



@property (weak) IBOutlet JDDragAndDropImageV *bgImgV;

- (IBAction)pressClearColorBtn:(id)sender;


@end
