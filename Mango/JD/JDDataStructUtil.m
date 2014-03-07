//
//  JDDataStructUtil.m
//  Mango
//
//  Created by JD on 13. 2. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDDataStructUtil.h"

@implementation JDDataStructUtil

+(NSMutableDictionary*) mutableDictWithNullObjectsAndKeysWithCount:(NSUInteger)count, ... {
	NSMutableDictionary* dict=[NSMutableDictionary	dictionary];
	va_list args;
    va_start(args, count);
    for (int i=0; i<count; i++)
    {
		id object=va_arg(args,id);
		id key=va_arg(args,id);
		if (object!=nil) {
			[dict setObject:object forKey:key];
		}
    }
    va_end(args);
	return dict;
}


@end

@implementation NSObject(JDExtension)



@end


@implementation NSArray (JDExtension)

- (id)firstObject{
    if (self.count == 0) {
        return nil;
    }
    return [self objectAtIndex:0];
}

- (id)firstObjectOfClass:(Class)aClass{
    for (id obj in self) {
        if ([obj isKindOfClass:aClass]) {
            return obj;
        }
    }
    return nil;
}

- (id)objectAtIndexOrNil:(NSUInteger)index{
    if (index >= [self count]) {
        return nil;
    }
    return [self objectAtIndex:index];
}

-(id)objectForStringKey:(NSString*)itemKey key:(NSString*)key{
    for (id obj in self) {
        if ([[obj valueForKey:key] isEqualToString:itemKey]) {
            return obj;
        }
    }
    return nil;
}

- (BOOL)containsString:(NSString*)string{
    for (NSString *str in self) {
        if ([str isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

-(id)objectBeforeObject:(id)obj{
    NSUInteger index = [self indexOfObject:obj];
    if (index == 0) {
        return nil;
    }
    else
        return [self objectAtIndex:index-1];
}

-(id)objectAfterObject:(id)obj{
    NSUInteger index = [self indexOfObject:obj];
    if (index == [self count]-1) {
        return nil;
    }
    else
        return [self objectAtIndex:index+1];
}


@end
@implementation NSMutableArray(JDExtension)
-(void)addObjectIgnoreNil:(id)obj{
    if (obj == nil){
        return;
    }
    [self addObject:obj];
}

-(void)insertObject:(id)obj1 afterObj:(id)obj2{
    NSUInteger idx = [self indexOfObject:obj2];
    [self insertObject:obj1 atIndex:idx+1];
}
-(void)insertObject:(id)obj beforeObj:(id)obj2{
    NSUInteger idx = [self indexOfObject:obj2];
    [self insertObject:obj atIndex:idx];
}

-(id)nextOfObject:(id)obj{
    NSUInteger idx = [self indexOfObject:obj];
    if (idx == NSNotFound || idx == self.count - 1) {
        return nil;
    }
    return [self objectAtIndex:idx+1];
}

-(id)prevOfObject:(id)obj{
    NSUInteger idx = [self indexOfObject:obj];
    if (idx == NSNotFound || idx == 0) {
        return nil;
    }
    return [self objectAtIndex:idx-1];
}
@end

@implementation NSMutableDictionary(JDExtension)


- (id)objectForKey:(id)aKey removeObjectForKey:(BOOL)remove{
    id v = [self objectForKey:aKey];
    if (remove) {
        [self removeObjectForKey:aKey];
    }
    return v;
}

- (void)removeObjectsForKeyStrings:(NSString*)key1, ... NS_REQUIRES_NIL_TERMINATION{
	va_list args;
    
    
    va_start(args, key1);
    [self removeObjectForKey:key1];
    while(1){
		NSString *key=va_arg(args,id);
        if (key == nil){
            return;
        }
        [self removeObjectForKey:key];
    }
}

- (void)setObjectRemoveNil:(id)object forKey:(id)key{
    if (object == nil) {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:object forKey:key];
}

#define IS_OBJECT(T) _Generic( (T), id: YES, default: NO)

-(void)putDictionary:(NSDictionary*)dict{
    for (NSString *key in dict) {
        [self putStringOrRemoveKey:[dict objectForKey:key] ifTrue:YES forKey:key param:nil];
    }
}

-(void)removeKeys:(NSArray*)keys{
    for (NSString *key in keys) {
        NSMutableDictionary *defaultObj = [self objectForKey:@"default"];
        [defaultObj removeObjectForKey:key];
    }
}


-(void)putDictionary:(NSDictionary*)dict ifTrue:(BOOL)ifTrue{
    for (NSString *key in dict) {
        [self putStringOrRemoveKey:[dict objectForKey:key] ifTrue:ifTrue forKey:key param:nil];
    }
}


-(void)putInt:(NSInteger)intValue forKey:(id)key param:(NSDictionary*)param{
    NSString *outputDictKey = [param objectForKey:kMDExOutputDictKey];
    
    if (outputDictKey == nil) {
        outputDictKey = @"default";
    }

    NSMutableDictionary *subDict = [self objectForKey:outputDictKey];
    
    if (subDict == nil) {
        subDict = [NSMutableDictionary dictionary];
        [self setObject:subDict forKey:outputDictKey];
    }
    
    if (intValue==0 && [[param objectForKey:kMDExIgnoreZero] boolValue]) {
        return;
    }
    
    if (intValue && [param objectForKey:kMDExDictForTrue]) {
        NSDictionary *insertDict = [param objectForKey:kMDExDictForTrue];
        [subDict addEntriesFromDictionary:insertDict];
        return;
    }
    
    if ([[param objectForKey:kMDExModifier] isEqualToString:kMDExModifierPixel]) {
        NSString *finalString = [NSString stringWithFormat:@"%ld",intValue];
        finalString = [finalString stringByAppendingString:@"px"];
        [subDict setObject:finalString forKey:key];
    }
    else if ([[param objectForKey:kMDExModifier] isEqualToString:kMDExModifierPercent]) {
        NSString *finalString = [NSString stringWithFormat:@"%ld",intValue];
        finalString = [finalString stringByAppendingString:@"%"];
        [subDict setObject:finalString forKey:key];
    }
    else{
        NSString *finalString = [NSString stringWithFormat:@"%ld",intValue];
        [subDict setObject:finalString forKey:key];
    }
}

-(void)putFloat:(CGFloat)value forKey:(id)key param:(NSDictionary*)param{
    NSString *outputDictKey = [param objectForKey:kMDExOutputDictKey];
    
    if (outputDictKey == nil) {
        outputDictKey = @"default";
    }
    
    NSMutableDictionary *subDict = [self objectForKey:outputDictKey];
    
    if (subDict == nil) {
        subDict = [NSMutableDictionary dictionary];
        [self setObject:subDict forKey:outputDictKey];
    }
    
    if (value==0 && [[param objectForKey:kMDExIgnoreZero] boolValue]) {
        return;
    }
    
    if (value && [param objectForKey:kMDExDictForTrue]) {
        NSDictionary *insertDict = [param objectForKey:kMDExDictForTrue];
        [subDict addEntriesFromDictionary:insertDict];
        return;
    }
    
    if ([[param objectForKey:kMDExModifier] isEqualToString:kMDExModifierPixel]) {
        NSString *finalString = [NSString stringWithFormat:@"%.1f",value];
        finalString = [finalString stringByAppendingString:@"px"];
        [subDict setObject:finalString forKey:key];
    }
    else if ([[param objectForKey:kMDExModifier] isEqualToString:kMDExModifierPercent]) {
        NSString *finalString = [NSString stringWithFormat:@"%.1f",value];
        finalString = [finalString stringByAppendingString:@"%"];
        [subDict setObject:finalString forKey:key];
    }
    else{
        NSString *finalString = [NSString stringWithFormat:@"%.1f",value];
        [subDict setObject:finalString forKey:key];
    }
}


-(void)putStringOrRemoveKey:(NSString*)strValue ifTrue:(BOOL)ifTrue forKey:(id)key param:(NSDictionary*)param{
    NSString *outputDictKey = [param objectForKey:kMDExOutputDictKey];
    
    if (outputDictKey == nil) {
        outputDictKey = @"default";
    }
    
    NSMutableDictionary *subDict = [self objectForKey:outputDictKey];
    
    if (subDict == nil) {
        subDict = [NSMutableDictionary dictionary];
        [self setObject:subDict forKey:outputDictKey];
    }
    
    if (ifTrue) {
        [subDict setObjectRemoveNil:strValue forKey:key];
    }
    else{
        [subDict removeObjectForKey:key];
    }
}


-(void)putString:(NSString*)strValue forKey:(id)key param:(NSDictionary*)param{
    [self putStringOrRemoveKey:strValue ifTrue:1 forKey:key param:param];
}

-(void)removeObjectForKey:(id)key param:(NSDictionary*)param{
    NSString *outputDictKey = [param objectForKey:kMDExOutputDictKey];
    
    if (outputDictKey == nil) {
        outputDictKey = @"default";
    }
    
    NSMutableDictionary *subDict = [self objectForKey:outputDictKey];
    [subDict removeObjectForKey:key];
}


-(void)setFloat:(float)val forKey:(id)key{
    [self setObject:[NSNumber numberWithFloat:val] forKey:key];
}

-(void)setFloat:(float)val forKey:(id)key ignoreZero:(BOOL)ignoreZero{
    if (ignoreZero && (val==0) ) {
        return;
    }
    [self setObject:@(val)forKey:key];
}


-(void)setBool:(BOOL)val forKey:(id)key{
    [self setObject:[NSNumber numberWithBool:val] forKey:key];
}


-(void)setInteger:(NSInteger)val forKey:(id)key{
    [self setObject:@(val)forKey:key];
}

-(void)setInteger:(NSInteger)val forKey:(id)key ignoreZero:(BOOL)ignoreZero{
    if (ignoreZero && (val==0) ) {
        return;
    }
    [self setObject:@(val)forKey:key];
}


-(void)setObjectFromObject:(NSObject*)obj withKeys:(NSString*)key1,...NS_REQUIRES_NIL_TERMINATION{
    va_list args;
    va_start(args, key1);
    while(1){
		NSString *key=va_arg(args,NSString*);
        if (key == nil){
            return;
        }
        [self setObjectRemoveNil:[obj valueForKey:key] forKey:key];
    }
}


+(NSMutableDictionary*)mutableDictionaryFromObject:(NSObject*)object withKeys:(NSString*)key1,...NS_REQUIRES_NIL_TERMINATION{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    va_list args;
    va_start(args, key1);
    while(1){
		NSString *key=va_arg(args,NSString*);
        if (key == nil){
            return dict;
        }
        [dict setObject:[object valueForKey:key] forKey:key];
    }
}


-(void)merge:(NSDictionary*)overwriteDict{
    for (id key in overwriteDict) {
        if ([self objectForKey:key] != nil) {
            if ([[self objectForKey:key] isKindOfClass:[NSDictionary class]] &&
                [[overwriteDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *subDict = [[self objectForKey:key] mutableCopy];
                [subDict merge:[overwriteDict objectForKey:key]];
                [self setObject:subDict forKey:key];
            }
            else{
                [self setObject:[overwriteDict objectForKey:key] forKey:key];
            }
        }
        else{
            [self setObject:[overwriteDict objectForKey:key] forKey:key];
        }
    }
    return;
}


@end

@implementation NSDictionary (JDExtension)
+(NSDictionary*)dictionaryFromObject:(NSObject*)object withKeys:(NSString*)key1,...NS_REQUIRES_NIL_TERMINATION{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    va_list args;
    va_start(args, key1);
    for (NSString *key = key1; key != nil; key = va_arg(args, NSString*)){
        if (key == nil){
            return [NSDictionary dictionaryWithDictionary:dict];
        }
        id obj = [object valueForKey:key];
        [dict setObjectRemoveNil:obj forKey:key];
    }
    va_end(args);
    return dict;
}

-(void)exportToObj:(id)obj{
    for (NSString *key in self) {
        id value = [self objectForKey:key];
        [obj setValue:value forKey:key];
    }
}

-(NSDictionary*)dictionaryWithMerging:(NSDictionary*)overwriteDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
    for (id key in overwriteDict) {
        [dict setObject:[overwriteDict objectForKey:key] forKey:key];
    }
    return [dict copy];
}


@end

@implementation NSString (JDExtension)

- (NSString*)lastLine{
    NSInteger len = [self length];
    NSInteger i;
    for (i=len-1; i>=0; i--) {
        unichar c = [self characterAtIndex:i];
        if (c == '\n') {
            break;
        }
    }
    return [self substringFromIndex:i+1];
}

-(NSString*)stringEscape{
    NSMutableString *str = [self mutableCopy];
    [str replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0    range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"'" withString:@"\\'" options:0    range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0    range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"\n" withString:@"\\n" options:0    range:NSMakeRange(0, [str length])];
    return str;
}


- (NSString*)substringToChar:(unichar)charecter{
    NSUInteger len = [self length];
    int i;
    for (i=0; i<len-1; i++) {
        unichar c = [self characterAtIndex:i];
        if (c == charecter) {
            break;
        }
    }
    return [self substringToIndex:i];
}
- (NSString*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to{
    return [[self substringToIndex:to] substringFromIndex:from];
}

- (NSString*)stringByAppendingPathComponents:(NSArray*)paths{
    NSString *str = [self copy];
    for (NSString *path in paths) {
        str = [str stringByAppendingPathComponent:path];
    }
    return str;
}

- (NSString*)stringByPathDiff:(NSString*)path{
    NSMutableString *val = [self mutableCopy];
    [val replaceOccurrencesOfString:path withString:@"" options:0 range: NSMakeRange(0, [self length])];
    if ([val characterAtIndex:0] == '/') {
        val = [[val substringFromIndex:1] mutableCopy];
    }
    return [NSString stringWithString:val];
}


- (BOOL)isHTTPURL{
    if ([self length] > 7) {
        if ([[self substringToIndex:7] isEqualToString:@"http://"]) {
            return YES;
        }
    }
    return NO;
}

-(NSString*)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*)stringByTrimEndWithChar:(char)c{
    NSInteger idx = [self length] -1;
    if (idx < 0) {
        return nil;
    }
    while (1) {
        char strC = [self characterAtIndex:idx];
        if (strC == c) {
            idx --;
        }
        else{
            break;
        }
    }
    if (idx == -1) {
        return [self copy];
    }
    return [self substringToIndex:idx+1];
}

// file directory 만 내보냄
// 스트링 끝에 '/'가 붙는다.
- (NSString*)dirOfFile{
    NSString *modifiedStr = [self stringByTrimEndWithChar:'/'];
    NSUInteger len = [modifiedStr length];
    NSUInteger pathComponentLen = [[self lastPathComponent] length];
    if (pathComponentLen > len) {
        return @"";
    }
    return [self substringToIndex:len - pathComponentLen];
}

- (NSString*)nameWithoutExtensionAsFile{
    NSString *fileName = [self lastPathComponent];
    NSString *extension = [NSString stringWithFormat:@".%@", [self pathExtension]];
    return [fileName stringByReplacingOccurrencesOfString:extension withString:@""];
}

- (NSString*)changeFileNameWithExtensionUntouched:(NSString*)newFileName{
    NSString *path = [self dirOfFile];
    NSString *extension = [self pathExtension];
    return [NSString stringWithFormat:@"%@/%@.%@",path,newFileName,extension];
}

- (NSString*)stringByChangeExtension:(NSString*)extension{
    NSString *path = [[self stringByDeletingPathExtension] stringByAppendingFormat:@".%@",extension];
    return path;
}

- (NSString*)stringByIndent:(NSUInteger)indent{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"\n"];
    [str appendString:@" " multipleTimes:indent];

    NSString *newStr = [self stringByReplacingOccurrencesOfString:@"\n" withString:str];
    
    NSMutableString *resultStr = [NSMutableString string];
    [resultStr appendString:@" " multipleTimes:indent];
    [resultStr appendString:newStr];
    NSString *fStr = [resultStr stringByTrimEndWithChar:' '];
    return fStr;
}


- (NSString*)stringByAppendFileNameWithExtensionUntouched:(NSString*)appendingString{
    NSString *path = [self dirOfFile];
    NSString *fileName = [self nameWithoutExtensionAsFile];
    NSString *extension = [self pathExtension];
    NSString *newFileName = [fileName stringByAppendingString:appendingString];
    
    if ([path isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@.%@",newFileName,extension];
    }
    return [NSString stringWithFormat:@"%@/%@.%@",path,newFileName,extension];
}


// Assumes that self and endPath are absolute file paths.
// Example: [ @"/a/b/c/d" relativePathTo: @"/a/e/f/g/h"] => @"../../e/f/g/h".
- (NSString*) relativePathTo: (NSString*) endPath {
    NSAssert( ! [self isEqual: endPath], @"illegal link to self");
    NSArray* startComponents = [self pathComponents];
    NSArray* endComponents = [endPath pathComponents];
    NSMutableArray* resultComponents = nil;
    int prefixCount = 0;
    if( ! [self isEqual: endPath] ){
        int iLen = MIN((int)[startComponents count], (int) [endComponents count]);
        for(prefixCount = 0; prefixCount < iLen && [[startComponents objectAtIndex: prefixCount] isEqual: [endComponents objectAtIndex: prefixCount]]; ++prefixCount){}
    }
    if(0 == prefixCount){
        resultComponents = [NSMutableArray arrayWithArray: endComponents];
    }else{
        resultComponents = [NSMutableArray arrayWithArray: [endComponents subarrayWithRange: NSMakeRange(prefixCount, [endComponents count] - prefixCount)]];
        int lifterCount = (int)[startComponents count] - prefixCount;
        if(1 == lifterCount){
            [resultComponents insertObject: @"." atIndex: 0];
        }else{
            --lifterCount;
            for(int i = 0; i < lifterCount; ++i){
                [resultComponents insertObject: @".." atIndex: 0];
            }
        }
    }
    return [NSString pathWithComponents: resultComponents];
}

- (BOOL) containsString:(NSString*)string{
    if ([self rangeOfString:string].location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}



@end

@implementation NSMutableString(JDExtension)
- (void)appendString:(NSString*)string multipleTimes:(NSUInteger)multipleTimes{
    for (int i=0; i<multipleTimes; i++) {
        [self appendString:string];
    }
}

- (void)appendStringIfNotNil:(NSString*)string{
    if (string == nil) {
        return;
    }
    else{
        [self appendString:string];
    }
}

@end


@implementation NSIndexPath(JDExtension)
- (NSComparisonResult)compareAncestor:(NSIndexPath*)indexPath{
    NSUInteger myLen = [self length];
    NSUInteger compareLen = [indexPath length];
    
    for (NSUInteger i=0; i<[self length]; i++) {
        if (i==compareLen) {
            return NSOrderedDescending;
        }
        NSUInteger currentMyIdx = [self indexAtPosition:i];
        NSUInteger currentCompareIdx = [indexPath indexAtPosition:i];
        if (currentCompareIdx != currentMyIdx) {
            return NSOrderedNone;
        }
    }
    if (myLen == compareLen) {
        return NSOrderedSame;
    }
    return NSOrderedAscending;
}

@end

@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end
