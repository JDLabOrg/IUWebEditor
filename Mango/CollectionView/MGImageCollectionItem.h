//
//  MGImageCollectionItem.h
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGCollectionItem.h"



@interface MGImageCollectionItem : MGCollectionItem
@property (nonatomic) NSURL     *URL;
@property NSString *UTI;
@property BOOL  isImageFile;
@property BOOL  isMovieFile;
@property NSString      *relativePath;

@end