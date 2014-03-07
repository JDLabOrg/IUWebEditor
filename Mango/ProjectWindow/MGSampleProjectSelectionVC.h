//
//  MGSampleProjectSelectionVC.h
//  WebGenerator
//
//  Created by JD on 2/6/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MGNewProjectWC;

@interface IUProjectSample : NSObject

@property (nonatomic, readonly) NSString              *name;
@property (nonatomic, readonly) NSString              *type;
@property (nonatomic, readonly) NSString              *directory;
@property (nonatomic, readonly) NSString              *projectFile;
@property (nonatomic, readonly) NSString              *desc;
@property (nonatomic, readonly) NSString              *pageSize;
@property (nonatomic, readonly) NSArray               *images;
@property (nonatomic, readonly) NSString              *feature;

-(IUProject*)project;
-(id)initWithDictionary:(NSDictionary*)dict;
-(NSImage*)firstImage;

@end



@interface MGSampleProjectSelectionVC  : NSViewController <NSCollectionViewDelegate>

@property (nonatomic)   NSImage           *selectionImage;
@property (nonatomic)   NSString          *imageIndexString;
@property (strong) IBOutlet NSArrayController *arrayController;

@property MGNewProjectWC *nProjectWC;

-(void)doubleClick:(id)sender;

@end
