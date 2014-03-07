//
//  MGNewFileWC.h
//  Mango
//
//  Created by JD on 13. 6. 28..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUWidget.h"


@interface MGNewFileWC : NSWindowController{
}

-(id)initWithWindowNibName:(NSString *)windowNibName fileItem:(MGFileItem*)fileItem;
@property (weak) IBOutlet NSCollectionView *collectionV;

@property (nonatomic) NSIndexSet    *selectedIUIndexSet;
@property (nonatomic) NSArray       *currentSelectableIUs;
@property (nonatomic) IUWidget      *selectedIUWidget;

@property (nonatomic) NSUInteger    selectedFileType;
@property (nonatomic) NSString      *fileName;
@property (nonatomic) NSString      *fileFormat;

@property (nonatomic) IUProject *project;

@property BOOL  isConfirmEnabled;
-(NSString*)fullFileName;
@end
