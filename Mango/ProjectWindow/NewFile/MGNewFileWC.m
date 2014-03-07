//
//  MGNewFileWC.m
//  Mango
//
//  Created by JD on 13. 6. 28..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGNewFileWC.h"
#import "MGProjectWC.h"
#import "IUProject.h"
#import "IUPresProject.h"


@implementation MGNewFileWC {
    NSArray *templateWidgets;
    NSArray *pageWidgets;
    NSArray *compWidgets;
    MGFileItem *fileItem;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        self.fileFormat = @".pgiu";
    }
    
    return self;
}

-(id)initWithWindowNibName:(NSString *)windowNibName fileItem:(MGFileItem*)_fileItem{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        fileItem = _fileItem;
        self.fileFormat = @".pgiu";
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self addObserver:self forKeyPaths:@[@"fileName",@"selectedIdx"] options:0 context:nil];
    templateWidgets = [[self.project class] templateWidgets];
    pageWidgets = [[self.project class] pageWidgets];
    compWidgets = [[self.project class] compWidgets];

    if ([_project isKindOfClass:[IUPresProject class]]) {
        MGFileItem *lostFileItem = [[self.project pageFileItems].array lastObject];
        NSString *lostFileName = [lostFileItem name];
        NSUInteger lostFileNameInt = [lostFileName intValue];
        NSUInteger newFileNameInt = lostFileNameInt + 1;
        self.fileName = [NSString stringWithFormat:@"%ld",newFileNameInt];
    }
    switch (fileItem.type) {
        case MGFileItemTypeCOIU:
            self.selectedFileType = 2;
            break;
            
        case MGFileItemTypeTMIU:
            self.selectedFileType = 1;
            break;
        default:
            self.selectedFileType =0;
    }
    
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"fileName", @"selectedIdx"]];
}


-(void)setSelectedFileType:(NSUInteger)selectedFileType{
    _selectedFileType = selectedFileType;
    switch (selectedFileType) {
        case 0:
            self.currentSelectableIUs = pageWidgets;
            self.fileFormat = @".pgiu";
            break;
        case 1:
            self.currentSelectableIUs = templateWidgets;
            self.fileFormat = @".tmiu";
            break;
        case 2:
            self.currentSelectableIUs = compWidgets;
            self.fileFormat = @".coiu";
            break;
        default:
            break;
    }
    NSIndexSet *selectSet = [[NSIndexSet alloc] initWithIndex:0];
    [self.collectionV setSelectionIndexes:selectSet];
}

-(void)setSelectedIUIndexSet:(NSIndexSet *)selectedIUIndexSet{
    _selectedIUIndexSet = selectedIUIndexSet;
    if ([selectedIUIndexSet count] == 0) {
        return;
    }
    NSUInteger index = [selectedIUIndexSet firstIndex];
    self.selectedIUWidget = [self.currentSelectableIUs objectAtIndex:index];
}


- (IBAction)pressCancel:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseCancel];
}

- (IBAction)pressConfirm:(id)sender {
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
}

-(NSString*)fullFileName{
  
    NSAssert(self.selectedFileType>0 | self.selectedFileType < 2, @"file type overranged");
    
    return [_fileName stringByAppendingString:self.fileFormat];
}


-(void)fileNameDidChange{
    if ([_fileName length] == 0) {
        self.isConfirmEnabled = NO;
        return;
    }
    if ([self.project.rootFileItem childOfName:[self fullFileName]]) {
        self.isConfirmEnabled = NO;
        return;
    }
    self.isConfirmEnabled = YES;
}

@end
