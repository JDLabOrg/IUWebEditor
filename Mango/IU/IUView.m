//
//  IUGroup.m
//  Mango
//
//  Created by JD on 13. 2. 3..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUView.h"
#import "IUObjs.h"
#import "IUManager.h"
#import "IULayerOld.h"
#import "IUCSS.h"
#import "IUViewManager.h"

@implementation IUView


@synthesize formTarget;
@synthesize children;


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


+(NSArray*)propertyList{
    return @[@"formTarget",];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObject:@"formTarget"];
    return array;
}

#pragma mark -
#pragma mark initialize


- (id)init
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
        cachedChildren = [NSMutableArray array];
        
    }
    return self;
}

-(void)setIuManager:(IUManager *)iuManager{
    [super setIuManager:iuManager];
    for (IUObj *obj in self.children) {
        [obj setIuManager:iuManager];
    }
}

-(id)instantiate{
    [super instantiate];
    return self;
}


-(void)iuLoad{
    [super iuLoad];
    for (IUObj *iu in self.children){
        [iu iuLoad];
        iu.iuLoaded = YES;
    }
}


-(void)dealloc{
    if (self.iuManager) {
    }
}


-(void)autoSetIUName{
    self.name = [self.iuManager makeNewIUName:self.className];
    for (IUObj *iu in children) {
        [iu autoSetIUName];
    }
}


#pragma mark -
#pragma mark dict

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    if (dict) {
        NSMutableDictionary *myDict = [self exportPropertyFromDictOfClass:[IUView class]];
        NSMutableArray *childIUML = [NSMutableArray array];
        for (IUObj * obj in children) {
            [childIUML addObject:[obj dict]];
        }
        
        if ([childIUML count]){
            [myDict setObject:childIUML forKey:@"children"];
        }
        [dict setObject:myDict forKey:@"IUView"];
    }
    return dict;
}


-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSMutableDictionary *myDict = [dict objectForKey:@"IUView"];
    [self importPropertyFromDict:myDict ofClass:[IUView class]];
    
    NSMutableArray *childrenArray = [myDict objectForKey:@"children"];
    //    [childrenArray sortUsingDescriptors:@[DefinedIUSortDescriptor]]; // zindex 에 따라 넣기
    
    for (NSMutableDictionary *childDict in childrenArray) { // zIndex가 작은것부터 넣는다.
        NSString *className = [childDict objectForKey:@"type"];
        IUObj *obj = [[NSClassFromString(className) alloc] init];
        //        obj.iuManager = self.iuManager;
        if (self.loadFromFile) {
            obj.loadFromFile = YES;
        }
        [obj loadWithDict:childDict]; // 그래야 parent 값이 제대로 들어감
        [self addIU:obj error:nil];
    }
}


-(NSString*)insertionJavascript{
    NSMutableString *js = [[super insertionJavascript] mutableCopy];
    for (IUObj *child in self.allChildren ) {
        [js appendString:@"\n"];
        [js appendString:child.CSSChangeJavascript];
    }
    return js;
}

#pragma mark -
#pragma mark relatedtoChildren


-(NSArray*)childrenIUinRect:(NSRect)rect{
    NSMutableArray  *ret = [NSMutableArray array];
    for (IUObj *child in self.children) {
        if (isNSRectContainsRect(rect, child.iuFrame.frame)){
            [ret addObject:child];
        }
    }
    return [ret copy];
}




-(NSUInteger)indexOfIU:(IUObj*)iu{
    return [self.children indexOfObject:iu];
}


-(BOOL)isLeaf{
    return NO;
}




-(NSMutableArray*)allChildren{
    NSMutableArray *retArray = [NSMutableArray array];
    for (IUObj *obj in self.children) {
        [retArray addObject:obj];
        if ([obj isKindOfClass:[IUView class]]) {
            [retArray addObjectsFromArray:[(IUView*)obj allChildren]];
        }
    }
    return retArray;
}


#pragma mark -
#pragma mark manage IU hierachy

-(IUObj*)iuHitTest:(NSPoint)point{
    if ([super iuHitTest:point]) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"z" ascending:NO];
        NSArray *sortedChildren = [self.children.reversedArray sortedArrayUsingDescriptors:@[sortDescriptor]];

        for (IUObj *child in sortedChildren) {
            IUObj *hit = [child iuHitTest:point];
            if (hit) {
                return hit;
            }
        }
        return self;
    }
    return nil;
}

-(NSInteger)nextZIndex{
    NSInteger retValue = 1;
    for (IUObj *iu in children) {
        if (iu.z < 1000 && iu.z >= retValue) {
            retValue = iu.z + 1;
        }
    }
    return retValue;
}

-(BOOL)addIU:(IUObj *)iu  error:(NSError**)error{
    NSInteger index = [self.children count];
    return [self insertIU:iu atIndex:index error:error];
}


-(BOOL)insertIU:(IUObj *)iu atIndex:(NSInteger)index  error:(NSError**)error{
    if(iu== nil){
        return NO;
    }
    
    [self.undoManager beginUndoGrouping];
    
    
    IUView *parent = self;
    [iu bind:@"iuManager" toObject:parent withKeyPath:@"iuManager" options:nil];
//    iu.iuManager = parent.iuManager;
    [self.iuManager.iuViewManager disableUpdate:self];
    [self.iuManager.iuViewManager disableSelection:self];
    
    /*tree hierechy*/
    iu.parent = parent;
    [[parent mutableArrayValueForKey:@"children"] insertObject:iu atIndex:index];
    [parent.iuManager.pWC.iuController rearrangeObjects];

    [parent.iuManager.iuViewManager setInsertedIUNeedsDisplay:iu];
    [self.iuManager.iuViewManager enableSelection:self];
    [parent.iuManager.iuViewManager enableUpdate:self];
    
    /* Undo */
    [[self.undoManager prepareWithInvocationTarget:iu.parent] undoInsertIU:iu];
    [self.undoManager endUndoGrouping];
    
    return YES;
}

-(void)undoInsertIU:(IUObj *)iu{
    [self.iuManager.iuViewManager disableUpdate:self];

    [iu.parent removeIU:iu];
    [self.iuManager.pWC.iuController setSelectionObject:nil];
    [self.iuManager.pWC.iuController rearrangeObjects];
    
    
    [self.iuManager.iuViewManager enableUpdate:self];
}

-(BOOL)removeFromSuperIU:(id)sender{
    if(self.children){
        for(IUObj *obj in self.allChildren){
            [obj.borderLayer removeFromSuperlayer];
            [obj.assitLayer removeFromSuperlayer];
        }
        
    }
    return [super removeFromSuperIU:sender];
}


-(BOOL)removeIU:(IUObj *)iu{
    NSAssert([self.children containsObject:iu], @"Has No IU");
    
    [self.undoManager beginUndoGrouping];
    [self.iuManager.iuViewManager disableUpdate:self];
    if ([iu removeFromSuperIU:self]){

        NSInteger index = [self.children indexOfObject:iu];
        
        [[self mutableArrayValueForKey:@"children"] removeObject:iu];
        
        [self.iuManager.iuViewManager enableUpdate:self];
        [[self.undoManager prepareWithInvocationTarget:iu.parent] undoRemoveIU:iu index:index];
        [self.undoManager endUndoGrouping];

        return YES;
    }
    else{
        
        [self.undoManager endUndoGrouping];
        [self.iuManager.iuViewManager enableUpdate:self];
        return NO;
    }

}

-(void)undoRemoveIU:(IUObj *)iu index:(NSInteger)index{
    [self.iuManager.iuViewManager disableUpdate:self];
    
    [self insertIU:iu atIndex:index error:nil];
    [self.iuManager.iuViewManager setBorderLayer:iu];

    [self.iuManager.pWC.iuController setSelectionObject:iu];
    [self.iuManager.pWC.iuController rearrangeObjects];
    
    [self.iuManager.iuViewManager enableUpdate:self];

}

-(void)moveIU:(IUObj*)iu to:(NSInteger)index{
    NSAssert(index >= 0, @"zIndex Too Small");
    NSAssert(index < self.children.count + 1, @"zIndex Too Large");
    
    [[self.undoManager prepareWithInvocationTarget:self] moveIU:iu to:iu.index];
    [self.children removeObject:iu];
    [self.children insertObject:iu atIndex:index];
    [self.iuManager.pWC.iuController rearrangeObjects];
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];
}


#pragma mark -
#pragma mark CSS

-(NSMutableString*)CSSSourceWithScreenType:(IUScreenType)screenType{
    NSMutableString *retStr = [super CSSSourceWithScreenType:screenType];
    for (IUObj *iu in self.children) {
        [retStr appendString:@"\n"];
        [retStr appendString:[iu CSSSourceWithScreenType:screenType]];
    }
    return retStr;
}

#pragma mark HTML

-(NSString*)HTMLTag2{
    if (formTarget) {
        return @"form";
    }
    else{
        return @"div";
    }
}

-(BOOL)preventMarginCollapse{
    return YES;
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    if (self.formTarget) {
        [dict putString:@"post" forKey:@"method" param:nil];
        NSString *target = [[self.formTarget stringByDeletingPathExtension] stringByAppendingPathExtension:@"html"];
        [dict putString:target forKey:@"action" param:nil];
    }
    return dict;
}

-(NSString*)innerHTML2:(id)caller{
    NSMutableString *str = [[super innerHTML2:caller] mutableCopy];
    if (self.children.count) {
        // to prevent margin-collapse, add <p> tag
        if ([self preventMarginCollapse]) {
            [str appendString:@"<p style=\"font-size: 0px; line-height: 0px;\">&nbsp;</p>"];
        }
        for (IUObj *childIU in self.children) {
            if ([childIU HTMLSource2:caller]) {
                [str appendString:[childIU HTMLSource2:caller]];
                [str appendString:@"\n"];
            }
        }
        if ([self preventMarginCollapse]) {
            [str appendString:@"<p style=\"font-size: 0px; line-height: 0px;\">&nbsp;</p>"];
        }
    }
    return str;
}

-(NSString*)innerOutputHTML2{
    NSMutableString *str = [NSMutableString stringWithString:[super innerOutputHTML2]];
    if (self.children.count) {
        if (self.formTarget) {
            [str appendString:[self.iuManager.project.compiler statementOfCSRF]];
        }
        if ([self preventMarginCollapse]) {
            [str appendString:@"<p style=\"font-size: 0px; line-height: 0px;\">&nbsp;</p>"];
        }
        
        for (IUObj *childIU in self.children) {
            if ([childIU outputHTMLSource2:self]){
                [str appendString:[childIU outputHTMLSource2:self]];
                [str appendString:@"\n"];
            }
        }
        [str replaceOccurrencesOfString:@"\n" withString:@"\n  " options:0 range:NSMakeRange(0, str.length)];
        
        if ([self preventMarginCollapse]) {
            [str appendString:@"<p style=\"font-size: 0px; line-height: 0px;\">&nbsp;</p>"];
        }
    }
    return str;
}


#pragma mark Javascript

-(NSMutableDictionary*)jsVariableDictionary{
    NSMutableDictionary *dict = [super jsVariableDictionary];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    for (IUObj *obj in self.allChildren) {
        [dict merge:obj.jsVariableDictionary];
    }
    return dict;
}


-(NSMutableDictionary*)jsTriggerDictionary{
    NSMutableDictionary *dict = [super jsTriggerDictionary];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    for (IUObj *obj in self.allChildren) {
        [dict merge:obj.jsTriggerDictionary];
    }
    return dict;
}

-(NSMutableDictionary*)jsReceiverDictionary{
    NSMutableDictionary *dict = [super jsReceiverDictionary];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    for (IUObj *obj in self.allChildren) {
        [dict merge:obj.jsReceiverDictionary];
    }
    return dict;
}

-(BOOL)childHasFocus{
    for (IUObj *iu in self.allChildren) {
        if (iu.hasFocus) {
            return YES;
        }
    }
    return NO;
}

@end
