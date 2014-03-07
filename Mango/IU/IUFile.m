//
//  IUSet.m
//  Mango
//
//  Created by JD on 6/25/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUFile.h"
#import "MGFileItem.h"
#import "IUViewManager.h"
#import "IUScreenFrame.h"

@implementation IUFile{
    NSArray *availableDeviceLists;
}

+(NSArray*)propertyList{
    return @[@"sampleImage", @"sampleImageXModifier", @"sampleImageYModifier"];
}

+(NSMutableArray *)undoPropertyList{
    
    NSMutableArray *array = [super undoPropertyList];
    
    [array addObjectsFromArray:@[@"sampleImage",
             @"sampleImageXModifier",
             @"sampleImageYModifier"
             ]];
    return array;
}


-(NSMutableString*)buildOutputSource:(NSString*)CSS HTML:(NSString*)HTML{
    return [NSMutableString stringWithFormat:@"<style> %@ </style><body style='margin:0px; padding:0px; background-color:transparent;'> %@ </body>",CSS, HTML];
}




-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:dict[@"IUFile"] ofClass:[IUFile class]];
}

-(id)init{
    self = [super init];
    if (self) {
        self.referenceIUs = [NSMutableArray array];
        self.receiverCTX = [NSMutableDictionary dictionary];
        self.triggerCTX = [NSMutableDictionary dictionary];
        self.variableCTX = [NSMutableDictionary dictionary];
        self.variables = [NSMutableArray array];
    }
    return self;
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    dict[@"IUFile"] = [self exportPropertyFromDictOfClass:[IUFile class]];
    return dict;
}


- (void)saveAsFile{
    assert(self.fileItem != nil);
    
    BOOL result = [self.IUMLData writeToFile:self.fileItem.absolutePath atomically:YES];
    if (!result) {
        [MGAppController log:[NSString stringWithFormat: @"save to file error :%@", self.fileItem.absolutePath]];
    }
}

- (void)saveAsFileWithPath:(NSString*)path{
    BOOL result = [self.IUMLData writeToFile:path atomically:YES];
    if (!result) {
        [JDLogUtil alert:[NSString stringWithFormat: @"Save File Error %@",path]];
    }
}


-(void)redrawSampleImage{
    self.sampleImage = self.sampleImage;
}

-(void)iuLoad{
    [super iuLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawSampleImage) name:@"IUManagerDidLoad" object:self.iuManager];
    [self addObserver:self forKeyPath:@"fullWebSource" options:0 context:nil];
}


-(void)setSampleImage:(NSString *)sampleImage{
    _sampleImage = sampleImage;
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: [self.project.absoluteResDirPath stringByAppendingPathComponent:sampleImage]];
    [self.iuManager.iuViewManager setGridGhostImage:image];
}

-(void)setSampleImageXModifier:(NSInteger)sampleImageXModifier{
    _sampleImageXModifier = sampleImageXModifier;
    [self.iuManager.iuViewManager setGridGhostXModifier:sampleImageXModifier];
}

-(void)setSampleImageYModifier:(NSInteger)sampleImageYModifier{
    _sampleImageYModifier = sampleImageYModifier;
    [self.iuManager.iuViewManager setGridGhostYModifier:sampleImageYModifier];
}

- (void)deleteAsFile{
    [[NSFileManager defaultManager] removeItemAtPath:self.fileItem.absolutePath error:nil];
}

- (BOOL)renameAsFile:(NSString*)newName{
    
    if([[self.fileItem.name pathExtension] isEqualToString:@"tmiu"]){
        [JDLogUtil alert:@"Can't change template name"];
        return NO;
    }
    
    NSString *newAbsolutePath = [[[self.fileItem absolutePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:newAbsolutePath]) {
        [JDLogUtil alert:@"file exist in same path"];
        return NO;
    }
    [self.iuManager.pWC.IUManagers removeObjectForKey:self.fileItem.absolutePath];
    [[NSFileManager defaultManager] moveItemAtPath:self.fileItem.absolutePath toPath:newAbsolutePath error:nil];
    self.fileItem.name = newName;
    [self.iuManager.pWC.IUManagers setObject:self.iuManager forKey:self.fileItem.absolutePath];
    return YES;
}

- (NSDictionary*)emptyJSDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@{} forKey:@"_IUVariable_CTX_"];
    [dict setObject:@{} forKey:@"_IUReceiver_CTX_"];
    [dict setObject:@{} forKey:@"_IUTrigger_CTX_"];
    return dict;
}

- (void)buildJS{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.jsVariableDictionary) {
        [dict setObject:self.jsVariableDictionary forKey:@"_IUVariable_CTX_"];
    }
    else{
        [dict setObject:@{} forKey:@"_IUVariable_CTX_"];
    }
    if (self.jsReceiverDictionary) {
        [dict setObject:self.jsReceiverDictionary forKey:@"_IUReceiver_CTX_"];
    }
    else{
        [dict setObject:@{} forKey:@"_IUReceiver_CTX_"];
    }
    if (self.jsTriggerDictionary) {
        [dict setObject:self.jsTriggerDictionary forKey:@"_IUTrigger_CTX_"];
    }
    else{
        [dict setObject:@{} forKey:@"_IUTrigger_CTX_"];
    }
    self.JSReplaceDict = dict;
}


-(NSDictionary*)JSDict2{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([self jsVariableDictionary]) {
        [dict setObject:[self jsVariableDictionary] forKey:@"_IUVariable_CTX_"];
    }
    else{
        [dict setObject:@{} forKey:@"_IUVariable_CTX_"];
    }
    if ([self jsReceiverDictionary ]) {
        [dict setObject:[self jsReceiverDictionary ] forKey:@"_IUReceiver_CTX_"];
    }
    else{
        [dict setObject:@{} forKey:@"_IUReceiver_CTX_"];
    }
    if ([self jsTriggerDictionary]) {
        [dict setObject:[self jsTriggerDictionary] forKey:@"_IUTrigger_CTX_"];
    }
    else{
        [dict setObject:@{} forKey:@"_IUTrigger_CTX_"];
    }
    return dict;
}

-(NSString*)source:(IUSourceType)type{
    assert(0);
    return nil;
}

-(NSMutableDictionary*)sourceReplacementDict:(IUSourceType)type{
    assert(0);
    return nil;
}
@end