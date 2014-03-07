//
//  IUProperty.m
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUProperty.h"
#include "JDRuntime.h"

@implementation IUProperty

#pragma mark -
#pragma mark init


-(id)init{
    self = [super init];
    if (self) {
        if ([self enableUndo]) {
            [self addObserver:self forKeyPaths:[[self class] allUndoPropertyList] options:NSKeyValueObservingOptionOld context:@"undoStack"];
        }
    }
    return self;
}

-(void)dealloc{
    if ([self enableUndo]) {
        [self removeObserver:self forKeyPaths:[[self class] allUndoPropertyList] context:@"undoStack"];
    }
}


#pragma mark -
#pragma mark UndoManager



/*******************
 ** Undomanager
 *
 
1.  IUProperty Class -  undoStackContextDidChange: (default method)
2.  IUProperty is default class of IUObj,  IUBG, IUCSS, IUFrame
3.  Undostack includes all memeber of IUPropery
    //using below methods to redefine
    +(NSArray*)undoPropertyList;
    +(NSArray*)undoPropertyListExclude;
4.  IUmanager has one undoManager
5.  Each undomanager of IUProperty binds to undomanager of IUManager
 
6.  UndoStack (property (value))
    1. setXXX
    2. if you additional operation, make XXXUndoInvocation()
    3. If each class needs defulat undo operation, make IUClassNameUndoInvocation
    4. example) x = 18 -> x = 15 and undo
        1. x = 15 ( = [self setX:15])
        2. xUndoInvocation{ //e.g. setNeedsDisplay } or
        3. IUScreenFrameUndoInvocation{ //e.g. setNeedsDisplay }
 
7. UndoStack - makeIU, removeIU
    1. invocationd dependent (inside in methods)
    2. new IU
        1. makeIU() or addIU()
        2. insertIU() -------------------------- undo invocation : undoInsertIU()
    3. remove IU
        1.removeCurrentIU()
        2. removeIU() ------------------------- undo invocation : undoRemoveIU()
        3.removeFromSuperIU()
 *
 *
 ********************/

+(NSArray*)autoUndoPropertyList{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        if ([name length] > 10 && [name containsString:@"_XProperty"]) {
            continue;
        }
        if ([self respondsToSelector:@selector(undoPropertyListExclude)]) {
            if ([[self undoPropertyListExclude] containsString:name]) {
                continue;
            }
        }
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}


+(NSMutableArray*)undoPropertyList{
    return [NSMutableArray array];
}

-(BOOL)enableUndo{
    return YES;
}

+(NSArray*)allUndoPropertyList{
    NSMutableArray *arr = [NSMutableArray array];
    Class selfClass = [self class];
    while (1) {
        if (selfClass == [IUProperty class]) {
            break;
        }
        NSArray *undoPropertyList = [selfClass undoPropertyList];
        for (NSString *property in undoPropertyList) {
            if ([arr containsString:property] == NO) {
                [arr addObject:property];
            }
        }
        selfClass=[selfClass superclass];
    }
    return [NSArray arrayWithArray:arr];
}




-(void)undoStackContextDidChange:(NSDictionary*)change{
    if (self.undoManager.isUndoRegistrationEnabled == NO) {
        return;
    }
    id currentVal = [self valueForKey:[change objectForKey:kJDKeyPath]];
    id oldVal = [change objectForKey:NSKeyValueChangeOldKey];
    //NSNull objects are used to represent nil in a dictionary
    if (oldVal == [NSNull null]) {
        oldVal = nil;
    }
    if (currentVal != oldVal) {
        [[self undoManager] beginUndoGrouping];
        [[[self undoManager] prepareWithInvocationTarget:self] setValue:oldVal forKey:[change objectForKey:kJDKeyPath]];
        [[self undoManager] setActionName:[change objectForKey:kJDKeyPath]];
        
        //각각의 property가 가지는 undo invocation.
        NSString *selectorName = [NSString stringWithFormat:@"%@UndoInvocation", kJDKeyPath];
        SEL s = NSSelectorFromString(selectorName);
        if([self respondsToSelector:s]){
            [[self undoManager] registerUndoWithTarget:self selector:s object:nil];
        }
        
        //각각의 클래스 별로 공통으로 가지는것.
        selectorName = [NSString stringWithFormat:@"%@UndoInvocation", [self className]];
        s = NSSelectorFromString(selectorName);
        if([self respondsToSelector:s]){
            [[self undoManager] registerUndoWithTarget:self selector:s object:nil];
        }
        
        [[self undoManager] endUndoGrouping];
    }
}



#pragma mark -
#pragma mark observing

+(NSArray*)autoPropertyList{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        if ([name length] > 10 && [name containsString:@"_XProperty"]) {
            continue;
        }
        if ([self respondsToSelector:@selector(propertyListExclude)]) {
            if ([[self propertyListExclude] containsString:name]) {
                continue;
            }
        }
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *contextStr = (__bridge NSString *)(context);
    if ([contextStr isEqualToString:@"undoStack"]) {
        NSMutableDictionary *mchange = [[NSDictionary dictionaryWithDictionary:change] mutableCopy];
        [mchange setObject:keyPath forKey:kJDKeyPath];
        change = [NSDictionary dictionaryWithDictionary:mchange];

        [self undoStackContextDidChange:change];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IUChangedNotification" object:nil];
}


#pragma mark -
#pragma mark dictionary

-(void)loadWithDict:(NSDictionary*)dict{
}

-(NSMutableDictionary*)dict{
    return [NSMutableDictionary dictionary];
}


-(void)importPropertyFromDict:(NSDictionary*)dict ofClass:(Class)aClass{
    NSString* property;
    for (NSString *s in [aClass propertyList]) {
        property = s;
        id v = [dict objectForKey:property];
        if (v) {
            /* is property is NSColor? */
            objc_property_t p = class_getProperty(aClass, [property UTF8String]);
            NSString *type = [JDRuntime getPropertyType:p];
            Class typeClass = NSClassFromString(type);
            if ([typeClass isSubclassOfClass:[NSColor class]]){
                v = [(NSString*)v color];
            }
            if ([self validateValue:&v forKey:property error:nil]) {
                [self setValue:v forKey:property];
            }
        }
    }
}

-(NSMutableDictionary*)exportPropertyFromDictOfClass:(Class)aClass{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString* property in [aClass propertyList]) {
        id value = [self valueForKey:property];
        if ([value isKindOfClass:[NSColor class]]) {
            value = [(NSColor*)value rgbString];
        }
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:value]];
        }
        [dict setObjectRemoveNil:value forKey:property];
    }
    return dict;
}


-(void)setProperties:(NSDictionary *)properties{
    for (NSString *key in properties) {
        id value = [properties objectForKey:key];
        id obj = self;
        NSArray *propertyChain = [key componentsSeparatedByString:@"."];
        
        for (int i=0; i<[propertyChain count]-1; i++) {
            id innerKey = [propertyChain objectAtIndex:i];
            obj = [obj valueForKey:innerKey];
        }
        [obj setValue:value  forKey:[propertyChain lastObject]];
    }
}

#pragma mark -
#pragma mark class hierachy

-(NSArray*)classPedigree{
    NSMutableArray *arr = [NSMutableArray array];
    Class selfClass = [self class];
    while (1) {
        if (selfClass == [IUProperty class]) {
            break;
        }
        [arr addObject:NSStringFromClass(selfClass)];
        selfClass=[selfClass superclass];
    }
    return [NSArray arrayWithArray:arr];
}
@end
