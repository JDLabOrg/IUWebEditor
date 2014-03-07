//
//  MGObjSelectVC.h
//  Mango
//
//  Created by JD on 13. 4. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "MGCollectionItem.h"
#import "MGProjectWC.h"

@interface MGClassSelectVC : NSViewController <NSCollectionViewDelegate, NSPopoverDelegate>{
    NSArray      *classArray;
    __weak NSCollectionView *_collectionV;
    
    
}

@property (nonatomic) MGProjectWC *pWC;
@property NSArray   *classArray;
@property NSIndexSet   *selectedIndexes;
@property MGCollectionItem *selectedItem;
@property (weak) IBOutlet NSCollectionView *collectionV;
@property IUProject     *project;

@end
