//
//  MGToolbarDelegate.m
//  WebGenerator
//
//  Created by JD on 1/17/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "MGToolbarDelegate.h"
#import "MGProjectWC.h"
#import "IUFrameManager.h"
#import "IUScreenFrame.h"
#import "IUManager.h"
#import "IUViewManager.h"
#import "IUController.h"
#import "IUBG.h"
#import "JDDragAndDropImageV.h"
#import "IUTextPanelWC.h"


@implementation MGToolbarDelegate

-(id)init{
    self = [super init];
    [[NSBundle mainBundle] loadNibNamed:@"MGToolbarItems" owner:self topLevelObjects:nil];

    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelX" options:nil context:@"@selector(updateX)" ];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentX" options:nil context:@"@selector(updateX)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX" options:nil context:@"@selector(updateX)"];
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelY" options:nil context:@"@selector(updateY)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentY" options:nil context:@"@selector(updateY)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagY" options:nil context:@"@selector(updateY)"];
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelWidth" options:nil context:@"@selector(updateW)" ];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentWidth" options:nil context:@"@selector(updateW)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagWidth" options:nil context:@"@selector(updateW)"];
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelHeight" options:nil  context:@"@selector(updateH)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentHeight" options:nil context:@"@selector(updateH)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagHeight" options:nil context:@"@selector(updateH)"];

    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.flowLayout" options:nil  context:@"@selector(updateFlowLayout)"];

    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginTop" options:nil  context:@"@selector(updateMarginTop)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginTop" options:nil context:@"@selector(updateMarginTop)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginTop" options:nil context:@"@selector(updateMarginTop)"];

    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginBottom" options:nil  context:@"@selector(updateMarginBottom)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginBottom" options:nil context:@"@selector(updateMarginBottom)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginBottom" options:nil context:@"@selector(updateMarginBottom)"];

    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginRight" options:nil  context:@"@selector(updateMarginRight)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginRight" options:nil context:@"@selector(updateMarginRight)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginRight" options:nil context:@"@selector(updateMarginRight)"];

    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginLeft" options:nil  context:@"@selector(updateMarginLeft)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginLeft" options:nil context:@"@selector(updateMarginLeft)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginLeft" options:nil context:@"@selector(updateMarginLeft)"];
    
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.bg.img" options:nil  context:@"@selector(updateBGImg)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.bg.color" options:nil  context:@"@selector(updateBGColor)"];
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.horizontalCenter" options:nil  context:@"@selector(updateHCenter)"];
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.iuFrame.verticalCenter" options:nil  context:@"@selector(updateVCenter)"];
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection.selection.iuFrame.currentScreenFrame.flowLayout" options:nil  context:@"@selector(updateFlowLayout)"];
    
    [self addObserver:self forKeyPath:@"pWC.iuController.selection" options:0 context:nil];
    return self;
}


-(void)awakeFromNib{
    //awakeFromNib is called twice : (1)pWC loading, (2)xTF, yTF... loading
    if (self.pWC && self.xTF) {
        [self.xTF setController:self.pWC.iuController];
        [self.xTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagX"];
        [self.xTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelX"];        
        [self.xTF setFalseCheckSel:@"shouldChangeXByUserInput:"];
        [self.xTF setTrueCheckSel:@"shouldChangeXByUserInput:"];
        [self.xTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentX"];
        self.xTF.displayActionType = IUNeedsDisplayActionCSS;
        
        [self.yTF setController:self.pWC.iuController];
        [self.yTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagY"];
        [self.yTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelY"];
        [self.yTF setTrueCheckSel:@"shouldChangeYByUserInput:"];
        [self.yTF setFalseCheckSel:@"shouldChangeYByUserInput:"];
        [self.yTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentY"];
        self.yTF.displayActionType = IUNeedsDisplayActionCSS;
        
        [self.wTF setController:self.pWC.iuController];
        [self.wTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagWidth"];
        [self.wTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelWidth"];
        [self.wTF setFalseCheckSel:@"shouldChangeWidthByUserInput:"];
        [self.wTF setTrueCheckSel:@"shouldChangeWidthByUserInput:"];
        [self.wTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentWidth"];
        self.wTF.displayActionType = IUNeedsDisplayActionCSS;
        
        [self.hTF setController:self.pWC.iuController];
        [self.hTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagHeight"];
        [self.hTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelHeight"];
        [self.hTF setFalseCheckSel:@"shouldChangeHeightByUserInput:"];
        [self.hTF setTrueCheckSel:@"shouldChangeHeightByUserInput:"];
        [self.hTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentHeight"];
        self.hTF.displayActionType = IUNeedsDisplayActionCSS;
        
        [self.marginTopTF setController:self.pWC.iuController];
        [self.marginTopTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginTop"];
        [self.marginTopTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelMarginTop"];
        [self.marginTopTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentMarginTop"];
        self.marginTopTF.displayActionType = IUNeedsDisplayActionAll;

        [self.marginLeftTF setController:self.pWC.iuController];
        [self.marginLeftTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginLeft"];
        [self.marginLeftTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelMarginLeft"];
        [self.marginLeftTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentMarginLeft"];
        self.marginLeftTF.displayActionType = IUNeedsDisplayActionAll;

        [self.marginRightTF setController:self.pWC.iuController];
        [self.marginRightTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginRight"];
        [self.marginRightTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelMarginRight"];
        [self.marginRightTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentMarginRight"];
        self.marginRightTF.displayActionType = IUNeedsDisplayActionAll;

        [self.marginBottomTF setController:self.pWC.iuController];
        [self.marginBottomTF setConditionlKeyPath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginBottom"];
        [self.marginBottomTF setFalseKeyPath:@"selection.iuFrame.currentScreenFrame.pixelMarginBottom"];
        [self.marginBottomTF setTrueKeyPath:@"selection.iuFrame.currentScreenFrame.percentMarginBottom"];
        self.marginBottomTF.displayActionType = IUNeedsDisplayActionAll;

        [self.bgImgV registerForImageDraggedType:kIUImageURL];
        [self.bgImgV setInsertionObj:self.pWC.iuController];
        [self.bgImgV setInsertionKeyPath:@"selection.bg.img"];
        
        [self.xFlagBtn setController:self.pWC.iuController];
        
        [self.xFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagX"];
        
        
        
        [self.yFlagBtn setController:self.pWC.iuController];
        
        [self.yFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagY"];
        
        
        
        [self.wFlagBtn setController:self.pWC.iuController];
        
        [self.wFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagWidth"];
        
        
        
        [self.hFlagBtn setController:self.pWC.iuController];
        
        [self.hFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagHeight"];
        
        
        
        [self.topFlagBtn setController:self.pWC.iuController];
        
        [self.topFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginTop"];
        
        
        
        [self.leftFlagBtn setController:self.pWC.iuController];
        
        [self.leftFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginLeft"];
        
        
        
        [self.rightFlagBtn setController:self.pWC.iuController];
        
        [self.rightFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginRight"];
        
        
        
        [self.bottomFlagBtn setController:self.pWC.iuController];
        
        [self.bottomFlagBtn setFlagValuePath:@"selection.iuFrame.currentScreenFrame.percentFlagMarginBottom"];
        

    }
}

#define kFrameViewToolbarItemID @"frame"
#define kFrowFrameViewToolBarItemID @"ff"
#define kOpacityViewToolbarItemID @"op"
#define kVCenterToolbarItemID @"v"
#define kHCenterToolbarItemID @"h"
#define kFlowToolbarItemID @"flow"
#define kOverflowToolbarItemID @"ov"
#define kVisibleToolbarItemID  @"vis"
#define kClearColorToolbarItemID @"cc"
#define kBGToolbarItemID @"bg"
#define kExportToolbarItemID @"ex"
#define kScreenToolbarItemID @"sc"
#define kSeparateLineToolbarItem @"sp"
#define kCenterToolbarItem @"ct"
#define kFitToolbarItem @"ft"

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:   kFrameViewToolbarItemID, kSeparateLineToolbarItem, kFlowToolbarItemID, kFrowFrameViewToolBarItemID, kSeparateLineToolbarItem, kCenterToolbarItem,kFitToolbarItem,
            kOverflowToolbarItemID, kSeparateLineToolbarItem,  kBGToolbarItemID, kClearColorToolbarItemID,NSToolbarShowColorsItemIdentifier, kSeparateLineToolbarItem, kVisibleToolbarItemID, kOpacityViewToolbarItemID,NSToolbarFlexibleSpaceItemIdentifier, kScreenToolbarItemID, kExportToolbarItemID, nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:   kFrameViewToolbarItemID, kSeparateLineToolbarItem, kFlowToolbarItemID, kFrowFrameViewToolBarItemID, kSeparateLineToolbarItem, kCenterToolbarItem, kFitToolbarItem,
            kOverflowToolbarItemID, kSeparateLineToolbarItem,  kBGToolbarItemID, kClearColorToolbarItemID,NSToolbarShowColorsItemIdentifier, kSeparateLineToolbarItem, kVisibleToolbarItemID, kOpacityViewToolbarItemID,NSToolbarFlexibleSpaceItemIdentifier, kScreenToolbarItemID, kExportToolbarItemID, nil];
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
    // You could check [theItem itemIdentifier] here and take appropriate action if you wanted to
    return YES;
}

- (void) toolbarWillAddItem:(NSNotification *)notification
{
    NSToolbarItem *addedItem = [[notification userInfo] objectForKey: @"item"];
    if([[addedItem itemIdentifier] isEqual: NSToolbarShowColorsItemIdentifier]) {
		[addedItem setToolTip:@"Change Text Color"];
		[addedItem setTarget:self];
		[addedItem setAction:@selector(showColorPicker)];
    }
	
}

-(void)showColorPicker{
    //sharedColorPanel -- text, bgground
    //share되지 않도록 textpanel이 열려있으면 panel close
    [[IUTextPanelWC sharedInstanceWithPWC:self.pWC] close];
    [[NSColorPanel sharedColorPanel] close];

	NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel setAction:@selector(setColor:)];
    [colorPanel setTarget:self];
    [NSApp orderFrontColorPanel:self];
}

-(void)setColor:(NSColorPanel*)colorPanel{
    [self.pWC.iuController setValue:colorPanel.color forKeyPath:@"selection.bg.color"];
}



- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag{
    if ([itemIdentifier isEqualToString:kFrameViewToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kFrameViewToolbarItemID label:kFrameViewToolbarItemID paleteLabel:kFrameViewToolbarItemID toolTip:@"Frame for absolute layout" target:nil itemContent:self.frameV action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kFrowFrameViewToolBarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kFrowFrameViewToolBarItemID label:kFrowFrameViewToolBarItemID paleteLabel:kFrowFrameViewToolBarItemID toolTip:@"Frame for flow layout" target:nil itemContent:self.flowFrameV action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kOpacityViewToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kOpacityViewToolbarItemID label:kOpacityViewToolbarItemID paleteLabel:kOpacityViewToolbarItemID toolTip:@"Opacity value" target:nil itemContent:self.opacityView action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kVCenterToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kVCenterToolbarItemID label:kVCenterToolbarItemID paleteLabel:kVCenterToolbarItemID toolTip:@"Vertical center" target:nil itemContent:self.vCenterBtn action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kCenterToolbarItem]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kCenterToolbarItem label:kCenterToolbarItem paleteLabel:kVCenterToolbarItemID toolTip:@"Vertical center" target:nil itemContent:self.centerV action:nil menu:nil];
        return item;
    }

    if ([itemIdentifier isEqualToString:kHCenterToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kHCenterToolbarItemID label:kHCenterToolbarItemID paleteLabel:kHCenterToolbarItemID toolTip:@"Horizontal Center" target:nil itemContent:self.hCenterBtn action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kFlowToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kFlowToolbarItemID label:nil paleteLabel:nil toolTip:@"frame" target:nil itemContent:self.flowBtn action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kOverflowToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kOverflowToolbarItemID label:kOverflowToolbarItemID paleteLabel:kOverflowToolbarItemID toolTip:@"Flow layout" target:nil itemContent:self.overflowBtn action:nil menu:nil];
        return item;
    }
    if([itemIdentifier isEqualToString:kVisibleToolbarItemID]){
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kVisibleToolbarItemID label:kVisibleToolbarItemID paleteLabel:kVisibleToolbarItemID toolTip:@"Visibility" target:nil itemContent:self.visibleBtn action:nil menu:nil ];
        return item;
    }
    if ([itemIdentifier isEqualToString:kClearColorToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:@"frame" label:kClearColorToolbarItemID paleteLabel:kClearColorToolbarItemID toolTip:@"Clear color" target:nil itemContent:self.clearColorBtn action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kBGToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:@"frame" label:kBGToolbarItemID paleteLabel:kBGToolbarItemID toolTip:@"Background Toolbar Item" target:nil itemContent:self.bgV action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kExportToolbarItemID]) {
        NSImage *img = [NSImage imageNamed:@"chrome"];
        NSToolbarItem *item = [self toolbarItemWithIdentifier:@"frame" label:kExportToolbarItemID paleteLabel:kExportToolbarItemID toolTip:@"Build" target:self.pWC itemContent:img action:@selector(build:) menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kScreenToolbarItemID]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:@"frame" label:kScreenToolbarItemID paleteLabel:kScreenToolbarItemID toolTip:@"Select screen" target:nil itemContent:self.screenSelectBtn action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kFitToolbarItem]) {
        NSToolbarItem *item = [self toolbarItemWithIdentifier:kFitToolbarItem label:kFitToolbarItem paleteLabel:kFitToolbarItem toolTip:@"Fit" target:nil itemContent:self.fitBtn action:nil menu:nil];
        return item;
    }
    if ([itemIdentifier isEqualToString:kSeparateLineToolbarItem]) {
        NSImage *img = [NSImage imageNamed:@"line"];
        NSImageView *imgV = [[NSImageView alloc] init];
        imgV.image = img;
        imgV.frame = NSRectMake(0, 0, 10, 35);

        NSToolbarItem *item = [self toolbarItemWithIdentifier:@"frame" label:nil paleteLabel:nil toolTip:@"frame" target:nil itemContent:imgV action:nil menu:nil];
        return item;
    }

    assert(0);
    return nil;
}



- (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)identifier
                                       label:(NSString *)label
                                 paleteLabel:(NSString *)paletteLabel
                                     toolTip:(NSString *)toolTip
                                      target:(id)target
                                 itemContent:(id)imageOrView
                                      action:(SEL)action
                                        menu:(NSMenu *)menu
{
    // here we create the NSToolbarItem and setup its attributes in line with the parameters
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
    
    [item setLabel:label];
    [item setPaletteLabel:@"qwerqwer"];
    [item setToolTip:toolTip];
    [item setTarget:target];
    [item setAction:action];
    
    // Set the right attribute, depending on if we were given an image or a view
    if([imageOrView isKindOfClass:[NSImage class]]){
        [item setImage:imageOrView];
    }
    else if ([imageOrView isKindOfClass:[NSView class]]){
        [item setView:imageOrView];
    }else {
        assert(!"Invalid itemContent: object");
    }
    
    // If this NSToolbarItem is supposed to have a menu "form representation" associated with it
    // (for text-only mode), we set it up here.  Actually, you have to hand an NSMenuItem
    // (not a complete NSMenu) to the toolbar item, so we create a dummy NSMenuItem that has our real
    // menu as a submenu.
    //
    if (menu != nil)
    {
        // we actually need an NSMenuItem here, so we construct one
        NSMenuItem *mItem = [[NSMenuItem alloc] init];
        [mItem setSubmenu:menu];
        [mItem setTitle:label];
        [item setMenuFormRepresentation:mItem];
    }
    
    return item;
}

#pragma mark -
#pragma mark update Value


-(void)updateX{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_xTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id pixelX = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelX"];
        if (pixelX == NSMultipleValuesMarker || pixelX==NSNoSelectionMarker || pixelX == NSNotApplicableMarker) {
            [_xTF setStringValue:pixelX];
            return;
        }
        [_xTF setStringValue:[NSString stringWithFormat:@"%.0f", [pixelX floatValue]]];
    }
    else{
        id pixelX = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentX"];
        if (pixelX == NSMultipleValuesMarker || pixelX==NSNoSelectionMarker || pixelX == NSNotApplicableMarker) {
            [_xTF setStringValue:pixelX];
            return;
        }
        [_xTF setStringValue:[NSString stringWithFormat:@"%.2f", [pixelX floatValue]]];
    }
}

-(void)updateY{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagY"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_yTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelY"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_yTF setStringValue:value];
            return;
        }
        [_yTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentY"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_yTF setStringValue:value];
            return;
        }
        [_yTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }

}


-(void)updateW{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagWidth"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_wTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelWidth"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_wTF setStringValue:value];
            return;
        }
        [_wTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else{
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentWidth"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_wTF setStringValue:value];
            return;
        }
        [_wTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }
}

-(void)updateH{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagHeight"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_hTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelHeight"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_hTF setStringValue:value];
            return;
        }
        [_hTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentHeight"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_hTF setStringValue:value];
            return;
        }
        [_hTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }
}

-(void)updateMarginTop{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginTop"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_marginTopTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginTop"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginTopTF setStringValue:value];
            return;
        }
        [_marginTopTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginTop"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_hTF setStringValue:value];
            return;
        }
        [_marginTopTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }
}

-(void)updateMarginLeft{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginLeft"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_marginLeftTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginLeft"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginLeftTF setStringValue:value];
            return;
        }
        [_marginLeftTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginLeft"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginLeftTF setStringValue:value];
            return;
        }
        [_marginLeftTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }
}

-(void)updateMarginRight{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginRight"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_marginRightTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginRight"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginRightTF setStringValue:value];
            return;
        }
        [_marginRightTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginRight"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginRightTF setStringValue:value];
            return;
        }
        [_marginRightTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }
}

-(void)updateMarginBottom{
    id percentFlag = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagMarginBottom"];
    if (percentFlag == NSMultipleValuesMarker || percentFlag==NSNoSelectionMarker || percentFlag == NSNotApplicableMarker) {
        [_marginBottomTF setStringValue:percentFlag];
        return;
    }
    if ([percentFlag boolValue] == NO) {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.pixelMarginBottom"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginBottomTF setStringValue:value];
            return;
        }
        [_marginBottomTF setStringValue:[NSString stringWithFormat:@"%.0f", [value floatValue]]];
    }
    else {
        id value = [self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentMarginBottom"];
        if (value == NSMultipleValuesMarker || value==NSNoSelectionMarker || value == NSNotApplicableMarker) {
            [_marginBottomTF setStringValue:value];
            return;
        }
        [_marginBottomTF setStringValue:[NSString stringWithFormat:@"%.2f", [value floatValue]]];
    }
}



- (void)pressPercentFlag:(NSButton*)btn{
    BOOL value;
    switch (btn.tag) {
        case 0:
            value = [[self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX"] boolValue];
            [self setValue:@(!value) forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX"];
            break;
        case 1:
            value = [[self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagY"] boolValue];
            [self setValue:@(!value) forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX"];
            break;
        case 2:
            value = [[self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagWidth"] boolValue];
            [self setValue:@(!value) forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX"];
            break;
        case 3:
            value = [[self valueForKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagHeight"] boolValue];
            [self setValue:@(!value) forKeyPath:@"pWC.iuController.selection.iuFrame.currentScreenFrame.percentFlagX"];
            break;
        default:
            assert(0);
            break;
    }
    for (IUObj *iu in self.pWC.iuController.selectedObjects) {
        [iu setNeedsDisplay:IUNeedsDisplayActionCSS];
    }
}


-(void)updateFlowLayout{
    id value = [self.pWC.iuController valueForKeyPath:@"selection.iuFrame.currentScreenFrame.flowLayout"];
    if (value==NSNoSelectionMarker || value == NSMultipleValuesMarker || value == NSNotApplicableMarker || [value boolValue] == NO) {
        [[self.flowFrameV animator] setAlphaValue:0.3];
        [[self.vCenterBtn animator] setAlphaValue:1];
        [self.vCenterBtn setEnabled:YES];
        [self.flowBtn setState:0];
        return;
    }
    else {
        [[self.flowFrameV animator] setAlphaValue:1];
        [[self.vCenterBtn animator] setAlphaValue:0.3];
        [self.vCenterBtn setEnabled:NO];
        [self.flowBtn setState:1];
    }
}


-(void)updateBGImg{
    id value = [self.pWC.iuController valueForKeyPath:@"selection.bg.img"];

    BOOL isImageClass= NO;
    
    //selection is Image class
    for(IUObj *obj in self.pWC.iuController.selectedObjects){
        if([obj isKindOfClass:[IUImage class]]){
            isImageClass = YES;
        }
    }
    
    if (value == nil || value == NSNotApplicableMarker || isImageClass) {
        [self.bgTitle setStringValue:@"BG"];
        [[self.bgXBtn animator] setAlphaValue:0.3];
        [[self.bgYBtn animator] setAlphaValue:0.3];
        [[self.bgRepeatBtn animator] setAlphaValue:0.3];
        [[self.bgManualBtn animator] setAlphaValue:0.3];
        [[self.bgXLabel animator] setAlphaValue:0.3];
        [[self.bgYLabel animator] setAlphaValue:0.3];
        [self.bgXBtn setEnabled:NO];
        [self.bgYBtn setEnabled:NO];
        [self.bgRepeatBtn setEnabled:NO];
        [self.bgManualBtn setEnabled:NO];
    }
    else{
        [[self.bgXBtn animator] setAlphaValue:1];
        [[self.bgYBtn animator] setAlphaValue:1];
        [[self.bgRepeatBtn animator] setAlphaValue:1];
        [[self.bgManualBtn animator] setAlphaValue:1];
        [[self.bgXLabel animator] setAlphaValue:1];
        [[self.bgYLabel animator] setAlphaValue:1];
        [self.bgXBtn setEnabled:YES];
        [self.bgYBtn setEnabled:YES];
        [self.bgRepeatBtn setEnabled:YES];
        [self.bgManualBtn setEnabled:YES];
    }
}


-(void)updateVCenter{
    id value = [self.pWC.iuController valueForKeyPath:@"selection.iuFrame.verticalCenter"];
    if (value == nil || value == NSNotApplicableMarker || value == NSNoSelectionMarker) {
        [[self.vCenterBtn animator] setAlphaValue:0.3];
        [self.vCenterBtn setEnabled:NO];
    }
    else{
        [[self.vCenterBtn animator] setAlphaValue:1];
        [self.vCenterBtn setEnabled:YES];
        if (value == NSMultipleValuesMarker) {
            [self.vCenterBtn setImage:nil];
        }
        else if ([value boolValue] == YES){
            NSImage *img = [NSImage imageNamed:@"check_16"];
            [self.vCenterBtn setImage:img];
        }
        else{
            [self.vCenterBtn setImage:nil];
        }
    }
}

-(void)updateHCenter{
    id value = [self.pWC.iuController valueForKeyPath:@"selection.iuFrame.horizontalCenter"];
    if (value == nil || value == NSNotApplicableMarker || value == NSNoSelectionMarker) {
        [[self.hCenterBtn animator] setAlphaValue:0.3];
        [self.hCenterBtn setEnabled:NO];
    }
    else{
        [[self.hCenterBtn animator] setAlphaValue:1];
        [self.hCenterBtn setEnabled:YES];
        if (value == NSMultipleValuesMarker) {
            [self.hCenterBtn setImage:nil];
        }
        else if ([value boolValue] == YES){
            [self.hCenterBtn setImage:[NSImage imageNamed:@"check_16"]];
        }
        else{
            [self.hCenterBtn setImage:nil];
        }
    }
}

-(void)updateBGColor{
    id value = [self.pWC.iuController valueForKeyPath:@"selection.bg.color"];
    if (value == nil || value == NSNotApplicableMarker || value == NSNoSelectionMarker) {
        [[self.clearColorBtn animator] setAlphaValue:0.3];
        [self.clearColorBtn setEnabled:NO];
    }
    else {
        [[self.clearColorBtn animator] setAlphaValue:1];
        [self.clearColorBtn setEnabled:YES];
        if ([value isKindOfClass:[NSColor class]]) {
            [[NSColorPanel sharedColorPanel] setColor:value];
        }
    }
}
-(void)updatePercentFlag{
    for (IUObj *obj in self.pWC.iuController.selectedObjects){
        [obj setNeedsDisplay:IUNeedsDisplayActionCSS];
    }
}

#pragma mark -
#pragma mark press Button

- (IBAction)pressFlowBtn:(id)sender {
    id value = [self.pWC.iuController valueForKeyPath:@"selection.iuFrame.currentScreenFrame.flowLayout"];
    BOOL flow;
    if (value == nil || value == NSNotApplicableMarker || value == NSNoSelectionMarker) {
        return;
    }
    if (value == NSMultipleValuesMarker) {
        flow = YES;
    }
    else{
        flow = [value boolValue];
    }

    for (IUObj *iu in self.pWC.iuController.selectedObjects) {
        if ([iu shouldChangeFlowLayoutByUserInput:!flow] == NO) {
            [self updateFlowLayout]; // update 를 불러주지 않으면 toolbar 에서 개김
            return;
        }
    }
    [self.pWC.iuController setValue:@(!flow) forKeyPath:@"selection.iuFrame.currentScreenFrame.flowLayout"];
    [self.flowBtn setState:!flow];
}




- (IBAction)pressScreenTypeBtn:(id)sender {
    
    NSPopUpButton *screenTypeButton = sender;
    NSInteger type =[screenTypeButton indexOfSelectedItem];
    
    self.pWC.selectedScreenType = type;
}


- (IBAction)pressClearColorBtn:(id)sender {
    [self setValue:nil forKeyPath:@"pWC.iuController.selection.bg.color"];
}

- (IBAction)pressBgManulBtn:(id)sender {
    id value = [self.pWC.iuController valueForKeyPath:@"selection.bg.bgSize"];
    
    IUBGSize bgSize;
    
    if (value == nil || value == NSNotApplicableMarker || value == NSNoSelectionMarker) {
        return;
    }
    if(value == NSMultipleValuesMarker){
        bgSize = IUBGSizeNone;
    }else{
        bgSize = (IUBGSize)([value integerValue] +1 );
        if(bgSize == IUBGSizeCount){
            bgSize = IUBGSizeNone;
        }
    }
    
    [self.pWC.iuController setValue:@(bgSize) forKeyPath:@"selection.bg.bgSize"];
}

@end
