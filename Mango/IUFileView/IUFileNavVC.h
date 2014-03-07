//
//  IUFileNavVC.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 28..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MGProjectWC.h"
#import "MGFileItem.h"
#import "JDOutlineView.h"
#import "IUManager.h"

@interface IUFileNavVC : NSViewController <NSMenuDelegate, NSTextFieldDelegate>{
    BOOL     awaked; // 1 if awaked from nib, 0 if not
    MGProjectWC *pWC;
    
    MGFileItem *currentEditedItem;
    NSArray *currentDraggedItems;
    NSArray *rootItemArray;
    
    MGFileItem *firstSelectedItem;
    NSString *oldTextString;

}

@property NSArray   *rootItemArray;
@property MGFileItem *rootItem;

@property  IBOutlet JDOutlineView *outlineV;
@property (strong) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *popupCopyMI;
@property (weak) IBOutlet NSMenuItem *popupRemoveMI;
@property (weak) IBOutlet NSMenuItem *popupNewMI;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;
- (void)reloadData;
-(void)reloadItem:(id)item;
- (IBAction)popupCopyPressed:(id)sender;
- (IBAction)popupRemovePressed:(id)sender;

-(void)setSelectRowFromTab:(MGFileItem *)item;




@end
