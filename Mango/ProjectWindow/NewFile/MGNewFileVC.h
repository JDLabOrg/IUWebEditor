//
//  MGNewFileVC.h
//  Mango
//
//  Created by JD on 13. 6. 28..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>

@interface MGNewFileVC : NSViewController{
    NSString *fileName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil project:(IUProject*)project;

@property (weak) IBOutlet NSCollectionView *collectionV;

@property (nonatomic) NSIndexSet *selectedIndexSet;
@property NSArray  *currentSelectableIUs;
@property NSString *selectedTypeName;
@property NSString *selectedTypeDesc;
@property NSString *fileName;
@property NSUInteger    selectedIdx;
@property MGProjectWC   *pWC;
@end
