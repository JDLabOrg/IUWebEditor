//
//  IUTopToolBar2VC.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 3. 3..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGColorWell.h"
#import "MGProjectWC.h"
#import "IUDefinition.h"


@interface IUTextToolbarVC : NSViewController <NSTextViewDelegate, NSControlTextEditingDelegate, NSTextStorageDelegate>

@property NSTextStorage *currentStorage;
@property MGProjectWC *pWC;
@property (strong) IBOutlet NSScrollView *textEditV; //container
@property (unsafe_unretained) IBOutlet NSTextView *textV;

@property IUSelectType  selectType;

//fontName
@property (weak) IBOutlet NSPopUpButton *fontNameBtn;
//fontSie
@property (weak) IBOutlet NSTextField *fontSizeField;
@property (nonatomic) CGFloat currentFontSize;
@property (weak) IBOutlet NSStepper *fontSizeStepper;
//color
@property (weak) IBOutlet MGColorWell *fontColorBtn;
@property (nonatomic) NSColor *currentColor;
//taits
@property (weak) IBOutlet NSSegmentedControl *fontTraitsControl;
@property (nonatomic) BOOL bold, italic, underline;
//text align
@property (weak) IBOutlet NSSegmentedControl *textAlignControl;
/*
 remove link current version:
@property (weak) IBOutlet NSTextField *linkTextField;
@property (nonatomic)   NSString *linkStr;
 */
//line spacing
//autoLineHeight - handle => IUText
//Initailize 문제가 있기 때문에 autoLineHeight는 내보낼때 맡아야 함.
//따라서 IUText가 autoLineHeight를 내보냄
@property (weak) IBOutlet NSComboBox *lineSpacingComboBox;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC *)aPWC;
- (void)resetToolBarState;
@end
