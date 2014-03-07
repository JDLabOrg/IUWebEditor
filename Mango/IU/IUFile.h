//
//  IUSet.h
//  Mango
//
//  Created by JD on 6/25/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUView.h"
#import "IUDefinition.h"
@class MGFileItem;


@interface IUFile : IUView{
    
}

@property NSMutableArray        *referenceIUs;
@property NSMutableArray        *variables;

@property MGFileItem    *fileItem;
@property (nonatomic)   NSString      *sampleImage;
@property (nonatomic)   NSInteger     sampleImageXModifier;
@property (nonatomic)   NSInteger     sampleImageYModifier;

@property NSMutableDictionary *receiverCTX;
@property NSMutableDictionary *triggerCTX; // trigger information{'event':'click', 'variable':
@property NSMutableDictionary *variableCTX; // variable information (defaultValue, value, range)

@property NSDictionary *JSReplaceDict;

- (void)buildJS;

- (void)saveAsFile;
- (void)saveAsFileWithPath:(NSString*)path;
- (void)deleteAsFile;
- (BOOL)renameAsFile:(NSString*)newName;
- (NSDictionary*)emptyJSDict;
- (NSMutableString*)buildOutputSource:(NSString*)CSS HTML:(NSString*)HTML;

-(NSString*)source:(IUSourceType)type;
-(NSMutableDictionary*)sourceReplacementDict:(IUSourceType)type;

@property NSArray *screenTypeLists;
@end
