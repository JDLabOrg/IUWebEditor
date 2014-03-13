//
//  JDDataStructUtil.h
//  Mango
//
//  Created by JD on 13. 2. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol JDPropertyListDelegate <NSObject>
@required
+(NSArray*) propertyList;
@end

@interface JDDataStructUtil : NSObject

+(NSMutableDictionary*) mutableDictWithNullObjectsAndKeysWithCount:(NSUInteger)count, ... NS_REQUIRES_NIL_TERMINATION;


@end

@interface NSArray (JDExtension)
- (id)firstObject;
- (id)firstObjectOfClass:(Class)aClass;
- (id)objectAtIndexOrNil:(NSUInteger)index;
- (BOOL)containsString:(NSString*)string;
-(id)objectBeforeObject:(id)obj;
-(id)objectAfterObject:(id)obj;
-(id)objectForStringKey:(NSString*)itemKey key:(NSString*)key;
@end

 

@interface NSMutableArray (JDExtension)
-(void)addObjectIgnoreNil:(id)obj;
-(void)insertObject:(id)obj afterObj:(id)obj;
-(void)insertObject:(id)obj beforeObj:(id)obj;
-(id)nextOfObject:(id)obj;
-(id)prevOfObject:(id)obj;
@end

@interface NSMutableDictionary(JDExtension)
- (id)objectForKey:(id)aKey removeObjectForKey:(BOOL)remove;
- (void)setObjectRemoveNil:(id)object forKey:(id)key;

- (void)removeObjectsForKeyStrings:(NSString*)key1, ... NS_REQUIRES_NIL_TERMINATION;

-(void)setInteger:(NSInteger)val forKey:(id)key;
-(void)setInteger:(NSInteger)val forKey:(id)key ignoreZero:(BOOL)ignoreZero;

-(void)setFloat:(float)val forKey:(id)key;
-(void)setFloat:(float)val forKey:(id)key ignoreZero:(BOOL)ignoreZero;

-(void)setBool:(BOOL)val forKey:(id)key;

-(void)setObjectFromObject:(NSObject*)obj withKeys:(NSString*)key1,...NS_REQUIRES_NIL_TERMINATION;

+(NSMutableDictionary*)mutableDictionaryFromObject:(NSObject*)object withKeys:(NSString*)key1,...NS_REQUIRES_NIL_TERMINATION;


#define kMDExIgnoreZero @"ignoreZero"
#define kMDExIgnoreNil @"ignoreNil"
#define kMDExModifier   @"modifier"
#define kMDExModifierParam  @"modifierParam"
#define kMDExOutputDictKey  @"outputDictKey"
#define kMDExDictForTrue    @"dictForTrue"
#define kMDExDefault    @"default"

#define kMDExModifierPixel @"px"
#define kMDExModifierURL @"url"
#define kMDExModifierPercent @"percent"


-(void)putInt:(NSInteger)intValue forKey:(id)key param:(NSDictionary*)param;
-(void)putFloat:(CGFloat)value forKey:(id)key param:(NSDictionary*)param;
-(void)putString:(NSString*)strValue forKey:(id)key param:(NSDictionary*)param;
-(void)putStringOrRemoveKey:(NSString*)strValue ifTrue:(BOOL)ifTrue forKey:(id)key param:(NSDictionary*)param;
-(void)putDictionary:(NSDictionary*)dict;
-(void)putDictionary:(NSDictionary*)dict ifTrue:(BOOL)ifTrue;
-(void)removeKeys:(NSArray*)keys;
-(void)removeObjectForKey:(id)key param:(NSDictionary*)param;
-(void)merge:(NSDictionary*)overwriteDict;
@end

@interface NSDictionary (JDExtension)
+(NSDictionary*)dictionaryFromObject:(NSObject*)object withKeys:(NSString*)key1,...NS_REQUIRES_NIL_TERMINATION;
-(NSDictionary*)dictionaryWithMerging:(NSDictionary*)overwriteDict;
-(void)exportToObj:(id)obj;
@end

typedef enum _SORGXMatchOption{
    SORGXMatchOptionExtractToEnd
}SORGXMatchOption;

@interface NSString (JDExtension)
-(NSString*)stringEscape;
- (NSString*)lastLine;
- (NSString*)dirOfFile;
- (BOOL)isHTTPURL;
- (NSString*)changeFileNameWithExtensionUntouched:(NSString*)fileName;
- (NSString*)stringByAppendFileNameWithExtensionUntouched:(NSString*)appendingString;

- (NSString*)stringByAppendingPathComponents:(NSArray*)paths;
- (NSString*)stringByPathDiff:(NSString*)path;

- (NSString*)stringByTrimEndWithChar:(char)c;
- (NSString*)trim;

- (NSString*) relativePathTo: (NSString*) endPath;
- (BOOL) containsString:(NSString*)string;

- (NSString*)nameWithoutExtensionAsFile;
- (NSString*)substringToChar:(unichar)charecter;
- (NSString*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

- (NSString*)stringByChangeExtension:(NSString*)extension;
- (NSString*)stringByIndent:(NSUInteger)indent;

- (BOOL)isValidEmail;
#define RGXEmailPattern @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"

- (NSArray*) RGXMatchAllStringsWithPatten:(NSString*)patten;


@end

@interface NSMutableString(JDExtension)
- (void)appendString:(NSString*)string multipleTimes:(NSUInteger)multipleTimes;
- (void)appendStringIfNotNil:(NSString*)string;
@end


@interface NSIndexPath(JDExtension)
#define NSOrderedNone 0
/*
 NSOrderedAscending: The receiving index path is ancestor of indexPath.
 NSOrderedDescending: The receiving index path comes after indexPath.
 NSOrderedSame: The receiving index path and indexPath are the same index path.
 NSOrderedNone: The receiving index path does not have relation of ancestor with indexPath.
 */

- (NSComparisonResult)compareAncestor:(NSIndexPath*)indexPath;
@end



@interface NSArray (Reverse)
- (NSArray *)reversedArray;
@end

@interface NSMutableArray (Reverse)
- (void)reverse;
@end